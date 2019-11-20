Return-Path: <SRS0=7egO=ZM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1280CC43215
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 10:18:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8601E22311
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 10:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1O/HnGA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8601E22311
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD91D4A5C3;
	Wed, 20 Nov 2019 05:18:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qebotlzV5rqp; Wed, 20 Nov 2019 05:18:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D924A7E4;
	Wed, 20 Nov 2019 05:18:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 989594A7E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 05:18:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8TxG9f8q4Wvv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Nov 2019 05:18:29 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4349B4A5C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 05:18:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574245109;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xWcoDmmt3hOnbNOgoE5dQlhwSeBPgNfYdupdAnlBkc8=;
 b=U1O/HnGAEKoAQAxFSerYgYqmpWThpQb3eZ4vbpVJiM5CqY/QLtZZdmjXK2U8fOIbxw0KQg
 lijYMy5xPgSvm6yBpgG6/3DfF5u3ZY29P08zGXC6S43YAgo1sLOgrAji574sQX984FrEFk
 Nu22VLuWv3L2aUjhoIFTCDDH4dxYBY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-5HWBhLnLMeGUl4cuPBFxxQ-1; Wed, 20 Nov 2019 05:18:25 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BA40801E6A;
 Wed, 20 Nov 2019 10:18:21 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 694F71968D;
 Wed, 20 Nov 2019 10:18:14 +0000 (UTC)
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
To: Tomasz Nowicki <tnowicki@marvell.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
 "will.deacon@arm.com" <will.deacon@arm.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
 <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <3741c034-08f1-9dbb-ab06-434f3a8bd782@redhat.com>
Date: Wed, 20 Nov 2019 11:18:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 5HWBhLnLMeGUl4cuPBFxxQ-1
X-Mimecast-Spam-Score: 0
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
 "tina.zhang@intel.com" <tina.zhang@intel.com>
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

Hi Tomasz,

On 11/20/19 9:15 AM, Tomasz Nowicki wrote:
> Hi Eric,
> 
> On 11.07.2019 15:56, Eric Auger wrote:
>> This series brings the VFIO part of HW nested paging support
>> in the SMMUv3.
>>
>> The series depends on:
>> [PATCH v9 00/14] SMMUv3 Nested Stage Setup (IOMMU part)
>> (https://www.spinics.net/lists/kernel/msg3187714.html)
>>
>> 3 new IOCTLs are introduced that allow the userspace to
>> 1) pass the guest stage 1 configuration
>> 2) pass stage 1 MSI bindings
>> 3) invalidate stage 1 related caches
>>
>> They map onto the related new IOMMU API functions.
>>
>> We introduce the capability to register specific interrupt
>> indexes (see [1]). A new DMA_FAULT interrupt index allows to register
>> an eventfd to be signaled whenever a stage 1 related fault
>> is detected at physical level. Also a specific region allows
>> to expose the fault records to the user space.
>>
>> Best Regards
>>
>> Eric
>>
>> This series can be found at:
>> https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
> 
> I think you have already tested on ThunderX2, but as a formality, for 
> the whole series:
> 
> Tested-by: Tomasz Nowicki <tnowicki@marvell.com>
> qemu: https://github.com/eauger/qemu/tree/v4.1.0-rc0-2stage-rfcv5
> kernel: https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9 + 
> Shameer's fix patch
> 
> In my test I assigned Intel 82574L NIC and perform iperf tests.

Thank you for your testing efforts.
> 
> Other folks from Marvell claimed this to be important feature so I asked 
> them to review and speak up on mailing list.

That's nice to read that!  So it is time for me to rebase both the iommu
and vfio parts. I will submit something quickly. Then I would encourage
the review efforts to focus first on the iommu part.

Thanks

Eric
> 
> Thanks,
> Tomasz
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
