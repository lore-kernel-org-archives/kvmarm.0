Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23A20D4FF
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533982; cv=none; b=ttewMqQb0PiIpIv+YiEh3vOyqHdus/5jvU3bwU3NAtzkgxuxgFSnwx/lMoVUvRXNwlXUKGsAlSWJcn0nOsPA60kSbwXotx7Pla5gWN8aX+1p2ocJq9t/YTDQQm5lfRbp1FTLAddAPNF7GSSu2JSGUEqU3XzXOM7+6Qyus1QzT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533982; c=relaxed/simple;
	bh=JP8zf6L3hflAD9DfHgHhFb+z9U9XgJ/aXorJou5xHMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sdd8NGtGxh9MqiA/YLdkKzIjgLDip9g6DT7DbZspcRFLM3Ac6qt+tti4PJeW6ajnuo6yP0cr94Hb6wUaJJNMm13wJYOPsRnU2Lm0dgpuDFmTZaS/G4fbd5fIQ1ng9Qbzljc7DVKrbtThXPVxntUU9wvVc81WCopEjP0ORHb2SJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g6oqZntm; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g6oqZntm"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86cfff5669bso475195839f.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533978; x=1753138778; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SJZ+xwDjyMIGIgaKCFQ3UPZ4fJ+Lh0B/3NWWuRP6Bzw=;
        b=g6oqZntmcJsSXpBI1DRRUCv2oKqqpnaqREJ7ND8nRi5AOunR7wQIC+xHuiS1/4/dSw
         oSRZwBEwM8Ei2gaeGIetstsF2oFLnMhiKI7O28Hb0qy8W3UE83XRyvgdd78Lm0noThWS
         yJ51Q0yw9vLbT/ukCKGcUrxl+ZywqLWYVAJgMOmo3Bt7UoHugGUBb/zyR0x3a2vkR3zm
         yXfz3V5Sj3vtDMHo9M24kv2siDdyGXspdwMIGq6coi4WHL1m7sLvc2HzQAssoDpfzDOU
         78rQR9w7L95i3LqyWugKDK8MXpJx/FP2a5Ajb07mBCnsk4nSW7VvHB5PqhlTc4+iuzsP
         NBUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533978; x=1753138778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJZ+xwDjyMIGIgaKCFQ3UPZ4fJ+Lh0B/3NWWuRP6Bzw=;
        b=ToLa1pshNeAkzWdFWh/OzL1w03bv2jfJLArr7xBEzwb2FbW+AEAjr574FlxvM8nW1x
         l7WG2hK2BI91NNFnGgjAecAS4O0I1Z9+Bvztx5KGh9DAnD+T1N4hBliBZ1+dhvzuDhMO
         8Yk+QHbXIvEoTxLwiiJqDcbOFOpa+8HD3bpU4siNgm09hx3Ghgtq8c/OE5+PRRjolILd
         aIYdGeD7WxsUBW1B2MO1I74lZWJwRgBvN4KsYONTRMxqYmzHlanvCVUIhwWviZEe+cVj
         fSHYTc7ZzzTQrpaBW90lp/tztQyWWiQOIsr5s2XU5kszj4bRBnbEuP9gqNQbzPQ9iavF
         +j0w==
X-Forwarded-Encrypted: i=1; AJvYcCVhdIxAkyMFLgl+ox5sBAi/9UEmpeVj9p1tfO4Jwvh84Hy/nGUoeSEdFwJAtFJ1hASs5bIDtqg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVj6N8LXoXSECq/Rw0j4MBJheMQ1CY+RDWV5UUsJLD3wJg2KUK
	bFCLo6H4oCKj8n2htfKfkwg9F29If+xFXHFxLmAewEcW7FcoEwhiiqhJtqh7BAglEBY6wwFewsY
	9HJb0LIKcrDbe5sQwGPWJdCdCjA==
X-Google-Smtp-Source: AGHT+IGcsfYXq37Q6WkECHaXfuTpZ4xUC2MHD5EzXhz1ZNa8q/Bm5uigtDkeVAlpUUfariaZ73ybTmOi3F0pZZ07NA==
X-Received: from ioxw3.prod.google.com ([2002:a05:6602:5c3:b0:86c:9981:d21d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:3411:b0:876:b17c:dec3 with SMTP id ca18e2360f4ac-879af05ab13mr188823039f.8.1752533978200;
 Mon, 14 Jul 2025 15:59:38 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:02 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-9-coltonlewis@google.com>
Subject: [PATCH v4 08/23] KVM: arm64: Introduce non-UNDEF FGT control
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mark Brown <broonie@kernel.org>

We have support for determining a set of fine grained traps to enable for
the guest which is tied to the support for injecting UNDEFs for undefined
features. This means that we can't use the mechanism for system registers
which should be present but need emulation, such as SMPRI_EL1 which should
be accessible when SME is present but if SME priority support is absent
SMPRI_EL1.Priority should be RAZ.

Add an additional set of fine grained traps fgt, mirroring the existing fgu
array. We use the same format where we always set the bit for the trap in
the array as for FGU. This makes it clear what is being explicitly managed
and keeps the code consistent.

We do not convert the handling of ARM_WORKAROUND_AMPERE_ACO3_CPU_38 to this
mechanism since this only enables a write trap and when implementing the
existing UNDEF that we would share the read and write trap enablement (this
being the overwhelmingly common case).

Signed-off-by: Mark Brown <broonie@kernel.org>
[Removed unused vcpu argument from macro]
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h       | 6 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 7 ++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 92d672429233..f705eb4538c3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -301,6 +301,12 @@ struct kvm_arch {
 	 */
 	u64 fgu[__NR_FGT_GROUP_IDS__];
 
+	/*
+	 * Additional FGTs to enable for the guests, eg. for emulated
+	 * registers,
+	 */
+	u64 fgt[__NR_FGT_GROUP_IDS__];
+
 	/*
 	 * Stage 2 paging state for VMs with nested S2 using a virtual
 	 * VMID.
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 7599844908c0..7fe5b087c95a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -153,9 +153,9 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		id;							\
 	})
 
-#define compute_undef_clr_set(vcpu, kvm, reg, clr, set)			\
+#define compute_trap_clr_set(kvm, trap, reg, clr, set)			\
 	do {								\
-		u64 hfg = kvm->arch.fgu[reg_to_fgt_group_id(reg)];	\
+		u64 hfg = kvm->arch.trap[reg_to_fgt_group_id(reg)];	\
 		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
 		set |= hfg & m->mask;					\
 		clr |= hfg & m->nmask;					\
@@ -171,7 +171,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))		\
 			compute_clr_set(vcpu, reg, c, s);		\
 									\
-		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
+		compute_trap_clr_set(kvm, fgu, reg, c, s);		\
+		compute_trap_clr_set(kvm, fgt, reg, c, s);		\
 									\
 		val = m->nmask;						\
 		val |= s;						\
-- 
2.50.0.727.gbf7dc18ff4-goog

