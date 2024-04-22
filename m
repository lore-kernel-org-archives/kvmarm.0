Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F37156C6A
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816162; cv=none; b=WYl17tZ7FE8ctNYfsZrQKtQ3Ib4NV6PAfXycalSAsACSzBobBYWwi0nyfH9G+xD/PHFg6yWLh2fOVBI005q87DLvydn94lyCz8O+35iuC30GWWcm1dOhEpYiyVGH6WHE2TIYn0gQw0FxedJQqBi4Iw/Mc1odTi9uYzCjVSH1Npo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816162; c=relaxed/simple;
	bh=Kc7x6bBWnBrixpWyfIC23KBLHq23dPtkQnQlmp3RezE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbqPfR1vtqsyIt0fvmi6AR1EQA9eppFTzLqulCZCCGg6/X7guaO46+dOtcZiNtFjo0bogEVvnAR7U58FUt+9/Xi5pGPSoj+U31avB6glNDGQW3wCQfAktCVs1GYo5/vFXY7MzqVxbvch6vGWzHAzVzOE+9EewTGhxb+2AsScal4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BOIdNNmn; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BOIdNNmn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ydGmABd6xNhfxGKC+ckmezP0gUyG4AMWoj4bEZpIn7U=;
	b=BOIdNNmnoliOdlddkmKKfvxtt2zW7yhDaGiI67MYwONk85scRMeB3BcZ4Be9JAOcrZ1O3n
	FPNKmk6Il/vaH/oRYJCTAKBR3kNL5wmJWGO+Eq5N4d18Y897UQp8S+LGpalqm6SO3t7MTz
	k1YLLmEwaazXi3AkITGEYuTOj8fNDGI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 15/19] KVM: selftests: Add quadword MMIO accessors
Date: Mon, 22 Apr 2024 20:01:54 +0000
Message-ID: <20240422200158.2606761-16-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
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
index 9e518b562827..f129a1152985 100644
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
2.44.0.769.g3c40516874-goog

