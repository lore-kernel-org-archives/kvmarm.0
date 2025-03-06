Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28619199FB2
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258850; cv=none; b=H8QVtbNxdvrUKlxF1/ptJeIj0J5o92ezKYuurYzDcVgLndNcjU1utz+RUprWadNzVDKG4y3RZtwugD+q2ZdKuzofvIuUuTBmhDmHw79hV8Acj4kEJ2ISkzn//CKHslMiUfVW2xXxhuJaUe3e8Lc1coMhNDcSI/p5Szl+8NIZ2mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258850; c=relaxed/simple;
	bh=HjLJ7C2AIduywljQpybYoX8/PUosMtVkdvA1RpOLC6s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ns7fbsXxp99zbAuh5ZNk5VF6yHQ0EmQucPZuKRb1SdAVSjsrtaIBAusGFA+HX8l5fMwOXvlamnKkDXObBL/Mlm+cEqmrepVqmqopGo3oa/Ojam+mUiTyyKSZyCXxWzncmpzr6soXaqb1JivNEJhbgHSwrB1i1GlSVIRI9R4n9NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IE/xsK4p; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IE/xsK4p"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394c489babso2266045e9.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 03:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741258847; x=1741863647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3EIDfh3bzz6FZ09T3hzG7XWiQpkIRvJOzVpoxagQuo=;
        b=IE/xsK4pq4n7pyMUiq5CJAF42CStx26yMNOcMtQ1PrCF6xlmC1gSG5tMxfzNMn0iuN
         RTcZpTN91keSWzsEgn1rKxpsr/m0JWFeKVJ5F4wIY9+Kxn0+V5o3ydBmwwl86lDvC2LZ
         FrEYnXlo7cIDMKe3AAkIvyjUhohudJGjrLjaYCFppzJsXBC8U/8ZzW58JbjG9XQ8DNDb
         WhPD45cSCmyIdIMvRckM0Sa34SAyxYftTd1KcfkBjKTrVsX2pGX7DX6lrPhmcr1e0YQD
         wvQ8I5Xhw7f/eMzY5zSO78eLYCIF/9+ytmnEhZ+vq25ymJrEptVM9SI9niUFl6xNFKds
         ioGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258847; x=1741863647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3EIDfh3bzz6FZ09T3hzG7XWiQpkIRvJOzVpoxagQuo=;
        b=rzq36zBXvCNQQ63gmtuB5IWgZBfOve+Kjldhh4QT0cs13cdQHYZnxrKkcs0U977PaQ
         e/+uTE0aSOgeknELVp7c0q2zdJ8BqjzNUvaUT9wVDBqWIxXBR/3W/2TAYbDwji+iVH/1
         E3HzbC0mpHh8YEtzHl2NViA8C5YfmXgYJcJK/nhATdTTV6xzqe5h60dOxkW02kInBXnG
         uni7qqiNXCjlATHYfH4TtzcP6gId67lGGxyrIJz16H5pmr9QnsHeZbxtzsnpmoTDlGDc
         4wqbA2bi2Jk5SLOGLdoGWeaVEK9gYurvLno/ECEWqIwT6jqk5aDVKj7yO4Rn9EICq0HU
         Bufw==
X-Forwarded-Encrypted: i=1; AJvYcCVek84ZrUQJXg1Nz7hRvlqDFb3qgOYNeFpb7gKRsSkAWUUV+bibrrbJ8ulhPApaNtEga0xgkCw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9cVMmGnGOlgFPf87ZFG3M+FMy7oYEFb+RD0cWFnYoDdQkogeL
	ZfzNPI78P/bzHX7Abgt1l7IzsQYwV+KqNS3pyw2cL0abGtONnGyYiaTIl9i3rJI9S/rXrybYwza
	zJiLs7gHHMcCEaIfifg==
X-Google-Smtp-Source: AGHT+IHc9gvpZKIAvFGYxWaWiTqhy0gbG8Wikxg2XkAF/4yfzSNV6Mp0Ztsi5081XwxCLqL618nGLsdLrgFavXUx
X-Received: from wmgg12.prod.google.com ([2002:a05:600d:c:b0:43b:d4fc:1dee])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b95:b0:43b:cfbb:3806 with SMTP id 5b1f17b1804b1-43bd29d2d84mr55969355e9.14.1741258847657;
 Thu, 06 Mar 2025 03:00:47 -0800 (PST)
Date: Thu,  6 Mar 2025 11:00:30 +0000
In-Reply-To: <20250306110038.3733649-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250306110038.3733649-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250306110038.3733649-2-vdonnefort@google.com>
Subject: [PATCH v2 1/9] KVM: arm64: Handle huge mappings for np-guest CMOs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

clean_dcache_guest_page() and invalidate_icache_guest_page() accept a
size as an argument. But they also rely on fixmap, which can only map a
single PAGE_SIZE page.

With the upcoming stage-2 huge mappings for pKVM np-guests, those
callbacks will get size > PAGE_SIZE. Loop the CMOs on PAGE_SIZE basis
until the whole range is done.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 19c3c631708c..63968c7740c3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -219,14 +219,30 @@ static void guest_s2_put_page(void *addr)
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
-	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	if (WARN_ON(!PAGE_ALIGNED(size)))
+		return;
+
+	while (size) {
+		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
+					  PAGE_SIZE);
+		hyp_fixmap_unmap();
+		va += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
 }
 
 static void invalidate_icache_guest_page(void *va, size_t size)
 {
-	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	if (WARN_ON(!PAGE_ALIGNED(size)))
+		return;
+
+	while (size) {
+		__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
+					       PAGE_SIZE);
+		hyp_fixmap_unmap();
+		va += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
 }
 
 int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
-- 
2.48.1.711.g2feabab25a-goog

