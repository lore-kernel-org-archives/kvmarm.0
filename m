Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55C6282EE
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309453; cv=none; b=i+ri6jj7ZypGDing38soM0RypfFwObKmEJzjYL26+Ijq1kx6jpryDkhx0QctSXlGsi1mzl3pabL/Sv6PVef4xhQ6s/pPEsp3aoNjzpX4imELmVbtQuXkyOyQJCjip6x145bEBn0lPT6oo03MZIDnZKJudie/8YuDJbAtiiCE+zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309453; c=relaxed/simple;
	bh=W9eaIY69PS4FpTnSSIPPNi9w6/UTStqkVlGEhdd1lR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LFFZFJOay+ctSJPHUAX9p/tFSNzILLbZS6pDMva4KRyvN+EcX32/0GshmlMVdtkK+y5QDLPvBNlTtKE+1lY7v4KKye/Bw4F33uWjgk7gcy5+GPZmmbuObJIiC07y5863IUG1kyxBDeLbb0QWqvc0UE6d/o+rTBlfg6Q0058KF38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TwzqkAks; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TwzqkAks"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-34da03e19beso8839929f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309450; x=1716914250; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k/0hj0j8uoKeQ/05yPMhnQ/V/3jbf54VOj9SgPeRjlM=;
        b=TwzqkAks2ZBqYa1TDyPxmelDztMdjrzu4mbL5W8sBNiz/WCeYVV+la8kLTvEVx3WND
         N0UG6CuQso3zkeTppcWAz/5z/QGbdgvmFCSnqNUx0ZhFmMdpgmGt8TIqum6iO9jlxms4
         aPcdIke786gYnRBUlpeJyzs3Wjy7OJT2anIDxiTcydwbyUczVL1k6swuVUZFRZmJjoQd
         yyeQJPHXK3R94SqhnT7OmZTB96260aQNWcHZc+KZe+7JhbgNaqPwZgyXFwGxpUJoXbXl
         j421YQXfF69TDr0hrPw/7eudqBR6DYUTUG9h6AYm+uBJ4Esun5KCoQsgnM8wJ+juJwfx
         VTAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309450; x=1716914250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/0hj0j8uoKeQ/05yPMhnQ/V/3jbf54VOj9SgPeRjlM=;
        b=OZSWfG2pvVy4TWXXjzdOvVzDpxAiIr2eG9orrTg9Ab1fJcbj+u7iV0O4YqrKvvCDJJ
         PuY8sleCWFslBgo4DiNTwsi9T217OZXDEuz8/msE6bNIyTRXRy0pGujJ+sZze2Rps4em
         8+8EqvyLNGqxmjBdKzbWtFY55i2c+mzHOjqXnhlhd/JnOQlIv82esM+/Ql6hP2fVAI+O
         /+MWV3N+/5dGmDKIuwHype3rFphDSNGaKchQNiw/LB23PF9PFNDqeZDDt1QkLhK3yFPu
         Lhg5a1kVSH75mTjRQzUP24bjl49EaaAlhLyob4F0oBeTU5+wAtKeMcrAPpRbXPOz7bCV
         XLOg==
X-Gm-Message-State: AOJu0YyEKyKtzKaYlTolsHpzZLefH6FUdU9Gp0DCHwZ2Plqd7ch1KDYA
	3xu6iCtjZoVNGc1Iw4g7VbK3E1zwkOH2OlVTWmMUH3L4ujx5JSRuT6eKjBcEng8Ci/23A2ZZWaM
	S8q1ByMyi5b1KQy9Nrvu1DkBX2sM6MFpKBaBFeVA3HGTe9q7KMDequQBV34DkMV3ttUYyAC9AOh
	r1nEI+x9HXbeiC6oQcKLFHahDyHzM=
X-Google-Smtp-Source: AGHT+IGfo3FoP1LPLNecJM9pz4MMBU+/bkr6sW/B/VYT0/8JAzKn/12TTr6SufeDBwVYLZkOR7A/ZAm5aA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:55c2:0:b0:34e:23d7:3ad with SMTP id
 ffacd0b85a97d-3504aa62e82mr61396f8f.13.1716309450010; Tue, 21 May 2024
 09:37:30 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:16 +0100
In-Reply-To: <20240521163720.3812851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-4-tabba@google.com>
Subject: [PATCH v2 3/7] KVM: arm64: Specialize handling of host fpsimd state
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
index 2ebe2fea8768..1897b73e635c 100644
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
2.45.0.215.g3402c0e53f-goog

