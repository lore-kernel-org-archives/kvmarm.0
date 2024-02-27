Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72F455783
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073810; cv=none; b=sxtEJ1PJyEVsMNwrLkTEiVQ1eNhq94bpbzNIcFJXX42KjFSSQyBlEOKT/L6w9VVyD5z/fo6CCsXUuRYKkCFmvQWxfSfkjiMtECkKtN2cSQWUktHarERtnWfTBmGLMLRPF+w3W12DGMlv/FOSh7H/BfCWiyx0DLeu6c6+U2uyrwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073810; c=relaxed/simple;
	bh=LZhnGMljJiHSUDRASbCDy6n2BnK+0klJ/bcIxdLAiXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D13G06pabyIc0rSkPSUGxS+6PUcVW8MN4ePs9Yq6yMB7QH8/Wx5dQuo5yA9s787FjnzFZviAGOe71uPQSurwONxclFXoNS30VDI+nYFx6vjZa4mkKvDW8YsH00jTK7kTGtCapagBpRx7ssVjEo8C7uVrdpmjYGQL3taXKR+pMCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n0P/nnUO; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n0P/nnUO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I7y6/77b8YjR91A6MI21pSAeAUKYD3YrahPlR9r/F+Q=;
	b=n0P/nnUO6DM1rIjrL1zzMbP9yOwCSghRcMSuHRN5uUqRYn0T3wr+LRoAIJidhonjz+nNZe
	esCao+l8o0n0V+VwHCKrySlT2WlV+PInQJvaon2C/gtLexCV9rhMdDfMsEBbC6KWGJC0nf
	ty4XTQfVcWgWJ/yVSQmR/HRaJIvWlD0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 15/20] KVM: selftests: Add quadword MMIO accessors
Date: Tue, 27 Feb 2024 22:42:44 +0000
Message-ID: <20240227224249.2209194-16-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The base registers in the GIC ITS and redistributor for LPIs are 64 bits
wide. Add quadword accessors to poke at them.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/aarch64/processor.h   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index cf20e44e86f2..884e31d9572e 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -177,11 +177,28 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
 	return val;
 }
 
+static __always_inline void __raw_writeq(u64 val, volatile void *addr)
+{
+	asm volatile("str %0, [%1]" : : "rZ" (val), "r" (addr));
+}
+
+static __always_inline u64 __raw_readq(const volatile void *addr)
+{
+	u64 val;
+	asm volatile("ldr %0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
 #define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
 #define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })
+#define writeq_relaxed(v,c)	((void)__raw_writeq((__force u64)cpu_to_le64(v),(c)))
+#define readq_relaxed(c)	({ u64 __r = le64_to_cpu((__force __le64)__raw_readq(c)); __r; })
 
 #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
 #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
+#define writeq(v,c)		({ __iowmb(); writeq_relaxed((v),(c));})
+#define readq(c)		({ u64 __v = readq_relaxed(c); __iormb(__v); __v; })
+
 
 static inline void local_irq_enable(void)
 {
-- 
2.44.0.rc1.240.g4c46232300-goog

