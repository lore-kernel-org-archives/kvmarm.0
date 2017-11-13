From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 26/27] KVM: arm/arm64: Fix GICv4 ITS initialization issues
Date: Mon, 13 Nov 2017 10:17:51 +0100
Message-ID: <20171113091752.10663-27-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C77549DBD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZjjDaoWsFz6A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:24 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B244649DA2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:24 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id l8so7822435wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:35 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We should only try to initialize GICv4 data structures on a GICv4
capable system.  Move the vgic_supports_direct_msis() check inito
vgic_v4_init() so that any KVM VGIC initialization path does not fail
on non-GICv4 systems.

Also be slightly more strict in the checking of the return value in
vgic_its_create, and only error out on negative return values from the
vgic_v4_init() function.  This is important because the kvm device code
only treats negative values as errors and only cleans up in this case.
Errornously treating a positive return value as an error from the
vgic_v4_init() function can lead to NULL pointer dereferences, as has
recently been observed.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 8 +++-----
 virt/kvm/arm/vgic/vgic-its.c  | 2 +-
 virt/kvm/arm/vgic/vgic-v4.c   | 3 +++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 40be908da238..62310122ee78 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,11 +285,9 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	if (vgic_supports_direct_msis(kvm)) {
-		ret = vgic_v4_init(kvm);
-		if (ret)
-			goto out;
-	}
+	ret = vgic_v4_init(kvm);
+	if (ret)
+		goto out;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index b8c1b724ba3e..c93ecd4a903b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1673,7 +1673,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	if (vgic_initialized(dev->kvm)) {
 		int ret = vgic_v4_init(dev->kvm);
-		if (ret) {
+		if (ret < 0) {
 			kfree(its);
 			return ret;
 		}
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 915d09dc2638..53c324aa44ef 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -118,6 +118,9 @@ int vgic_v4_init(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i, nr_vcpus, ret;
 
+	if (!vgic_supports_direct_msis(kvm))
+		return 0; /* Nothing to see here... move along. */
+
 	if (dist->its_vm.vpes)
 		return 0;
 
-- 
2.14.2
