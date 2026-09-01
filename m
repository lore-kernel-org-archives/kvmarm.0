Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDF8380FD7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250204; cv=none; b=NwhZCMyPnirk8v4mpNZN2Y88MQJlL44sGZ8uGWRPqVIS7HgV04VST7Kq8xfNv+9MG3S+E4hqYZorMd/37vejGt6sKlS2ptiYyJk9+VktS60kkPDj4fDM1p3NKOS7kVdo4QaLAwpm1MzWXQYV7MbUmzZlKepN/BMUl8fBrVuQc8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250204; c=relaxed/simple;
	bh=1f28K/it7huR36ibfbivLRDSA6zlLGCX6PBVGVE8fLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=STE020QpIUUkNOcnbPQH4ufUpbrD0xdjI3K/g44arNsYIYKWS7VoGiHVyfrZudcPiM0Zzddm0mlVmIS8XRgE39P3u5pkx3JjR5ZEl0lR0YNt1hzu3W4AsRSiFZ4u3CLhOFZMZTSJGQzS6lDc8yVvGZfTK4U/cKxKx8pmq1dj0Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=baGDMs/L; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="baGDMs/L"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49cd55ee2f7so18265605e9.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250201; x=1788855001; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9pO2+KcPdaCxq3dy8Vxk1F9NqAdOG0WVzqKgbcyEAuc=;
        b=baGDMs/LZFfmyVXQj5XwhjR2yZflM/yMiByjQO4LyHndiA2ip/jnwSDa/Si5V6At2E
         5chIzdxAU6eFG55Wl696C+tilusbGKDNZmFKNBX+xR3uEElpjDxQJ+p5QzLCOuNuD7DG
         jQNNerFTafWAT0fM1K/oWe9KLAkTMi4LdD/40UIWGYORTKF5hwXnW1RVDtvuTXyqqVl3
         rf5kR6KM8qSdkw5vNH9A+/EVpdQ3yUueLaIK7Z6g4OR46QSdSGPNf/HPqfVBSyZdH4pC
         /gLYMjmQ2ONGVPPXsXa4SfX1ng7t0LC0RXXhoAW1USUsdPCfY3cdz9HYs0DKa9SoJrz4
         agmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250201; x=1788855001;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9pO2+KcPdaCxq3dy8Vxk1F9NqAdOG0WVzqKgbcyEAuc=;
        b=Vx9UYdoOiTOQMA+HyWsJtzBJury4dA8XGMUDEiV8jdd9KTdRYIdOfLDIvO06FajJyz
         XHwHzyYoM7AJ9Xt6cuKjZc4U9x2WBjSmgf3aEX3+IGD0bH/BDINWXl93X9d40mac6sCZ
         r2mjCJncEqeOVS6NPCg+OhD1V/iRXv4twE3+clJYp+CrOHQ1IRd1IxercoSpeA5DL6DS
         hoB3lNTzcqApkKTiI8wVtr0jRCu4O8re+CChnumYQPAjrUr0EM/4/kAp+WJVWb6srdTK
         vq2y5fovvlOohaYOwBzKhfq+G1QxDOHaYRipyNabgIoV/Sd709XvfPnQvFHOGVBeLkQS
         a5JA==
X-Forwarded-Encrypted: i=1; AHgh+RpCsDJoFfA1KfN152REDe/c43dRSyFIEmwo35F/z26hGgQ8rE5DkxOHNe2EB3UuXCQqEfv4TPo=@lists.linux.dev
X-Gm-Message-State: AFuF++kVpVzQqDsktTduFmaJzDwP01KNvuZa+JF1x1nYSamUMFnwc6Tb
	AHkPIHugw2p8AI36hdSxRzsjHyuhhfvUN+IKrHr6UWcnGE5p6dFIoyXV9XrGjvwAPls9T8OOyhU
	4agSqaVYPwQNHsJ+w1ktipQ==
X-Received: from wmbh6.prod.google.com ([2002:a05:600c:a106:b0:49b:8bd3:6b1e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:81ca:b0:49b:47b3:d6d with SMTP id 5b1f17b1804b1-49b91c3b7c4mr548776525e9.10.1788250200510;
 Tue, 01 Sep 2026 01:10:00 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:33 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-11-vdonnefort@google.com>
Subject: [PATCH v5 10/18] KVM: arm64: Add a shrinker for pKVM
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

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 366bbd5c854b..976fa65522fe 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -19,6 +19,7 @@
 
 enum pkvm_topup_id {
 	PKVM_TOPUP_HYP_ALLOC,
+	NR_PKVM_TOPUP_HYP_IDS,
 	PKVM_TOPUP_HYP_ALLOC_SELFTEST,
 };
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7821f2592eba..ea96744f41fb 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -133,7 +133,7 @@ static unsigned long __pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long tar
 	return reclaimed;
 }
 
-static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
 {
 	unsigned long reclaimed = 0;
 
@@ -154,7 +154,7 @@ static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsi
 	return reclaimed;
 }
 
-static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
+static unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
 {
 	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
 }
@@ -360,8 +360,39 @@ void __init pkvm_selftests(void)
 #endif
 }
 
+static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	unsigned long reclaimable = 0;
+	int id;
+
+	for (id = 0; id < NR_PKVM_TOPUP_HYP_IDS; id++)
+		reclaimable += pkvm_hyp_reclaimable(id);
+
+	return reclaimable ?: SHRINK_EMPTY;
+}
+
+static unsigned long pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	unsigned long reclaimed = 0;
+	int id;
+
+	sc->nr_scanned = 0;
+
+	for (id = 0; id < NR_PKVM_TOPUP_HYP_IDS; id++) {
+		unsigned long r = pkvm_hyp_reclaim(id, sc->nr_to_scan - sc->nr_scanned);
+
+		reclaimed += r;
+		sc->nr_scanned += r;
+		if (sc->nr_scanned >= sc->nr_to_scan)
+			break;
+	}
+
+	return reclaimed ?: SHRINK_STOP;
+}
+
 static int __init finalize_pkvm(void)
 {
+	struct shrinker *pkvm_shrinker;
 	int ret;
 
 	if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
@@ -377,10 +408,21 @@ static int __init finalize_pkvm(void)
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
2.55.0.897.gb25b4bd76c-goog

