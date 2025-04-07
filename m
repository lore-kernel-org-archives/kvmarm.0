Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B71A226D0B
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014456; cv=none; b=j8g0pOqSKCXKCMylyWBp+EkZk+bEC10n6Ow9Icj5xZUgYSb0HO6JPVIH7KjsdDn6ajW4fCmKIifYI4gE/Nh+AT4B89GF0P4/iSJDU4E6U2pL/iLdNkmsJDrZs6ru+nTc2Wcx7/Ps0qw/TFl1bKxLNLckXxxb9Amq6KJ1wgjOtvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014456; c=relaxed/simple;
	bh=uyGJyVdm3PuN+alby9AYULNVVykMkqtNQdizjxSG9ko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bWqD3r8p2J0Bgt/fmq3JUV5lLRzu1nGscMORgcPjsPZ3xBCM2rRmE3GgzslSGGDQFCqIP7QH919vdjMSjRhYtfgE83tHU76YpLG3kUgHk/kwePJgeJl/NMALGh4+3pc8K+VIczOBp5UOzLu/tOZXp8PxdZ5tZL0IbY5fgDdNkgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ssspGo7n; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ssspGo7n"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so32683385e9.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014453; x=1744619253; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eamk+m6hItJvvYURRtivMfLvxKXUv+N3LqKXR7/o518=;
        b=ssspGo7nuaOBRglnPcvbHqBSht/XVvEDCdnYrgDIku87BjsBWMO2N5J8z5A460NfWg
         Q9Usf5nB6KnHj9ZR0zyDWBE/b0DIdCZImj4dWfcO4FxCCHKIR1GLVR2hcjtFrgy6MsjO
         OIOC0k+vZdaj8r8CyRu66pNoaSSiBqEkZWZkyuSnFE6VEhOMnGneJFT0coXVMnNim4h5
         teNn82i5jQTHPJ+7LQ574J+K+wGIZgUArclBtP+1X3q6G2Ftqmh2zZbeM783jHSfSGpl
         lS1gZENjvK7Z/LGbe6FPzZ1j3EaaPMVE/KPkhZxZdI2/23YS7dDwLZlftUAJ2JyctIYl
         1ukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014453; x=1744619253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eamk+m6hItJvvYURRtivMfLvxKXUv+N3LqKXR7/o518=;
        b=TJl85doBP8okTn6NUSw6FlHiSgVcLWvwbVId3BBCE/n4xzAf/aEJq0uSwVd84VlLAR
         iOVFoIYAoWCZodK27Qd69lRMgBq09HN8jRIcD0WCeO/JtZKSZB2bcnlo4RsowxUF/lP3
         fU6tF+P/xbEI7b8+SYVLY3KBtZOKgw0Sm7zoXaHKezaHbo32U9R6FQttTiUuwf6H5bUH
         mkdq598siuF3itP0HW0rMpWRVkIUbnYWrZZdOYdGu9uHLASy8B+eVSACVsrjKocVclKL
         b200HUrUJtD3Ft/smUChbbp5rVXS9EVwOrUACzOkTO1LhaAVbI5Qeyzz+zk72eepyz9B
         rZbg==
X-Forwarded-Encrypted: i=1; AJvYcCXsdnnUou55ZyU1lrHA5c3U4KzWid/X81MJNJWVZxHDAvR+sacXx/b3vBt/ErEK2kwhmW7kHzM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0kRgvTra7yEFsFTolXveqL7bCJzW+Egb79o/fTQcIlxWjkpk5
	oL5mVZ4io4NgzK/6sn/2lR+85zTkDUWavUdO7/r4EnWmad31zCWym04wqKddlgiKTunTfI7/Vpk
	r7RRHCIRZlrY1YavPUg==
X-Google-Smtp-Source: AGHT+IHEfDdtZEMKCFIiHPdGqbLmomiVEbcScZiVB7Z9bOtLoQQDsPDC5tGrnKssCX7IQ10njG1t/CVa1RWO127b
X-Received: from wmbep23.prod.google.com ([2002:a05:600c:8417:b0:43c:f6c0:3375])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46d0:b0:43c:e8a5:87a with SMTP id 5b1f17b1804b1-43ed0c6ba07mr107917445e9.16.1744014452806;
 Mon, 07 Apr 2025 01:27:32 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:26:58 +0100
In-Reply-To: <20250407082706.1239603-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407082706.1239603-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-2-vdonnefort@google.com>
Subject: [PATCH v3 1/9] KVM: arm64: Handle huge mappings for np-guest CMOs
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
index f34f11c720d7..6a90e7687f1f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -219,14 +219,28 @@ static void guest_s2_put_page(void *addr)
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
-	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	WARN_ON(!PAGE_ALIGNED(size));
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
+	WARN_ON(!PAGE_ALIGNED(size));
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
2.49.0.504.g3bcea36a83-goog

