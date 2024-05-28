Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F1616E875
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901166; cv=none; b=TCsta+P9xFQCKJr7FKbt+EILJomiDutX1c8umrv6q/qTjrwWyerFiCMNKYOq5fMKX3/xWhVlcxhIANi+8LemHfUBDlR8k8UbPzSi3l+2TkIrZ4mU5VFsCd3ATzEwMipOqx7+Tti8Zudf6XJcN8R0whEX+dHAK7ifz7dvGlbPleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901166; c=relaxed/simple;
	bh=joPTNbNBZ+9MF3MDVXR5zGvv6kZ18osJtIHAGHfQ8+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ANzkSSYal0TIi8LmYljxrfyexjuIGf+Sfr//W9DsYGaZNUsZa2Q+buHeNZxJgzLi2MKPaFQO2Cvwl2AqLd1tH64Iv6CZeNXv86mEJ/G8UosR+6MxrkvvfmYTs2aTrn5rgbSKFMiuORqQqDzgiqNi/y6n68XlFqMMTqfBDmWINiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a8Ik8kKD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a8Ik8kKD"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78fddad5dso1429553276.2
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901164; x=1717505964; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r+QiCggCS2BFvWndXiWKaMaB45YhFWVhibPBqkjOntM=;
        b=a8Ik8kKD8T5P5BuY7UGExOqxvvplCjQUX0osclcjpnxTZgU+YQuDLWPS2JxzqCL6fQ
         NTiiPr7fX11A6qm43hRFt3PZog9IsiT/KSWSNb0PA115zEAgdWkCHrdfXRElNZDoGRY6
         cL9B0H6r3JN83zneOfAZM9BBM1pgIfNUewb6wGn3ZzMXCn5PocUD/EPzbb0YbeOnwRBh
         bBZZTEhEZnbgl8woFt8at2LLbOel3liXmW4pbCddLSfld27sOmPuSRwh+o3wwVGwfQb1
         RNPb+2Z5A+GTyuUAI2jJMhwN19SedQsXKeJxT7WTFVV9Gx/CF7Nd0wIEphcTShSaeqaf
         1aqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901164; x=1717505964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r+QiCggCS2BFvWndXiWKaMaB45YhFWVhibPBqkjOntM=;
        b=mb4w/9QOrpLwHMf/+0PfUb8Nw5EeKwpRGbIXILK4VI5dZ35C+CWD6ncetrkJDNsgzr
         xRa4ZB8mL/CwISEHUQCo4tlpjylPMiSL1YuwaUn+W7B5yXM2D3I+OV2PdY8vJPkgHqqM
         g+/MKuKGnqknO1+qTKh0yBW3INKozb9M4z/mgeOn/73rCGjjNHCrU0S2YxxYYsvktrU7
         2m7x7DOp/VL8yOp67QZ10YsxxXRm7Dq5KDYjcrKhw+Y2cW/pvQXK9ERG5OFyY0Q2HRRh
         ndZw2kx2yRwijb4CTwypxZANaLnPbFLRo05hDE42fA4/LME2klOnFalv6xZSEka/Dxm3
         RYkA==
X-Gm-Message-State: AOJu0YztIZuI+LBjzAaGea0YoQ7V7DVKlzZ92UODgvwshUHa8fF1DVi4
	Ho4ccNJpJQ4gJPMsvI3VU43CYA88vujOxb6vM+brmcn0iWvlLlLJF9B7UH4Fqh3AvdvN26NLEQ9
	2kLmz4QAf568WO3NqHUDzOXa29BYVZCQ6zMqy1KE9+nGn3aVSinm+ryzInzLNAO3b+42b7cBplR
	3cR8wAWKGb1Tppjk3xp2PU/Xmnit4=
X-Google-Smtp-Source: AGHT+IEslkFdzwwVLli6sx9gX8TcTiCvwCxvf3/LpaNXjWwdImIRi6Ue9Ms/VJWTEMEOMh5le/Q+r2Kqqw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2b01:b0:dda:c59c:3953 with SMTP id
 3f1490d57ef6-df772046936mr3250810276.0.1716901163877; Tue, 28 May 2024
 05:59:23 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:06 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-4-tabba@google.com>
Subject: [PATCH v3 03/11] KVM: arm64: Specialize handling of host fpsimd state
 on trap
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

In subsequent patches, n/vhe will diverge on saving the host
fpsimd/sve state when taking a guest fpsimd/sve trap. Add a
specialized helper to handle it.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 5 +++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 5 +++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 2cfbfedadea6..d3a3f1cee668 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -320,6 +320,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
+
 /*
  * We trap the first access to the FP/SIMD to save the host context and
  * restore the guest context lazily.
@@ -360,7 +362,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	/* Write out the host state if it's in the registers */
 	if (host_owns_fp_regs())
-		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+		kvm_hyp_save_fpsimd_host(vcpu);
 
 	/* Restore the guest state */
 	if (sve_guest)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6758cd905570..019f863922fa 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -182,6 +182,11 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
+{
+	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d7af5f46f22a..20073579e9f5 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -262,6 +262,11 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
+{
+	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
-- 
2.45.1.288.g0e0cd299f1-goog

