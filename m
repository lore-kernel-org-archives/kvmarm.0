Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011951DB95E
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016455; cv=none; b=IhaAP3ebLTwOXbdYkow49vVMF+FOgqzkg5TJWxlYuTx2tXOe8mWYgCzk1xnznRBO2oH+tX9s1H8vRKdUEmXHYLKJhytOZrjUjDAJgG2CMu5iteU4/I2rZ9GLUoIfSXI+YEqHoSsguX/HGVZjPxXwx0CmLukUzcJeCAwZTjRE6nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016455; c=relaxed/simple;
	bh=e+fynXqXDHpzzqW8Vs+cdjC+w3ueF0FGlAHIDITfNr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U+WN8L4+3dQetCeCx7uoibuqbvZGokwyseHV5VCiHHT6KIBpJHfEwCFPtfiLFevT4C+9fobbGy4Y4N+nZ4q+uPWqdBmjHM6Ch3LqjOhasmfQ2o2Hxq10nm4bm6V82E6z0TNOkL+/SQLWrJBLQ8A4k8EeO/CbZqyfsuBY4lqK5ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcWvWJFp; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcWvWJFp"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3cfb20d74b5so35279675ab.3
        for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 14:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016453; x=1738621253; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GaVkSfHrHzVfJjq8AwEUCvEhNWS7AN/5lexlisUUmk8=;
        b=DcWvWJFpS/tf3JY7qVGUVlLmxKwME58DzCNVMk9PJMNezKEIgE9o8wwP/51ktZnRrr
         eXMNGng43xIICmVBWYO8nlmaGqN+zN9HAuaxm2wQIFf8lQ5fEAAXkCHuEBZVx985Mr9M
         8V0+Nf83bJ1I3G8XlqAVMVd+05zw73O1xT7+taHwlfALCIMcKQwpg0NOOJGxZDFzVz/x
         cLcFmW6qN4cr7MBFJBlkJt1wr3sAVonXYZVUoFebBmHT83J71BXyPaPCdKz7IIMjPgk4
         YCdDXEoiywqutv38g3Uf/G5DgtQLOTrRdP0GgR7llMK1MoHZl0ljawLOMLoIPhDmjMRy
         yK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016453; x=1738621253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaVkSfHrHzVfJjq8AwEUCvEhNWS7AN/5lexlisUUmk8=;
        b=o+GAdR5BtPDRHKHR9DsEVAyO/PU0MBkeg3ZAZLiw08nfFrYwbdlPWTbnJE5NhA+fxC
         6uRiOplHkICJJRJoQVf3erXhJvn8uXBfBP2WxCSbI1mkzXdY7pSblsI+dkbpB3z1sKhx
         4dT5X7e5H/T+dunk1WpWUDlmCIj46oT7dJELpg2VoiqkfQnGC3AvuzgziB/stgi0ZoRs
         oohQDPFF+KrIKfz7iucrxIWQSSrDU6drzurDyLZ9frDUPDAWge9H9SfP/TPZKoI19p5R
         ii2TOxtm41fX7tjo2yqStey0634UxvsNYbTfJjBuQFbVdbAer2jXxHURW9daFJ9ulbNy
         b9+g==
X-Forwarded-Encrypted: i=1; AJvYcCUU8aU/EVtxc9g7xPjtnF/JxOAX2BWPfBoyx95Tym9spXYGpTREKfavdQ3D4295eOllg0Hlvpk=@lists.linux.dev
X-Gm-Message-State: AOJu0YypBhyehflH6wDOKSbNtwAeST8LZxvGa/uH+dH36uIEgYOps0dG
	2KSXjL6SEBLFvZixvMzAL6RgU9WCNM2ILSbLPQwhO0aucvd9KDOEKf1/hTVNRUjV82kicYHKo4i
	ngS6izyJhBoq3RFdiWsQXUw==
X-Google-Smtp-Source: AGHT+IFYMP4DnSoUUl5kkRFoQsqHI/1D0lC2aOLiNQgEnibJSp/Pb6c49edDE2uZE1uw/6tcaw+6CTgspGEMpXa6dw==
X-Received: from ilbbu12.prod.google.com ([2002:a05:6e02:350c:b0:3ce:8579:c1eb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1f85:b0:3cf:b08e:7e91 with SMTP id e9e14a558f8ab-3cfb08e7f5bmr197753565ab.13.1738016453125;
 Mon, 27 Jan 2025 14:20:53 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:28 +0000
In-Reply-To: <20250127222031.3078945-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250127222031.3078945-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-3-coltonlewis@google.com>
Subject: [RFC PATCH 2/4] KVM: arm64: Make guests see only counters they can access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The ARM architecture specifies that when MDCR_EL2.HPMN is set, EL1 and
EL0, which includes KVM guests, should read that value for PMCR.N.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-emul.c                                 | 8 +++++++-
 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6c5950b9ceac..052ce8c721fe 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -993,12 +993,18 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+	u8 limit;
+
+	if (arm_pmu->partitioned)
+		limit = arm_pmu->hpmn - 1;
+	else
+		limit = ARMV8_PMU_MAX_GENERAL_COUNTERS;
 
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
 	 */
-	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+	return bitmap_weight(arm_pmu->cntr_mask, limit);
 }
 
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index f9c0c86d7e85..4d5acdb66bc2 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -610,7 +610,7 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  */
 static void run_error_test(uint64_t pmcr_n)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
 	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
 	destroy_vpmu_vm();
-- 
2.48.1.262.g85cc9f2d1e-goog

