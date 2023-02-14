Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE923D5
	for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 03:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676346322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T3RTShQ549nS3MCyK+d3Glymy/QK2/1R23bUV/FnFH8=;
	b=RYViiMLf0KAjA93K0Ul8UIVKJRqkSc9iJg0Gbtq5ngsGcaZRaif+KjzbVt3Uw/5qG68ar7
	IiIb30Cunvu+PiO3N4oYcMtqIq37i625WdGFYnqxeRLkQ5b2x+yVUbB5/LXhaVsGjJSlVi
	hA7wd+IS8P+LujIrfKCHdJRM6XKHr6w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-M1hFsxafMBq6KFp5tGyM0A-1; Mon, 13 Feb 2023 22:45:11 -0500
X-MC-Unique: M1hFsxafMBq6KFp5tGyM0A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4630985CBE5;
	Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2EDDCC16022;
	Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
From: shahuang@redhat.com
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <drjones@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date: Mon, 13 Feb 2023 22:44:50 -0500
Message-Id: <20230214034453.148494-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8

From: Shaoqin Huang <shahuang@redhat.com>

Some tests still use their own code to enable/disable irq, use
gic_enable/disable_irq() to clean up them.

The first patch fixes a problem which will disable all irq when use
gic_disable_irq().

The patch 2-3 clean up the code by using the macro.

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

