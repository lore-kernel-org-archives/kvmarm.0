Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4D6286D4E
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533981; cv=none; b=rKOPz2MP9YUkAtEN/PYBGsQ+dfPjJ+NeaXunAv6C6/ubsFHgXO/fv21fs0N9npb4bR7yhsN2JdeHkIP/+6leW3EYOn396a6EhEPGnWvFZ+IRCeGKXYSNo0XyBBvGZRHvTi7BHlw5yiTyqmOk22Gomt89E0wNIruRBZxObXr2620=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533981; c=relaxed/simple;
	bh=83DjgNByW3MicWNoftr7pf8Sgs8ybpROMTZWgSw674M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QZpoB9ZPcJYR84ANCEpI6XrIPDooLgWllkKqI8SMkdQbwItqCihqS2UKsE/ELSiySqcSIBZCvli0FaYMpNzHg4eN9YmkH4Aex5Cy3MDlIFx9CTGm2D9glDU/VCN6RC4FgG7xS1yEJdVbHJa9zvChCfGob5raXI4kRH/lndNAIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Otrt9mms; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Otrt9mms"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-873fd6e896bso510656139f.3
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533977; x=1753138777; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hXtQgo0JIkUT7TODCNQx7pYKeIXv6hb0g8DOUP6P7to=;
        b=Otrt9mmsbG3nwF30q3umFOvuJqYp3c4678GV7i+G1F/O3yK+BJXmfszTYQxHWxY+H9
         V+If+YkM8qiQvBMbx/JBK4VsfqHzN46NBPPvSQxKsf+ELSOrocGyGhzaRSSsEuSgr8YF
         fRhlQTkd5SCBkdreOkGfhxzL60FgKRyoPwkYrXKW3aVYOdL3J1Dvvj0IxBdwMeK4zJmS
         42/Kim1yflDs7TVBRdS4mAvwCgZUc6sSMCeFQCQiGmJLZY7lFjHOPiczyuWTQoIT6OkL
         05rrjvitxD0xMcilHWxxRbH/H00L1iZJsccxc8ZdFiXb26utkkGQARqR2IbQCmRo0ACl
         zBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533977; x=1753138777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXtQgo0JIkUT7TODCNQx7pYKeIXv6hb0g8DOUP6P7to=;
        b=ME4p0zvd6UHzbqD2aqL5qOw5XkIlIWAUqM30Vhtqf9RJlzT9OZIdBiJDF3pvsD0r4s
         APloozGi9QYK8GYuYbTt4XNIDveFWcOdatUsD5E4OTD19gX0J8jJ2cRK83HllH8UnWa1
         JPS3zyuVhCsOX7O97yq+Zzyfw+aq864VWJjmxKVqhLcZ3fjU5Pf8JMmzt3UkaP/hQq4G
         RfYBQFb2C43l0MgfgXiayAGgsliXAt8uWEQ6A67X5bhMKLc3pXZ9+wranTtct8gO79Vk
         fLR5UQe8nAnQGZFa3Ffq0uqElJHL2c9E/qG5vHwZgoFmzt/rCALtd+oBkRV5Svo+N9RH
         WV9A==
X-Forwarded-Encrypted: i=1; AJvYcCWRUBqc3DXipn0LSDNI+Xoj5jL8C1Jznq7XvMXZAhp+C0f7Q9B882/3BtSS9aceWbL2iEE3u/U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yztbkb1QDQ/Sup0PcLk3hWRMC1Z66v+Z+y2eP13RHke9yYmHRYb
	+IOcF/upZZrtIcnCSqQl3LDDopORUzVGmEPzhghBjsofjF9FxMmUDiozzMW1V82xPJOwfin9HXw
	+lPVDvyxCld8kOW9+7WF2aNXlNQ==
X-Google-Smtp-Source: AGHT+IHBO0mASu578wHJOGcQpQ9A5EOTJJDI2Tsl6mLeD713vdCHw+Xsr7SE46k9aYTsouWFo/KzgvhsXQhtYGQfSw==
X-Received: from ioni15.prod.google.com ([2002:a5d:840f:0:b0:855:9384:bf3d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:380d:b0:85d:b054:6eb9 with SMTP id ca18e2360f4ac-87977ff3c65mr1759326739f.14.1752533977132;
 Mon, 14 Jul 2025 15:59:37 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:01 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-8-coltonlewis@google.com>
Subject: [PATCH v4 07/23] KVM: arm64: Account for partitioning in kvm_pmu_get_max_counters()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Since cntr_mask is modified when the PMU is partitioned to remove some
bits and kvm_pmu_get_max_counters() uses that bitmask to determine how
many counters are on the system, make sure that function also counts
the counters that are no longer in the bitmask.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 79b7ea037153..8a21ddc42f67 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -533,6 +533,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+	u8 counters;
 
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
@@ -545,7 +546,12 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
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
2.50.0.727.gbf7dc18ff4-goog

