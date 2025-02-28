Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABF825DD15
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738349; cv=none; b=YI53A4gm3MIkyGbx8cnrGNPeIik1rtuZeTXqSVNVRU8txPPJHMaStrO91tl10nXlkaH7/5ZG0scWjXMK96hZU5g9DWlLN9UoJcUsoNkOsCD9+H2m7N7xOh8PZdMzr9Yrs+KCWZyJH93QbvIVoFhUVTMNAif1LZs2K4s5OthXnHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738349; c=relaxed/simple;
	bh=XyLO+57fDofN6GJHV7mkm+GB+xkNeXPKaNuh0zqrY5Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JSDaBfSIGs8XxOOO7287VrHZUv8ml54VJjapBxwyXWOa2UriW383bsIawh25gR7q4aCiUB+zfANIVnhkqIV76w9itCM3+I5Ouuh8TL8ZP02VDFt6EqpEoExQdsAkuQ3tQc8bQktFGRA0EE4D/C7BZKMeTc/dyMMK0OD++6wDI9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WUNWuj9k; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WUNWuj9k"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43943bd1409so14152705e9.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738346; x=1741343146; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZhAYztASFyJGMSgZE5i6lkqu3vzWqDwef4eaMAfdZ0=;
        b=WUNWuj9k/u+Chkh3jwyvccvdd7uN0It5fh64ht9bFdjtuhMJaXpEFp1/d+LRlI4UR/
         Jd06Xr4NIDmgrx06x2/pnk57WtzC5gWKJa2Mjf/9IY0HJ4h10waw5FDhtvXQ8uX6wZQE
         6YW9U9UfQQWspn6fE3a2GJ42a8F2b2Q66I+F9SUPbQIsw9zGAuaSspIf8zcqGwNl/nTS
         hn+KzSTMXWgXXHbLo3fOXj9pI+EgGhZYK4PjZqCMKcMWAMxCC5+caSiLB1BoK3x7bKmm
         KDCRBl6sT27YULKHe8DbTQzvIjxK62fWqmsblE8ooUH11you/TIEcrBmgmUbLp7utYud
         ZFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738346; x=1741343146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZhAYztASFyJGMSgZE5i6lkqu3vzWqDwef4eaMAfdZ0=;
        b=jT/x5qhF68HaFxR6Ca2wpzixboifgVdC7Mwy0SEFjaSv39JDs1TgctdXhl/BC5ZKrs
         OqIzgwMrwzi2yj76MIgnng+19CZDMeyVg8eGlqpjf337CdPj1v/VgDoZpweKD5KQbEkS
         hQGnPs3IBavc0lWxkY0Y6JHEfQu0f8DqzEaL/4+/jPesqiZLPQcVziUmIY28RXFGt62b
         RptQq8H/34j0cZarSMwT9t23RB71+WAFc7yoR9JhWjYMSNWv/jSvHE6WU537baQ5unpY
         MsPVYFi4ABbeSIwWQ2XJe6Anu5ekJO9LBQCQe5mBUDw3aoyHqcD8gdbpnXvHrAvdu9DW
         20+w==
X-Forwarded-Encrypted: i=1; AJvYcCUZ4hhH8VupoOJMe5U7mm/itr+OduaWurWlYesRe6CPr/FbtLl+XX4sY6HDaUSyVZqGA8MoOhY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzgmt0NY1d4bqbiRwnWIdhwQ0hlyFIGr6GbEjgWN1RjOaYLXCtI
	vM2g9AUltuch1CYdXePA8ZxbQLewutkQ4Lwa4nuvgIb0dF01EzPUv+DIsxgbNV+ng5sBlNpjIGh
	uITR5IUIaCHPV1yDZBA==
X-Google-Smtp-Source: AGHT+IErysWGWTMM3bCvvoDqVF2QmB3ahdAOa99vtob8aheucDELjb3c2wdk5I/bEmp96LHcj4ZpHr7SpAP9x51t
X-Received: from wmbfm6.prod.google.com ([2002:a05:600c:c06:b0:439:9601:298d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1986:b0:439:98b0:f8db with SMTP id 5b1f17b1804b1-43ba66f9800mr25488185e9.16.1740738346325;
 Fri, 28 Feb 2025 02:25:46 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:17 +0000
In-Reply-To: <20250228102530.1229089-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250228102530.1229089-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-2-vdonnefort@google.com>
Subject: [PATCH 1/9] KVM: arm64: Handle huge mappings for np-guest CMOs
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
index 19c3c631708c..a796e257c41f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -219,14 +219,24 @@ static void guest_s2_put_page(void *addr)
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
-	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
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

