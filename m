Return-Path: <SRS0=Kjqu=TI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FB9C04A6B
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 18:31:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05674216C4
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 18:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05674216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A8F4A2E7;
	Wed,  8 May 2019 14:31:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gOaeZmJU9Jd5; Wed,  8 May 2019 14:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 640024A4A3;
	Wed,  8 May 2019 14:31:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9644A2E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 14:31:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Le7CJ1AGtLYV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 May 2019 14:31:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 818464A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 14:31:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD66F80D;
 Wed,  8 May 2019 11:31:41 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A02F23F575;
 Wed,  8 May 2019 11:31:38 -0700 (PDT)
Subject: Re: [PATCH v7 11/23] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To: Robin Murphy <robin.murphy@arm.com>, Eric Auger <eric.auger@redhat.com>,
 eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, will.deacon@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-12-eric.auger@redhat.com>
 <e3b417b7-b69f-0121-fb72-6b6450e1b2f2@arm.com>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <ecb3725c-27c4-944b-b42c-f4e293521f94@arm.com>
Date: Wed, 8 May 2019 19:31:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e3b417b7-b69f-0121-fb72-6b6450e1b2f2@arm.com>
Content-Language: en-US
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
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

On 08/05/2019 15:05, Robin Murphy wrote:
> On 08/04/2019 13:18, Eric Auger wrote:
>> From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>>
>> When handling faults from the event or PRI queue, we need to find the
>> struct device associated to a SID. Add a rb_tree to keep track of SIDs.
> 
> Out of curiosity, have you looked at whether an xarray might now be a
> more efficient option for this?

I hadn't looked into it yet, but it's a welcome distraction.

* Searching by SID will be more efficient with xarray (which still is a
radix tree, with a better API). Rather than O(log2(n)) we walk
O(log_c(n)) nodes in the worst case, with c = XA_CHUNK_SIZE = 64. We
don't care about insertion/deletion time.

* Memory consumption is worse than rb-tree, when the SID space is a
little sparse. For PCI devices the three LSBs (function number) might
not be in use, meaning that 88% of the leaf slots would be unused. And
it gets worse if the system has lots of bridges, as each bus number
requires its own xa slot, ie. 98% unused.

  It's not too bad though, and in general I think the distribution of
SIDs would be good enough to justify using xarray. Plugging in more
devices would increase the memory consumption fast, but creating virtual
functions wouldn't. On one machine (TX2, a few discrete PCI cards) I
need 16 xa slots to store 42 device IDs. That's 16 * 576 bytes = 9 kB,
versus 42 * 40 bytes = 1.6 kB for the rb-tree. On another machine (x86,
lots of RC integrated endpoints) I need 18 slots to store 181 device
IDs, 10 kB vs. 7 kB with the rb-tree.

* Using xa would make this code a lot nicer.

Shame that we can't store the device pointer directly in the STE though,
there is already plenty of unused space in there.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
