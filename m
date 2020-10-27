Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D164CC55179
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 13:04:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E9FA22283
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 13:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="esJ7PWQy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E9FA22283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 253C94B53B;
	Tue, 27 Oct 2020 09:04:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1WMm2UStUSDA; Tue, 27 Oct 2020 09:04:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 126064B53D;
	Tue, 27 Oct 2020 09:04:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916184B526
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 09:04:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qCm8Ya3-j9hi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 09:04:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2AE4B47D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 09:04:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603803858;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eXXpUz3VnsL2Xy70mrZp5D4eUU9pHEsl4U/A+ZeUZVA=;
 b=esJ7PWQyeyfFmeTdZkzSB3sOlX8b8ME/b1704roI+wc5ZFPsdh79Uivt0lWEVew3Qeo5pn
 3fIW1C2ImGT7ZnF+SUN/tEhKtYkQuHDYhfPKyQrnvW7VZnBZGfmJZsFN7FvyNEUzkZnJc6
 ybreO9btDTiJvQdES+qVB3qC2ANOwew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-6ACk6zq5PEK2TZ_Z7S-pwA-1; Tue, 27 Oct 2020 09:04:15 -0400
X-MC-Unique: 6ACk6zq5PEK2TZ_Z7S-pwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D744FEC505;
 Tue, 27 Oct 2020 13:04:12 +0000 (UTC)
Received: from [10.36.112.194] (ovpn-112-194.ams2.redhat.com [10.36.112.194])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3446F5B4A4;
 Tue, 27 Oct 2020 13:04:06 +0000 (UTC)
Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 yuzenghui <yuzenghui@huawei.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
 <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
 <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
 <cb5835e79b474e30af6702dbee0d46df@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <cde28d6d-c6cf-ef23-b293-f9959aba0a18@redhat.com>
Date: Tue, 27 Oct 2020 14:04:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cb5835e79b474e30af6702dbee0d46df@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Hi Shameer,

On 10/27/20 1:20 PM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: iommu [mailto:iommu-bounces@lists.linux-foundation.org] On Behalf Of
>> Auger Eric
>> Sent: 23 September 2020 12:47
>> To: yuzenghui <yuzenghui@huawei.com>; eric.auger.pro@gmail.com;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; joro@8bytes.org;
>> alex.williamson@redhat.com; jacob.jun.pan@linux.intel.com;
>> yi.l.liu@intel.com; robin.murphy@arm.com
>> Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
> 
> ...
> 
>>> Besides, before going through the whole series [1][2], I'd like to
>>> know if this is the latest version of your Nested-Stage-Setup work in
>>> case I had missed something.
>>>
>>> [1]
>>> https://lore.kernel.org/r/20200320161911.27494-1-eric.auger@redhat.com
>>> [2]
>>> https://lore.kernel.org/r/20200414150607.28488-1-eric.auger@redhat.com
>>
>> yes those 2 series are the last ones. Thank you for reviewing.
>>
>> FYI, I intend to respin within a week or 2 on top of Jacob's  [PATCH v10 0/7]
>> IOMMU user API enhancement. 
> 
> Thanks for that. Also is there any plan to respin the related Qemu series as well?
> I know dual stage interface proposals are still under discussion, but it would be
> nice to have a testable solution based on new interfaces for ARM64 as well.
> Happy to help with any tests or verifications.

Yes the QEMU series will be respinned as well. That's on the top of my
todo list right now.

Thanks

Eric
> 
> Please let me know.
> 
> Thanks,
> Shameer
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
