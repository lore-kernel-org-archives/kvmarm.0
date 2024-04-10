Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE32813D60A
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737693; cv=none; b=pbJJTqxDoQE1W+aGDy4fUWoH2WjgAmnx32QfYSqWHCMelj2XQimexKRLlCmSs4Y4C73aAKvUO5LYHyGRd/huVxx0jvQxWwMJtz4VbruUxUrsrM6TK5+VKyW+ZvdNSUZfSN6vb1wf7B5+LQIzeTUyj+uW0jVSRMM2FCSzKRzV/t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737693; c=relaxed/simple;
	bh=loO222umeudNN/3VRDuIKBD8h6ayrjYQtdXvLf/9SQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hpm6hBZ/NBmFistgVbKaW/t3ze0MfAbIztvYvuG+E3/ZBc3Z/dx8DOeTNOD9yqu9u5kV6fSr954LO2MVPSMqGFijkPp5grQqYNjnjzKx5898PmPeG8S5kiUilPLfUK6TnIbbuac0CCl/CQS9OsWz2lECemmIRtaiZJdURCRl7CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tXoIZv/Z; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tXoIZv/Z"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d89346eb45so36871291fa.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737690; x=1713342490; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qY+POk7z4HcyMMlZuNM5o7DMNVtuiYxieApfPnvv9HE=;
        b=tXoIZv/ZfAxw/NgXpLOT3cEsLhsBDFRlObbj0C9mCPlE6cJ8QR35Fo/8+Sj1JzXiJB
         U5/thYlI32WA9uGVoqw+r5cyMoyw1RVxmSGTrtl8L9Dts21df/jJYWgImGC95CTmjvoS
         nzLMdrbnjriFjEw9W6vZ2ubaZFyObss8kQVyO1LBt50ppnNAzA3ljfWuI9ohlmWHX6nx
         nwmNKiO1OJDJtwLGDVB5vJatjOaJ7wkJCQvuJZkljLRehdvqVCKOpswUg1YHm6u5u6eQ
         fD5eAwpN2fR48TdtvqESycc5Tgp4mKxbtUAHVqtFBha8nH7eQJ1f2F8sUy1kiKGqLdk2
         MmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737690; x=1713342490;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qY+POk7z4HcyMMlZuNM5o7DMNVtuiYxieApfPnvv9HE=;
        b=bDuBmscx3aJzCqAB27hkWsgM42OjMfG/i89CFtnjahYezzZBOLWPJ8wJ3V73LWwd00
         qR+Iy8aHAppWNYYAaR8bAyv+KhpaYywepLMjRmxp5ZUC1yG0POLMCBarRpkRd647KEUB
         t/SArzDLnTttMIIism2qf83dLNtasKZX5MrBt8wNqiHTIlUp5Xq4Sp5zJq3uH8TthkZf
         dmxZDUOYq8hA1iX6bTbTZAqaNzeQgGcyuaqMfht60I+s00Jm2n0GQBDHexhJFrNxpKJQ
         c89ptys7KmGganKjjI4Wo4wDNxRJeF9BWol5THdG7mzcekasVGCpidtDj1sFiiHF8iyE
         O0JQ==
X-Gm-Message-State: AOJu0YxYpSiEp0nCd7ZZCyvafkZ07Bpzy5dgjdcZ7MYFb1KgVpxixNB9
	YWj7tuL2007Dx2g1hLZ4uuaCSwET+GJQBXj4gbdJizbqJA7YziiZMsAm2NPbnx1h26z3DsLxxWZ
	8DQ==
X-Google-Smtp-Source: AGHT+IEL5qT3PXK3v0HpJZ+zPd2REaRDBNASA0+bLbNO3hFsj9CwSLwbfI4Q9HqWFPT0ZHUDjdBQXg==
X-Received: by 2002:a05:651c:2c1:b0:2d8:2d0a:7b9b with SMTP id f1-20020a05651c02c100b002d82d0a7b9bmr1863181ljo.14.1712737689629;
        Wed, 10 Apr 2024 01:28:09 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id dr2-20020a170907720200b00a4ea1fbb323sm6656464ejc.98.2024.04.10.01.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:09 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:05 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 01/12] KVM: arm64: Fix clobbered ELR in sync abort/SError
Message-ID: <iyww6yls3pqijoabrtgg5fq6p2a5pkv27cgesu7ffldlf3ooif@qxl5vpvdokfb>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

When the hypervisor receives a SError or synchronous exception (EL2h)
while running with the __kvm_hyp_vector and if ELR_EL2 doesn't point to
an extable entry, it panics indirectly by overwriting ELR with the
address of a panic handler in order for the asm routine it returns to to
ERET into the handler.

However, this clobbers ELR_EL2 for the handler itself. As a result,
hyp_panic(), when retrieving what it believes to be the PC where the
exception happened, actually ends up reading the address of the panic
handler that called it! This results in an erroneous and confusing panic
message where the source of any synchronous exception (e.g. BUG() or
kCFI) appears to be __guest_exit_panic, making it hard to locate the
actual BRK instruction.

Therefore, store the original ELR_EL2 in the per-CPU kvm_hyp_ctxt and
point the sysreg to a routine that first restores it to its previous
value before running __guest_exit_panic.

Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kernel/asm-offsets.c         | 1 +
 arch/arm64/kvm/hyp/entry.S              | 9 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 81496083c041..27de1dddb0ab 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -128,6 +128,7 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2]));
   DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
   DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index f3aa7738b477..bcaaf1a11b4e 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,15 @@ alternative_else_nop_endif
 	eret
 	sb
 
+SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: hyp regs
+
+	stp	x0, x1, [sp, #-16]!
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+	ldr	x0, [x0, #CPU_ELR_EL2]
+	msr	elr_el2, x0
+	ldp	x0, x1, [sp], #16
+
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e3fcf8c4d5b4..19a7ca2c1277 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -775,7 +775,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
 
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic, elr_el2);
+	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
+	write_sysreg(__guest_exit_restore_elr_and_panic, elr_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
