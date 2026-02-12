Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0239E2DE6F5
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 09:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886979; cv=none; b=ZTaEE488e42K8wxqrFTGkOaNO7B+UPLGpLEa068gHhbZkKTxrFiC4M/nmAkLSuo9Qql4Gv1xwxipvDt9ZifWyr2oBfbLqmkJ31w/cALh+W4tuTeiDkKE8eIrYpPRWSLX0mpkclwJixkjqBWxw/uI3Bvuy6MPneoDrFsQHl5rNP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886979; c=relaxed/simple;
	bh=i9Zhh3N6A4NdcyXc5VJPTx/rNWSpAt0ReEMQ1vjLMdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r16nS1sOyICocjMErM0RH9IHtHv2EkDSoKXySwKjmqeyukBj3J3LdxWyqJubDmcqx413ejAogA9eJZKUo//cW8P2xgOvXKQOnZ0UR7XUOk0KfFFFiep8bX6/QhP7uxKzU1MnIvsl8HKlDjfvkXDk7ljzhj+9eCrWPb59Cqb2yDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dOmJ9bzu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dOmJ9bzu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4803e8b6007so26056265e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 01:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886976; x=1771491776; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cyyYRiwc6FqhQlyFBFLg66ihDNCGyZfWrA54Edi64Eg=;
        b=dOmJ9bzusw65icn9DtOGMUXG6aWxOlkSCUMbyxHehtqyAoSo2JXkyrwghj0+6z12t9
         FALVZccQw1/fV3j5R2UiMwFZcI3OSYyxGnFiefyiekadGfi5ZS0XHiONNbML2Pgl32GI
         6ZaRWo2olC/mUvZ5LSh6h19KrTWERUBq2Z4HLMuto/GUVa+C7M4ZQrzmOd9VtKD1/qDI
         3tbNHDU+67Zt7IvIRvfGJ+Ns6nJqx97Oqp8GNPTi1fCCVnWpGjD7IQjar+0SZkWMiDGJ
         yZIIBv2wKnP6I6SwZ6CQ6VkhhE/rCM5jFZcG1dv4NyMX5XBe4kX7XR4XwYZnYoSttXzW
         WJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886976; x=1771491776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cyyYRiwc6FqhQlyFBFLg66ihDNCGyZfWrA54Edi64Eg=;
        b=Ng5ZfrwRO1nI7Vzz2nrF1ywd64UkvrrkrsgOEqqIHD9M9RaE9Zs3R02CiRk/57ngJc
         GeGnk2sPwBAT3koN4qIZXz2HypiODM5M2+6vL7sxK0fj5xguMGo/cDR/TcFksIA5yKSY
         i7pIL0nJ9a3v1QfRF3cInFuBoMTVXrSFVxhCZNr/LYRfA52q+Y6QbfpjWh9vzQo6bMVE
         YPQnrfwyKe1Nc6DJNjABDMQDH7j/20+FSIkvbF5XoCwEKTLtiCnBF8ZZz+M/4RFfA6Ny
         Luz82zm+SyS0Oux1NSXlZSORqPG54Bz0wq+4/KWTGo52AKiXVO5zRu3jryBmGz1easvS
         IhIg==
X-Forwarded-Encrypted: i=1; AJvYcCXwjDi0qyMRCRadDvfSAhJjxhouVKMVY1R1sNKDrYKuokWkpEczgsuWXQyV7otcIFAY54Hs/ww=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt+OASUa2kELbXHl4yEPb9uXfxJgZV62DJB5i1r6DvhJr8GAUx
	Rm1gfgfnHTjcTps+tl0rLH4CKD8mtn0StZ1g1SdP9FjgV8e9O3/9oTK1Fh6u8mGJTBzB89rB3tE
	B8A==
X-Received: from wmqu17.prod.google.com ([2002:a05:600c:19d1:b0:483:29f4:26b8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:608b:b0:47d:8479:78d5
 with SMTP id 5b1f17b1804b1-4836710a0afmr20458865e9.7.1770886976534; Thu, 12
 Feb 2026 01:02:56 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:52 +0000
In-Reply-To: <20260212090252.158689-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-4-tabba@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The `sve_state` pointer in `hyp_vcpu->vcpu.arch` is initialized as a
hypervisor virtual address during vCPU initialization in
`pkvm_vcpu_init_sve()`.

`unpin_host_sve_state()` calls `kern_hyp_va()` on this address. Since
`kern_hyp_va()` is idempotent, it's not a bug. However, it is
unnecessary and potentially confusing. Remove the redundant conversion.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 267854ed29c8..8b9e027ec86a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -393,7 +393,7 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
 		return;
 
-	sve_state = kern_hyp_va(hyp_vcpu->vcpu.arch.sve_state);
+	sve_state = hyp_vcpu->vcpu.arch.sve_state;
 	hyp_unpin_shared_mem(sve_state,
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
-- 
2.53.0.239.g8d8fc8a987-goog

