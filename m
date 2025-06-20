Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0115024DD02
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457931; cv=none; b=hM6Dx6aTLgmH33vwDA6wc7onLBSYNW5kcQT176d8fPRonr2/x/FdFAIJ1hZLAr4sGsEEuuve1v822JMiRNZKlSnz7KDtUZHfT5z607/Z5DmsG8v/yETejSQLBA/X62Pmz3zAco1vfiqeAWXkl2RfYfW+l0tyU2fsdiREXJ4Yl9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457931; c=relaxed/simple;
	bh=QZPsbtUaYametyX+rMN8NQzux/Frt4tHD8rtEMiJ9Sc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VslKJViMgGjXm9EFaIYrA1hWOgMNHiVws7A4Za+bohnbv6CyTAJxG42Krt5rrbY7WSvLBn7nDYvsCeMyRkZ1TnxQGd3ITqcIMtOCYip5y7B4IXEkyjyRy4evKYvrMzoZ7jXAVxDhPoO2TEr4sTyZbHzfMOKCSqJ4Vb7/Kd+IlCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zLY2UAni; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zLY2UAni"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddc6d66787so32551105ab.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457927; x=1751062727; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qBxhIed3fkpmOQu/SLH3ienlsanfX2Wz3izzC9sfark=;
        b=zLY2UAniMvOPWG9N4ht1Amm3F/zg0QzE3sFYQVbKTbQ4g7dtziMXR28+No5ZNJzepF
         ZeMuJ77wcamvcLbmHxPUBUg+zZn0GKLo6VBroXc1PidJq0QTL7xpcZUXZr22DxK2iVWh
         BKUfRWG3fo5nWcSSjiyj6ftMePoLYZ5NMjyCSOVAvn9BzIxWnst+pnsGG1jAJM63lT9C
         Qu1aa332oqf2rQxurF0py9Pa/2WZkKnJmYgtlyBFParHnQFaquXhJ5/B5tZgW7nbuyjy
         VIrGZhahQVldsQB/uZIA5/iSEMZuaOK+iVrvYxDD8YxrlOMj1V9UIeZCv474y9njXppS
         squg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457927; x=1751062727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBxhIed3fkpmOQu/SLH3ienlsanfX2Wz3izzC9sfark=;
        b=SdDcwhjUZVueSI5pMX5LiU+xDtLw8KTnau4n61Q9vbseJq/jS/CxgVAkr16S4Kgj3d
         kG3tGlkV5FHMsNrj7ZTNmfK7yTcoHh/9SllomBwMJtaFPmn6z4Fn/LpsHmPIJFkjMqYr
         Zw87L0/F/gcg/zQcIcbvnnF0hAi3jl4lm1OrcxGmO/JbFywP7ox/rbs7Jr30q4ARI7Z+
         xC5fuWrVYrOigoPyLC+tCoKUJcN+jeTKdfW3qsYbQ7gDpHiEcxI89Dz57i+FKy5ZOnpX
         3ZxBhRHZ856xCVs+y5JBZ48NhQe4qeeeSeJzqwipWpzRXqch329aTsSQDOH5lk6ZEFkQ
         o6LA==
X-Forwarded-Encrypted: i=1; AJvYcCWbEQaFYtHwVkUZnVxdroDOV3KBrmvLW5zm/iuAx2yvw4sH9pplWMKWMp2SnnLQF3Qbu6p2kog=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCSVqTkIuv73B3SIsvZGzz9pQMa/KcOvOXdJ1AyMI8aFKsKNQU
	6NYT/BqgdpWEeezyQhSj00ql17j1oHfmjFH5GAsFOUgpUoPIb/LzYEfXJP+u2q5wCZGhFd7cFy5
	WvLTLPTDYVCPwTh32ePB+NEl2Fw==
X-Google-Smtp-Source: AGHT+IFTbBL04tu/5o1zgL0CZq/zWbduiqa+Y5YKeofcr7jFQYs86cUlPmuIGNSiiyk8Ax4cMVHcBUNCIBRZtQH70g==
X-Received: from ilbcp10.prod.google.com ([2002:a05:6e02:398a:b0:3dc:756a:e520])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:2488:b0:3dd:c40d:787e with SMTP id e9e14a558f8ab-3de38c1b8f3mr60278825ab.2.1750457927652;
 Fri, 20 Jun 2025 15:18:47 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:11 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-12-coltonlewis@google.com>
Subject: [PATCH v2 10/23] KVM: arm64: Correct kvm_arm_pmu_get_max_counters()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Since cntr_mask is modified when the PMU is partitioned to remove some
bits, make sure the missing counters are added back to get the right
total.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 79b7ea037153..67216451b8ce 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -533,6 +533,8 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+	u8 counters;
+
 
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
@@ -545,7 +547,12 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
 	 */
-	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+	counters = bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+
+	if (kvm_pmu_is_partitioned(arm_pmu))
+		counters += arm_pmu->hpmn_max;
+
+	return counters;
 }
 
 static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
-- 
2.50.0.714.g196bf9f422-goog

