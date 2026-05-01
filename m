Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B248239EF15
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634521; cv=none; b=ZkkmdXhzE+0ZutmKrsxPHBWJOKKefpGwEqHta2oz5/4mf0oIuXoi9Tub7uNMj54+aSo9QJAl1kDx8fp0aDQSoXWpY1/UYoq27QmH0RYEcL+NLba5q6zbEYkC/IuSETYgPD45p/lOQjH80hjGhk39pD8fcz89k7vQ+Thc4DgXH4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634521; c=relaxed/simple;
	bh=wyLa8NKF6GhGuRRNf3zay2XeK8bwHhxV1DLSA58dF5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XYucLNyMnY+QdtBBhzfJxhYhkMI/jQfcjAYgBNGDyrkbIdoi4mGkxN0mENWLrbbech/LfgRxOwZfe3rY0sohL4BzFR8rvR0SgybAA06tR4MORjjATqWE3CZEvsxeYG3zGmJ02gqoiRKU2bcRSN0gJ4mT/qlx4e+R6pjTrKGtB9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AfjWXSpC; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AfjWXSpC"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b9360e9f43bso189163266b.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634518; x=1778239318; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrLinQWyFKg2m6ErNGuwXnFHhW5qOEbX3IE7Ywix0YI=;
        b=AfjWXSpClSIkaA2cpnlAQeVec6W4trpxmx/ySuIM7jnGNhPMnAWyuc2wClXmpjrLlF
         4v0py8w54lz2f/qjXcodNlw6H2elnAchbRSIiY+LoRhkxCPA4SIkf982bQkE5IDI0dyg
         8pZroVqLceIv8UaXer5k456css+O5H/74oS8C4yRtkey+L5FudCHztP7s3+qQ5J21hWg
         rCRM6vUsBx34I/GOZQjCK9j76oz0PnMvaVGvmTpiqzbC4R4muxV2dpBo+Zhalz1tFMoa
         n/erjWPPRUmIubRL8JcDTEtQIxCgRVOyn8ylgQaVWbzyMEpT28FkHgwBiqRk45NAipDN
         w1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634518; x=1778239318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrLinQWyFKg2m6ErNGuwXnFHhW5qOEbX3IE7Ywix0YI=;
        b=ec0kIRCpkW7VkdH3a6hFeP82bpPh14gxn3NrKgxedks+chtkODa/oclTMSo/p/0K2B
         QKtTyqosFmNSEMQhoC0CT5q6EkGN4GgQr37cR5AUCGz4wg0wOE+uUXuO6kKBK+7qWDYu
         IBqIP8wtvLjePNvMJHFSwMpjGNZsoGYRJvZ+xNEpAiQHsxnDweORUWeV7rOVrB22/MWK
         U3SICgZrbWbIylpJu4zFOkp9uKL87Kpjto0c4vPKrVrFD12cx/NcUEn1JUy4t2VvXt1l
         LEBXSHHopiROvBnpv7lXIcC/JZs+J+gADt65Ef0sGKOs7Y8FXiXiOHVJB5wv8IRdLrXx
         /aSQ==
X-Forwarded-Encrypted: i=1; AFNElJ8qwgmMFtlrBH4vvIhWtmlwwnkV7an27ecCgKAwHbaKdLAvHEbuegVC58rkCggROouaCTrXstw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzM6b+rrwoYu2aDbwotjwWCftYQw0nkylqWEHa8EV6+iZPgojWr
	guhFlIBJMfEAFcrFYo+l27q38QuwA44JpWHxnEHvgCT95iVNZit3AiZA8++dGcPnToFVtonO2AE
	jkQ==
X-Received: from ejcdn19.prod.google.com ([2002:a17:907:94d3:b0:b9c:aee9:a002])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:f588:b0:b9c:b069:8ab6
 with SMTP id a640c23a62f3a-bbac47d4717mr450739666b.7.1777634517844; Fri, 01
 May 2026 04:21:57 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:49 +0100
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-7-tabba@google.com>
Subject: [PATCH v2 6/6] KVM: arm64: Pre-check vcpu memcache for host->guest donate
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

__pkvm_host_donate_guest() flips the host stage-2 PTE for the
donated page to a non-valid annotation via
host_stage2_set_owner_metadata_locked() and then calls
kvm_pgtable_stage2_map() to install the matching guest stage-2
mapping. The map's return value is wrapped in WARN_ON() and
otherwise discarded, asserting that the call cannot fail.

WARN_ON() at nVHE EL2 panics, so this assertion is only correct
if the call genuinely cannot fail. kvm_pgtable_stage2_map() can
fail with -ENOMEM even at PAGE_SIZE granularity: the donate path
verifies PKVM_NOPAGE for the guest IPA before the map, so the
walker must allocate fresh page-table pages from the vcpu
memcache, and the host controls the vcpu memcache via the topup
interface. An under-provisioned donation request would otherwise
turn a recoverable -ENOMEM into a fatal hyp panic.

Bound the worst-case walker allocation alongside the existing
__host_check_page_state_range() / __guest_check_page_state_range()
pre-checks, using the helper introduced for host->guest share. If
the vcpu memcache holds fewer pages than kvm_mmu_cache_min_pages(),
return -ENOMEM before any state mutation.

Fixes: 1e579adca177 ("KVM: arm64: Introduce __pkvm_host_donate_guest()")
Assisted-by: Gemini:gemini-3.1-pro review-prompts
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e428304f94f2..c7f7149c4796 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1404,6 +1404,10 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	if (ret)
 		goto unlock;
 
+	ret = __guest_check_pgtable_memcache(vcpu);
+	if (ret)
+		goto unlock;
+
 	meta = host_stage2_encode_gfn_meta(vm, gfn);
 	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
 						      PKVM_ID_GUEST, meta));
-- 
2.54.0.545.g6539524ca2-goog

