Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B391235B621
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866185; cv=none; b=RrTjeSwNQSJuor8uic+rRkXGkrjTYr59X+KOR9hakLau63j9MPpVILdmhMMHd6RLvORgadozflgAGkmoo9GihOJChN8acb94592NCN6BVGc0R6IvPSe4EO6d5aENmc+bkHT4JOIB7elRJvZYYOGkkO7QhgaMScYDCnuX2qwv/Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866185; c=relaxed/simple;
	bh=akk2UdENQbgS4aNRHidtxoT1q7g4hUSbv0c7DfQudsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IxiuSwCSYcARAexBwCowgve5pHPGp3bHixafPPxD8DnFZwgVIenbdP9KMTkp9xsICS16l/jXv4vUgtJS0fOgJbB7tmIPZAA8Y8L0PSXGBCkFsip4OETsMAu6zfRzc6Pv0aVRDMdPr20s9jq6rQNlBjS4s3ssxGzDV//CS7Cu9S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soHr3a3i; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soHr3a3i"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4801d21c280so22491375e9.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866182; x=1770470982; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Vepb6gWbmfw10H3EWIgkkfZunr0icHCkKhsRxDAh8=;
        b=soHr3a3iy6K56Dj4TPiFIsrUmJ0SpeDwaI89HNdD/r5Z/duMk/Pf8KQm8/5utTVhGg
         cMCC51GmYxnpvKGENmREQ7oj0rPK+66kudkq5clI1+uzAeIYfEQhpgdtpzgnA10/5UrY
         NgPRS6gip4pKtAIgcA7/sZSeDKVf7zLuy/BQgdcV22nPdP5AYKx9Nvu6MUvZP8gFmpkx
         LV8zqQXYFI78d6apYoEXX0YuVBuuPHDsVT2Fgen/Mvx+XASQPWk1eLHRTj6JAhEzdj0F
         WQzDERRrEitgau2GLzRvXymmV/oytbg+Nr3/hCu9gvSOseqyw2ZM9Ge6Ivr0nVMy0dpf
         9U0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866182; x=1770470982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Vepb6gWbmfw10H3EWIgkkfZunr0icHCkKhsRxDAh8=;
        b=TQokNsSC5+Z6HxaSY7yLkhvf0p4Vdv4X/weARhj5drI7X8zatn/0usLiad7crk1pK0
         ZGCUjIK6nck7VxCUFShWaEl47qNTZJ+I+DaN2IA4bHkniD9rJ4Cpd2ROm4P8eQ5dVnrl
         8JrAWcA7REgmjUnkGgzJzOGf7+jeYoJN8tD7B92q+tMSVLEFsf+UoKnp673o5ISCQNGu
         bOL6mS7Uk+wJE9xUa3g8fRpE2Cs2/xV/X0pskZYlXsYcvtyBZpY2IAKvMk+en+uvjpkl
         o17sjbin4hYz6jnfNJOZiwAoIhXzMRWndV4OM5DLjnOhRQJEz18AiP/nFOntPQoxn5WA
         Cxpw==
X-Gm-Message-State: AOJu0Yx19YsB2H4LXBGB5yTZ579br75Mo43mvJLo87yoVHHMJBqvwRcM
	3SFpoKwAvl2og0kKVvHeaEAkaat9B/FHyVlM9jIxqiDLXLy6P7ZU35Mk8U/Ow5f6WBI5AOu2bLs
	YGhdXp4BrB5E3qhy31kb4dw==
X-Received: from wmcn4.prod.google.com ([2002:a05:600c:c0c4:b0:480:6afd:1fd0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d03:b0:477:7f4a:44b4 with SMTP id 5b1f17b1804b1-482db4567d6mr85643685e9.1.1769866182054;
 Sat, 31 Jan 2026 05:29:42 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:40 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-23-vdonnefort@google.com>
Subject: [PATCH v11 22/30] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment. While at it, do the same for hyp_fixblock_map().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ae8391baebc3..a6eafd72f87c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -244,7 +244,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 
 void *hyp_fixmap_map(phys_addr_t phys)
 {
-	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys);
+	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys) + offset_in_page(phys);
 }
 
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
@@ -366,7 +366,7 @@ void *hyp_fixblock_map(phys_addr_t phys, size_t *size)
 #ifdef HAS_FIXBLOCK
 	*size = PMD_SIZE;
 	hyp_spin_lock(&hyp_fixblock_lock);
-	return fixmap_map_slot(&hyp_fixblock_slot, phys);
+	return fixmap_map_slot(&hyp_fixblock_slot, phys) + offset_in_page(phys);
 #else
 	*size = PAGE_SIZE;
 	return hyp_fixmap_map(phys);
-- 
2.53.0.rc1.225.gd81095ad13-goog

