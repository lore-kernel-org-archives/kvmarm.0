Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEE7C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:42:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1C1C6115C
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 06:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F1C1C6115C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B77649F5D;
	Mon, 27 Sep 2021 02:42:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1fg1s0VBodTK; Mon, 27 Sep 2021 02:42:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F634B091;
	Mon, 27 Sep 2021 02:42:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FB5D49F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:42:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VeCxeU9U-p2s for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 02:42:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 816B34025B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 02:42:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632724948;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=dAcybXZptWhXuaEnwPAcHdlIaUsfWP7DKdFq484lIaw=;
 b=HoLfAWQO3brUazdA4xX5QaFn0j5r1UI8mzf2igb+eNxGNi3x0AzXEpkis09L/i84n2GI3T
 3tS5UUgithY1iA4l/UC1dKdQ1uE+WC6Um70A59YeQmYd+R4Ye49JnE8xG1z0iHWWv+NFJN
 RKwCBEXycXhKFC57VopsBJ04ySx86wg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573--8vK7PZVOGeQzBTMxcruEQ-1; Mon, 27 Sep 2021 02:42:23 -0400
X-MC-Unique: -8vK7PZVOGeQzBTMxcruEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ABE91006AA3;
 Mon, 27 Sep 2021 06:42:22 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BEA160936;
 Mon, 27 Sep 2021 06:42:16 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: devicetree@vger.kernel.org
Subject: [PATCH v2 0/2] Specify empty NUMA node
Date: Mon, 27 Sep 2021 14:41:17 +0800
Message-Id: <20210927064119.127285-1-gshan@redhat.com>
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

There are multiple empty nodes, where no memory resides in, are allowed
in virtual machine (VM) backed by QEMU. I don't find anywhere to document
how the corresponding device nodes are populated. This series adds one
section in Documentation/devicetree/bindings/numa.txt to document how
the empty NUMA nodes are handled: no device nodes are existing for these
empty NUMA nodes, but the NUMA IDs and distance map are still valid in
"numa-distance-map-v1" compatible device node.

PATCH[1] adds one section in Documentation/devicetree/bindings/numa.txt
         to specify how device nodes are populated for these empty NUMA
         nodes.
PATCH[2] fetches NUMA IDs and distance maps from "numa-distance-map-v1"
         compatible device node.

Changelog
=========
   * No device nodes for empty NUMA nodes                     (Rob)
   * Add patch to fetch NUMA IDs and distance map from the
     "numa-distance-map-v1" compatible device node            (Rob)

Gavin Shan (2):
  Documentation, dt, numa: Add note to empty NUMA node
  of, numa: Fetch empty NUMA node ID from distance map

 Documentation/devicetree/bindings/numa.txt | 46 +++++++++++++++++++++-
 drivers/of/of_numa.c                       |  2 +
 2 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
