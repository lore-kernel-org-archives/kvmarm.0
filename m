Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5463358A9
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBMaz2Bj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHFy7l3/5ZTvD59ydZrD2IN8QQe0B4M21kQ4dHgfeYA=;
	b=SBMaz2Bj0+b8fu7uzN1NUrcWZIkBSb+boI7cXeNxTbJ3/NLWyP3uyGcE4uWg8lyNMLhqGx
	X9+GIPQmTrdxb/+MPJZqnKjYEqJqby0CcK4SHlZdEfRMbjioGKv7cmXOIeZ843yYn+aAOx
	bi8tZkzANF4+dgyum0PEJLwA2M283Y4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-xgrAwIs7NQa1BlbkXanrcA-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: xgrAwIs7NQa1BlbkXanrcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCD3F82A621;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6D931C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 08/18] lib/alloc_phys: Expand documentation with usage and limitations
Date: Thu, 30 Nov 2023 04:07:10 -0500
Message-Id: <20231130090722.2897974-9-shahuang@redhat.com>
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

The physical allocator has gotten simpler, document its limitations and
current/expected usage.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 86b3d021..861959cf 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -4,10 +4,17 @@
  * phys_alloc is a very simple allocator which allows physical memory
  * to be partitioned into regions until all memory is allocated.
  *
- * Note: This is such a simple allocator that there is no way to free
- * a region. For more complicated memory management a single region
- * can be allocated, but then have its memory managed by a more
- * sophisticated allocator, e.g. a page allocator.
+ * Note: This is such a simple allocator that there is no way to free a
+ * region, and concurrent allocations are not supported. As such, it is
+ * mostly suitable for the architecture setup code, and less so for
+ * allocating memory in a test. For more complicated memory management a
+ * single region can be allocated (or the entire free memory), but then
+ * have that memory managed by a more sophisticated allocator, e.g. the
+ * page or the vmalloc allocators.
+ *
+ * Because of its simplicity, phys_alloc can easily perform cache
+ * maintenance on the state tracking variables it maintains, making it
+ * suitable for architectures which require such operations.
  *
  * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
-- 
2.40.1

