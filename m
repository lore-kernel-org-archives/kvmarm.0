From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 25/79] KVM: arm/arm64: vgic: Don't check vgic_initialized in
 sync/flush
Date: Sun, 23 Apr 2017 19:08:35 +0200
Message-ID: <20170423170929.27334-26-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF4ED49C63
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1sIiFHte2a+X for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:14 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A222B49C48
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:11 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id i137so1938794wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:58 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Now when we do an early init of the static parts of the VGIC data
structures, we can do things like checking if the AP lists are empty
directly without having to explicitly check if the vgic is initialized
and reduce a bit of work in our critical path.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index b64b143..04a405a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -633,9 +633,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
-		return;
-
 	vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
 
@@ -646,9 +643,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
-		return;
-
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
-- 
2.9.0
