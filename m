Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C2C1A76AC
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 13:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689452; cv=none; b=qyxNeBO9DRK4hJfDad8XpfGR0ck8O1699tf96HQQP/aaF91sAu+sulhKYNpLvnyNSK6LqJJxPXSIqRyR+aLzRZS4kHMHNHw83zNknJayUiMe39vZj9NKflYMt3OUNjdxYqQqPzwSGIYknaEH8Lkqc5XyNcp1yTw1XhZijfWj9MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689452; c=relaxed/simple;
	bh=VxEExFJ5cT66ChsR+4TqWR6RdTnzv16Bxu3/mJ5sDTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNNgPTCSPZHhtBOcfidKlrz0YKXkHxX+nh92DtB+g3yb+myZ4Afr3sOaY0wfE8btrLRkkcsNhOmLq/yCSt9NUtfT2hu1sluHw3klx/EnLBk7NKG+sSlTdDCehdT774i7a4XqKN0FCkW3fIxldtDKWtrH82rLtYiDvdwqM7PuD/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R96KKr45; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R96KKr45"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QeV4UfkiS7XFzfn3GzKPrb95YL+mJ8EYcU6Ge+O/14M=;
	b=R96KKr45P98nWNOUWIJnWJDx/9nd3WZG25knN4pFUZzB4fuUvsjoVabJi4z3xcoy/ZHkVV
	CXySf4GOiO8G7USyOggyGxSnaR+X33cdujPH4+XrRKeS3u8v/fQaJMegQnZ05uEn/uHqqv
	b4cAIgKHO1E5RwIF5gyzjGNf6N80yJ0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 1/2] lib/on-cpus: Correct and simplify synchronization
Date: Wed, 23 Oct 2024 15:17:20 +0200
Message-ID: <20241023131718.117452-5-andrew.jones@linux.dev>
In-Reply-To: <20241023131718.117452-4-andrew.jones@linux.dev>
References: <20241023131718.117452-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

get/put_on_cpu_info() were trying to provide per-cpu locking for
the per-cpu on_cpu info, but they were flawed since they would
always set the "lock" since they were treating test_and_set/clear
as cmpxchg (which they're not). Just revert to a normal spinlock
to correct it. Also simplify the break case for on_cpu_async() -
we don't care if func is NULL, we only care that the cpu is idle.
And, finally, add a missing barrier to on_cpu_async().

Fixes: 018550041b38 ("arm/arm64: Remove spinlocks from on_cpu_async")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/on-cpus.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/lib/on-cpus.c b/lib/on-cpus.c
index 892149338419..f6072117fa1b 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -9,6 +9,7 @@
 #include <on-cpus.h>
 #include <asm/barrier.h>
 #include <asm/smp.h>
+#include <asm/spinlock.h>
 
 bool cpu0_calls_idle;
 
@@ -18,18 +19,7 @@ struct on_cpu_info {
 	cpumask_t waiters;
 };
 static struct on_cpu_info on_cpu_info[NR_CPUS];
-static cpumask_t on_cpu_info_lock;
-
-static bool get_on_cpu_info(int cpu)
-{
-	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
-}
-
-static void put_on_cpu_info(int cpu)
-{
-	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
-	assert(ret);
-}
+static struct spinlock lock;
 
 static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
 {
@@ -81,18 +71,14 @@ void do_idle(void)
 	if (cpu == 0)
 		cpu0_calls_idle = true;
 
-	set_cpu_idle(cpu, true);
-	smp_send_event();
-
 	for (;;) {
+		set_cpu_idle(cpu, true);
+		smp_send_event();
+
 		while (cpu_idle(cpu))
 			smp_wait_for_event();
 		smp_rmb();
 		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
-		on_cpu_info[cpu].func = NULL;
-		smp_wmb();
-		set_cpu_idle(cpu, true);
-		smp_send_event();
 	}
 }
 
@@ -110,17 +96,17 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 
 	for (;;) {
 		cpu_wait(cpu);
-		if (get_on_cpu_info(cpu)) {
-			if ((volatile void *)on_cpu_info[cpu].func == NULL)
-				break;
-			put_on_cpu_info(cpu);
-		}
+		spin_lock(&lock);
+		if (cpu_idle(cpu))
+			break;
+		spin_unlock(&lock);
 	}
 
 	on_cpu_info[cpu].func = func;
 	on_cpu_info[cpu].data = data;
+	smp_wmb();
 	set_cpu_idle(cpu, false);
-	put_on_cpu_info(cpu);
+	spin_unlock(&lock);
 	smp_send_event();
 }
 
-- 
2.47.0

