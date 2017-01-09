From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 14/55] KVM: arm64: Take account of system instruction traps
Date: Mon,  9 Jan 2017 01:24:10 -0500
Message-ID: <1483943091-1364-15-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E054025C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ER9oT2ZGztTt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:11 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB9A540783
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:09 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096O7Qb005079
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:51 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 6C2D480
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:51 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 5391980
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:51 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Pp0U004727
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:51 -0500
Received: by mail-qk0-f197.google.com with SMTP id 11so31128957qkl.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:51 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When HCR.NV bit is set, execution of the EL2 translation regime Address
Translation instructions and TLB maintenance instructions are trapped to
EL2. In addition, execution of the EL1 translation regime Address
Translation instructions and TLB maintenance instructions that are only
accessible from EL2 and above are trapped to EL2. In these cases,
ESR_EL2.EC will be set to 0x18.

Take account of this and handle system instructions as well as MRS/MSR
instructions in the handler. Change the handler name to reflect this.

Emulation of those system instructions is to be done.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_coproc.h |  2 +-
 arch/arm64/kvm/handle_exit.c        |  2 +-
 arch/arm64/kvm/sys_regs.c           | 49 ++++++++++++++++++++++++++++++++-----
 arch/arm64/kvm/trace.h              |  2 +-
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 0b52377..1b3d21b 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -43,7 +43,7 @@ void kvm_register_target_sys_reg_table(unsigned int target,
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
 #define kvm_coproc_table_init kvm_sys_reg_table_init
 void kvm_sys_reg_table_init(void);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 4e4a915..a891684 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -147,7 +147,7 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
 	[ESR_ELx_EC_SMC64]	= handle_smc,
-	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
+	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
 	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4158f2f..202f64d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1903,6 +1903,36 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int emulate_tlbi(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *params)
+{
+	/* TODO: support tlbi instruction emulation*/
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
+static int emulate_at(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *params)
+{
+	/* TODO: support address translation instruction emulation */
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
+static int emulate_sys_instr(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *params)
+{
+	int ret;
+
+	/* TLB maintenance instructions*/
+	if (params->CRn == 0b1000)
+		ret = emulate_tlbi(vcpu, params);
+	/* Address Translation instructions */
+	else if (params->CRn == 0b0111 && params->CRm == 0b1000)
+		ret = emulate_at(vcpu, params);
+	return ret;
+}
+
 static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
 			      const struct sys_reg_desc *table, size_t num)
 {
@@ -1914,18 +1944,19 @@ static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
 }
 
 /**
- * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
+ * kvm_handle_sys-- handles a system instruction or mrs/msr instruction trap
+		    on a guest execution
  * @vcpu: The VCPU pointer
  * @run:  The kvm_run struct
  */
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
+int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_hsr(vcpu);
 	int Rt = (esr >> 5) & 0x1f;
 	int ret;
 
-	trace_kvm_handle_sys_reg(esr);
+	trace_kvm_handle_sys(esr);
 
 	params.is_aarch32 = false;
 	params.is_32bit = false;
@@ -1937,10 +1968,16 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.regval = vcpu_get_reg(vcpu, Rt);
 	params.is_write = !(esr & 1);
 
-	ret = emulate_sys_reg(vcpu, &params);
+	if (params.Op0 == 1) {
+		/* System instructions */
+		ret = emulate_sys_instr(vcpu, &params);
+	} else {
+		/* MRS/MSR instructions */
+		ret = emulate_sys_reg(vcpu, &params);
+		if (!params.is_write)
+			vcpu_set_reg(vcpu, Rt, params.regval);
+	}
 
-	if (!params.is_write)
-		vcpu_set_reg(vcpu, Rt, params.regval);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 5f40987..192708e 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -134,7 +134,7 @@
 	TP_printk("%s %s reg %d (0x%08llx)", __entry->fn,  __entry->is_write?"write to":"read from", __entry->reg, __entry->write_value)
 );
 
-TRACE_EVENT(kvm_handle_sys_reg,
+TRACE_EVENT(kvm_handle_sys,
 	TP_PROTO(unsigned long hsr),
 	TP_ARGS(hsr),
 
-- 
1.9.1
