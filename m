Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBA2C43217
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:42:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 050306113D
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 050306113D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDFB4B0D7;
	Mon, 27 Sep 2021 02:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SlUTUVcOILVi; Mon, 27 Sep 2021 02:42:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D3F4A1B0;
	Mon, 27 Sep 2021 02:42:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F4094B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SAvzyESfpukr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 02:42:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 806EC4B0DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:42:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632724952;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dgUQa1q2yVLHuH43oDCQpdzXKKAxjWaL6vBqtSCv00M=;
 b=aseZ2k5tgTcAZc0QSA2kiugIe3aVZJ80x042v8OjqIUJoMO91fg7WeANfrfXZQ2DW2P4tl
 /j5CxH5Bsgc98OgTqRyA3cVJn+vRV1NAE7R/wsVKOLZxxpUmxSkaGSEnCEmwJW+kY+IDJK
 /aKZRo+zGneFozKghRh5SVKu/dW0Br8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-Up7L8uypM4ConrfU_bs3rA-1; Mon, 27 Sep 2021 02:42:28 -0400
X-MC-Unique: Up7L8uypM4ConrfU_bs3rA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 977BC1966320;
 Mon, 27 Sep 2021 06:42:26 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9527560936;
 Mon, 27 Sep 2021 06:42:22 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: devicetree@vger.kernel.org
Subject: [PATCH v2 1/2] Documentation, dt, numa: Add note to empty NUMA node
Date: Mon, 27 Sep 2021 14:41:18 +0800
Message-Id: <20210927064119.127285-2-gshan@redhat.com>
In-Reply-To: <20210927064119.127285-1-gshan@redhat.com>
References: <20210927064119.127285-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
The NUMA node IDs are still valid and parsed, but memory may be
added to them through hotplug afterwards. Currently, QEMU fails
to boot when multiple empty memory nodes are specified. It's
caused by device-tree population failure and duplicated memory
node names.

The device-tree specification doesn't provide how empty NUMA
nodes are handled. Besides, I finds difficulty to get where
this case is documented. So lets add a section for empty memory
nodes to cover it in NUMA binding document.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/devicetree/bindings/numa.txt | 46 +++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/numa.txt b/Documentation/devicetree/bindings/numa.txt
index 21b35053ca5a..42f282c2f3cc 100644
--- a/Documentation/devicetree/bindings/numa.txt
+++ b/Documentation/devicetree/bindings/numa.txt
@@ -103,7 +103,51 @@ Example:
 		};
 
 ==============================================================================
-4 - Example dts
+4 - Empty memory nodes
+==============================================================================
+
+Empty memory nodes, which no memory resides in, are allowed. There are no
+device nodes for these empty memory nodes. However, the NUMA node IDs and
+distance maps are still valid and memory may be added into them through
+hotplug afterwards.
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
+	/* Empty memory node 2 and 3 */
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
