Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11003224D7
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPr+1hPv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699897410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuZQTH8ou4sne3XAujNeANupGE25O7xRLkTjiVZncBU=;
	b=NPr+1hPvijKYYS6XTPp4BzkogNcKQDIvqHmBuXBcsS/6i/+IM311/z1SnOi+/4D0Cz5z4b
	1ez0KK1rJZrQ5yni4n/gxAMGvnL7qyoxIhGwUPloyMU5Lg3E6b40bCNZAQGGeqaV2kv6BM
	SViHK0JVMMG20YnB+D+TCJrHK94dNaQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-BoT0NtqyMqWf-FaRVVu0qw-1; Mon, 13 Nov 2023 12:43:29 -0500
X-MC-Unique: BoT0NtqyMqWf-FaRVVu0qw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20909811E82;
	Mon, 13 Nov 2023 17:43:29 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.115])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B5161121306;
	Mon, 13 Nov 2023 17:43:27 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	oliver.upton@linux.dev,
	alexandru.elisei@arm.com
Cc: jarichte@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/2] arm: pmu: Declare pmu_stats as volatile
Date: Mon, 13 Nov 2023 18:42:40 +0100
Message-ID: <20231113174316.341630-2-eric.auger@redhat.com>
In-Reply-To: <20231113174316.341630-1-eric.auger@redhat.com>
References: <20231113174316.341630-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Declare pmu_stats as volatile in order to prevent the compiler
from caching previously read values. This actually fixes
pmu-overflow-interrupt failures on some HW.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a91a7b1f..86199577 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -328,7 +328,7 @@ asm volatile(
 	: "x9", "x10", "cc");
 }
 
-static struct pmu_stats pmu_stats;
+static volatile struct pmu_stats pmu_stats;
 
 static void irq_handler(struct pt_regs *regs)
 {
-- 
2.41.0

