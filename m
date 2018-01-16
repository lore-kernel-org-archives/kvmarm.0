From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL v2 2/3] KVM: arm64: Fix GICv4 init when called from
 vgic_its_create
Date: Tue, 16 Jan 2018 18:02:32 +0100
Message-ID: <20180116170233.7085-3-christoffer.dall@linaro.org>
References: <20180116170233.7085-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9912149DFE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 11:57:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fbFG0hu21Lxz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 11:57:39 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97EE549DFB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 11:57:39 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id f3so10114639wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 09:02:41 -0800 (PST)
In-Reply-To: <20180116170233.7085-1-christoffer.dall@linaro.org>
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

Commit 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization
issues") moved the vgic_supports_direct_msis() check in vgic_v4_init().
However when vgic_v4_init is called from vgic_its_create(), the has_its
field is not yet set. Hence vgic_supports_direct_msis returns false and
vgic_v4_init does nothing.

The gic/its init sequence is a bit messy, so let's be specific about the
prerequisite checks in the various call paths instead of relying on a
common wrapper.

Fixes: 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization issues")
Reported-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
 virt/kvm/arm/vgic/vgic-v4.c   | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 62310122ee78..743ca5cb05ef 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,9 +285,11 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	ret = vgic_v4_init(kvm);
-	if (ret)
-		goto out;
+	if (vgic_has_its(kvm)) {
+		ret = vgic_v4_init(kvm);
+		if (ret)
+			goto out;
+	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 4a37292855bc..bc4265154bac 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -118,7 +118,7 @@ int vgic_v4_init(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i, nr_vcpus, ret;
 
-	if (!vgic_supports_direct_msis(kvm))
+	if (!kvm_vgic_global_state.has_gicv4)
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
-- 
2.14.2
