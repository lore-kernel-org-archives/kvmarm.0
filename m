Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F03D77118
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417739; cv=none; b=XuBb96sCJWwK0E5L+QE3GA0bQEdNOfO03Ps+SWtYlAXcbsT7URRL4+dMxMOgkOAQdXIKXDFJYvYl+U1b0nzZsre18X7I9DgkG3jazpLnJSzsjRH3NIjlQnvbWcirNsxHGINUKjmj0TAcvv4yQsyzjOnJ3bc9BAEVN/jtCSotFK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417739; c=relaxed/simple;
	bh=x84lbyLAdvxffUIQokclEzOAI8Pjk17cnvn6wlyv/R4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nkSBYhdN8VHBX8DRSncbRZO3pdWOlk5JD/Tp1xaN9aLTNf8x0t0IvmWHXZXPBGptJYf3CpIATfE1gqgEXDdcWUNyLFtiUzn1TZLgxbG3RpEHWMeMLK+fPy7uz15hJn/PU3KrRLdwMck454X/j/TvGdsVny8+XGZ6iIQsoAdSCrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yzFllasd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yzFllasd"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a2aec8521so67568407b3.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417737; x=1718022537; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJElILGc/DFr0V7MwmCDmwJNbQ0Gt5gen+2yBiM6YFM=;
        b=yzFllasdm8uRZ6TL0IIdIAQc5Kg2jQPkA0wQSb+ZBPmqCQCsdgBiHnpww3/fTF28t/
         JWUCboF3NSBom87LnpS1plN1mS1brE9keuZCqmnUPVacpjCY1RYxmr2duSpEFXwYj+u9
         v3nUzwKBgSsgt7Kbaf24yGgjJgpP3OqZTINTxa4GTMWlIPJ2yhRpXDbtmvotsjif0qSh
         yx3YcHQEWGf32kfffuGzkiy8TDkfZf7IaE6pJWOfTdjrnngsHKvgef8IpZ2ZpqtEiDts
         HWTCGBxTXSYZgQfnYlsEQJi1oAlNs2M4mcI9/kxa80US5TLf61YzCanYLpS4nqFZS/ui
         zRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417737; x=1718022537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJElILGc/DFr0V7MwmCDmwJNbQ0Gt5gen+2yBiM6YFM=;
        b=F/aUjjGpeRyYCfQLv0g9/VGD3PbL/sQ64SOiOmCnqdRUUtagtpzq7s50fJZqtIOty/
         VR1rpftReb/mv5BfEVKj0iV22po4kH3j9lti1Q5wpAF3CEq2Uv4gGfQ5Sc+9jHhGn7wb
         W6b7n+OEtsNdepoekcTmig+kVugIy42YScaeia6E55rAN8E1GRlkD3T4VohXDPXsOmVF
         1XjjLi0BKZ8qt2ypwd0aOboUiZ1nAaI4Zfq2KRvTcLWYcV4q7yUqtP4kxO+ox0WxZ7Di
         tpmsKl6n6pzdQ39SGiK4wqblrnXbpjEWdewWgO2UUEzEP869A+pe9IgjqZJBGayqa0HA
         kadA==
X-Gm-Message-State: AOJu0YxGIGpG+zEPxJSvCU4TDH/4vjtwLzgvElbtFFrxzq9Da216ZufX
	bqVqVXuHkFD8i4ozLtN5Wk2VHzAHKIUSDx/qssLYAGe35LLSXJcQU4suoVxMKGFAhXpjuvAa4zh
	5b6LM/FtsAZaoJZ6+8ty1zOhllEHplJnGQzD7CTOR/+jyOexpHlI9SSEgtvVpzLL1dXSZTvoJhK
	ewAzp0bSjJnu8hcmKbQyx4Y6oivFs=
X-Google-Smtp-Source: AGHT+IH9EZr0+cP35eFhh0weNHHYeukIG+afizsQT2UWTA3EwT7k/xipG8LyTSJ/NWUCj+R123OVNcA/bQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:39c:b0:627:96bd:b2b with SMTP id
 00721157ae682-62c797ecc09mr30469737b3.6.1717417736650; Mon, 03 Jun 2024
 05:28:56 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:43 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-2-tabba@google.com>
Subject: [PATCH v4 1/9] KVM: arm64: Reintroduce __sve_save_state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Now that the hypervisor is handling the host sve state in
protected mode, it needs to be able to save it.

This reverts commit e66425fc9ba3 ("KVM: arm64: Remove unused
__sve_save_state").

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/fpsimd.S      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e80464f8953..2ab23589339a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -111,6 +111,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+void __sve_save_state(void *sve_pffr, u32 *fpsr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 61e6f3ba7b7d..e950875e31ce 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -25,3 +25,9 @@ SYM_FUNC_START(__sve_restore_state)
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
+
+SYM_FUNC_START(__sve_save_state)
+	mov	x2, #1
+	sve_save 0, x1, x2, 3
+	ret
+SYM_FUNC_END(__sve_save_state)
-- 
2.45.1.288.g0e0cd299f1-goog

