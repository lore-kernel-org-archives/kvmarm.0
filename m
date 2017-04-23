From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 31/79] arm64: KVM: PMU: Inject UNDEF on read access to
 PMSWINC_EL0
Date: Sun, 23 Apr 2017 19:08:41 +0200
Message-ID: <20170423170929.27334-32-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BB049CA8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DiB5w5o3yulY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:20 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D70E249C8F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:17 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id u65so7503543wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:04 -0700 (PDT)
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

PMSWINC_EL0 is a WO register, so let's UNDEF when reading from it
(in the highly hypothetical case where this doesn't UNDEF at EL1).

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 20f90c0..3fef01d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -772,16 +772,15 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (!p->is_write)
+		return read_from_write_only(vcpu, p);
+
 	if (pmu_write_swinc_el0_disabled(vcpu))
 		return false;
 
-	if (p->is_write) {
-		mask = kvm_pmu_valid_counter_mask(vcpu);
-		kvm_pmu_software_increment(vcpu, p->regval & mask);
-		return true;
-	}
-
-	return false;
+	mask = kvm_pmu_valid_counter_mask(vcpu);
+	kvm_pmu_software_increment(vcpu, p->regval & mask);
+	return true;
 }
 
 static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.9.0
