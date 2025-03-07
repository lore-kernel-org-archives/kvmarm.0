Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C7217677
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347262; cv=none; b=ZYTHjWb5GwkYDCYA6xIGBEGAnVcjBH0R1FMJO/x/hhGnBH00nKPdjyMsUXFu5KFAVfG10cnuplffrn54j65HQxiY4T/yCdiVm8pd4kgZTKI6qMvu4PZEGekAQXTCOrHJ63/1Ib2ArTkQtQXZ9mscp5yQw4VPvgfMoMrOOdcFFXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347262; c=relaxed/simple;
	bh=dAOYkLLFHOymrTr6TpeE0Wl2p2/V2JWcE5kJsjBx6rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FFM+r7nxGVHilb2sEFbI8QPpWZAGp3Jsh7aQ/GtBwRNdzJ7ilKkssutQDuS2Z+pAd+Z3dG0u//bXIhj2PSCJcBRlImYd3FRWOk3O6WjNBnAOO/nEx0kyrlF6/xhZdeduDd8k5foMS6hXDC5Ice1LqWSx13/mUq7o8leJjFCIv2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kVocMwR/; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kVocMwR/"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bd8fd03a2so7971055e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 03:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741347259; x=1741952059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pOQy/PNkKkoEowxNbThyv2leDUZfqMcfcwikaBspss8=;
        b=kVocMwR/d+pEdPAXxpFShMo1C+n9ih2nOZ1mziUgnAr6s3QVQPD8yYJw+3g3KOxqyL
         msDQDw1qmSIIUUc6dp++a+MSbQBenwYy3at5DqupZ60aVMHwu5tyhVbYMqU/kzBoT6Pd
         MYzCnfARQ3A+2YX3xbRyT5GTKI3U5sJvFIa0hhO9Fw3f1yrDODHDHcPzxjsE+nlLmlsp
         D8RTRxF56dtN/GJq/88lqR8IdeJsuYHE/dJ4no3d8gxtuaUu2dWu/UuHUs1rNVZ9vwOH
         Jmx/ToItSsrTOO4qoq+NnkIQ2RzCT9svNPq95iTa4JdFq1NHCr+o718vM5on0+Fz4uoK
         eiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347259; x=1741952059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOQy/PNkKkoEowxNbThyv2leDUZfqMcfcwikaBspss8=;
        b=AdKi2Kkjj3viZJu2L/2HdPZXL8fMyLfymqEkfoBJFgDg/Sx4masNQ0tyWUboqjUudR
         MTPMsBMy1KXdMcVQIwbVk2M9qVKq3rZbVvbwGzLCvBTJeK8hhGrHbV2fFuQeCcb+lJPy
         dWTEDJMqrV+95qDHcChDdgdU2hac23EoWorqIzYfNtVIo0hC6w2eWyEq5O/fB0syenMW
         v91X8p9OX3AUwZNX8NvvuWxmcxoZ2UOFopXbt9b4fg+kz83iaBEtzyGC5e6R6ZTZsuG0
         9TDeZjl0RX7X49oY7rcx7i0tgdkFb8n9hbLjpO1LXqsU2I4kGN4R5+9yoj8mioT4Lwg/
         MALw==
X-Forwarded-Encrypted: i=1; AJvYcCUFSAzRuDWGQVZT3wIJdqW+lssbXNFYgnp6L8bqvby3iR61JTY8XzVK2hlNFHjDgvEzrcasu1g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNLbmhfPwuBpCvYsdjHZtW3H/HIshBVwGPBObOQUGelmb/Kixu
	GwDygkGSbpUy0SzduRut83EwCxkWq+U97pyk8ZjZKcTulM5KvuFTmiiLLeGX+hzi5Mnu7/YPFYD
	D9pkON0egBqav36ChLQ==
X-Google-Smtp-Source: AGHT+IEufDVmieTtOmTjD0ozshwtJsjGuKwUjK5sVkafXGyepALDAzCQ7cNYVDR3nM3liRfh3n/pBfr+E6zRFIsK
X-Received: from wmgg5.prod.google.com ([2002:a05:600d:5:b0:43b:bd03:5d2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b1a:b0:43b:cc87:374a with SMTP id 5b1f17b1804b1-43c601e1294mr21499365e9.18.1741347259383;
 Fri, 07 Mar 2025 03:34:19 -0800 (PST)
Date: Fri,  7 Mar 2025 11:34:09 +0000
In-Reply-To: <20250307113411.469018-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250307113411.469018-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250307113411.469018-2-vdonnefort@google.com>
Subject: [PATCH v3 1/3] KVM: arm64: Add flags to kvm_hyp_memcache
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add flags to kvm_hyp_memcache and propagate the latter to the allocation
and free callbacks. This will later allow to account for memory, based
on the memcache configuration.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3a7ec98ef123..12691ae23d4c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -86,6 +86,7 @@ struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
 	struct pkvm_mapping *mapping; /* only used from EL1 */
+	unsigned long flags;
 };
 
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..c01ad4430729 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1086,12 +1086,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
-static void hyp_mc_free_fn(void *addr, void *unused)
+static void hyp_mc_free_fn(void *addr, void *mc)
 {
 	free_page((unsigned long)addr);
 }
 
-static void *hyp_mc_alloc_fn(void *unused)
+static void *hyp_mc_alloc_fn(void *mc)
 {
 	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
 }
@@ -1102,7 +1102,7 @@ void free_hyp_memcache(struct kvm_hyp_memcache *mc)
 		return;
 
 	kfree(mc->mapping);
-	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, NULL);
+	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, (void *)mc);
 }
 
 int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
@@ -1117,7 +1117,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
 	}
 
 	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
-				    kvm_host_pa, NULL);
+				    kvm_host_pa, (void *)mc);
 }
 
 /**
-- 
2.49.0.rc0.332.g42c0ae87b1-goog

