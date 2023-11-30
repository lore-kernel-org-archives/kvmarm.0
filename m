Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21633715C
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6+B48fk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3NVP4k3DW8b+TT7nW3nBKoNYoxz8meflEmGy5APB9fM=;
	b=H6+B48fk9j9q6IzmScrSQzhB3d6dKvKzv/rE+lKlpaiOEapjVVXqRuRqCBDg9hTvVwTugF
	KRm//VdoxtthWXWC1Ax85BSbj7wPxaT8pGp6cPzEU6P9sUlCVsBEntrOep06C5b0TSNun8
	zTexRO9D4F2hAf2S9pRjdhngMV07HYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-oc5npyueMwqcjqg5hfodpA-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: oc5npyueMwqcjqg5hfodpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EE6B101A52D;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 986011C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 07/18] lib/alloc_phys: Add callback to perform cache maintenance
Date: Thu, 30 Nov 2023 04:07:09 -0500
Message-Id: <20231130090722.2897974-8-shahuang@redhat.com>
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

Some architectures, like arm and arm64, require explicit cache maintenance
to maintain the caches in sync with memory when toggling the caches. Add
the function to do the required maintenance on the internal structures that
the allocator maintains.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 8 ++++++++
 lib/alloc_phys.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index c96bcb48..5d5487f2 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -45,6 +45,14 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 	align_min = align;
 }
 
+void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn)
+{
+	maint_fn((unsigned long)&base);
+	maint_fn((unsigned long)&used);
+	maint_fn((unsigned long)&top);
+	maint_fn((unsigned long)&align_min);
+}
+
 static void *memalign_early(size_t alignment, size_t sz)
 {
 	phys_addr_t align = (phys_addr_t)alignment;
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 4d350f01..86b3d021 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,6 +15,8 @@
  */
 #include "libcflat.h"
 
+typedef void (*cache_maint_fn)(unsigned long addr);
+
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
@@ -27,6 +29,12 @@ extern void phys_alloc_init(phys_addr_t base, phys_addr_t size);
  */
 extern void phys_alloc_set_minimum_alignment(phys_addr_t align);
 
+/*
+ * Perform cache maintenance on the internal structures that the physical
+ * allocator maintains.
+ */
+extern void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn);
+
 /*
  * phys_alloc_show outputs all currently allocated regions with the
  * following format, where <end_addr> is non-inclusive:
-- 
2.40.1

