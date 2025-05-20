Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0E265CAC
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731185; cv=none; b=X+nWubG+dqP2zuSKiAvWfUtHpsLfs4pXnOdGvlW9VonDx5JK5ukANs4S1n7KKmloTnroPQCeqR9t/vA9noBeom5F5B6LN/rngNmnpyWlzgPMK+fk/3gJuHkXZ+1NXHv6HexVD+flPoqjd6EtOQV8zhguKpv51o3O1irmL3XN4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731185; c=relaxed/simple;
	bh=YgmArXGJBjFelTvxc+9b3y1ehEGR8e4TCnYOoPgpzsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U1vOeBz5+TCxdNmPTTZvb0iRRUkqaC63U6GNWd0g44rnlv0p862ZXhOt0TsPiv2gG1orUVSrozR0F+FTHb5LgqYiAntpOt87sEUa0wIfnWMHfFxgrleUBxEYRUVpJ0PCfqkDsDRemAWy1u7prjEOjQYFZ9y+F+aLXkxhB5x9YQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TPZQp9kD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TPZQp9kD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442cdf07ad9so31075105e9.2
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731182; x=1748335982; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CKZgmiZHsWd3katRT3fxSYHJdGTZyCIpS+lL+y5Js0E=;
        b=TPZQp9kDwxyXuzVreiyATGQKd6KrxJGl9bc4uCK61nOVD/PxX+65utT/Cjwv/t50iN
         PxFjuEeyKegeWjrnpFQYdhYHDIGbHAA+9f9q0xq1ZoSSGe4goaOyLsEpKm9XBQRlUpGg
         cyHgqJgkhDSiHBRkYdvCowXWaTdWMVlJuPcUzPCjfl//KdL1G6+kW3m6MEAll/vRjfmx
         2giSSG4PR9Dif4A+J1+aocotXGyLjALvNL8KZx1xx1H1t91wI5UQQkNmgGABBT+0uhyO
         7I5Fc5Yhr+YpO4gIZR4Nm8rli2ujUJcgc4BLEgYYc9GYS2EmCo5M7T4xAU0t9EUEFFHP
         9EUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731182; x=1748335982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CKZgmiZHsWd3katRT3fxSYHJdGTZyCIpS+lL+y5Js0E=;
        b=lQwKZNfPvN978rTrEh5VDUQvqt5jp8vUcD7Y5wQx8e8kws1ELVTaqs+2DU5Aogo77J
         WUlIt2kMK73eGuPO4rfsn0iVvb0n8XLQlFxvJUtUD0asbK2sI8gaFlKuSsA4RV6PFsMK
         4aQU/Nq9P0Fy4/dYgwJoaFsNnuBfJSMZlSLp5r3MVYptAs7qpVI7a0HyPGkdJZKBqyJn
         0ArToktNilPe7y1SmglI6CaoKzfHdkpWxKLOwlWBIu5HTVmqCnfc/4ohTNInK2FWKKzL
         cgeqZsOGpE9DQrLPoan9nqvjH8mQl8yWHps0HUZx166EnTPmIlmTrddkOfI+DHjnk+/k
         ny2g==
X-Forwarded-Encrypted: i=1; AJvYcCXRABXmcBgykjSjeBkppUZoHbVpqugi2xTQJ92jZMWfrAOV2kyvysjh5UjrsTbhu/zdGth1jys=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQqHPt2LpPVoPTsAm44AZkVOdSQVjjFMyetQugvJbYoWKpuqHV
	y2vHp3OCJzmKey8VUEkTqLB/02KN5wK0obKszYJGgiyxCZmnFrlftDL4E4wR3CZYAqUZJaTe6Ho
	4sNCg0wNWBUxcssl0728EZA==
X-Google-Smtp-Source: AGHT+IFVdTcpdyqZnbRyjGjgkt8Kni5chetO4dBq5cxEbxyb82PcnyVXthra3fVVyFQB8jcxKQCM9hCtE+YosLWO
X-Received: from wmbhh15.prod.google.com ([2002:a05:600c:530f:b0:43b:c450:ea70])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:59a6:0:b0:3a3:7752:108a with SMTP id ffacd0b85a97d-3a377521242mr3030138f8f.25.1747731182145;
 Tue, 20 May 2025 01:53:02 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:52 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-2-vdonnefort@google.com>
Subject: [PATCH v5 01/10] KVM: arm64: Handle huge mappings for np-guest CMOs
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
callbacks will get size > PAGE_SIZE. Loop the CMOs on a PAGE_SIZE basis
until the whole range is done.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 31173c694695..be4f7c5612f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -219,14 +219,32 @@ static void guest_s2_put_page(void *addr)
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
-	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	size += va - PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	va = PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
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
+	size += va - PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	va = PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
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
2.49.0.1143.g0be31eac6b-goog

