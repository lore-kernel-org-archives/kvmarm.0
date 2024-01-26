Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD921DDC8
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279046; cv=none; b=XopznT8HzbXJLA6GSurJiKCKCRmq6rchIKDRPJjskBgv0Z/yHozjrD/oIrDl3o2/NC+BjYXzdnRdgV9ab7rYXpjrxFGmKmt8aeUg99f6OCYYFJOvXgRIPooRLOc/Rx5eptWJXzuZ1cESXFZ0JyFDE6Gko5czjZ0MIjTb9wyEysk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279046; c=relaxed/simple;
	bh=Af26vAd8OBKlZzGzRohSIEMXkzE4TiL1ndHkB9c95rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=F8Px9j+zsgiwsSu37ABip4LKVzmzhI/ZQWBICZKGEF6mjVQ+nOZ+/CILHeTgQmubthBmjR4j/+NYcTg1GT21S/yKhSgMGKB3L8ubibreS0FPlrDJqnQlw0XSc+SmiiwGs9tPUUloUX+CyoDpak2V9U0O1MpELhF551PoPeTCUdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k85QG6Qk; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k85QG6Qk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t8QBCSw0ugGbsG4j0H3vVx98CQz+uxYdKruKGslmE+8=;
	b=k85QG6QkOt0UxdejJJAMT7hiHfU8JA6dOIpZZMj1j9WofQ9z/1cK2JvYcY5K494iQ1MFfp
	53m+Dhx98Ke2OG3QL4YUuwGg0AjkQKakFL5MMTrblIeeE37fHjiwq4J5eUnfWZRo7RIWjg
	ikL4NMn4tSKCiCpxkFrc255DdJ/LwGg=
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
Subject: [kvm-unit-tests PATCH v2 11/24] arm/arm64: Generalize wfe/sev names in smp.c
Date: Fri, 26 Jan 2024 15:23:36 +0100
Message-ID: <20240126142324.66674-37-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Most of Arm's on_cpus() implementation can be shared by any
architecture which has the possible, present, and idle cpumasks,
like riscv does. Rename the exceptions (wfe/sve) to something
more generic in order to prepare to share the functions.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/arm/asm/smp.h |  4 ++++
 lib/arm/smp.c     | 16 ++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index b89a68dd344f..9f6d839ab568 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -6,6 +6,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <cpumask.h>
+#include <asm/barrier.h>
 #include <asm/thread_info.h>
 
 #define smp_processor_id()		(current_thread_info()->cpu)
@@ -18,6 +19,9 @@ struct secondary_data {
 };
 extern struct secondary_data secondary_data;
 
+#define smp_wait_for_event()	wfe()
+#define smp_send_event()	sev()
+
 extern bool cpu0_calls_idle;
 
 extern void halt(void);
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 78fc1656cefa..c00fda2efb03 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -45,7 +45,7 @@ secondary_entry_fn secondary_cinit(void)
 	 */
 	entry = secondary_data.entry;
 	set_cpu_online(ti->cpu, true);
-	sev();
+	smp_send_event();
 
 	/*
 	 * Return to the assembly stub, allowing entry to be called
@@ -65,7 +65,7 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
 	assert(ret == 0);
 
 	while (!cpu_online(cpu))
-		wfe();
+		smp_wait_for_event();
 }
 
 void smp_boot_secondary(int cpu, secondary_entry_fn entry)
@@ -122,7 +122,7 @@ static void cpu_wait(int cpu)
 	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
 	deadlock_check(me, cpu);
 	while (!cpu_idle(cpu))
-		wfe();
+		smp_wait_for_event();
 	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
 }
 
@@ -134,17 +134,17 @@ void do_idle(void)
 		cpu0_calls_idle = true;
 
 	set_cpu_idle(cpu, true);
-	sev();
+	smp_send_event();
 
 	for (;;) {
 		while (cpu_idle(cpu))
-			wfe();
+			smp_wait_for_event();
 		smp_rmb();
 		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
 		on_cpu_info[cpu].func = NULL;
 		smp_wmb();
 		set_cpu_idle(cpu, true);
-		sev();
+		smp_send_event();
 	}
 }
 
@@ -174,7 +174,7 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 	on_cpu_info[cpu].data = data;
 	spin_unlock(&lock);
 	set_cpu_idle(cpu, false);
-	sev();
+	smp_send_event();
 }
 
 void on_cpu(int cpu, void (*func)(void *data), void *data)
@@ -201,7 +201,7 @@ void on_cpus(void (*func)(void *data), void *data)
 		deadlock_check(me, cpu);
 	}
 	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
-		wfe();
+		smp_wait_for_event();
 	for_each_present_cpu(cpu)
 		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
 }
-- 
2.43.0

