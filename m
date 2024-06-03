Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920212BEBE
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417746; cv=none; b=VWT/0FQIRohf4KAwbfW8Ev1dRD61RALzK9SOHspOIOxOXmCZHZEqg73AG5DnYLzMGdI4W0NXtYkCkgFzfMyUaaLRzWe//qVtA87dUYmFQu9AYExFtTFvyDw3/30erx5PJrzszuDcsVGsbaeBPvK+Wzu1xbATc6bNTQhHTkzbRZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417746; c=relaxed/simple;
	bh=l8UsS8GCm8foYDVUOasrc4eFIT3M0YJyXdxJtNcxUv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DxGskb131qdC4P5hVj0mjy0ecqBxRGBN7V1TR+WYx8mfKKujFj/XvTWBpftyf06BnNvdlRxzvigTmK69gVIIjqX6qw7QCZEvA7uCTgWA3IkLU8dDoMMCUUl3JkABdtYH1/o+NxFbFpcflUEMwBH6al+4Z5yxdYv+MlmVNrbM0XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0K2EzsDG; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0K2EzsDG"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-354fa62abd7so2063222f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417744; x=1718022544; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Obs8wQb56SN3ytvB7eYGaaTtKy9MiA5Ct8Vd1I9X58=;
        b=0K2EzsDGfssKMcv2cjnJKpNwiOb10COYtSFbyNan3NR8GYy+xfs+pQ8hLIgdgAjO4n
         lSXusZzjkHzp5L5kY9l2fWwdEYLjZeNY8q3TodAd3vCSw7IsCfQUlmqPNIFGQcj+hyFh
         dEpl3t/bcKI5MLKm9zTGonumNEETHEC0T9NOMfU/H1NQOiWp55U9MZqmp4z+1JzNcZpt
         kRWz5gCUXhHE5PZCBVt2fFC41eCjDzkKvZ6FeqsEESrnpLB2ECE/5sEqMZOmuXqDywm5
         FP1A5rt1VD4HnuQW7cAfDgvqGO6KlNF78Hn91gISPvoNpq8oE5mg4URohyQ1S1YXYZGC
         zvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417744; x=1718022544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Obs8wQb56SN3ytvB7eYGaaTtKy9MiA5Ct8Vd1I9X58=;
        b=D5c1aFfiHPrHrZs0Q6E21L/BGQT7qy9/fa8kVgGu0iH73TC9ijSDniNIrUjOUlqkLu
         CQ1QrrVH3LthfMp/rWPhMK09/9iQKI0MqaC5cbb9WO0BSI2iC+zFRS8s1F5EZUSpX9Ix
         XTjS+Q0IAkKMNfoEB8kWFK9A7wzlqlA30CfBt1L27tFRYwRbBHilEaCXe7iQRKZfeu4v
         PpB0+TXBU5A77DWAnfgiDPj53fZHg1MTo3GZ6IOi4vry1n0o14rVvkcnceuET3BxWaIP
         OHM5eEXjVDIv/KYPZdWtVZEnFRT2KHOs9HnF8Wk0gNai3qn7CUExRLEmf31OkgPecuPK
         /hnw==
X-Gm-Message-State: AOJu0YyS1xgpt/R6++r+HnhZXxaEJU5s90ypsipw1rvLevD/CjxEhNRc
	/N78dwegITWAU6bEm3NV+cucVP3NQ+zD2YGstDfFxE/tMDpvf5DjeVnEQIdPPNtmYtt+XuRFITs
	khAHaYh6rus7qPf+7bxMdqYILhHZgdVl34kx5TrhgKfnDDoQfY1qBIHhG+kv7DTOcveLAs3Tcfh
	H6YhDxRmbAAMdQzbB2rPEdJkTL0kg=
X-Google-Smtp-Source: AGHT+IFurd6haRy4TrY/aOhmQai6XtU0ooXEHS9lpiY6OLHdBLWtxLD+Ga6VPY3uWeNVmCdauneRn5NOOw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4941:0:b0:34f:b5b2:2154 with SMTP id
 ffacd0b85a97d-35e0f26d9e5mr17562f8f.6.1717417743332; Mon, 03 Jun 2024
 05:29:03 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:46 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-5-tabba@google.com>
Subject: [PATCH v4 4/9] KVM: arm64: Specialize handling of host fpsimd state
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

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 5 +++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 5 +++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 055d2ca7264e..9b904c858df0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -321,6 +321,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
+
 /*
  * We trap the first access to the FP/SIMD to save the host context and
  * restore the guest context lazily.
@@ -361,7 +363,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
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

