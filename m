Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9039136B1B
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNQ1C4Rj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=daF1W+qFDy7SQgpx9k6RPP0gYXImFe7hYdM1W8I2WsQ=;
	b=jNQ1C4RjBDSUuc23ew+FzYFMU07lyGbjLDD+AOVCIVvdXEtsdtMvjIhunxDaIt1ygBvgiS
	scwUUWPunPZAFkhSk6tmDbr/m4r59jSXXyzhWU9lhBnCCVjVH0eX5y8qw51aFH3p91rRhb
	9RCmaIgxl4IljHklyQa8cyags5R4vsY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-KVrDTyZIP1-0DUE33u_niA-1; Thu, 30 Nov 2023 04:07:56 -0500
X-MC-Unique: KVrDTyZIP1-0DUE33u_niA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 172C3185A785;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F4DA1C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 03/18] lib/alloc_phys: Initialize align_min
Date: Thu, 30 Nov 2023 04:07:05 -0500
Message-Id: <20231130090722.2897974-4-shahuang@redhat.com>
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

Commit 11c4715fbf87 ("alloc: implement free") changed align_min from a
static variable to a field for the alloc_ops struct and carried over the
initializer value of DEFAULT_MINIMUM_ALIGNMENT.

Commit 7e3e823b78c0 ("lib/alloc.h: remove align_min from struct alloc_ops")
removed the align_min field and changed it back to a static variable, but
missed initializing it. Change it back to being initialized with the value
DEFAULT_MINIMUM_ALIGNMENT.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 7 +++----
 lib/alloc_phys.h | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index a4d2bf23..3a78d0ac 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -13,8 +13,6 @@
 
 #define PHYS_ALLOC_NR_REGIONS	256
 
-#define DEFAULT_MINIMUM_ALIGNMENT	32
-
 struct phys_alloc_region {
 	phys_addr_t base;
 	phys_addr_t size;
@@ -26,12 +24,13 @@ static int nr_regions;
 static struct spinlock lock;
 static phys_addr_t base, top;
 
+#define DEFAULT_MINIMUM_ALIGNMENT	32
+static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
+
 static void *early_memalign(size_t alignment, size_t size);
 static struct alloc_ops early_alloc_ops = {
 	.memalign = early_memalign,
 };
-static size_t align_min;
-
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
 void phys_alloc_show(void)
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 611aa70d..8049c340 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,8 +15,6 @@
  */
 #include "libcflat.h"
 
-#define DEFAULT_MINIMUM_ALIGNMENT 32
-
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
-- 
2.40.1

