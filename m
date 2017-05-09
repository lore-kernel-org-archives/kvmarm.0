From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 01/37] arm64: KVM: Fix decoding of Rt/Rt2 when trapping AArch32
 CP accesses
Date: Tue,  9 May 2017 12:44:30 +0200
Message-ID: <20170509104506.30929-2-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8275240430
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5m9-0dtNoZPz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:41:59 -0400 (EDT)
Received: from mail-qk0-f175.google.com (mail-qk0-f175.google.com
 [209.85.220.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A810C405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:41:59 -0400 (EDT)
Received: by mail-qk0-f175.google.com with SMTP id y201so42658283qka.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:14 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Our 32bit CP14/15 handling inherited some of the ARMv7 code for handling
the trapped system registers, completely missing the fact that the
fields for Rt and Rt2 are now 5 bit wide, and not 4...

Let's fix it, and provide an accessor for the most common Rt case.

Cc: stable@vger.kernel.org
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 6 ++++++
 arch/arm64/kvm/sys_regs.c            | 8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5ea0ba..fe39e68 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -240,6 +240,12 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_FSC_TYPE;
 }
 
+static inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_hsr(vcpu);
+	return (esr & ESR_ELx_SYS64_ISS_RT_MASK) >> ESR_ELx_SYS64_ISS_RT_SHIFT;
+}
+
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
 	return vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8ddcee6..ea9fbb5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1529,8 +1529,8 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 {
 	struct sys_reg_params params;
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
-	int Rt = (hsr >> 5) & 0xf;
-	int Rt2 = (hsr >> 10) & 0xf;
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	int Rt2 = (hsr >> 10) & 0x1f;
 
 	params.is_aarch32 = true;
 	params.is_32bit = false;
@@ -1586,7 +1586,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 {
 	struct sys_reg_params params;
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
-	int Rt  = (hsr >> 5) & 0xf;
+	int Rt  = kvm_vcpu_sys_get_rt(vcpu);
 
 	params.is_aarch32 = true;
 	params.is_32bit = true;
@@ -1688,7 +1688,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_hsr(vcpu);
-	int Rt = (esr >> 5) & 0x1f;
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
 	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
-- 
2.9.0
