Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA874172777
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457914; cv=none; b=T/3LNEf+p7+x0s0Z1YRV+WAdI7XCCRkWAj1T69RwIH08Gi5tAmC83aU2JvJ8IX/SVzKIGyEtVS9lrDmvTWJ1wwJJrwDQq+C9asrv2fyUnCkZJfCBcXclCtLbROBQfhdR+dVI1ooXGBtjILA25rYj32+Zxk9gAxxjnkVUMFaLxWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457914; c=relaxed/simple;
	bh=c2CK72lGJDZxhkE+vu1jRDsSGgFezzCof9rwe6Qg764=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKL0NwINNOMzSgO8TbKabIs3gpOcMUaUB/OivocxaQSOrvmo0T61oRcKT23L0EZaBur8Si1GDYmX8ABScHq5AC8JFEpHnPfVsO3OrSqDtJ/YZHiR5YCcfdfqLROcHSgSHQzitwJ6t/Nj2U6WmCqcc3To+8bWYpleqZIqBpyjocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A+ib7gdT; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A+ib7gdT"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso2430116276.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713457912; x=1714062712; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o/WdHir/Mi2mSDEW62XszsH6Iho8VZ+3enjU3uPIcDs=;
        b=A+ib7gdT9cA8rhq8UEHgdmf5Sz7U+4xpb0uCJfa9l3FQWAo9+tNQX0CmYE8gxAPFWy
         cgIFd+ltagEkE3NrlsIJt+1wq87eMwV8Dl2wxmggtgHQVIa0WiKAAlkLG61qa0aLXTpr
         6jEB1c3p30BLhJ9F565Ew1QaAQZMzud/XH9FfE4m417FPkh47iN9wrctcQE6EzmOwls5
         y+k6C/uK4JYo+uDcnmQkCnXmK6GNLBNYKmaHBWSFIJHoSyzRpXIwloNtdz2bxNkTZXFO
         SjZhEjZ5leWKcBAPlAjcLMT0DHgC7Jww7dWuU1LGJKQ4jSBCmqB9dN2nUQ7b0cVJcCVS
         5EJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713457912; x=1714062712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/WdHir/Mi2mSDEW62XszsH6Iho8VZ+3enjU3uPIcDs=;
        b=nckwrnCSRt0QvXAeu4O9RCfriX5kg3dNaUdmRt0dt0G/ocj3GGb5oG9sweq6woxWWp
         KyBxGjwNIRGfuokeUYSrMM7PBaHXUjxn69rkG3pOieI2DXZqJ++ewhtUdb/FlQP0y6bu
         3dwDcKA65dHl5TwrGsbAz4Yz5oKp7KXgDKDJAmPUewVHk2RPTWFkc1JtvoKAOk/kiXWb
         udtYWXdFp7F7A8gAQKpm2Pj8ySHF/8HIBj1flcDd+Q0jMwml9vIpzA/d1e0m4BRuhapJ
         K4rRhqk4aatCGICxOxSuxcRGHfm0htsowa6R+2noe5uzauqm3ca2/iayV0DJdSYoKejg
         fIOw==
X-Gm-Message-State: AOJu0YxXiH3MFCZD+KmA7ewA/PTue40X6nICrnNqnbVrl9gShcC/EiSS
	z2FuD5AHMuDjOZhJ5nROZx+1oD02IdmE283WJUJcfbadNYJ2Xas0wocMj8qm/a1KaXYHqsu0aWF
	F3cfDPu2g9+vaUkFPgVywwCZyvA==
X-Google-Smtp-Source: AGHT+IFU3gG7mhRXP799oGDxBlPxLgFLfF8KRo1VK5xtAu+Ns8G5jem0y2bESQeN8vefdLLSBSCfbA/Pv4M4UuLpEoo=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:2b8e:b0:dc6:cd85:bcd7 with
 SMTP id fj14-20020a0569022b8e00b00dc6cd85bcd7mr831056ybb.3.1713457911701;
 Thu, 18 Apr 2024 09:31:51 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:30:26 +0000
In-Reply-To: <20240418163025.1193763-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240418163025.1193763-2-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240418163025.1193763-6-sebastianene@google.com>
Subject: [PATCH 4/4] KVM: arm64: Use FF-A 1.1 with pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the layout of the structures is compatible with 1.1 it is time
to probe the 1.1 version of the FF-A protocol inside the hypervisor. If
the TEE doesn't support it, it should return the minimum supported
version.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index d53f50c73acb..8633c8e0b09b 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -455,7 +455,7 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 	memcpy(buf, host_buffers.tx, fraglen);
 
 	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, FFA_VERSION_1_0);
+			ffa_mem_desc_offset(buf, 0, host_buffers.ffa_version);
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -534,7 +534,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	fraglen = res->a2;
 
 	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, FFA_VERSION_1_0);
+			ffa_mem_desc_offset(buf, 0, host_buffers.ffa_version);
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
@@ -789,7 +789,7 @@ int hyp_ffa_init(void *pages)
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
 
-	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_0, 0, 0, 0, 0, 0, 0, &res);
+	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_1, 0, 0, 0, 0, 0, 0, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
 
-- 
2.44.0.769.g3c40516874-goog

