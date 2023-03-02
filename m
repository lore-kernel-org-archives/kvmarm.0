Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1205381
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 12:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677759059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CMgUDFG9sXPdMEH9xgulkf4eeUNkbssVC3IJ2/A7V+Y=;
	b=ZO+x3l7bB7imm2TFockDYxlJ7RrawdPH3UbU/2FwXdr8NVIObo82xWaAii/ZXfyW+EsAHy
	pcLNFgDFTSVu92IgLE0iJ5++UhkLRkApoDM5Tw5Z5BEvc31AW+wCjjvW0H9COiulsLo2Km
	kpAOYEkCAVP5KW/Rc91avP3SsSvjQAU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-CQZlb6vzO-WO7sMOVpkPmg-1; Thu, 02 Mar 2023 07:10:58 -0500
X-MC-Unique: CQZlb6vzO-WO7sMOVpkPmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C777485A5B1
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 12:10:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C28D82026D4B;
	Thu,  2 Mar 2023 12:10:57 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date: Thu,  2 Mar 2023 07:10:46 -0500
Message-Id: <20230302121049.160466-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Some tests still use their own code to enable/disable irq, use
gic_enable/disable_irq() to clean up them.

The first patch fixes a problem which will disable all irq when use
gic_disable_irq().

The patch 2-3 clean up the code by using the macro.

Changelog:
----------
v2:
  - tweak the comments in patch 1. (Eric)
  - Reviewed by Eric.

Shaoqin Huang (3):
  arm: gic: Write one bit per time in gic_irq_set_clr_enable()
  arm64: timer: Use gic_enable/disable_irq() macro in timer test
  arm64: microbench: Use gic_enable_irq() macro in microbench test

 arm/micro-bench.c | 15 +--------------
 arm/timer.c       | 20 +++-----------------
 lib/arm/gic.c     |  4 +---
 3 files changed, 5 insertions(+), 34 deletions(-)

-- 
2.39.1

