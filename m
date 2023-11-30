Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BB4134C3
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzRja0BK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr/7wVzkmltnw1sRFdNXHtv+81MR3WwvKLkyr4K5qvo=;
	b=RzRja0BKxy15ByQJFe+LUIwskQM2Xxz+3nuZHX9PkzjZInggNMs1c0bEQTfvLPCb6z3sQd
	Ukk+UPYawMvBSiBvgYLATeYTdS3zSLtAJj8YRIVyHbuLdSSjmO34+0mpD4xaRTb4L5pm84
	GmazjSpzo8rz1oG3PqwuL+/PuZXvD60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-WyDj6E47NqSZKMlXa4T8fg-1; Thu, 30 Nov 2023 04:07:58 -0500
X-MC-Unique: WyDj6E47NqSZKMlXa4T8fg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A26FD84ACAF;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9341B1C060AE;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 13/18] arm/arm64: Configure secondaries' stack before enabling the MMU
Date: Thu, 30 Nov 2023 04:07:15 -0500
Message-Id: <20231130090722.2897974-14-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

Now that the secondaries' stack is linearly mapped, we can set it before
turning the MMU on. This makes the entry code for the secondaries
consistent with the entry code for the boot CPU.

secondary_data is written by the CPU that brings the secondary online with
the MMU enabled in the common case (that is, unless the user specifically
compiled the tests to run with the MMU disabled), and now it is read by the
secondary with the MMU disabled. Data is fetched from PoC by the secondary
when the MMU is disabled, clean struct secondary_data to PoC to handle
this.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S   | 20 ++++++++++----------
 arm/cstart64.S | 16 ++++++++--------
 lib/arm/smp.c  |  5 +++++
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 98d61230..090cf38d 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -134,16 +134,6 @@ get_mmu_off:
 
 .global secondary_entry
 secondary_entry:
-	/* enable the MMU unless requested off */
-	bl	get_mmu_off
-	cmp	r0, #0
-	bne	1f
-	mov	r1, #0
-	ldr	r0, =mmu_idmap
-	ldr	r0, [r0]
-	bl	asm_mmu_enable
-
-1:
 	/*
 	 * Set the stack, and set up vector table
 	 * and exception stacks. Exception stacks
@@ -161,6 +151,16 @@ secondary_entry:
 	bl	exceptions_init
 	bl	enable_vfp
 
+	/* enable the MMU unless requested off */
+	bl	get_mmu_off
+	cmp	r0, #0
+	bne	1f
+	mov	r1, #0
+	ldr	r0, =mmu_idmap
+	ldr	r0, [r0]
+	bl	asm_mmu_enable
+
+1:
 	/* finish init in C code */
 	bl	secondary_cinit
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 7fb44f42..b9784d82 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -144,6 +144,14 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	/* set the stack */
+	adrp	x0, secondary_data
+	ldr	x0, [x0, :lo12:secondary_data]
+	and	x1, x0, #THREAD_MASK
+	add	x2, x1, #THREAD_SIZE
+	zero_range x1, x2
+	mov	sp, x0
+
 	/* Enable FP/ASIMD */
 	mov	x0, #(3 << 20)
 	msr	cpacr_el1, x0
@@ -159,14 +167,6 @@ secondary_entry:
 	bl	asm_mmu_enable
 
 1:
-	/* set the stack */
-	adrp	x0, secondary_data
-	ldr	x0, [x0, :lo12:secondary_data]
-	and	x1, x0, #THREAD_MASK
-	add	x2, x1, #THREAD_SIZE
-	zero_range x1, x2
-	mov	sp, x0
-
 	/* finish init in C code */
 	bl	secondary_cinit
 
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 1d470d1a..c9b247a8 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -7,6 +7,8 @@
  */
 #include <libcflat.h>
 #include <auxinfo.h>
+
+#include <asm/cacheflush.h>
 #include <asm/thread_info.h>
 #include <asm/spinlock.h>
 #include <asm/cpumask.h>
@@ -60,6 +62,9 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
 
 	secondary_data.stack = thread_stack_alloc();
 	secondary_data.entry = entry;
+	dcache_clean_poc((unsigned long)&secondary_data,
+			 (unsigned long)&secondary_data + sizeof(secondary_data));
+
 	mmu_mark_disabled(cpu);
 	ret = cpu_psci_cpu_boot(cpu);
 	assert(ret == 0);
-- 
2.40.1

