Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1771847
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 03:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677813153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IO1gpQ6okMjDRZ9SmWpM9jmX/gPcR4kBaLTqXQqGADg=;
	b=Wl6Tn6coz6Vbm+PTnuRrClR5z6/8STSKMY8MGvBGfgiyhqhR45DVvHF+ri/V/2zn0mB7Q7
	OgbNprqguKCvaM+knLylCg4vu3iMVIHUB5OaC5ECjFtFKtbCx8ixwZ3SGxSNcepQPH+Lt0
	Iu3jPFBl9ZbMgzyt0LpZvS03//CzwM8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-PbniyvcsO82z3qx0h8TcAg-1; Thu, 02 Mar 2023 22:12:28 -0500
X-MC-Unique: PbniyvcsO82z3qx0h8TcAg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7F761871D94;
	Fri,  3 Mar 2023 03:12:27 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B343E492C3E;
	Fri,  3 Mar 2023 03:12:27 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v3 0/3] arm: Use gic_enable/disable_irq() macro to clean up code 
Date: Thu,  2 Mar 2023 22:11:44 -0500
Message-Id: <20230303031148.162816-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

Some tests still use their own code to enable/disable irq, use
gic_enable/disable_irq() to clean up them.

The first patch fixes a problem which will disable all irq when use
gic_disable_irq().

The patch 2-3 clean up the code by using the macro.

Changelog:
----------
v3:
  - s/diretly/directly.
  - Refer Gic Spec to make comments more clear.
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

