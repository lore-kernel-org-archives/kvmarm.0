Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4973D23D5
	for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 03:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676346315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3AIpnqpvUD6jq2TBiR4c/9rNmsRY6g7mIfXM/n0+slQ=;
	b=SC2ipuiKHVVlIS5/9ev1x1y+wHj+L3MG9T7cvKj7IF/MMNFx4CfxkWu60lGqKTOfVuB2b1
	5c/SjGGBdnWDZf0J0ucZ01X773E3lbaEFlcn65WBqKHXtGcRQuvupfF9Pj/GgZi94uo+7d
	fY5kgogvGp9TdVwwFm0ROL8CDwkpQTw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-W6oFm3vQNy2SJHawQnV8CQ-1; Mon, 13 Feb 2023 22:45:11 -0500
X-MC-Unique: W6oFm3vQNy2SJHawQnV8CQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 675303810789;
	Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A1EEC16022;
	Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
From: shahuang@redhat.com
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests 1/3] arm: gic: Write one bit per time in gic_irq_set_clr_enable()
Date: Mon, 13 Feb 2023 22:44:51 -0500
Message-Id: <20230214034453.148494-2-shahuang@redhat.com>
In-Reply-To: <20230214034453.148494-1-shahuang@redhat.com>
References: <20230214034453.148494-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8

From: Shaoqin Huang <shahuang@redhat.com>

When use gic_irq_set_clr_enable() to disable an interrupt, it will
disable all interrupt since it first read from Interrupt Clear-Enable
Registers and then write this value with a mask back.

So diretly write one bit per time to enable or disable interrupt.

Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
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

