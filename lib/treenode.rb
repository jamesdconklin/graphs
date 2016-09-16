require_relative 'vertex'

class TreeNode < Vertex
  def parent?(node)
    return true if self == node
    @prev.nil? ? false : @prev.parent?(node)
  end

  def disconnect(node)
    @neighbors.delete(node)
  end

  def connect(node, weight=1)
    unless parent?(node)
      directed_connect(node, weight)
      node.prev.disconnect(node) if node.prev
      node.prev = self
    end
  end
end
