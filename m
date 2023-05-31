Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C343C0A8
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685564096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+0lJgJTfsrQmsUY4kO4c0whWsHymbAlubhm8+JrK9U=;
	b=aUcRZTfg35W8Ex8k+y7EdM+TTR/LRZda+R2+uGUPsTUP0fWE9kim3ewmLl/3yVPghkjP5f
	uyM23cQMOz7ksfVoAfF4KKVt7qpZBKpeQMIQZCaawCHVFLfUmERDw2tyyyh5Ls/djgnOPZ
	XJJ8pdrPfw0R2Kpx2rW0X5xOYfNFDqc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-Z3mxBfccNQKpd3mBRjsTiw-1; Wed, 31 May 2023 16:14:51 -0400
X-MC-Unique: Z3mxBfccNQKpd3mBRjsTiw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B38CF185A78E;
	Wed, 31 May 2023 20:14:50 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CF08407DEC0;
	Wed, 31 May 2023 20:14:48 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	ricarkol@google.com,
	reijiw@google.com,
	alexandru.elisei@arm.com
Cc: mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 3/6] arm: pmu: Add extra DSB barriers in the mem_access loop
Date: Wed, 31 May 2023 22:14:35 +0200
Message-Id: <20230531201438.3881600-4-eric.auger@redhat.com>
In-Reply-To: <20230531201438.3881600-1-eric.auger@redhat.com>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

The mem access loop currently features ISB barriers only. However
the mem_access loop counts the number of accesses to memory. ISB
do not garantee the PE cannot reorder memory access. Let's
add a DSB ISH before the write to PMCR_EL0 that enables the PMU
to make sure any previous memory access aren't counted in the
loop, another one after the PMU gets enabled (to make sure loop
memory accesses cannot be reordered before the PMU gets enabled)
and a last one after the last iteration, before disabling the PMU.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>

---

v1 -> v2:
- added yet another DSB after PMU enabled as suggested by Alexandru

This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
---
 arm/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 51c0fe80..74dd4c10 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -301,13 +301,16 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
 {
 	uint64_t pmcr64 = pmcr;
 asm volatile(
+	"       dsb     ish\n"
 	"       msr     pmcr_el0, %[pmcr]\n"
 	"       isb\n"
+	"       dsb     ish\n"
 	"       mov     x10, %[loop]\n"
 	"1:     sub     x10, x10, #1\n"
 	"       ldr	x9, [%[addr]]\n"
 	"       cmp     x10, #0x0\n"
 	"       b.gt    1b\n"
+	"       dsb     ish\n"
 	"       msr     pmcr_el0, xzr\n"
 	"       isb\n"
 	:
-- 
2.38.1

