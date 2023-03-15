Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD6C3C02
	for <kvmarm@lists.linux.dev>; Wed, 15 Mar 2023 11:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678878472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pw5und1amevi6fGrmvoVmaGCPWmitHsfJCR1o0JTYMk=;
	b=DE4sRemLD5h8HE4mQOZyG1yJa1mc12umNkaK8yMk3xWouRvQ2hms1RdZOqwm57yEGVCKfc
	oko2Ob0dixYB/dlwouFwjjqjiYLllinWisSqgBSaaNheSqmaMBWK3yagGy2PowfM6o38HH
	RVkVheQHOoW8rPMv2ZRh5pgJp/xOrgo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-BLTLcpIFNVygVpIQ8I_qgg-1; Wed, 15 Mar 2023 07:07:48 -0400
X-MC-Unique: BLTLcpIFNVygVpIQ8I_qgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C01A5382C970;
	Wed, 15 Mar 2023 11:07:47 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.134])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BBA2B202701E;
	Wed, 15 Mar 2023 11:07:45 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH 6/6] arm: pmu-chain-promotion: Increase the count and margin values
Date: Wed, 15 Mar 2023 12:07:25 +0100
Message-Id: <20230315110725.1215523-7-eric.auger@redhat.com>
In-Reply-To: <20230315110725.1215523-1-eric.auger@redhat.com>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4

Let's increase the mem_access loop count by defining COUNT=250
(instead of 20) and define a more reasonable margin (100 instead
of 15 previously) so that it gives better chance to accommodate
for HW implementation variance. Those values were chosen arbitrarily
higher. Those values fix the random failures on ThunderX2 machines.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index c3d2a428..d897d8d3 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -60,8 +60,8 @@
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
-#define COUNT 20
-#define MARGIN 15
+#define COUNT 250
+#define MARGIN 100
 /*
  * PRE_OVERFLOW2 is set so that 1st COUNT iterations do not
  * produce 32b overflow and 2d COUNT iterations do. To accommodate
-- 
2.38.1

