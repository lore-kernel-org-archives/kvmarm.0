From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 3/4] KVM: arm/arm64: check power_off in critical section
 before VCPU run
Date: Fri,  7 Aug 2015 18:08:32 +0200
Message-ID: <1438963713-10460-4-git-send-email-eric.auger@linaro.org>
References: <1438963713-10460-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38EFB5A503
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:56:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eafpLRIc2fcM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 11:56:32 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD545A504
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:56:32 -0400 (EDT)
Received: by wibxm9 with SMTP id xm9so71907583wib.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Aug 2015 09:09:25 -0700 (PDT)
In-Reply-To: <1438963713-10460-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In case KVM_SET_MP_STATE ioctl is called just after we executed the
vcpu_sleep check, we can enter the guest although KVM_MP_STATE_STOPPED
is set. Let's check the power_off state in the critical section,
just before entering the guest.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reported-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 4f50be3..cc404a8 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -555,7 +555,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
+		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+			vcpu->arch.power_off) {
 			local_irq_enable();
 			kvm_vgic_sync_hwstate(vcpu);
 			preempt_enable();
-- 
1.9.1
