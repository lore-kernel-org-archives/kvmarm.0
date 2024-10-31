Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF619E7FA
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 12:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378399; cv=none; b=aIoTPEjMVMgame98bdqXh+8e3lCxbUP0eYgjzDRQ5BriQTKDdehkWHbmOMmbzz7C1STATttc0Z1diniHWbYOlN7Q+R9K+YQiS3FQZOMlniOt9fkzcyOYC24tuQosDzicr3Qit+KGH2iu7rc4qKFM0SS9Zp500Gh9K0DGVQ9M+vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378399; c=relaxed/simple;
	bh=jRU/yFn2oW7xkZzVSpjURvbyXNtflsGkn735wYplPN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpthfF2Eoul6rikNoI4hgDFshxvEeBRb8eXTHblfEIJiqPXJwOYHW4QziI+xQRkQoIZzknSWmMdxEVXRJcrOt2LOrFsN8urW/aOnyHKLT+NCxC61BPEdu8zONSA+Fp62GCwhUTF0o2Ut6fHAxo+3tDEj/m7ABaG2Q8bBhy5t83c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v+g3pbxJ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v+g3pbxJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730378394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRNGizBmS3No09royYQAbT6P9mobmk6sdA5rSdYfEw8=;
	b=v+g3pbxJitJk62SxyplCt57DrusgyGpM1bvqDyQRLaklC9QaBKdHygl10drdXSH684vIp3
	GhqLtspjbXJAhsVs6+Eg3dXOPrCelIw2fTKba838UV++/PfIoP17ybbv7COMfBwYCvs9bV
	EEXdPyhXFl4pek866OP5Bw/E5sjZu2s=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] lib/on-cpus: Correct and simplify synchronization
Date: Thu, 31 Oct 2024 13:39:50 +0100
Message-ID: <20241031123948.320652-6-andrew.jones@linux.dev>
In-Reply-To: <20241031123948.320652-5-andrew.jones@linux.dev>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

get/put_on_cpu_info() were providing per-cpu locking for the per-cpu
on_cpu info, but it's difficult to reason that they're correct since
they use test_and_set/clear rather than a typical lock. Just revert
to a typical spinlock to simplify it. Also simplify the break case
for on_cpu_async() - we don't care if func is NULL, we only care
that the cpu is idle. And, finally, add a missing barrier to
on_cpu_async(). Before commit 018550041b38 ("arm/arm64: Remove
spinlocks from on_cpu_async") the spin_unlock() provided an implicit
barrier at the correct location, but moving the release to the more
logical location, below the setting of idle, lost it.

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

