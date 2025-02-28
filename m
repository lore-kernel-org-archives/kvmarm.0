Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38525D91C
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738375; cv=none; b=W+IfWbgJNrrFOX8TX/LuVZLwnTEm+BFQSAjtuPPFXx7ZLKYZpFngty+gY4q5h9qRX5Zs7pZqqIX71iSFbfH1X7OxAiwQtFAkZlRqaIS1rCo7PMLZQ5EMJMO1TbtOVs2ts5oj+EJuDpC1yu6hBad5J3l78MWjPl3daq/5p0s4k6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738375; c=relaxed/simple;
	bh=whyGc5aGHwNKn0mfmuFzvWSs8yNUHY/ZhnQubB+H94o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LkS/Qufob5ReadF8KTiR3KXm0lWCjAUoJc+Ysqmzu5FMNj3r+PM1F3jAOjDLbdEZeDTf7ur62kjdyxpkbEfXtcG7BTTQpbkWuRHswhqkQ8kZYCtZiMVCM6bWdNOSr5DvcPBSL6el5B41Ss8PwXJZvQO8r8GhMB27ayzQfEa9pAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bskzTm2U; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bskzTm2U"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394c747c72so8301445e9.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738372; x=1741343172; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yRMnVBqxbNr0g4BbhZbbaQ06EF+wmwJkU+0Xf25VfM4=;
        b=bskzTm2U8vcpQgTnqXxpwdyxwruaJP+G30RNRw2gd2sONRZGKvuPQez5ikcOgwahxY
         gAEh1Mva+6vTjtj7wSN9mQS0DSciDw+fViHhxMu6oZoxWRfk1Cqw3bSC8uqluhnBpwfw
         zc+n5O5zklm5IT5m804YqZmqflTCKV+xXD5xnxEtTWNaERiAeydEnrsRBmUUboJxkzGt
         iQF2sMxN9gWrc9gh8vEeC7pqX81dqPuTsshWWvBK3eEd1RsPm8ANEECMWQvZXy6c4+D7
         G39xp0RZ7OmxuPz3FkG0VvTbMzzS9Hooe6uzYNW9Joljv4jF4mUeyZRyf2jOJv011sMn
         KAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738372; x=1741343172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yRMnVBqxbNr0g4BbhZbbaQ06EF+wmwJkU+0Xf25VfM4=;
        b=KQaMXmg+2iUbUOD46qhDzUav7jLJfre3RrzV29oK5f1uEpGrARIiZBGK4/P6NU22lU
         B0neApcIBImaWSPz+CFn+oz1ndrYxv+QypHjoGC0WxS5MJ78qaov88mfaxIs+jXQ5AK/
         PMTzFhd6NvJ9/M/VCOWs38gzwNcKj9So0T8KWVvryvQL62xKQCVD9fC59TMrge1Rb/VV
         JLk1IEWzM67c5BkUmwO1Kzh2X4gSQXDc15anyZ7vetnijWm6DR4oec1uNCje57TNNZAt
         rGQW3z+hOY83/jGJ29p7O/fyFizX1SZ+T8MGvSdrNHKuc+WN7sok+tXZ9WnnYtH7b6Fg
         sTLw==
X-Forwarded-Encrypted: i=1; AJvYcCW2xSSCoVz+DmXOzW0wEQOyZaCD8b1ECdgqwY9iZxnNgGWjGwfSshKJlmhTwJj1H3V/lz96BdU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzr4VQhuPvh3eFJtI4PMgCZAhKyLAPLRkEorT6hPOT+uyyhEawx
	HLBfOgqT7iReXtOyTk0aS3WszDMASyjXoYZmbO4udSKhXRDsOd257/G55A3BwxiapgPwzQXy+ti
	U2m3aNIgji4eGYOewSA==
X-Google-Smtp-Source: AGHT+IH0fwtXCTDeJhT/l/khwHsuYplMhcSCRFECxM5q7EjwmroI+BdQCjojPmRxAfbH2kPDmDbv1a422TO5a1h/
X-Received: from wmqe15.prod.google.com ([2002:a05:600c:4e4f:b0:439:9fd1:8341])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1387:b0:439:91dd:cfa3 with SMTP id 5b1f17b1804b1-43ba6760305mr20891625e9.29.1740738372225;
 Fri, 28 Feb 2025 02:26:12 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:29 +0000
In-Reply-To: <20250228102530.1229089-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250228102530.1229089-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-14-vdonnefort@google.com>
Subject: [PATCH 8/9] KVM: arm64: Stage-2 huge mappings for np-guests
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Now np-guests hypercalls with range are supported, we can let the
hypervisor to install block mappings whenever the Stage-1 allows it,
that is when backed by either Hugetlbfs or THPs. The size of those block
mappings is limited to PMD_SIZE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 25944d3f8203..271893eff021 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -167,7 +167,7 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
-	return true;
+	return false;
 }
 
 static void *guest_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..3143f3b52c93 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1525,7 +1525,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active || is_protected_kvm_enabled()) {
+	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1535,7 +1535,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+		if (is_protected_kvm_enabled() ||
+		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 9c9833f27fe3..b40bcdb1814d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -342,7 +342,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 pfn = phys >> PAGE_SHIFT;
 	int ret;
 
-	if (size != PAGE_SIZE)
+	if (size != PAGE_SIZE && size != PMD_SIZE)
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-- 
2.48.1.711.g2feabab25a-goog

