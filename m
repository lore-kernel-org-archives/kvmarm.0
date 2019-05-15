Return-Path: <SRS0=1iCv=TP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0141EC04E53
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 15:58:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78E422084E
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 15:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78E422084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D602A4A369;
	Wed, 15 May 2019 11:58:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lzZn2gfx3kzJ; Wed, 15 May 2019 11:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AED2C4A483;
	Wed, 15 May 2019 11:58:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16B464A369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 11:58:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rVI5Ukg5cbpt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 May 2019 11:58:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB1B54A331
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 11:58:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A615374;
 Wed, 15 May 2019 08:58:13 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16E9D3F703;
 Wed, 15 May 2019 08:58:09 -0700 (PDT)
Subject: Re: [PATCH v7 04/23] iommu: Introduce attach/detach_pasid_table API
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, will.deacon@arm.com, robin.murphy@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-5-eric.auger@redhat.com>
 <21bfdab4-846c-1dc7-6dff-62a46cc9c829@arm.com>
 <b4c47851-0269-5aa2-682a-77677f756205@redhat.com>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <9fedefb7-e13c-7ea7-b2ae-50a8f1a7e09b@arm.com>
Date: Wed, 15 May 2019 16:57:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b4c47851-0269-5aa2-682a-77677f756205@redhat.com>
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

On 15/05/2019 14:06, Auger Eric wrote:
> Hi Jean-Philippe,
> 
> On 5/15/19 2:09 PM, Jean-Philippe Brucker wrote:
>> On 08/04/2019 13:18, Eric Auger wrote:
>>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>>> index edcc0dda7993..532a64075f23 100644
>>> --- a/include/uapi/linux/iommu.h
>>> +++ b/include/uapi/linux/iommu.h
>>> @@ -112,4 +112,51 @@ struct iommu_fault {
>>>  		struct iommu_fault_page_request prm;
>>>  	};
>>>  };
>>> +
>>> +/**
>>> + * SMMUv3 Stream Table Entry stage 1 related information
>>> + * The PASID table is referred to as the context descriptor (CD) table.
>>> + *
>>> + * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
>>> +   or 2-level table)
>>
>> Running "scripts/kernel-doc -v -none" on this header produces some
>> warnings. Not sure if we want to get rid of all of them, but we should
>> at least fix the coding style for this comment (line must start with
>> " * "). I'm fixing it up on my sva/api branch
> Thanks!
> 
> Let me know if you want me to do the job for additional fixes.

I fixed the others warnings as well, in case we ever want to include
this into the kernel doc

Thanks,
Jean

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
