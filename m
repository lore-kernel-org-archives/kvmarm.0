Return-Path: <SRS0=YpAl=XP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821F3C49ED7
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 07:27:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1343A2086A
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 07:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1343A2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72FC94A6D1;
	Fri, 20 Sep 2019 03:27:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MivhuAXtXJ0s; Fri, 20 Sep 2019 03:27:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 607454A58D;
	Fri, 20 Sep 2019 03:27:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9264A58D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Sep 2019 03:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pCWamIgxjVd2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Sep 2019 03:27:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5DFC4A527
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Sep 2019 03:27:54 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 0D66C2A09B2;
 Fri, 20 Sep 2019 07:27:54 +0000 (UTC)
Received: from [10.36.117.220] (ovpn-117-220.ams2.redhat.com [10.36.117.220])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E12DE60606;
 Fri, 20 Sep 2019 07:27:45 +0000 (UTC)
To: Will Deacon <will@kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
From: Auger Eric <eric.auger@redhat.com>
Subject: Plumber VFIO/IOMMU/PCI "Dual Stage SMMUv3 Status" Follow-up
Message-ID: <51ed9586-9973-4811-2cda-a2356fb3a1b4@redhat.com>
Date: Fri, 20 Sep 2019 09:27:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.38]); Fri, 20 Sep 2019 07:27:54 +0000 (UTC)
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <jroedel@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
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

Hi Will,

As a follow-up of the VFIO/IOMMU/PCI "Dual Stage SMMUv3 Status"
session, please find some further justifications about the
SMMUv3 nested stage enablement series.

In the text below, I only talk about use cases featuring
VFIO assigned devices where the physical IOMMU is actually
involved.

The virtio-iommu solution, as currently specified, is expected
to work efficiently as long as guest IOMMU mappings are static.
This hopefully actually corresponds to the DPDK use case.
The overhead of trapping on each MAP/UNMAP is then close to 0.

I see 2 main use cases where guest uses dynamic mappings:
  1) native drivers using DMA ops are used on the guest
  2) shared virtual address on guest.

1) can be addressed with current virtio-iommu spec. However
the performance will be very poor: it behaves as Intel IOMMU
with the driver operating with caching mode and strict mode
set (80% perf downgrade is observed versus no iommu). This use
case can be tested very easily. Dual stage implementation
should bring much better results here.

2) natural implementation for that is nested. Jean planned
to introduce extensions to the current virtio-iommu spec to
setup stage 1 config. As far as I understand this will require
the exact same SMMUv3 driver modifications I introduced in
my series. If this happens, after the specification process,
the virtio-iommu driver upgrade, the virtio-iommu QEMU device
upgrade, we will face the same problematics as the ones
encountered in my series. This use case cannot be tested
easily. There are in-flight series to support substream IDs
in the SMMU driver and SVA/ARM but none of that code is
upstream. Also I don't know if there is any PASID capable
device easily available at the moment. So during the uC you
said you would prefer this use case to be addressed first
but according to me, this brings a lot of extra complexity
and dependencies and the above series are also stalled due to
that exact same issue.

HW nested paging should satisfy all use cases including
guest static mappings. At the moment it is difficult to
run comparative benchmarks. First you may know virtio-iommu
also suffer some FW integration delays, its QEMU VFIO
integration needs to be rebased. Also I have access to
some systems that feature a dual stage SMMUv3 but I am
not sure their cache/TLB structures are dimensionned for
exercising the 2 stages (that's a chicken and egg issue:
no SW integration, no HW).

If you consider those use cases are not sufficient to
invest time now, I have no problem pausing this development.
We can re-open the topic later when actual users show up,
are interested to review and test with production HW and
workloads.

Of course if there are any people/company interested in
getting this upstream in a decent timeframe, that's the right
moment to let us know!

Thanks

Eric

References:
[1] [PATCH v9 00/11] SMMUv3 Nested Stage Setup (IOMMU part)
https://patchwork.kernel.org/cover/11039871/
[2] [PATCH v9 00/14] SMMUv3 Nested Stage Setup (VFIO part)
https://patchwork.kernel.org/cover/11039995/

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
