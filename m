Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85525173351
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340444; cv=none; b=Qu+0qr+Z1z8K5S6oAbCyonSHpJL2tJ3ywuLLRyivaCsVXoa83C/cg6iMMNBILFhuqPaBYJvMTGommuavGDpcpNX6OurYfld0mvxLYuWxGZVnmhb6j0B+KqhCZZbjzG2Lfu2eAMYZ2SDuNeILz+IMgxxz3eJDD+GaQdifiy8O/zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340444; c=relaxed/simple;
	bh=JHJFWyJeQVH89FDkO+GfM1Lay/KIUWopPc58GA0ph10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DQI/o2wlcyH2036Xdu/k6pHee+s3Xj3uXuCn4m3asG43MTGJez2Ao1NsIyE7obIIjYEYiEx1N2gRwuA/XJjgeFC37ORGSmiAlr46bUawCvgEVAQzbeLQYN0jstDRDpjnIksorOWA3+ESs2XbzU+Ndz/cPNq/JEpH/kVRsL/ToIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qtBCyO6Q; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qtBCyO6Q"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a59a1fe7396so121431766b.3
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340441; x=1715945241; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlOgeEx7Dj0f9uD0T276ThAzO+p8Gd1L0Dz8H/gEavQ=;
        b=qtBCyO6QqsswhCIYF9+kV6jhD37gRKAasjjkq3cLrsNNCLi2YaOCJotzZbLQ3P4Sv1
         /uuc7LNL2ieP9fSAckxI4wlheerOkYwNUwLOvVV62/dyOEGLlrdYBP6pvIVJUlpJydre
         Jh1ozyLiSZP262s1qGxYyIKy+QvMtzA6HrgxePSn3gS9QV0iTdfBlkBl9JP1u/ctjmf1
         cA44VfKAy0/HvAMzPUt4LmoLTmTnQQAIzsXpTfWh2qnF3biEEPPsDdt8mRHlWBO2rm0+
         /ymzsRuf7xYcGBwQ0NGfx9qMFCEL3wbQgMGtPfVxOL4l/5cHqLnmv//4Oudw3NjNNH+W
         QZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340441; x=1715945241;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IlOgeEx7Dj0f9uD0T276ThAzO+p8Gd1L0Dz8H/gEavQ=;
        b=MjzVYWsdUB0I2tB0cBxSTMkzMW59zy/6ZIjDCySG9kKifXVoH/HO2kDjA4WlFE0B5M
         yxWzahh8VNhxkU48rV6l0i6PBM9VOQE2VNIoeoiYelwiSUzZpI5lhy7TwhlJGt+HjxVY
         qFIB95ylH6cF+qqRPtSY7sbXiveAhATnhHB4icN9AgmrXOX+Ex+BB6s3QeM37DGHHchj
         w0+LlVFUJb95/8xq2l9iJtkWK74Pe+KmQ9Gj96nPQ+DhHMyNWCFkndYljua8l3Sgem/2
         pU9o+H+1cfXufnX94Ly30JLMY3ISnpudFZ0fYT17moT7POKYF1JXbYK9VSYGxeoYFXsk
         PTMg==
X-Gm-Message-State: AOJu0YzU1EBz70q5oikP+UcU2pKnAR6/thU3a3NSpG+ysT/XQi+CRX32
	Xjg+4Kbf3Lw9f25kKju6W8N9Np/J39D3JNLNyLcQbGSUw1/r+553DUkXWg6kBuoFIiFaFLhvrVx
	CdE84iUsNYZLCUojRS3b8ja2B0pKvzoCsIIcQvUj+dLaIkvayrc6j4RQId/Mxw6bDSp8RTN/Oif
	sOcOZ7hr+BQ3YF/SZul7DtrjgQa4Y=
X-Google-Smtp-Source: AGHT+IGzC6wBegF/BY4InGWvNQC2wCX5XWro3nkGNqjvsssmipwEVTEODbeq170WB3/2uigSQJYtADatpQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:456:b0:a59:cfcb:4973 with SMTP id
 a640c23a62f3a-a5a2d553699mr225366b.3.1715340439853; Fri, 10 May 2024 04:27:19
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:30 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-2-ptosi@google.com>
Subject: [PATCH v3 01/12] KVM: arm64: Fix clobbered ELR in sync abort/SError
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest conte=
xt")
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kernel/asm-offsets.c         | 1 +
 arch/arm64/kvm/hyp/entry.S              | 9 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offset=
s.c
index 81496083c041..27de1dddb0ab 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -128,6 +128,7 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2])=
);
   DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1=
]));
   DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1])=
);
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIA=
KEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index f3aa7738b477..bcaaf1a11b4e 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,15 @@ alternative_else_nop_endif
 	eret
 	sb
=20
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
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index e3fcf8c4d5b4..19a7ca2c1277 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -775,7 +775,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
=20
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic, elr_el2);
+	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] =3D elr_el2;
+	write_sysreg(__guest_exit_restore_elr_and_panic, elr_el2);
 }
=20
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
--=20
2.45.0.118.g7fe29c98d7-goog

