Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0713837167
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ebjUgjXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/Y8e3ElHU0aNJgIxvk1soi56PmSeGH3qsiqyO+Bp04=;
	b=ebjUgjXPYo3xesqev4WKcE78TLhOw8htLyew856GecaC1+Mm7bJBlqBPFP7wWT9bJ79Z4W
	jqd2BPYFp7RqpURmutnQU87jxSP52VJHRtSGcVbb46vVRkDhWxzZTMTNXzk3GxfpUCHxwL
	ag+7ZKDUCXzaBuk0P+lFC365eh48VfQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-VgAp7QJwOV-s3wS_D8LoCw-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: VgAp7QJwOV-s3wS_D8LoCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD719185A780;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D07801C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 09/18] arm/arm64: Zero secondary CPUs' stack
Date: Thu, 30 Nov 2023 04:07:11 -0500
Message-Id: <20231130090722.2897974-10-shahuang@redhat.com>
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

For the boot CPU, the entire stack is zeroed in the entry code. For the
secondaries, only struct thread_info, which lives at the bottom of the
stack, is zeroed in thread_info_init().

Be consistent and zero the entire stack for the secondaries. This should
also improve reproducibility of the testsuite, as all the stacks will start
with the same contents, which is zero. And now that all the stacks are
zeroed in the entry code, there is no need to explicitely zero struct
thread_info in thread_info_init().

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/cstart.S          |  6 ++++++
 arm/cstart64.S        | 11 +++++++----
 lib/arm/processor.c   |  1 -
 lib/arm64/processor.c |  1 -
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index b24ecabc..2ecebd1d 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -151,7 +151,13 @@ secondary_entry:
 	 */
 	ldr	r1, =secondary_data
 	ldr	r0, [r1]
+	mov	r2, r0
+	lsr	r2, #THREAD_SHIFT
+	lsl	r2, #THREAD_SHIFT
+	add	r3, r2, #THREAD_SIZE
+	zero_range r2, r3, r4, r5
 	mov	sp, r0
+
 	bl	exceptions_init
 	bl	enable_vfp
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index a8ad6dc8..5ba2fb27 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -14,10 +14,6 @@
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
 
-#ifdef CONFIG_EFI
-#include "efi/crt0-efi-aarch64.S"
-#else
-
 .macro zero_range, tmp1, tmp2
 9998:	cmp	\tmp1, \tmp2
 	b.eq	9997f
@@ -26,6 +22,10 @@
 9997:
 .endm
 
+#ifdef CONFIG_EFI
+#include "efi/crt0-efi-aarch64.S"
+#else
+
 .section .init
 
 /*
@@ -162,6 +162,9 @@ secondary_entry:
 	/* set the stack */
 	adrp	x0, secondary_data
 	ldr	x0, [x0, :lo12:secondary_data]
+	and	x1, x0, #THREAD_MASK
+	add	x2, x1, #THREAD_SIZE
+	zero_range x1, x2
 	mov	sp, x0
 
 	/* finish init in C code */
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 9d575968..ceff1c0a 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -117,7 +117,6 @@ void do_handle_exception(enum vector v, struct pt_regs *regs)
 
 void thread_info_init(struct thread_info *ti, unsigned int flags)
 {
-	memset(ti, 0, sizeof(struct thread_info));
 	ti->cpu = mpidr_to_cpu(get_mpidr());
 	ti->flags = flags;
 }
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 5bcad679..a8ef8c59 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -233,7 +233,6 @@ void install_vector_handler(enum vector v, vector_fn fn)
 
 static void __thread_info_init(struct thread_info *ti, unsigned int flags)
 {
-	memset(ti, 0, sizeof(struct thread_info));
 	ti->cpu = mpidr_to_cpu(get_mpidr());
 	ti->flags = flags;
 }
-- 
2.40.1

