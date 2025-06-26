Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CED12F430D
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968364; cv=none; b=NB3NIiYunYCLcMOFWJ8zllQ+2VZAFx7uzPViGPnlY4HScsVy6N2Gf5c/vkRyeRHz707nJxR9+RT6JnRR1wThKNlMXexpAOr7ok6xgCQii++xERuL2nAMKG7GAup8A30tHQEB1voHDWjtslXQQuCkFvwqrS8tmjQQuysHqF9fzas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968364; c=relaxed/simple;
	bh=K2xYmW/GgRMbLaQlmv0qc4PJUypEgPrPpwxJt6aim7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AtxVsT1E9uIe4w+S7+HLMXMoefHGpwJzMVDZv8x/7ol4Bqidtuwlbh6zW3I+gKnVk6mlJA4XTQq8XDdsgJq81d2yZNwDNfEgFzc+dDvftDcM4iwAzka2/3N2VMiRZOelyCLk4lezB1z8hqXC1cJbhyBBSJJ+NiHKsQTVWzd3mIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TVPQ5rY3; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVPQ5rY3"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-736f88d8e02so227860a34.2
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968360; x=1751573160; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/x7IKRsWOtConph2bUpKtMTviRfv4NZ5l+qpFLQ4pko=;
        b=TVPQ5rY3nBKvbaucdkCfPX3ylUlNO3BKKCCuQorRIKte116VAR48vHVjHdxHe9LotG
         LGuYcnMZvfVLsY9F3pG9gMOBPXG9Nm08Qon2OSfq7J/fwDpfs/w3VVg9K46Dv/BFgbH/
         +6FVsh0lCqTfldjzp8fZDpP1QZ+pkDwibJfryO9lAhObQg32kS6b/UvjVmItzmPfTDrn
         HMbXdrZPEHXoVGxKPf//hhSsh5xLR8M/xc821j++MimUSK5IagQH4AEDnBacz/uR/dx9
         Lm/vTNLu1oy4NlVcLXmlzB+eVovkNKIEED+dm6yft8VamimReRLHclt16ze6npE1U15X
         6IjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968360; x=1751573160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/x7IKRsWOtConph2bUpKtMTviRfv4NZ5l+qpFLQ4pko=;
        b=v/klSmYh5/BG4Ti8XsSEzHyoipWNQkIMlKWN9JWok7xR/XtvQIX+czQlHqskN7sc6H
         2qA/FKaoZXYvzC8bN8B54iaLgy40YXSQwSPzG1fb1n+vho4XKQrj4z4IEa5bIwoIV7QV
         nx/aKF/2t9+lm17ARh39tDSgkWmPsngmFlTB+6kgMt1KQ0ikVS7gLAKUs8LpQeEGuBiD
         32OVj/rOwt2qdtREnjhTU3RJg+dxsDQluAdOyTCijfxAgfUUEVMwVvqRpfUbVPhr7aNB
         7SHmi75j73E7cXZItQCgEVZa4z7OjibUaqHRM/OjCq93s61MIvd1ovhoEsIa1qTo4YXf
         56Og==
X-Forwarded-Encrypted: i=1; AJvYcCUkpwffE5B3pUEwydZvlHrB7evlaVR1QJd8UChjnT+UrDu34KCA6aVzx7VnHpypwDlDrwNE9X8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQhYvOEFl02uVl9adNL0bC71o5IGIFRbJt5UXDlfLC/4VIjfp2
	xWOQnD0+yS2lExbZPAoBvdUM+dyRXyAUE9XtO5TpxxTaC5UYzLRgXOBDTheWNsaeKR/FL9W/Nl5
	9nGIgn7SbofkZsEEjnXuNNaoPbA==
X-Google-Smtp-Source: AGHT+IE+CkaZ5iXFv3dTlFyH7UdGDZHsbvzoJSe9buN7PuL7mIyZPRSBWsO96oSxssKGqZuLRqFlyodkFZoXyb0msA==
X-Received: from otber8.prod.google.com ([2002:a05:6830:3c08:b0:72b:8c86:a47f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:720b:b0:72b:9bb3:67cf with SMTP id 46e09a7af769-73afc5c355dmr285473a34.9.1750968360578;
 Thu, 26 Jun 2025 13:06:00 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:45 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-10-coltonlewis@google.com>
Subject: [PATCH v3 09/22] KVM: arm64: Correct kvm_arm_pmu_get_max_counters()
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
2.50.0.727.gbf7dc18ff4-goog

