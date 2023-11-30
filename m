Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53932321B8
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZR/WX8G4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4R+HNRZJiFFN+ip5dfjGVsMX98ycCVsp2Ww3/n0/cY=;
	b=ZR/WX8G4ISgLjMLDOWcYTEzn6L0TbLoy/uKKdGPMu76KWUCXb/u4jw+heZxC0SUDUot9Vc
	0umdqXAm+Ao72cSGRnAW6rFTJbhOzYqU13II5Ekg7YH5tnlbfeRNQzvNo4be2EaVWsIERv
	BEZY81aoad4PQvO4HOPpyDShbdFLZ5o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-Lw33qRLVNbyMgBVMVh1tnw-1; Thu,
 30 Nov 2023 04:07:57 -0500
X-MC-Unique: Lw33qRLVNbyMgBVMVh1tnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D4FA299E759;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00FDB1C060AE;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 10/18] arm/arm64: Allocate secondaries' stack using the page allocator
Date: Thu, 30 Nov 2023 04:07:12 -0500
Message-Id: <20231130090722.2897974-11-shahuang@redhat.com>
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

The vmalloc allocator returns non-id mapped addresses, where the virtual
address is different than the physical address. As a result, it's
impossible to access the stack of the secondary CPUs while the MMU is
disabled (if AUXINFO_MMU_OFF is set, a test disables the MMU or an
exception happens on the secondary before the MMU is enabled).

It turns out that kvm-unit-tests always configures the stack size to be a
power-of-two multiple of PAGE_SIZE: on arm, THREAD_SIZE is 16K and
PAGE_SIZE is 4K; on arm64, THREAD_SIZE is 16K when PAGE_SIZE is 4K or 16K,
and 64K when PAGE_SIZE is 64K. Use memalign_pages_flags() as a drop-in
replacement for vmalloc's vm_memalign(), which is the value for
alloc_ops->memalign when the stack is allocated, as it has the benefits:

1. The secondary CPUs' stack can be used with the MMU off.

2. The secondary CPUs' stack is identity mapped, just like the stack for
the primary CPU, making the configuration of the all the CPUs consistent.

3. start_usr(), which can take a new stack to use at EL0/in user mode, now
works if the function is called after the MMU has been disabled. This
doesn't affect the vectors-user test, as the only way to run the test with
the MMU disabled is by setting AUXINFO_MMU_INFO, in which case the vmalloc
allocator is not initialized and alloc_ops->memalign resolves to
memalign_pages().

memalign_pages_flags() has been used instead of memalign_pages() to
instruct the allocator not to zero the stack, as it's already zeroed in the
entry code.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/thread_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
index eaa72582..190e082c 100644
--- a/lib/arm/asm/thread_info.h
+++ b/lib/arm/asm/thread_info.h
@@ -25,6 +25,7 @@
 #ifndef __ASSEMBLY__
 #include <asm/processor.h>
 #include <alloc.h>
+#include <alloc_page.h>
 
 #ifdef __arm__
 #include <asm/ptrace.h>
@@ -40,7 +41,7 @@
 
 static inline void *thread_stack_alloc(void)
 {
-	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
+	void *sp = memalign_pages_flags(THREAD_ALIGNMENT, THREAD_SIZE, FLAG_DONTZERO);
 	return sp + THREAD_START_SP;
 }
 
-- 
2.40.1

