Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794F1D52A
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279063; cv=none; b=tn38fQam9BySLgFIJzsoIy5fiTrajotozZUa1QHg41YB3VAYfKeDmTBjQoJKAlzIvsJ6+W+UxLBUhCiqrxnYRcZkTyeh/byMQKM9MCJoXHVdnWIFA2Rth+QD5U3Nr5SJcXu2ZdkT90Pba5CZXQRDRwixx+JjEYKIcs8M/AWerxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279063; c=relaxed/simple;
	bh=yD0DHz7pxjmnjuRrKJkLL49cdN4zp7SbOrR7voqcMdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=GQPiZiaNkFjuR8FHJPYv/0W58BpUNoiLY2Cvo6RmFalKOjUmfLVnt5I6m3ggRAzhrcBOsG19apnnbWHy7v+EZ0L/TTJRAMwtm5EL0ozlA6jis3b75A8C1lQD8b4TOh2u/erPyPPWWBARcomQE/yYAN4FJMC9W7G3+KH7W7Tfh7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KK6kl53U; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KK6kl53U"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8aDuzOZfqPJsevjv/w8qZsr245l2msUP68ypMXsEOx0=;
	b=KK6kl53UTr90vCeQNo8aF5HrFTLD50EGdHlKJr136jAS3IcI/0JQWHTCRAh90F3vg3ONAp
	FE9MzyeIpuZ+bkH7zvv9TiILcOWzu4sFz4ZYV3M3m/wHGxNRfcKCvCTfx14sQyZcKfKSHg
	KWX3xeD1WX/4VCXfDKHnlSveTnsciXs=
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
Subject: [kvm-unit-tests PATCH v2 19/24] riscv: Enable the MMU in secondaries
Date: Fri, 26 Jan 2024 15:23:44 +0100
Message-ID: <20240126142324.66674-45-andrew.jones@linux.dev>
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

Set each secondary satp to the same as the primary's and enable the
MMU when starting. We also change the memalign() to alloc_pages()
to prepare for enabling vmalloc_ops. We always want an address
for the stack where its virtual address is the same as its physical
address, but vmalloc_ops.memalign wouldn't provide that.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm-offsets.c | 1 +
 lib/riscv/asm/smp.h     | 1 +
 lib/riscv/smp.c         | 7 +++++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index f5beeeb45e09..a2a32438e075 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -53,6 +53,7 @@ int main(void)
 	OFFSET(PT_ORIG_A0, pt_regs, orig_a0);
 	DEFINE(PT_SIZE, sizeof(struct pt_regs));
 
+	OFFSET(SECONDARY_SATP, secondary_data, satp);
 	OFFSET(SECONDARY_STVEC, secondary_data, stvec);
 	OFFSET(SECONDARY_FUNC, secondary_data, func);
 	DEFINE(SECONDARY_DATA_SIZE, sizeof(struct secondary_data));
diff --git a/lib/riscv/asm/smp.h b/lib/riscv/asm/smp.h
index 931766dc3969..b3ead4e86433 100644
--- a/lib/riscv/asm/smp.h
+++ b/lib/riscv/asm/smp.h
@@ -15,6 +15,7 @@ static inline int smp_processor_id(void)
 typedef void (*secondary_func_t)(void);
 
 struct secondary_data {
+	unsigned long satp;
 	unsigned long stvec;
 	secondary_func_t func;
 } __attribute__((aligned(16)));
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index ed7984e75608..7e4bb5b76903 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -5,9 +5,10 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
-#include <alloc.h>
+#include <alloc_page.h>
 #include <cpumask.h>
 #include <asm/csr.h>
+#include <asm/mmu.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
@@ -23,6 +24,7 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 {
 	struct thread_info *info;
 
+	__mmu_enable(data->satp);
 	thread_info_init();
 	info = current_thread_info();
 	set_cpu_online(info->cpu, true);
@@ -33,10 +35,11 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 
 static void __smp_boot_secondary(int cpu, secondary_func_t func)
 {
-	struct secondary_data *sp = memalign(16, SZ_8K) + SZ_8K - 16;
+	struct secondary_data *sp = alloc_pages(1) + SZ_8K - 16;
 	struct sbiret ret;
 
 	sp -= sizeof(struct secondary_data);
+	sp->satp = csr_read(CSR_SATP);
 	sp->stvec = csr_read(CSR_STVEC);
 	sp->func = func;
 
-- 
2.43.0

