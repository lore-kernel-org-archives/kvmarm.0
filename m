Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05359C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFD476140D
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFD476140D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 667A14B19F;
	Fri, 24 Sep 2021 08:54:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 80GH0xjImYfe; Fri, 24 Sep 2021 08:54:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 913394B1A4;
	Fri, 24 Sep 2021 08:54:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1DE4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KCPazidgtnXi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:15 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C0CF4B1A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:13 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 m1-20020a056000180100b0015e1ec30ac3so7987117wrh.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=c3qdDK6CwCMhdcn2tEJ6TpJKVu10uhj+XXDIPCtJjb0=;
 b=psNFg6nCmH9EU5Pajcz2UKWfcUW6CIkoTg6ob88wrS/HBXB3AkOhMbUc4AFLeMA0Sp
 7lu9JHDpVOWOXTNsn+YcIqR2zulAavdwwQM2YXe6C97wYk874q3MJIcDhun/XPLkM3pd
 aTmQUfLBonBQGjH0b4Xbo57FTjmUG/w7C0EUsuWgalUsbrG9wGYx1riQpbFpAJkE9a9T
 ISA5Y4eXtmuXhHAdn7YguY2m9S7EzU47PoSqQq64YqMpVEJUtiCQNauB8oza5MU9Z9Pp
 DUh1ObVuEjj9HZAXz32oTdLCLWK0TGm4SzdzVB1bDoeIwUh+cRZCmAJP4TcEm0Lov7cg
 ULBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=c3qdDK6CwCMhdcn2tEJ6TpJKVu10uhj+XXDIPCtJjb0=;
 b=ECE6Gkc/JpOurDqCWL/RSsOqTmWTpQlX4XHGQoyMbEhCpnMgyk+OqAE8OZyyzkrVt/
 oOMfs+h4Yf+fNyKUWw33PW0WbLDWBuLBmWurS+j04oFTqBmPZ/vkEx8m5tlFyuugzIBo
 /blROzftBgfdGWLiXbeRggZIVC6OesMEccMMLrYux0kdMM9DQAW54Bso4GM/jfSSLiWs
 x1fzhnIdUFIpI/5CJZULn7POlX7GTDoDETixki5AglQJGokY9KtOgNmgHWDvnLqCdJQw
 YYzKO4OiujGfVdrJ9YF9Agq1SaO3TSakwV+NY+uy/lgy0CLWRKJqNpDEwu5pf/wgH8ES
 fQLA==
X-Gm-Message-State: AOAM5333J3yFUBDvD5mFVIptqL2T7/Gac10KyyNgKwNtqZr4iE+9Hunn
 niJcH50nsl9qORLTRBW+SAp+ahT5g1+dqNo1SHbDB141kzCmJpzlBm0DxZ/fMsC4N4gg5l0kUhC
 s/Ao+WMuTCqYj+rhvRSV7W4ZK96HvIu1XYifnl/BioZtOeO4gzJZUCtUXxz+QRLzPx6Y=
X-Google-Smtp-Source: ABdhPJyHSTQAdyddoCnAQ1t8SsXdoW5w2rUjyZviDC87bdJ5+MrSTkFU5/hlW9/ETaN0jl9llsuMltIXvQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c766:: with SMTP id
 x6mr1928628wmk.53.1632488052437; 
 Fri, 24 Sep 2021 05:54:12 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:34 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-6-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 05/30] KVM: arm64: add accessors for kvm_cpu_context
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add accessors to get/set elements of struct kvm_cpu_context.

Simplifies future refactoring, and makes the code more consistent.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 53 ++++++++++++++++++++++------
 arch/arm64/include/asm/kvm_host.h    | 18 +++++++++-
 arch/arm64/kvm/hyp/exception.c       | 43 +++++++++++++++++-----
 3 files changed, 94 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 01b9857757f2..ad6e53cef1a4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -127,19 +127,34 @@ static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 	vcpu->arch.vsesr_el2 = vsesr;
 }
 
+static __always_inline unsigned long *ctxt_pc(const struct kvm_cpu_context *ctxt)
+{
+	return (unsigned long *)&ctxt_gp_regs(ctxt)->pc;
+}
+
 static __always_inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->pc;
+	return ctxt_pc(&vcpu_ctxt(vcpu));
+}
+
+static __always_inline unsigned long *ctxt_cpsr(const struct kvm_cpu_context *ctxt)
+{
+	return (unsigned long *)&ctxt_gp_regs(ctxt)->pstate;
 }
 
 static __always_inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
+	return ctxt_cpsr(&vcpu_ctxt(vcpu));
+}
+
+static __always_inline bool ctxt_mode_is_32bit(const struct kvm_cpu_context *ctxt)
+{
+	return !!(*ctxt_cpsr(ctxt) & PSR_MODE32_BIT);
 }
 
 static __always_inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 {
-	return !!(*vcpu_cpsr(vcpu) & PSR_MODE32_BIT);
+	return ctxt_mode_is_32bit(&vcpu_ctxt(vcpu));
 }
 
 static __always_inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
@@ -150,27 +165,45 @@ static __always_inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline void ctxt_set_thumb(struct kvm_cpu_context *ctxt)
+{
+	*ctxt_cpsr(ctxt) |= PSR_AA32_T_BIT;
+}
+
 static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 {
-	*vcpu_cpsr(vcpu) |= PSR_AA32_T_BIT;
+	ctxt_set_thumb(&vcpu_ctxt(vcpu));
 }
 
 /*
- * vcpu_get_reg and vcpu_set_reg should always be passed a register number
- * coming from a read of ESR_EL2. Otherwise, it may give the wrong result on
- * AArch32 with banked registers.
+ * vcpu/ctxt_get_reg and vcpu/ctxt_set_reg should always be passed a register
+ * number coming from a read of ESR_EL2. Otherwise, it may give the wrong result
+ * on AArch32 with banked registers.
  */
+static __always_inline unsigned long
+ctxt_get_reg(const struct kvm_cpu_context *ctxt, u8 reg_num)
+{
+	return (reg_num == 31) ? 0 : ctxt_gp_regs(ctxt)->regs[reg_num];
+}
+
+static __always_inline void
+ctxt_set_reg(struct kvm_cpu_context *ctxt, u8 reg_num, unsigned long val)
+{
+	if (reg_num != 31)
+		ctxt_gp_regs(ctxt)->regs[reg_num] = val;
+}
+
 static __always_inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
-	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs[reg_num];
+	return ctxt_get_reg(&vcpu_ctxt(vcpu), reg_num);
+
 }
 
 static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 				unsigned long val)
 {
-	if (reg_num != 31)
-		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
+	ctxt_set_reg(&vcpu_ctxt(vcpu), reg_num, val);
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index adb21a7f0891..097e5f533af9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,7 +446,23 @@ struct kvm_vcpu_arch {
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
 
-#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
+#define vcpu_ctxt(vcpu) ((vcpu)->arch.ctxt)
+
+/* VCPU Context accessors (direct) */
+#define ctxt_gp_regs(c)		(&(c)->regs)
+#define ctxt_spsr_abt(c)	(&(c)->spsr_abt)
+#define ctxt_spsr_und(c)	(&(c)->spsr_und)
+#define ctxt_spsr_irq(c)	(&(c)->spsr_irq)
+#define ctxt_spsr_fiq(c)	(&(c)->spsr_fiq)
+#define ctxt_fp_regs(c)		(&(c)->fp_regs)
+
+/* VCPU Context accessors */
+#define vcpu_gp_regs(v)		ctxt_gp_regs(&vcpu_ctxt(v))
+#define vcpu_spsr_abt(v)	ctxt_spsr_abt(&vcpu_ctxt(v))
+#define vcpu_spsr_und(v)	ctxt_spsr_und(&vcpu_ctxt(v))
+#define vcpu_spsr_irq(v)	ctxt_spsr_irq(&vcpu_ctxt(v))
+#define vcpu_spsr_fiq(v)	ctxt_spsr_fiq(&vcpu_ctxt(v))
+#define vcpu_fp_regs(v)		ctxt_fp_regs(&vcpu_ctxt(v))
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 11541b94b328..643c5844f684 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -18,43 +18,68 @@
 #error Hypervisor code only!
 #endif
 
-static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+static inline u64 __ctxt_read_sys_reg(const struct kvm_cpu_context *vcpu_ctxt, int reg)
 {
 	u64 val;
 
 	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
-	return __vcpu_sys_reg(vcpu, reg);
+	return ctxt_sys_reg(vcpu_ctxt, reg);
 }
 
-static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+static inline void __ctxt_write_sys_reg(struct kvm_cpu_context *vcpu_ctxt, u64 val, int reg)
 {
 	if (__vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
-	 __vcpu_sys_reg(vcpu, reg) = val;
+	 ctxt_sys_reg(vcpu_ctxt, reg) = val;
 }
 
-static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+static void __ctxt_write_spsr(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 {
 	write_sysreg_el1(val, SYS_SPSR);
 }
 
-static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
+static void __ctxt_write_spsr_abt(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 {
 	if (has_vhe())
 		write_sysreg(val, spsr_abt);
 	else
-		vcpu->arch.ctxt.spsr_abt = val;
+		*ctxt_spsr_abt(vcpu_ctxt) = val;
 }
 
-static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
+static void __ctxt_write_spsr_und(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 {
 	if (has_vhe())
 		write_sysreg(val, spsr_und);
 	else
-		vcpu->arch.ctxt.spsr_und = val;
+		*ctxt_spsr_und(vcpu_ctxt) = val;
+}
+
+static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+{
+	return __ctxt_read_sys_reg(&vcpu_ctxt(vcpu), reg);
+}
+
+static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	__ctxt_write_sys_reg(&vcpu_ctxt(vcpu), val, reg);
+}
+
+static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+{
+	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
+}
+
+static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
+{
+	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
+}
+
+static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
+{
+	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
 }
 
 /*
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
