Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6634027B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751874; cv=none; b=jxHzCCYiTP7YvXaZFQA9VPiBHYlQv6V0BnJEogYRSCpHzXy52vThI6nEh+UIrF1SjsM9mpCqGVzRjIuakD9/d1uipAWhGO5flLtRl2djGXsJ1Ul3seZsXJMY4EUXOe0VXMTc7Biby8ZJo1XbllagD8kCL1EyqOYDlnYLAzCqXzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751874; c=relaxed/simple;
	bh=L314ac0kHN76077j0ssfxbRaPZjQnUp/1F0F8HY5iD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VmEVNX76U7Q3YugZxkL0LVqyXJNitmE+05hKewkkKzJbMPuGBUPLc0hVYztGVSlpAO4SuRUwc5MJPHGw9a6CkG9R4N5eAxNASZvaENvA5xAFEh7O5LtGrxK51ZXC6PenfgU3o9pOIs9d5fUrFJxyt2tFAIMeu8cL+Zzu0hVDhTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j2XNKCAs; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j2XNKCAs"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4955843c6cdso18398885e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751871; x=1786356671; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vD9j2DbP1qcHhwrVAGFwQvUfw9yIjLdBpQmLc/B3JA8=;
        b=j2XNKCAsosqLFF2VG5javcsmDwfvlCDrnDm8PO/HAqgqVJgHSurSMbKOOOBD0SgZWU
         IM7YEHgwZgzhQu3tEuHalhLhOr5ZF2zO0PmDX/jeW6SU+F+/tBtwfJlFyVlyrtFhWdsc
         P+g/nmUt8kNmO33ut56ZlgvdclS/FN/nHQoXVM3SQ/BcM/CloIqojeRsmo14E2WL6zHm
         ijv5wxUYi91JYjNCqaB7tT3QW7rzjQHrXChfNUaLDJxfr7VmLzITlo/EGanVqBypkOC2
         TeO/wY2z3ExiWDoaww7t1qnX2r8rFKfWONHxORdKSmJi38hYw4gJcUY0vfDf5p9obfDI
         8jMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751871; x=1786356671;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vD9j2DbP1qcHhwrVAGFwQvUfw9yIjLdBpQmLc/B3JA8=;
        b=WHOD2uHmupV7z+MIFWH6KbVurZs4WGsYGzQPnbIGWLRJxqFfKZN2BfkymzLL5pjfLQ
         sYw3dR4/r9uIsK2gYH/zwFhITngHDfl1hU/XknNEloAn/jJzHgFk/l7U81y3+XCcz999
         tMs42fpU3JxxnPmNr+9cP/symNnElFYkTPJhjq7q35Bniy7Unwmc0RKSCjdMZ2v8h+iW
         biKOaZB3t4yBO7JCSyt8keyaC2mFhf6yvlQPUhyilTkPmG6ZFJwV+v2AV9FOKAxwi+7H
         oVRfv5nU4oCcQn38H3hMHIDhEV/qXMxJMzEKB9iYdNWuYYHy7wCK2NhM5tcvsPOK4zzE
         o+Kg==
X-Forwarded-Encrypted: i=1; AHgh+Rq+2FlgvrYheLxBZy2e4G0J5McjeYtRn7RKUeB3nhVxfWJ2OLmNo2pRcGGaMarzZ8RWSVDA2FY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpVIstadDgLgjYur6C0j/ywPKo60Jqc2oImLnM2PiHCBY3adQO
	2AcIPJrdncL1KqRJoiLxS1PiC5uGiMRI5s6qOZ+PQuYf3OQn8Ri35kf7Pw3FY5/zeg8emS5UDk1
	kpikvrn2E1t4McZ87A9pnTw==
X-Received: from wmdd23.prod.google.com ([2002:a05:600c:a217:b0:493:f79d:63cc])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19cf:b0:495:7a04:b006 with SMTP id 5b1f17b1804b1-4980c66b572mr188442825e9.8.1785751871069;
 Mon, 03 Aug 2026 03:11:11 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:58 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-15-vdonnefort@google.com>
Subject: [PATCH 14/20] KVM: arm64: pkvm: Warn on guest stage-2 block collapse
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

When pKVM is enabled, the host relies on a pkvm_mapping tree that
mirrors the actual hypervisor-owned stage-2. The hypervisor is not
allowed to silently split blocks or collapse page-tables. This should be
treated as a bug.

Therefore, WARN on guest stage-2 page-table collapse which would
otherwise be fatal anyway.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2340706e41d3..e16dde4c5f4b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -226,6 +226,12 @@ static void guest_s2_put_page(void *addr)
 	hyp_put_page(&current_vm->pool, addr);
 }
 
+static void guest_s2_free_unlinked_table(void *addr, s8 level)
+{
+	/* We should never collapse guest stage-2 tables into blocks */
+	WARN_ON(1);
+}
+
 static void __apply_guest_page(void *va, size_t size,
 			       void (*func)(void *addr, size_t size))
 {
@@ -287,6 +293,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 		.put_page		= guest_s2_put_page,
 		.dcache_clean_inval_poc	= clean_dcache_guest_page,
 		.icache_inval_pou	= invalidate_icache_guest_page,
+		.free_unlinked_table	= guest_s2_free_unlinked_table,
 	};
 
 	guest_lock_component(vm);
-- 
2.55.0.508.g3f0d502094-goog

