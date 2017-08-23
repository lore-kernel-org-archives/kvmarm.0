From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] KVM: arm/arm64: vgic: constify seq_operations and file_operations
Date: Wed, 23 Aug 2017 12:25:36 +0530
Message-ID: <de67d01fab53d5b7874cda1ac2c269887c673450.1503471217.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

vgic_debug_seq_ops and file_operations are not supposed to change
at runtime and none of the structures is modified.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 virt/kvm/arm/vgic/vgic-debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index 7072ab7..10b3817 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -234,7 +234,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static struct seq_operations vgic_debug_seq_ops = {
+static const struct seq_operations vgic_debug_seq_ops = {
 	.start = vgic_debug_start,
 	.next  = vgic_debug_next,
 	.stop  = vgic_debug_stop,
@@ -255,7 +255,7 @@ static int debug_open(struct inode *inode, struct file *file)
 	return ret;
 };
 
-static struct file_operations vgic_debug_fops = {
+static const struct file_operations vgic_debug_fops = {
 	.owner   = THIS_MODULE,
 	.open    = debug_open,
 	.read    = seq_read,
-- 
1.9.1
