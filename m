Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FCF171C2
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 07:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080712; cv=none; b=eP8h+O9zfB1LE/TohvKqMwmvt1tEkK0YaZPlWJOccTXsELXBeOS+oqf5dKXsKLoMxxt9SpTshFfreIiZDvhxpumS/z7uzxlXcdb0Gj9ib8t0ikveM/LiNQNa8lt5OwEEgakKQpmc4I0KsUoHOM25XWi5eL0PCOeiqF/y+3wIKIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080712; c=relaxed/simple;
	bh=83nPUxZ4qRX50+P8S1bP819FfLOr/K0iw4ghNjkLlK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=k8dLb3O1zbHQyhzN/Lq7QgpQCJ6nLxJkZmDSLJ+4rdGABRbmdoZbxU1p1l0kOEEc4hS7nKj6uXq6VVNINOgxNYfzWMF3NS9I3jJgKILm1yiWrwAudu/p+IKnPLkSaFO/8BwiMibONtFfCaMF/ZS/cAL4DSUU3mCQi2Sy+aN1+jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T136ah++; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T136ah++"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct4niFrUQ4K3w4xvlfkiDRofAbyG8x2g6tRFtaf6BTE=;
	b=T136ah++ZR4ZmZdY13fgtQTdmmMqLlmXhf92Ojv1F034/TRcFKU7wQVUVD6opXikbLVQyv
	qghPnE8e2ubXv/rkWk/oXZDOR3QaWrmygJfvlm7V9rMil1J7hgVbaM89tIij6bGckXDJN8
	lvINXJ6njeOXekJqhXzbm3vfMyQj5rU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 04/24] arm/arm64: Share cpu online, present and idle masks
Date: Wed, 24 Jan 2024 08:18:20 +0100
Message-ID: <20240124071815.6898-30-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

RISC-V will also use Arm's three cpumasks. These were in smp.h,
but they can be in cpumask.h instead, so move them there, which
is now shared.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/asm/smp.h | 33 ---------------------------------
 lib/cpumask.h     | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index bb3e71a55e8c..b89a68dd344f 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -23,39 +23,6 @@ extern bool cpu0_calls_idle;
 extern void halt(void);
 extern void do_idle(void);
 
-extern cpumask_t cpu_present_mask;
-extern cpumask_t cpu_online_mask;
-extern cpumask_t cpu_idle_mask;
-#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
-#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
-#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
-#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
-#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
-
-static inline void set_cpu_present(int cpu, bool present)
-{
-	if (present)
-		cpumask_set_cpu(cpu, &cpu_present_mask);
-	else
-		cpumask_clear_cpu(cpu, &cpu_present_mask);
-}
-
-static inline void set_cpu_online(int cpu, bool online)
-{
-	if (online)
-		cpumask_set_cpu(cpu, &cpu_online_mask);
-	else
-		cpumask_clear_cpu(cpu, &cpu_online_mask);
-}
-
-static inline void set_cpu_idle(int cpu, bool idle)
-{
-	if (idle)
-		cpumask_set_cpu(cpu, &cpu_idle_mask);
-	else
-		cpumask_clear_cpu(cpu, &cpu_idle_mask);
-}
-
 extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 extern void on_cpu(int cpu, void (*func)(void *data), void *data);
diff --git a/lib/cpumask.h b/lib/cpumask.h
index d30e14cda09e..be1919234d8e 100644
--- a/lib/cpumask.h
+++ b/lib/cpumask.h
@@ -119,4 +119,37 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
 			(cpu) < nr_cpus; 			\
 			(cpu) = cpumask_next(cpu, mask))
 
+extern cpumask_t cpu_present_mask;
+extern cpumask_t cpu_online_mask;
+extern cpumask_t cpu_idle_mask;
+#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
+#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
+#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
+#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
+#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
+
+static inline void set_cpu_present(int cpu, bool present)
+{
+	if (present)
+		cpumask_set_cpu(cpu, &cpu_present_mask);
+	else
+		cpumask_clear_cpu(cpu, &cpu_present_mask);
+}
+
+static inline void set_cpu_online(int cpu, bool online)
+{
+	if (online)
+		cpumask_set_cpu(cpu, &cpu_online_mask);
+	else
+		cpumask_clear_cpu(cpu, &cpu_online_mask);
+}
+
+static inline void set_cpu_idle(int cpu, bool idle)
+{
+	if (idle)
+		cpumask_set_cpu(cpu, &cpu_idle_mask);
+	else
+		cpumask_clear_cpu(cpu, &cpu_idle_mask);
+}
+
 #endif /* _CPUMASK_H_ */
-- 
2.43.0

