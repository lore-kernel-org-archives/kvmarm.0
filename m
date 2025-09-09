Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5548346A1E
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 13:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425006; cv=none; b=c3ApC1ZYFWsRgqShIWmFsNNH2zFsiNZY8Zj9KvnwRc++rJVTVgJoHPh24cNMeBo+NuhPUQRU5dywdqZBaUEsMcUOm+s+RUm3v/zogNfteuxwp2SA+QjGZ957B/66aLBg3kPa+jDZ3w4bLJPwIDTMY+K3l5vousTJyadC3QpQYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425006; c=relaxed/simple;
	bh=s+LTaxCdkbtafjfpxFbMtUJbb49yFD25c+tR5bvUCJA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jZgRBywX9eDzvnE36N1x2sbfsXN9Inz+VvuXGvyIgCJLqD2xdJqPKTNFg+FHMhxcDzT7YONZtTUnewO8uIBCRuCvipL2VekcP8eFOrwTNsDK9Magkm8zPmXthX06ceXJJO7MVucNlRAJBSZzhqn3v5871KtmYEOOooSUtqgGZBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zxwiWfrA; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zxwiWfrA"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3df9f185b82so2412725f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 06:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757425003; x=1758029803; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=owMpJomD9HktZXrYn67PIBgyXHZh+dj149j6UZF5idE=;
        b=zxwiWfrA8htNwnf3EutgCMVqBfSDVz3owV7Q+XEa5fNjlw3svM62f4ddkwlvlX6rxK
         O35SnnCgp+cw+JWFd/cJMrXdlEAP2TpaM8yx4g6fMgPDSzvx6T3KO6KbO+3EBKPE3Nok
         1byo4M9mxCQCU6svYAvJYhf75Ws1PbA0kxzHivGvHEYYPmtTExzkBzmPDvMJxen+Wc4F
         2wzwQC95NjzxbWV8OZjS1xDMNn62Q/9CAZ+0yvApDoQ22fXE930AwtA3YewOT3MH5p/9
         r6D3Ci7KfQ/pC5jBbPLX651Z/yP0wdvesYQcHxRzh/pf2Z2oRWFFPC8e3w+bRvAAbQ90
         np8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757425003; x=1758029803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=owMpJomD9HktZXrYn67PIBgyXHZh+dj149j6UZF5idE=;
        b=pbtWyZ+USX+Oy4td4laP3gNzliMNYbPxyquEkY5ix87BG2bfjdfYOrZ9/meQqfRtnH
         lksV0z+KlM4QVJhnL7RqSzwPDgqezRBMPZppvCbmYfSxEl23lllNc8ikJklQPyI55wMX
         8k20h4ZriZOjZCeAHtVnpytM3ZAClGiqwjI4dKQbUaE+IwMLlOqDz3LzZqAep7rwDfC/
         05FzLN6LvW58pKlW7lOMo7ZWz23JFQREkLWanen7PheiV65ffN36ZgBF3CSs3j9CjMUU
         P6UBj2apioT/Fl3UTSnMNuPOo9XDD7byChlFsWEI2oT5PioxE3Q/QHtLvXmCu7Cfc+/B
         9JTA==
X-Forwarded-Encrypted: i=1; AJvYcCX2qPZm8Pi6QNp4j789UrR3SSels3mbqAaPuyaQoDDJ/FhH6pYXdk8AbPct3LIdGjmPdfkdh84=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjE9HyqOjFWq0f2AsAnxdFkCAjjLROCdr2V7GMhMlHZcn6PNC+
	bFuEEo4ZgCTX1VrRKroVPPwlUzlm4N9nw+AcR71osZjtUMXBjZolAS3z2tjOWGRMG9UlacdOunO
	jlsTwl1gaaQ9gCw==
X-Google-Smtp-Source: AGHT+IFb5uZ+yXEAm2ul5d4u0zb6FcIArGntIYWXEsNgKuqjWpTpJjl0OgQdZTnmi211wUNW182dBv2tNknMLA==
X-Received: from wrbfq12.prod.google.com ([2002:a05:6000:2a0c:b0:3db:2c3c:8268])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64c9:0:b0:3c9:b8b7:ea4e with SMTP id ffacd0b85a97d-3e637370e00mr9580515f8f.19.1757425003090;
 Tue, 09 Sep 2025 06:36:43 -0700 (PDT)
Date: Tue,  9 Sep 2025 13:36:31 +0000
In-Reply-To: <20250909133631.3844423-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909133631.3844423-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909133631.3844423-3-smostafa@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Map hyp text as RO and dump instr on panic
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, perret@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Map the hyp text section as RO, there are no secrets there
and that allows the kernel extract info for debugging.

As in case of panic we can now dump the faulting instructions
similar to the kernel.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/handle_exit.c    |  4 +---
 arch/arm64/kvm/hyp/nvhe/setup.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 99a8205fc104..d449e15680e4 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -560,9 +560,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	kvm_nvhe_dump_backtrace(hyp_offset);
 
 	/* Dump the faulting instruction */
-	if (!is_protected_kvm_enabled() ||
-	    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
-		dump_kernel_instr(panic_addr + kaslr_offset());
+	dump_kernel_instr(panic_addr + kaslr_offset());
 
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
2.51.0.384.g4c02a37b29-goog

