From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 2/5] KVM: arm/arm64: vgic: constify seq_operations and file_operations
Date: Tue,  5 Sep 2017 17:41:03 +0200
Message-ID: <20170905154106.2945-3-cdall@linaro.org>
References: <20170905154106.2945-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170905154106.2945-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arvind Yadav <arvind.yadav.cs@gmail.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

vgic_debug_seq_ops and file_operations are not supposed to change
at runtime and none of the structures is modified.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
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
2.9.0
