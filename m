Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5741A42C511
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508569; cv=none; b=gRRPQg5CVED2XHMX3MZ9vTYda7aJXsVIJMdzNkx9WMpboVG9GtA+6B5O1nuw1l9RFODojT7rvhxtm1+9BWFigWRol9jBmhHtiEle4fkBClUYG/KrNzQ+d2HC1HnRoNNbMVHq/4CSvU8OzPvdtHfKsLADnLssUGoGe/8E2Yqltkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508569; c=relaxed/simple;
	bh=UjWguBI8BExFUahmiBJpC4s8PFYOWTR0EjWqTQDncMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tenXOwlhuZIBmYbnvbQ3lPUtwjpZ8fS0vCv1aCbw6i4nciGEyoxv888xVf0wlaK6866VGar3dzwigEe6nAHhjhBDpy7uf2LAMAFtu/C0DiUGP9w+jQXON7lGwQjiNa/TpsmbTLVa1pC+l5bbCKaJqTMrKFEZdlXqWPD9uEBNceI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f/DBmjgj; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f/DBmjgj"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15ff68c858so106389566b.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508566; x=1786113366; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UeVYpUNSyWbGnYXci/m7zUTzHjx11p/EDVKsXzs9OkA=;
        b=f/DBmjgj4YFJ6kKYNSVnvr5NUMZ1na5FNblnhLS5H6JnXrLpo7sZrj8J6132l9wZ78
         Y5Ity3tsQx25evNsswtc/IFEKN6kOR76sXlRCGSHB4P8t7JcHIDWqaHiTYsXzsY6mVy8
         k4qNtOQg73r9kd4lBDG1kQ4kNPyLwKQ0C0K/0g1ximG/6T3AQ946lLZqlhHve+C6fJI2
         LkwEAUvpGz1AvMLet7zCtsQnlyzyz0a2FGIuL9WDyobMX1pLHIKoaO901ZxRmotVvSBH
         sfmfVNNCfEAwTxdGked0nTyt/AO/X/gUVXk9H2uulfa6Thfk3cw3+xKYar058X4nfAb3
         y8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508566; x=1786113366;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UeVYpUNSyWbGnYXci/m7zUTzHjx11p/EDVKsXzs9OkA=;
        b=D8g8zZ6ZdUUVW84Yw2twi7pZSGxqwluzdpwSdlf1dGIBAm/ykvUf0RnGonLBf0yrM6
         FKhfiJKx0OadV74uLy/fNaX1VQbX1uS/9cdYBfj//xYYX7R8PZKLKaYDTqkNtEdYFoPr
         mKX8jo6RmqQw8efu/0ERQ6TqDEJCmYzKnmWRkI377H4nbfG4ufNgVcUdUridhGSvBhdS
         w9NmjuSiKY4B4wYMF7tY8s+ZK1X/WHtp4aTPNB7m2MaMYn2P5siibYCBH/XgGqHdAvP5
         bl6wFnwEyCnzuy9ZXO2jZDPEXrP+VCY3Qe5xcIXrDNL6J44WCx3RMRjI8eu9VH8l9ls9
         UWoA==
X-Forwarded-Encrypted: i=1; AHgh+Rphk/vxB1cJyLn9zIvWjW4nEGQsCnlYIsJkIF0Krsj1aXWhC4Ta2YX8Eh19gBxATjN/US29hoA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwF172EFKPEXR5FpCGF/9WKE/BsH9+QhDb7ohzIV34+GvkVQxvb
	NQGyRKv5FnC+d5Jd0PqBLmwSEv0rQZpbWTjmYYedyrvqi7MRbPp1CbZeqK/WV88Z3uZwvYsfAjE
	rGAJBaIZId/cYPh38ue6RCg==
X-Received: from wmfo11.prod.google.com ([2002:a05:600c:2e0b:b0:495:4a34:c789])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7955:b0:c1c:6e35:aca6 with SMTP id a640c23a62f3a-c1fd2541fabmr142724666b.51.1785508566396;
 Fri, 31 Jul 2026 07:36:06 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:34 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-11-vdonnefort@google.com>
Subject: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Integrate the pKVM memory reclaim interface with the host's memory
management subsystem.

This allows the host to automatically recover unused memory fom the
hypervisor's heap allocator when the host is under memory pressure.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d28422f5c3d6..bfbb1266491d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -115,7 +115,7 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return ret;
 }
 
-static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
 {
 	struct kvm_hyp_memcache mc;
 	struct arm_smccc_res res;
@@ -133,7 +133,7 @@ static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsi
 	return reclaimed;
 }
 
-static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
+static unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
 {
 	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
 }
@@ -342,8 +342,19 @@ void __init pkvm_selftests(void)
 #endif
 }
 
+static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
+}
+
+static unsigned long pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
+}
+
 static int __init finalize_pkvm(void)
 {
+	struct shrinker *pkvm_shrinker;
 	int ret;
 
 	if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
@@ -359,10 +370,21 @@ static int __init finalize_pkvm(void)
 	kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
 
 	ret = pkvm_drop_host_privileges();
-	if (ret)
+	if (ret) {
 		pr_err("Failed to finalize Hyp protection: %d\n", ret);
+		return ret;
+	}
 
-	return ret;
+	pkvm_shrinker = shrinker_alloc(0, "pkvm");
+	if (pkvm_shrinker) {
+		pkvm_shrinker->count_objects = pkvm_shrinker_count;
+		pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
+		shrinker_register(pkvm_shrinker);
+	} else {
+		kvm_err("Failed to register shrinker for pKVM\n");
+	}
+
+	return 0;
 }
 device_initcall_sync(finalize_pkvm);
 
-- 
2.55.0.508.g3f0d502094-goog

