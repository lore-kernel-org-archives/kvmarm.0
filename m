Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1775B53802
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984874; cv=none; b=a+8joX/9YnWG3h+D4ArmAmhlDbklOTm+787ptiwQHNWGs04lT+PryPjGF0b1mQ74sf3y3JpG1QREczVe0UejCzmWbvPJJ1IaIltU2Wzfp2SMzBXwiAJFU/z7iF4125B7xr0lM3Vghfk5lS4gf7MQ12oFJ4L+Bm6AMVtxJqFljaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984874; c=relaxed/simple;
	bh=+Do1Lj6aoKl60X1qo3qBYBuQpEpA40aboieYSjIPVEo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VR1R4c+JoAUFz49LHVrEO/JEZrDnahsqkQH3u49wsJJfEuA1Kq/qt0/d9t/gVcR6rTyrqKkBYESqZ95eYLf1rjPaw9ZtNtG5NdKwNjRoyXbz17rM8RrnjnpBKgJfOp0Kf3DUxXx9ozkp6HuEoZTGTPMdCeIOTnIxtudXmUeL9LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=udM8jIWa; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="udM8jIWa"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-579c4641702so1175616a12.0
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984871; x=1717589671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LiBCWky943GnQdDxaq98aS8ZLEQ71giQKbDHRUj5HqQ=;
        b=udM8jIWafwZMcP21JsTieV1su8QmBqPtFXndkpRC9euQCF8uC3+TUXV6YlcYp1oQdI
         DvGpIL6iOzyR2+LN8+7J/vrWQmNt0TN4kfb5/jRAjKUMfWm8sgdLTsL8YN2/Uy+6feLj
         j0WT6/szwT0jquWN75nlZ2SvmBW8b1joOVwJWjXs/yLat89GQh3y2b7Bccg3Gm5EdJbI
         iR5IusgQFcudyDjuvC30gl4uRq/7Qxb5FUyCeXyqqV5lfCcb2oCy/YYWtImxZnrPkMro
         TDsif8ZH1uRk/5MGXBrCAQEsV5Xtj3n/Wu7m5u+JiHztk1O4DgdX/HPze6NSXs2/5pyA
         L/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984871; x=1717589671;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LiBCWky943GnQdDxaq98aS8ZLEQ71giQKbDHRUj5HqQ=;
        b=OemTAXqT4ZN91Lh7+Ngu+x2cZoADSPmLMcVrXVxBxH1P5EkQKasNy28jYHMCcmMXPv
         i5MH9QwFtJUfk8/NFV7ixGMIVZAYcyuJUKDYoLyD0u/l1eycELGtNhTBdwdrtbEdkbd5
         lFOpuJ3M+yjhFDhCBJvbHRxHsCbrVg7V6kzb/6g5Vosg8Ntr08hkga82qDfCBH38doR6
         jwD+ya8juR99vvtPQ/RJ/An1amRGF3u2J+hzZHndmW77kahE8TbcOaBpdwckwUjG2upz
         EQUen/hDX6eETMAgR3g1CH8FkwZUEh5lvZ9VPtghG0TYaIBnditrWfYOUdxG45VgYymK
         dLow==
X-Gm-Message-State: AOJu0YyFwumL/OEv0zpRi2kq/8Z4zCGa9bQowRMLkZY5LjljAsAL98l/
	symha+Vl4gF597WU+XXoLQHVWotyGTOo6s91E3U4BHzq9IYxHRl+k0bGRtZLXbTtXU4Jl34Wp1n
	Y//Ht2SymXsvUiPHcZlFkUDE8oeQsxBQdAbsP/ces1ITtUYSEEWA2UysfXkUkFSrfr3UH41dLRh
	W6K6Xrd0eob3Y153L4ULyfu7JjE6g=
X-Google-Smtp-Source: AGHT+IFP6n0siCbzTCYAQHYIrAphWxkqP2Ntf7Z84XOpYY4Wgk7fdgvFlpZ4wx2gsGuIGmJgr+coEywpTQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:3185:b0:a5a:1c6:b892 with SMTP id
 a640c23a62f3a-a642d6aba53mr229666b.6.1716984871216; Wed, 29 May 2024 05:14:31
 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:07 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-2-ptosi@google.com>
Subject: [PATCH v4 01/13] KVM: arm64: Fix clobbered ELR in sync abort/SError
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
 arch/arm64/kvm/hyp/entry.S              | 8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 3 files changed, 12 insertions(+), 2 deletions(-)

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
index f3aa7738b477..4433a234aa9b 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,14 @@ alternative_else_nop_endif
 	eret
 	sb
=20
+SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+	// x2-x29,lr: vcpu regs
+	// vcpu x0-x1 on the stack
+
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+	ldr	x0, [x0, #CPU_ELR_EL2]
+	msr	elr_el2, x0
+
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index a92566f36022..ed9a63f1f7bf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -689,7 +689,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -711,7 +711,8 @@ static inline void __kvm_unexpected_el2_exception(void)
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
2.45.1.288.g0e0cd299f1-goog

