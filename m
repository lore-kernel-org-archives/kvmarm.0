Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00B1282EE
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309455; cv=none; b=oL6XSvrjH27li8gwoh0oRyblu52VMj8sQPqDFKsdoVxC0/lMSO6HgGz4aQYXyNNv0eQ+xTm/TPBICVFa7IDgR/ZRR3bzinH/hY4O39b/MdVO5Rr1/YRwaSkiogjIMf+bSguyFMYmaUZ/ktpfaQhXMNL+Op6iivBGE3suFWXDnQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309455; c=relaxed/simple;
	bh=bJxISrCgGtKKuJotSRj8Y+iFIvBlYepS5tjHYrHQ8k0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HonWGScVUUldZmaQHrTlREvpXxzBQTn2CIqlQ0oSAT0yY5XyU3Xy5WiCeuen9O4LzIwKwSe3IU3gft6wu3QgBkXLI1LALpoviy/T6hs/Ahkrjiw8iJTa8jEWpn8LpLN94eVHGN0cewC2hxxSYEIAZReeOr8Jl9+yg6nYP0Trvxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foow86Fg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foow86Fg"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61dfa4090c1so203877657b3.3
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309453; x=1716914253; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BAZMshDytnGDxGhwsqlb8PvuMT4D3ukGQKcLiDQkak8=;
        b=foow86FggOtWgRP+U1stOOx3zd0Er3Wrho6geZYjNg1cCGF6PqPPrKnZK9yOiu0ci2
         Hyj+nPXB4rUq5n0DTaMYfGi0lxpnMj6oYYGDdFPWbQlqhWCvDT7DmgZRwyW4/icTliI4
         jumljxWMWirGeV3qDEymZJzGspuW/Ru/D/vNISpm1LBUF7haEuhslKehBoVBKyYpmbra
         FXqmkzt+WZ7MZQXXA0RiurfZgyG5uxJsh95YveDoqyRhkVzjbkHNEsNGVQytqeFg1Ahi
         pwvbcUc4urF2mG5DN2qjMyYb2OK02CV+aO9Zwii5TTixmNcoSNg+8lSYMHRpP/XD+OMK
         8qiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309453; x=1716914253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BAZMshDytnGDxGhwsqlb8PvuMT4D3ukGQKcLiDQkak8=;
        b=ADCCbBAMzfFaAlwVk0Mf4tZLapeNjFpR1C/Smg+R4E4GsmvheQ5aYhJEhTfQpLHAKd
         Gr16cbqZYVfKN5O0CTXO+7KrJM5az+cnEcfvROLiTHmSjEIiCCGqZP9sPRrl6Zz6+ntk
         e68NeBtHfdaSmLermyFvKj41iT3rZUAO7kgHQBP4G0cj/GNMiTZCIepoqgmnYayDf8lK
         Ok/uT4KdViqtXOrPNrSwI3egrgkybVBuKwajsrg8Fyk0ZZgeFx3oJ+JcPh6zI5cliG/1
         kPq8D7Q5TxM7oJ+i7zS5JdROoFpFDFnnDJuq9OuAd8LgUQ36wIb/yDDSF8EAEnAkIwVb
         90GQ==
X-Gm-Message-State: AOJu0Yx8BSMUifUp5TCeWcAI0C0mgpb5NjZ8/UWsCXN9pnQ/WVSTq+qn
	b/mF40Tl1CxasTHkDGJFMRjRcYr/XimsuWd5fzXJ1i18210fW69aVOUFUQ7/e333L5pGIoS69tz
	TGyoHWwV6bAaVC3T0gOahAWn3KpiA2MwHMQcb2+bNg/WWLLYMIRcNRHbvg7j4uh0ZXdSvju5I4B
	mgsiQRXAfuCGGnu5fFolKDCuD3QNU=
X-Google-Smtp-Source: AGHT+IEYns8x4MPS+Z3Bgo6PiQei5OUYpf/cxfqIxt8Cf9RTN2GzvchoR/eQc/cYbR6sUsvk2B5q0haOqA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:6107:b0:61b:e165:44ba with SMTP id
 00721157ae682-622aff75294mr73783057b3.1.1716309452690; Tue, 21 May 2024
 09:37:32 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:17 +0100
In-Reply-To: <20240521163720.3812851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-5-tabba@google.com>
Subject: [PATCH v2 4/7] KVM: arm64: Store the maximum sve vector length at hyp
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

In subsequent patches, hyp needs to know the maximum sve vector
length for the host, without needing the trust the host for that.
This is used when allocating memory for the host sve state in the
following patch, as well as for allocating and restricting guest
sve state in a future patch series.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/include/asm/kvm_hyp.h  | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 ++
 arch/arm64/kvm/reset.c            | 2 ++
 5 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..0a5fceb20f3a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -76,6 +76,7 @@ static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
+extern unsigned int __ro_after_init kvm_host_sve_max_vl;
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2ab23589339a..d313adf53bef 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -143,5 +143,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9996a989b52e..9e565ea3d645 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2378,6 +2378,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
+	kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
 }
 
 static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 16aa4875ddb8..25e9a94f6d76 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,6 +18,8 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+unsigned int kvm_host_sve_max_vl;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 1b7b58cb121f..e818727900ec 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -46,11 +46,13 @@ static u32 __ro_after_init kvm_ipa_limit;
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
 unsigned int __ro_after_init kvm_sve_max_vl;
+unsigned int __ro_after_init kvm_host_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
+		kvm_host_sve_max_vl = sve_max_vl();
 
 		/*
 		 * The get_sve_reg()/set_sve_reg() ioctl interface will need
-- 
2.45.0.215.g3402c0e53f-goog

