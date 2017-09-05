From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 5/8] KVM: arm/arm64: vgic: constify seq_operations and
 file_operations
Date: Tue,  5 Sep 2017 16:52:04 +0200
Message-ID: <20170905145207.18447-6-cdall@linaro.org>
References: <20170905145207.18447-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7389049C32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 10:50:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7YLOgm4pmfPz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Sep 2017 10:50:15 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8371849C6F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 10:49:59 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id f145so11659219wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Sep 2017 07:52:23 -0700 (PDT)
In-Reply-To: <20170905145207.18447-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Arvind Yadav <arvind.yadav.cs@gmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
