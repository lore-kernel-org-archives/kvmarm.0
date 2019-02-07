From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/11] arm/arm64: KVM: Don't panic on failure to properly
 reset system registers
Date: Thu,  7 Feb 2019 13:18:39 +0000
Message-ID: <20190207131843.157210-8-marc.zyngier@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 481004A44B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VG002tS5XOMX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Feb 2019 08:19:16 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1772E4A469
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:16 -0500 (EST)
In-Reply-To: <20190207131843.157210-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Failing to properly reset system registers is pretty bad. But not
quite as bad as bringing the whole machine down... So warn loudly,
but slightly more gracefully.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/kvm/coproc.c     | 4 ++--
 arch/arm64/kvm/sys_regs.c | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 222c1635bc7a..e8bd288fd5be 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -1450,6 +1450,6 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
 	reset_coproc_regs(vcpu, table, num);
 
 	for (num = 1; num < NR_CP15_REGS; num++)
-		if (vcpu_cp15(vcpu, num) == 0x42424242)
-			panic("Didn't reset vcpu_cp15(vcpu, %zi)", num);
+		WARN(vcpu_cp15(vcpu, num) == 0x42424242,
+		     "Didn't reset vcpu_cp15(vcpu, %zi)", num);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 86096774abcd..c936aa40c3f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2608,7 +2608,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	table = get_target_table(vcpu->arch.target, true, &num);
 	reset_sys_reg_descs(vcpu, table, num);
 
-	for (num = 1; num < NR_SYS_REGS; num++)
-		if (__vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
-			panic("Didn't reset __vcpu_sys_reg(%zi)", num);
+	for (num = 1; num < NR_SYS_REGS; num++) {
+		if (WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
+			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
+			break;
+	}
 }
-- 
2.20.1
