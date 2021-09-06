Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B19C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 04:16:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC84D60F92
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 04:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC84D60F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 396114B267;
	Mon,  6 Sep 2021 00:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BXFyXWyg+F1t; Mon,  6 Sep 2021 00:16:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 081A44B2AD;
	Mon,  6 Sep 2021 00:16:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C4F4B268
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 00:16:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p9cJwvAIQuEJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 00:16:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A875A4B267
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 00:16:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630901766;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=N/7qUCDbLedcIM9wZfeDAGpIH0/Pk2uXbgsdONv5fHc=;
 b=X4xU0ed79XPDFabKxIlChAxbRGPs5xEhOGUj43WAIdTOpgMV8LQObj7hi1VSxvNBecs/t+
 bE4GGVwnA31Osz6/fWhlQ9u0JuZTORJdRuEIObkdgi6W7G2YNY1tQvArq9okl5mF2mbYZN
 VFYZwlm1XOA8tkfemV8+p+wyHDPLl2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-zC5vOcY3PEO1DJZod3-5Rw-1; Mon, 06 Sep 2021 00:16:02 -0400
X-MC-Unique: zC5vOcY3PEO1DJZod3-5Rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8945801A92;
 Mon,  6 Sep 2021 04:16:00 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-40.bne.redhat.com [10.64.54.40])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A56D019C59;
 Mon,  6 Sep 2021 04:15:53 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: devicetree@vger.kernel.org
Subject: [PATCH] Documentation, dt, numa: Add note to empty NUMA node
Date: Mon,  6 Sep 2021 12:14:24 +0800
Message-Id: <20210906041424.115473-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: robh@kernel.org, linux-efi@vger.kernel.org, maz@kernel.org,
 rdunlap@infradead.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The empty memory nodes, where no memory resides in, are allowed.
For these empty memory nodes, the 'len' of 'reg' property is zero.
The NUMA node IDs are still valid and parsed, but memory may be
added to them through hotplug afterwards. Currently, QEMU fails
to boot when multiple empty memory nodes are specified. It's
caused by device-tree population failure and duplicated memory
node names.

As device-tree specification indicates, the 'unit-address' of
these empty memory nodes, part of their names, are the equivalents
to 'base-address'. Unfortunately, I finds difficulty to get where
the assignment of 'base-address' is properly documented for these
empty memory nodes. So lets add a section for empty memory nodes
to cover this in NUMA binding document. The 'unit-address',
equivalent to 'base-address' in the 'reg' property of these empty
memory nodes is specified to be the summation of highest memory
address plus the NUMA node ID.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/devicetree/bindings/numa.txt | 60 +++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/numa.txt b/Documentation/devicetree/bindings/numa.txt
index 21b35053ca5a..82f047bc8dd6 100644
--- a/Documentation/devicetree/bindings/numa.txt
+++ b/Documentation/devicetree/bindings/numa.txt
@@ -103,7 +103,65 @@ Example:
 		};
 
 ==============================================================================
-4 - Example dts
+4 - Empty memory nodes
+==============================================================================
+
+Empty memory nodes, which no memory resides in, are allowed. The 'length'
+field of the 'reg' property is zero. However, the 'base-address' is a
+dummy and invalid address, which is the summation of highest memory address
+plus the NUMA node ID. The NUMA node IDs and distance maps are still valid
+and memory may be added into them through hotplug afterwards.
+
+Example:
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x0 0x0 0x0 0x80000000>;
+		numa-node-id = <0>;
+	};
+
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0x0 0x80000000 0x0 0x80000000>;
+		numa-node-id = <1>;
+	};
+
+	/* Empty memory node */
+	memory@100000002 {
+		device_type = "memory";
+		reg = <0x1 0x2 0x0 0x0>;
+		numa-node-id = <2>;
+	};
+
+	/* Empty memory node */
+	memory@100000003 {
+		device_type = "memory";
+		reg = <0x1 0x3 0x0 0x0>;
+		numa-node-id = <3>;
+	};
+
+	distance-map {
+		compatible = "numa-distance-map-v1";
+		distance-matrix = <0 0  10>,
+				  <0 1  20>,
+				  <0 2  40>,
+				  <0 3  20>,
+				  <1 0  20>,
+				  <1 1  10>,
+				  <1 2  20>,
+				  <1 3  40>,
+				  <2 0  40>,
+				  <2 1  20>,
+				  <2 2  10>,
+				  <2 3  20>,
+				  <3 0  20>,
+				  <3 1  40>,
+				  <3 2  20>,
+				  <3 3  10>;
+	};
+
+==============================================================================
+5 - Example dts
 ==============================================================================
 
 Dual socket system consists of 2 boards connected through ccn bus and
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
