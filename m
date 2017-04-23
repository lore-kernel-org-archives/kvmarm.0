From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 29/79] arm64: KVM: PMU: Inject UNDEF on non-privileged accesses
Date: Sun, 23 Apr 2017 19:08:39 +0200
Message-ID: <20170423170929.27334-30-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2D8F49C66
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4bpfha2Sx2P9 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:18 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 121FB49CAC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:15 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id m123so50336384wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:02 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

access_pminten() and access_pmuserenr() can only be accessed when
the CPU is in a priviledged mode. If it is not, let's inject an
UNDEF exception.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 750c129..d343c0f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -709,8 +709,10 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
-	if (!vcpu_mode_priv(vcpu))
+	if (!vcpu_mode_priv(vcpu)) {
+		kvm_inject_undefined(vcpu);
 		return false;
+	}
 
 	if (p->is_write) {
 		u64 val = p->regval & mask;
@@ -780,8 +782,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (p->is_write) {
-		if (!vcpu_mode_priv(vcpu))
+		if (!vcpu_mode_priv(vcpu)) {
+			kvm_inject_undefined(vcpu);
 			return false;
+		}
 
 		vcpu_sys_reg(vcpu, PMUSERENR_EL0) = p->regval
 						    & ARMV8_PMU_USERENR_MASK;
-- 
2.9.0
