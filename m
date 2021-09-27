Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE75C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:42:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F096611AF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F096611AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55274A1B0;
	Mon, 27 Sep 2021 02:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y8LdqvlpImrI; Mon, 27 Sep 2021 02:42:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5AE4B08A;
	Mon, 27 Sep 2021 02:42:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 769574025B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:42:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJh2YUmlL+GV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 02:42:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8624A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:42:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632724957;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=A7XJHc0p1FnNm1Yats8TDvDF65ghYHfrSmniJKe3ULQ=;
 b=cKVgivoHRsvbr7xNufHfrbmieP7Uf7mHOSqf2UVpN1k9VoNlgHHX7UeWD3un8jIjiR5GEY
 gpuq3TN8Ba/ryZK4B8NnlsMRSOuNHJtnGJkO4pHV7KWHY1yP7pdx4Bp5Y1XLWlPq9GHEf9
 v2cAnuhtzJshzJImY4S1MoeEMdDE1Kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-T6Ky4i-5M0mFA2scRJonRQ-1; Mon, 27 Sep 2021 02:42:33 -0400
X-MC-Unique: T6Ky4i-5M0mFA2scRJonRQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 698F3802935;
 Mon, 27 Sep 2021 06:42:31 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3499960936;
 Mon, 27 Sep 2021 06:42:26 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: devicetree@vger.kernel.org
Subject: [PATCH v2 2/2] of, numa: Fetch empty NUMA node ID from distance map
Date: Mon, 27 Sep 2021 14:41:19 +0800
Message-Id: <20210927064119.127285-3-gshan@redhat.com>
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

There is no device node for the empty NUMA node. However, the
corresponding NUMA node ID and distance map is still valid in
"numa-distance-map-v1" compatible device node.

This fetches the NUMA node ID and distance map for these empty
NUMA node from "numa-distance-map-v1" compatible device node.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 drivers/of/of_numa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
index fe6b13608e51..5949829a1b00 100644
--- a/drivers/of/of_numa.c
+++ b/drivers/of/of_numa.c
@@ -111,6 +111,8 @@ static int __init of_numa_parse_distance_map_v1(struct device_node *map)
 			return -EINVAL;
 		}
 
+		node_set(nodea, numa_nodes_parsed);
+
 		numa_set_distance(nodea, nodeb, distance);
 
 		/* Set default distance of node B->A same as A->B */
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
