Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2215F13D25D
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566378; cv=none; b=YuCbTdgcsjJlZsIM+0Pt541uu+Hpzfmy5mXQtwWia2WFosoyZR2xe11tPcRFkJCLh1vD23BHcg9oOCU9lBDbnjuNCO3RewFS7XHiJOmuoZq8omRdCF86LgOXvoImpL8zhwF7B4bRy8Ow/bHaSoGWD0XQPLVvUQiMNz0npfb2FqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566378; c=relaxed/simple;
	bh=Kc7x6bBWnBrixpWyfIC23KBLHq23dPtkQnQlmp3RezE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw3xYZykGegtlkNY0rNm2Fi0nTCQ7m4dDK2AAp2WaILZgUtAW4xey29emq7kJtzVqfoV1TZ3/QAEVUI943e1m8Yjgqx0w2fwJbajw0th8qUmxME6XFski5wD/P2nO7CEc1Jql+TdtHlWJQNPX80MHbQuCxY8N5haZl2kA2DXhfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=myeFKeOT; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="myeFKeOT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ydGmABd6xNhfxGKC+ckmezP0gUyG4AMWoj4bEZpIn7U=;
	b=myeFKeOTJM1fcTSTOLG2qOKqNO/4m6JcGb0PdwloPHxVKyh+A06ZktefR7nku9Rap4oaqB
	Org1rtGU2WTA2vDLn6tGD1msQNG8SeqZ85sIHOivPH5PIuJOZSYMBzBlHCmCmdoQdSjzwl
	JN1MISF+uOIJbXkSrBfqlRxZM0ZwFdo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 15/19] KVM: selftests: Add quadword MMIO accessors
Date: Fri, 19 Apr 2024 22:38:38 +0000
Message-ID: <20240419223842.951452-16-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
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

