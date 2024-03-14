Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2173196
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447862; cv=none; b=jsTQHNy9xQ2g2vfIY9p3mkeCVRMG4RKe6ygtE/cgsSFKyhfQBN/iwCbx0qSxgj1W4tHIgyfPeBTEnLsneD147Q6xL/k44XagXwtu8q+hkE4C1mDjoBgQJazr+G/mf8WJQgrPCZU0VxIaNJ07MrBfB6SYhtWfNqg7EmmamaB2OMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447862; c=relaxed/simple;
	bh=VNW8QZydmWpg/n7NPOfyNLIqspWVeZ/mxJN8WQ/9sL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RibB6cGOKBhQJ0kt7bUlUAz7EIpc+KrATwAUlvVubAzXeeVLuDtv0Wocv0GsckYNyjSQKPtLu1JYXEspwMoqQe/08ktQ2eDBQ7kfmQ3W3iuuuXJ8rM+R/fcsnPVuGT5DXXpkbDERoron8p9MlYI8NM+D7LEwf8Gx4DBf2Wvfif8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yAFytwWt; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yAFytwWt"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-568a53d2ce0so1082469a12.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447858; x=1711052658; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FGHXKr9Rrdhb7ltTqwpYqVe2UrsjZifyrXsCqgg5SVI=;
        b=yAFytwWtidMdgpLS6cR6SkjSNRgG+wdTaYzyX9d4qHiZB6wTJ2Y7hXs0i6xoSNFMDn
         n6FZs2yc+NCuuwGp8BJKWOvVUYViJWbEA86WKi2k34eicMLmWAhTC3hBOmSk51AdzBv1
         lXElty1kfYsD+QFvd/0kd7UDk3joSA7E8B3N2CVhd6nTkki4ERHyVjDC+jNBt7JTWFPA
         tiw8JDAaa3wuPlR14v8C2mEm3ZYM6A1+/tlUDbW088ksIbi+PsPkGBd1IafPdfsp2Npl
         QEFyazsKPbD/NJZuxZe7nMn0t5+sCl24Z7BQkWuZxbLceDnL7kc+eEhS92sKsoU1bkDD
         Js5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447858; x=1711052658;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FGHXKr9Rrdhb7ltTqwpYqVe2UrsjZifyrXsCqgg5SVI=;
        b=D9C+qA3QrHVC44Dssu/mUvSaJCQ6o/SvL7/ELYkRumoyWcfFmqq6bXkGwvHRelsphx
         L3gnVgXWoiNgQLPYUHVCdQP5z0sdGSGSPx0z1VXvLoffS3BXqMOqR0IiLE0EQVLfP5tL
         +s5zK6s3nCVYh8Pf9AXLsCIWQdiEutCtKj/BGooSXDTWufcCUQ4Qe57j5gPI/Cl7idIW
         P1otJf+hckyGQ11/G8L8a6JyWOft7ERNS2peMYekXdds5hNnGyGeAXMIM3g81tnRilbC
         mcrpC5TxKvnEZvo+3DjmmvA0nOb0K0jUaDY/TUmlraWBUmc/yVFM2t2UVJZQ30rM2/0d
         tlrg==
X-Gm-Message-State: AOJu0YzS5s2MH/BLSTRwJ6yHEQfgPaqIGqMzC9o18StyHGpSGOu0Vj4o
	CJMKXpWJZt8g8832BpX9UTAyylJaYP8lXjLG8s2UQipJSPH/XpJCxMJxvh4cyioK6kOpFXhD4hy
	26gfX
X-Google-Smtp-Source: AGHT+IGDSjzpxZf8AVYQE+b2VkhZATxpfpcqloyDmGyoEsgY/Kxfu5Lu+ucHeadFj0dWnxHl32HuWQ==
X-Received: by 2002:a05:6402:160c:b0:568:335d:a95d with SMTP id f12-20020a056402160c00b00568335da95dmr1235050edv.18.1710447858444;
        Thu, 14 Mar 2024 13:24:18 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7d358000000b0056729e902f7sm1019134edr.56.2024.03.14.13.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:24:18 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:24:14 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Andrew Scull <ascull@google.com>
Subject: [PATCH 04/10] KVM: arm64: nVHE: Simplify __guest_exit_panic path
Message-ID: <b13ddc391fce3ea01cffae9c694d997381598616.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Immediately jump to __guest_exit_panic when taking an invalid EL2
exception with the nVHE host vector table instead of first duplicating
the vCPU context check that __guest_exit_panic will also perform.

Fix the wrong (probably bitrotten) __guest_exit_panic ABI doc to reflect
how it is used by VHE and (now) nVHE and rename the routine to
__hyp_panic to better reflect that it might not exit through the guest
but will always (directly or indirectly) end up executing hyp_panic().

Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/entry.S              | 14 +++++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  8 +-------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 9cdf46da3051..ac8aa8571b2f 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
 
-SYM_INNER_LABEL(__guest_exit_panic_with_restored_elr, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_panic_with_restored_elr, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
 
 	stp	x0, x1, [sp, #-16]!
@@ -92,13 +92,15 @@ SYM_INNER_LABEL(__guest_exit_panic_with_restored_elr, SYM_L_GLOBAL)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
 
-SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
-	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
+SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: vcpu regs
+
+	stp	x0, x1, [sp, #-16]!
 
 	// If the hyp context is loaded, go straight to hyp_panic
 	get_loaded_vcpu x0, x1
 	cbnz	x0, 1f
+	ldp	x0, x1, [sp], #16
 	b	hyp_panic
 
 1:
@@ -110,10 +112,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
 	adr_l	x1, hyp_panic
-	str	x1, [x0, #CPU_XREG_OFFSET(30)]
+	str	x1, [x0, #CPU_LR_OFFSET]
 
 	get_vcpu_ptr	x1, x0
 
+	// Keep x0-x1 on the stack for __guest_exit
+
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
 	// x1: vcpu
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 03f97d71984c..7e65ef738ec9 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -122,7 +122,7 @@ el2_error:
 	eret
 	sb
 
-.macro invalid_vector	label, target = __guest_exit_panic
+.macro invalid_vector	label, target = __hyp_panic
 	.align	2
 SYM_CODE_START_LOCAL(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6a8dc8d3c193..0dc721ced358 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -747,7 +747,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic_with_restored_elr[];
+	extern char __hyp_panic_with_restored_elr[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -769,7 +769,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
 
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic_with_restored_elr, elr_el2);
+	write_sysreg(__hyp_panic_with_restored_elr, elr_el2);
 
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 7693a6757cd7..27c989c4976d 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -196,19 +196,13 @@ SYM_FUNC_END(__host_hvc)
 	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
 	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
 	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
-
 	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	hyp_panic
+	b	__hyp_panic
 
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */

-- 
Pierre
