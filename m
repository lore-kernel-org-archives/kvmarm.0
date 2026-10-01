Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1422F51DE1F
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864962; cv=none; b=YJ93W2cE2cts25s9Jtn0sw1m2C1oz9TWOTBNgeUCucAMV20FGOzPxRK7sH/y+JUTOSIE500wxdLNjjXBkHuJLKHKY67Y+3URZPZ96Ctq3oFEe2NJk2LO2Q8iVwRI/cId4+xAXK6ZljuFZn457DDODxaHTZ3bQKPA8r7rUEs/V2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864962; c=relaxed/simple;
	bh=VgBYrdgUVqx0LunEhQSQ3NbnQ2pg6rJzAKjLQlb/h44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RpSKto26YTpe51fURjmYpYjjlHaPcHLxQ0WC/PcTLBDAXmdznABUhChsikKoU+UkX2fwGI/aPzvb++zkdqvsvmw/eMKiJ41I2p81GqZEK5BevwLR/T2f7U7lf+9efWG0mLTsfrNgjn3+LK+K5cNflMU7VpRIXNwxvB6RdrO/68Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tNk8+88z; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tNk8+88z"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a024bce773so7180315e9.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864950; x=1791469750; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ogMG6FWLsaZmD+0hvaGeTXwDkULMhtfZspxWbbrsJg=;
        b=tNk8+88zPB/KqRYDfNslNalkabXMJxg7MJa7i/PjwPWMoWDm19mE4KySpd5o+Sqe2g
         j41+sPvTyLYmx1YsG70AlPqWMwUeikhX8BiVTKfzr9wKVuzUMLpzWmP1LQC/W8/sJBco
         2Knz21alOQlwP/TpHqgBzgxUF+QsRP0ePHPbVJgZkZaCHWXfBXyQjiFZdUI5IeCq0ULY
         bsJUdhuPpvFXr6jpXW12RsbCB/1UGMLc7XPFICHIXMaGvS3XWPK/ftgxKQOABXb50mUb
         +RTItmBTwi1hX1skxRtfkGKRsknNAKkflRvZvbYncQAcc1KR4N1kutEkeDdDtUI0jJho
         l+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864950; x=1791469750;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ogMG6FWLsaZmD+0hvaGeTXwDkULMhtfZspxWbbrsJg=;
        b=1MwXk/EOhi3rzgqsZFPHnO3G+m2uXZfXLdMAw8Vp4+1AHpoFmXKoZx+Vt4jGlg1ef6
         bm+tOpXcfNX+FCiBSKC7MkXYtI4abDxKVBJLsrh3ddh9VqB4oy+RWh+pXVWvt3wmg7ll
         EqWvKK3Twlcsvt7RLzWderjc71S+9LEqDUeOrnxpqJRGTRDQgF7dmOrdI0OzealtfCUo
         wcCIXkqEcD5riP/VCP2r9JGJVC8JqkEzQPtKTEJrMM3xPU2w5T/E0TwsBIgoQSd91AE/
         sVTvxEO5xJRbA2HKB3PDIhqKf/HlfuiuDtcwtuRVvn6byutaDcZPH8ECV+ttEjL4+ANq
         u1KQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQiywbxCuPogSL4eWJUdO9ROuoMURFY2x8TdKNxSgmJn2xLMw2egfD8sfzIREAuyoSm0akh7w=@lists.linux.dev
X-Gm-Message-State: AFuF++nb7KkNF4FrsoXsTwyVpIl7AQ9m4YnvKnYEzACdWZ3D0DZMZT7U
	3bBYZZVb7gL70oxH71HcV4Ch2oCGqEL2HHfINv/maaNXw+SiGXIm3KWTTuvQ2sUTq0StW2H9Pae
	DerleDfv8gAqrkf0OIX9oLg==
X-Received: from wmmi15.prod.google.com ([2002:a05:600c:400f:b0:4a0:1b62:1284])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b10:b0:4a0:c02:938c with SMTP id 5b1f17b1804b1-4a01b1290f0mr82799725e9.25.1790864949407;
 Thu, 01 Oct 2026 07:29:09 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:41 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-11-vdonnefort@google.com>
Subject: [PATCH v6 10/18] KVM: arm64: Add a shrinker for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Integrate the pKVM memory reclaim interface with the host's memory
management subsystem.

This allows the host to automatically recover unused memory fom the
hypervisor's heap allocator when the host is under memory pressure.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h |  1 +
 arch/arm64/kvm/pkvm.c              | 50 +++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 8a6c2506fdeb..9f09eb11193f 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -24,6 +24,7 @@ typedef u16 pkvm_handle_t;
 
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
2.56.0.rc1.315.gc6ed9934b7-goog

