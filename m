Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94366ED3
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 03:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677726169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6kZFiug5mIRB7tAkTIUwsKmYbfqvTxNd2xDpOYGIXL0=;
	b=ZRw7TYmiHgczm+dnG1hWtkECihscjCXqbzr348+b/ufwgGw+vxfnKKTm2MSo/Zxz9FTZGt
	MSN62gGmIGhxRadIiX93UHLKDEBhLXTIbVZQ+GJstXTIA6667joB3T4brYi+HR7Er7vCzD
	/5pm1i0rzIMawauP30kqT3c7RfOEd+M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-ovs6SDUBP0usNKu_LA2C6A-1; Wed, 01 Mar 2023 22:02:46 -0500
X-MC-Unique: ovs6SDUBP0usNKu_LA2C6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E843B802D38;
	Thu,  2 Mar 2023 03:02:45 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8B922026D4B;
	Thu,  2 Mar 2023 03:02:45 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org (open list:ARM)
Subject: [RESEND kvm-unit-tests 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date: Wed,  1 Mar 2023 22:02:34 -0500
Message-Id: <20230302030238.158796-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4

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

