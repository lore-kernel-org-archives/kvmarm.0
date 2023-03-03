Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80D71847
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 03:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677813151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FiupvBOuHnGQK0RaEyi5knTEXOR0PIgcsQZyDNSQCSI=;
	b=JgCiPL1C/wi85pTmyF9WcNnrKGa+Je5bQzGOzYF7eeFNUCXok/mQT742QXgF//7o8SgRlP
	YtP2Hg/Y7wvqauAxgDa5WBrLqnVqUDeLvGWzHBCYCMpAPLsHvGEce/OAQgM7fToCQdgGh4
	YUnCFS18H6slrHACkGr8ilYyL1QKOwk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-vLVb0atUMXm6CBLprAu35g-1; Thu, 02 Mar 2023 22:12:28 -0500
X-MC-Unique: vLVb0atUMXm6CBLprAu35g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4A3585A5A3;
	Fri,  3 Mar 2023 03:12:27 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8CBF492B00;
	Fri,  3 Mar 2023 03:12:27 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v3 1/3] arm: gic: Write one bit per time in gic_irq_set_clr_enable()
Date: Thu,  2 Mar 2023 22:11:45 -0500
Message-Id: <20230303031148.162816-2-shahuang@redhat.com>
In-Reply-To: <20230303031148.162816-1-shahuang@redhat.com>
References: <20230303031148.162816-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

When use gic_irq_set_clr_enable() to disable an interrupt, it will
disable all interrupt since it first read from Interrupt Clear-Enable
Registers where '1' indicates that forwarding of the corresponding
interrupt is enabled and then write this value with a mask into
Interrupt Clear-Enable Registers where '1' indicates disable the
forwarding of the corresponding interrupt.

So directly write one bit per time to enable or disable interrupt.

Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/gic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 1bfcfcf..89a15fe 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -176,7 +176,6 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
 void gic_irq_set_clr_enable(int irq, bool enable)
 {
 	u32 offset, split = 32, shift = (irq % 32);
-	u32 reg, mask = BIT(shift);
 	void *base;
 
 	assert(irq < 1020);
@@ -199,8 +198,7 @@ void gic_irq_set_clr_enable(int irq, bool enable)
 		assert(0);
 	}
 	base += offset + (irq / split) * 4;
-	reg = readl(base);
-	writel(reg | mask, base);
+	writel(BIT(shift), base);
 }
 
 enum gic_irq_state gic_irq_state(int irq)
-- 
2.39.1

