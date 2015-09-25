From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 3/4] KVM: arm/arm64: check power_off in critical section
 before VCPU run
Date: Fri, 25 Sep 2015 23:41:16 +0200
Message-ID: <1443217277-13173-4-git-send-email-eric.auger@linaro.org>
References: <1443217277-13173-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF18548B2E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 17:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qNn1G8Y9Wz3O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Sep 2015 17:41:10 -0400 (EDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
 [209.85.220.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC75A48AD0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 17:41:09 -0400 (EDT)
Received: by pacex6 with SMTP id ex6so116322985pac.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 14:42:34 -0700 (PDT)
In-Reply-To: <1443217277-13173-1-git-send-email-eric.auger@linaro.org>
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
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In case a vcpu off PSCI call is called just after we executed the
vcpu_sleep check, we can enter the guest although power_off
is set. Let's check the power_off state in the critical section,
just before entering the guest.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reported-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

---

v2 -> v3:
- reword commit message
---
 arch/arm/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d16f76..4eb59e3 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -560,7 +560,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
+		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+			vcpu->arch.power_off) {
 			local_irq_enable();
 			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
-- 
1.9.1
