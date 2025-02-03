Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5DA1D5CC4
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738607524; cv=none; b=YOpvCbf/MpFgNmSg6Jo5GkbaRIWXdUIBhK5UNqv3lc32qfPG5iZJL961YcPBCzcmcjbore+M7Q73siYqYDC9DSiWRydzCjv177cqqdFpaIpEaOP8p7wNuPfPcGNekCN5V5yJ8+pQJCgNfxiXyJaFE6j++KsbjjD9ZMpUnOd1hIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738607524; c=relaxed/simple;
	bh=KVMS2S20RqJDXL6CSXSKW6myhxVt+9yuaYWo6eiaa+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sfy59Q8VkyeYJ8kDj9m8pX8hyd2X570HAEu8OsYxKnRq4LHlW6i6N6LcLrGbQEBkoqA932HiNinIJDX0hRp3EP+hAZroOxbZn09BrhrScMIuHRrg12WggluT7p2zYiC2yAuagKkGuF45OjUw5AT+XeqM/Xifzmdm0I8HGE18YCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YgdNDFMw; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YgdNDFMw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738607520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eu97JSnDOZJQo0mlrfz4ghF9+QTKmQpDVJVrWRRDCys=;
	b=YgdNDFMwn/zsm7qQvUEG2ic6Nf1RTxd/ybFWcIhx/8dkfgjW25RwXPyXf4vr8u64OCowzn
	bcnjbRgJu3opxBddpvgae/5QNyzJQWQkb8NuwdtOxp+OCQ8IH0+K4Q/V6TgZspY4iXiJS5
	DLHuFM5tul8Kzz8KX/q4wc00lfiZsKM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Janne Grunau <j@jannau.net>
Subject: [PATCH v2 05/14] KVM: arm64: Always support SW_INCR PMU event
Date: Mon,  3 Feb 2025 10:31:02 -0800
Message-Id: <20250203183111.191519-6-oliver.upton@linux.dev>
In-Reply-To: <20250203183111.191519-1-oliver.upton@linux.dev>
References: <20250203183111.191519-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Support for SW_INCR is unconditional, as KVM traps accesses to
PMSWINC_EL0 and emulates the intended event increment. While it is
expected that ~all PMUv3 implementations already advertise this event,
non-PMUv3 hardware may not.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 104672a0c5a2..62349b670cf9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -856,6 +856,8 @@ static u64 compute_pmceid0(struct arm_pmu *pmu)
 {
 	u64 val = __compute_pmceid(pmu, 0);
 
+	/* always support SW_INCR */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
 	/* always support CHAIN */
 	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
 	return val;
-- 
2.39.5

