Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E5A1EA7FD
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 04:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741667865; cv=none; b=LCdIEf8vnVox9ueDn4WIYUjfQDqNvopFCyLWNw4K6Vg7t/HpaU688bylHw4Y1nWbatWd4GU5i4Bco+mIomkSQXsCS70ZwNIQ15UydntWqpqwGy/W6zmzuEqoUrVYLMHwfNS6OSi4E/TfnsCmaHXdg9KdjlSebln3MFt2dyiD4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741667865; c=relaxed/simple;
	bh=aKA9Axa8VhqTEUp5a80GIDVix3dJYAKKv69mDhaD8Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QH3P9KXviII9ugTbqWL6nB4c0BEuouma3vLYU3jfpN8GdvspMMmcPPf4lJSSm+XBU6AEp/JZ9l4+yyZE2o58HP/4Y3TXiAGaBwU5x11Xh3f9YwbMqA9f5xC5J7Irk9OenS/DWER0IMkJtfOOweRrPV0P48c531v27QLhiflwrww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iDL8jS7t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iDL8jS7t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741667862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jp+CLm+182YvIt4B09+/Rre5LjSBYKWjXMYkkY1eENo=;
	b=iDL8jS7tEf9mcaWbPK1jbWy2ODjQ+KdUjDy5cmASY/ynSnDp8Vn4D7Yxj1OInqULQIBvYc
	SIqKhY/w14PVwBbHdYOGQcU2O+H/OqzNG1gXXqRcsLFC1kNDfI9jp5YVw3/3TvDd9YuMUp
	mw2mGelJAwdRpWDBoYh9RFfJT/NQy/0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-rppQY3LgOnyGAPoEZaPR1A-1; Tue,
 11 Mar 2025 00:37:36 -0400
X-MC-Unique: rppQY3LgOnyGAPoEZaPR1A-1
X-Mimecast-MFC-AGG-ID: rppQY3LgOnyGAPoEZaPR1A_1741667855
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A74C5180035C;
	Tue, 11 Mar 2025 04:37:33 +0000 (UTC)
Received: from gshan-thinkpadx1nanogen2.remote.csb (unknown [10.64.136.79])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4628C1956094;
	Tue, 11 Mar 2025 04:37:25 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	qperret@google.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shan.gavin@gmail.com
Subject: [PATCH] KVM: arm64: Drop sort_memblock_regions()
Date: Tue, 11 Mar 2025 14:37:18 +1000
Message-ID: <20250311043718.91004-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Drop sort_memblock_regions() and avoid sorting the copied memory
regions to be ascending order on their base addresses, because the
source memory regions should have been sorted correctly when they
are added by memblock_add() or its variants.

This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
the hypervisor memblocks"). No functional changes intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/pkvm.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 930b677eb9b0..d9c9174f89a1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -10,7 +10,6 @@
 #include <asm/kvm_mmu.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
-#include <linux/sort.h>
 
 #include <asm/kvm_pkvm.h>
 
@@ -24,23 +23,6 @@ static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
 phys_addr_t hyp_mem_base;
 phys_addr_t hyp_mem_size;
 
-static int cmp_hyp_memblock(const void *p1, const void *p2)
-{
-	const struct memblock_region *r1 = p1;
-	const struct memblock_region *r2 = p2;
-
-	return r1->base < r2->base ? -1 : (r1->base > r2->base);
-}
-
-static void __init sort_memblock_regions(void)
-{
-	sort(hyp_memory,
-	     *hyp_memblock_nr_ptr,
-	     sizeof(struct memblock_region),
-	     cmp_hyp_memblock,
-	     NULL);
-}
-
 static int __init register_memblock_regions(void)
 {
 	struct memblock_region *reg;
@@ -52,7 +34,6 @@ static int __init register_memblock_regions(void)
 		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
 		(*hyp_memblock_nr_ptr)++;
 	}
-	sort_memblock_regions();
 
 	return 0;
 }
-- 
2.48.1

