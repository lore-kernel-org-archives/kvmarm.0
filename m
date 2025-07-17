Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE86248871
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 23:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752796079; cv=none; b=Gu/jEKuwILl5ADdhwraX3c04Z4TzFK5nfAQo1PCJ68LlnHAUZI7W6jy5YIgfTvvUofVqROF90x0zixYNFSkZ4s/OeLjcoS9L0w+PCdp2uIGgrgAsDpomLvLgUQrZGeZgit3fJzKumFozlkWEbPSqPleSpq7yzXM7uk7Chzrb97A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752796079; c=relaxed/simple;
	bh=4Lm6rMZZKj9i8zZ/NnoVMfxriOkG8OOdGzwZV10mDmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L66YtGdOkxfhwn1U1PZsbUGqgpI6AXOrGwOR8y2zqsNCdPwYLWue0Ov6j0VvVGmAKeEeBqS7qj2i+88U4vBcbnPMM5NLvlKNheveWg+s/1vMcbfeWHrvu/Q4Bi7d6l1BaTbcpnaCSnW3PHAfC6GfWrSHXGqbeNAO0hIvbFCsbHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bHNcxV4K; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bHNcxV4K"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a6d1394b07so996206f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752796076; x=1753400876; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i36b1JU3bh8bkcjM27fcG1Vv3a5VEOWwHxSUo3VGonw=;
        b=bHNcxV4Kh9kvO1SJLIlg+GxRysUnljQHmPVfvmw+Y+JMBtei3Do4T/MZdumjODCXKA
         ZXY/bEgYOOcJGRNJa+Eo92rtSjc91XlKIL8LXouWhCSVBa9Qq0nObUNKHMAy2gOZGnRC
         NENhFSfih+LqsOIkTQB/G+Yk+w8KmQBYZhvH4TPVF3lqCUvZMl4wFX70MWHidJtQztIy
         M1xf7MTAGqkUrEwSGRa3YSGGweJZlp6Uf4PQOvxtAttc47ikkosT3L6LDgLi2I9Iw5cl
         z73KC7hj6ef9J9qCNJBXnNvLTLzSim1Bcau6qeCojL4yozCwSIgpM9XhKEjNhXp6yZ7s
         545g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752796076; x=1753400876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i36b1JU3bh8bkcjM27fcG1Vv3a5VEOWwHxSUo3VGonw=;
        b=U0wfEAyvmxbIbrfaReRkS+wfLxEkJl6tVO2eGjh7xi+UvrAa3Tz5a8+Q2KVuxFeyq4
         fbknS1HhfxlKNfqQcPupaQUaEDXYNEm671tKjcHeQ83lYmpa8hGy5+hgoxwIMb+AH9ec
         dXaBCipQVJSAnxlzpA1ygprnOuHMGQAkE/BiMC99++4gnz+1CNaxXJ8e1Wn6bcNRKuv4
         +EfHrW5NumP8a5BcTG4S4tdu9T8Ve/7xbCm97rlp0C++asNA0TIVQ/ul67WA7Ip42gq4
         QvzRODWOfX1Sa1D4mSqMnN1H2Cm4aP7a6r+xcp8bI7GiGGQejXY7GtaWZjOk0jGHQ+9V
         b3Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVA+hoZAkITyMWOZCqHEprvboYUv9HL+USw1onyRdiiqOAmR5NmNnjX/BT9wdfoIvohHjWFqtY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwS0PV1W0pG+B79h3sMil2uzG+wnP3OqppmILTTX0gEZBVEGewn
	zsak1KRMXLQOoyBNnsr6ZU6rVHEtpqr0Ve+oWBh8q27NXpLEVErRkYpqBIe4D9CyCHbGz9rn2rr
	p1f3B80iPgRNNow==
X-Google-Smtp-Source: AGHT+IHKyMuHhag8ZOByJFmk1Ifp+SWFFmJZZLFql4fjdBJ3bTCSJXcxMK4YsTuE1B/9R5Fp15TBOEDcXOc6wQ==
X-Received: from wmbdz10.prod.google.com ([2002:a05:600c:670a:b0:450:cf3f:2a89])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d10:0:b0:3a5:5270:c38f with SMTP id ffacd0b85a97d-3b60dd0db62mr8326635f8f.0.1752796076663;
 Thu, 17 Jul 2025 16:47:56 -0700 (PDT)
Date: Thu, 17 Jul 2025 23:47:44 +0000
In-Reply-To: <20250717234744.2254371-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717234744.2254371-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717234744.2254371-3-smostafa@google.com>
Subject: [PATCH 2/2] KVM: arm64: Map hyp text as RO and dump instr on panic
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, qperret@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Map the hyp text section as RO, there are no secrets there
and that allows the kernel extract info for debugging.

As in case of panic we can now dump the faulting instructions
similar to the kernel.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/handle_exit.c    |  4 +---
 arch/arm64/kvm/hyp/nvhe/setup.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index de12b4d4bccd..d59f33c40767 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -566,9 +566,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	kvm_nvhe_dump_backtrace(hyp_offset);
 
 	/* Dump the faulting instruction */
-	if (!is_protected_kvm_enabled() ||
-	    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
-		dump_instr(panic_addr + kaslr_offset());
+	dump_instr(panic_addr + kaslr_offset());
 
 	/*
 	 * Hyp has panicked and we're going to handle that by panicking the
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index a48d3f5a5afb..90bd014e952f 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -192,6 +192,7 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	enum pkvm_page_state state;
 	struct hyp_page *page;
 	phys_addr_t phys;
+	enum kvm_pgtable_prot prot;
 
 	if (!kvm_pte_valid(ctx->old))
 		return 0;
@@ -210,11 +211,18 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * configured in the hypervisor stage-1, and make sure to propagate them
 	 * to the hyp_vmemmap state.
 	 */
-	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(ctx->old));
+	prot = kvm_pgtable_hyp_pte_prot(ctx->old);
+	state = pkvm_getstate(prot);
 	switch (state) {
 	case PKVM_PAGE_OWNED:
 		set_hyp_state(page, PKVM_PAGE_OWNED);
-		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
+		/* hyp text is RO in the host stage-2 to be inspected on panic. */
+		if (prot == PAGE_HYP_EXEC) {
+			set_host_state(page, PKVM_NOPAGE);
+			return host_stage2_idmap_locked(phys, PAGE_SIZE, KVM_PGTABLE_PROT_R);
+		} else {
+			return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
+		}
 	case PKVM_PAGE_SHARED_OWNED:
 		set_hyp_state(page, PKVM_PAGE_SHARED_OWNED);
 		set_host_state(page, PKVM_PAGE_SHARED_BORROWED);
-- 
2.50.0.727.gbf7dc18ff4-goog

