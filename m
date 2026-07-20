Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBF143CEF9
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567738; cv=none; b=i7PTr/Sfh2NQvDa/lwuNWLfTJrGeZIBX75WDEf1TKLsHniuGYUVo/ppjLUpNGdmOw5/69i9RI94oTDEu3qjGalLdxaE0KX+sYRKf71aCz8rQ/HOkKpJ09egT6QDV1gSzgyqXWYiSnvbCL8tZ9BRPJENDwrdSoVVDkAZ7yfSe7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567738; c=relaxed/simple;
	bh=KE/IFy1PCQj4yOfAKOkT+ZQWmjAf02RCIVJyyrKfz5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kFFtXnmDkDUGq1dvtN9HEftCcqOy87Bic47uNvofPiTKSAmPCRYPAl+++D2TR8AQxJprAxMAkP/n5tJm5Pl30Q+dHd/8kAA4rkAoKYg0ionbjTXKyEpMBdhLhHkqCJXJHNBerqyFTy2s9YD9aJnEISE+B0++h5nzBHz4m+wycV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RpIoBpG/; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpIoBpG/"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954b1c6310so27402305e9.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567731; x=1785172531; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4GGquKFUt+ZnnqoeDLaHiVsxrzSqvedgiIipPU3o3GU=;
        b=RpIoBpG/nu1TdD2DwVPWvdmHzxYZgOM8aPW3mCB6CTI3bDOduJmtm0QtukRj8HX+F9
         9XxKOPbS0z65jCszZqvVjDQToGg2qyH4gvpKZc9azWl4ClHiN1h6ubypcL+UR4M9Nxhu
         HTFxTGHK0aHUh/o7zoQaw3yap3f6WKKt2bS3tpVJaVgfZ+QEl2SigixLbLvnS90++Jim
         x8GZBupB77fDI7ovveClPJWmE+x6F5aCz/E82zo5/K0htBCGynKyyzhpB6C+sHMEXeBy
         mlF9fZb9nQzVHZ7cyFfhR+uk7tbnmhDJsCGh1Sxis7LzkLXbx7GJ/eVwgFsCvIS2oFD0
         s1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567731; x=1785172531;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4GGquKFUt+ZnnqoeDLaHiVsxrzSqvedgiIipPU3o3GU=;
        b=dkSy1y7EF6a295hzoO5dhiuAoZns+D7B5jXE/uiYtHFWvzsXtbup3FOGXG4bGnnNW4
         xf2193NBHdJhz7gqLuLgeS6xr+6kA/JXeVVH2+WprzDtOHiHDAQfRGRM9nZf2/c8VjHk
         5FhYaHULr+snlL4/aSwisEjr7HelIzQg42QS09Bmd77mAjhAYXWQRcoLrbb8A5qq1Fqj
         WnK5VORGKKrQWr9P2Q9/MPKju4OAFDI/lnFPC+/KPTSDoAvUpI2NnhhsmP4v328WjYcy
         e/z3rsFRpprFqr3pS4MAYfl/UsTOiJrpDXf6XaeGpQsUaqPqLh0bQCl38Ia+bGZj06Lg
         6s5Q==
X-Forwarded-Encrypted: i=1; AHgh+RrUY9cxLUb9yg7FSLhnpp+efwmJ8MUEchpPzgrBFSUpSGRZrWoVFuZRNQ7/wX2nQ85i6G11RBM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzypSRm1CSZ4b/QZOC41K1auA8xXCvev6DotVWfyHxEZSzr1msc
	9ejYavjgAfkNfZSs9cw9kSXUVQxXzc+uu9OO2dmYYNMFAUtx8lj8OMR0xwuLOdhqXhsuPqPG3GR
	WCA5xCwaQrigZIJ5t+m1CNg==
X-Received: from wmor19.prod.google.com ([2002:a05:600c:4593:b0:493:f17d:c775])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f94:b0:493:d741:5d72 with SMTP id 5b1f17b1804b1-4954a513ef9mr162325755e9.38.1784567731014;
 Mon, 20 Jul 2026 10:15:31 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:06 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-11-vdonnefort@google.com>
Subject: [PATCH v3 10/17] KVM: arm64: Add a shrinker for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Integrate the pKVM memory reclaim interface with the host's memory
management subsystem.

This allows the host to automatically recover unused memory fom the
hypervisor's heap allocator when the host is under memory pressure.

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
2.55.0.229.g6434b31f56-goog

