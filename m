Return-Path: <SRS0=1iCv=TP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59555C04E87
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 13:07:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDF4120881
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 13:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDF4120881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF8A4A4DE;
	Wed, 15 May 2019 09:07:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L2nllGoCAkJB; Wed, 15 May 2019 09:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F23F4A4D4;
	Wed, 15 May 2019 09:07:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DED14A4C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 09:07:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5QRADaZcoBD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 May 2019 09:07:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A55DA4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 09:07:05 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 685F330832EA;
 Wed, 15 May 2019 13:07:04 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A0A01995D;
 Wed, 15 May 2019 13:06:59 +0000 (UTC)
Subject: Re: [PATCH v7 04/23] iommu: Introduce attach/detach_pasid_table API
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, will.deacon@arm.com,
 robin.murphy@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-5-eric.auger@redhat.com>
 <21bfdab4-846c-1dc7-6dff-62a46cc9c829@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <b4c47851-0269-5aa2-682a-77677f756205@redhat.com>
Date: Wed, 15 May 2019 15:06:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <21bfdab4-846c-1dc7-6dff-62a46cc9c829@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.44]); Wed, 15 May 2019 13:07:04 +0000 (UTC)
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

Hi Jean-Philippe,

On 5/15/19 2:09 PM, Jean-Philippe Brucker wrote:
> On 08/04/2019 13:18, Eric Auger wrote:
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> index edcc0dda7993..532a64075f23 100644
>> --- a/include/uapi/linux/iommu.h
>> +++ b/include/uapi/linux/iommu.h
>> @@ -112,4 +112,51 @@ struct iommu_fault {
>>  		struct iommu_fault_page_request prm;
>>  	};
>>  };
>> +
>> +/**
>> + * SMMUv3 Stream Table Entry stage 1 related information
>> + * The PASID table is referred to as the context descriptor (CD) table.
>> + *
>> + * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
>> +   or 2-level table)
> 
> Running "scripts/kernel-doc -v -none" on this header produces some
> warnings. Not sure if we want to get rid of all of them, but we should
> at least fix the coding style for this comment (line must start with
> " * "). I'm fixing it up on my sva/api branch
Thanks!

Let me know if you want me to do the job for additional fixes.

Eric


> 
> Thanks,
> Jean
> 
>> + * @s1dss: STE s1dss (specifies the behavior when pasid_bits != 0
>> +   and no pasid is passed along with the incoming transaction)
>> + * Please refer to the smmu 3.x spec (ARM IHI 0070A) for full details
>> + */
>> +struct iommu_pasid_smmuv3 {
>> +#define PASID_TABLE_SMMUV3_CFG_VERSION_1 1
>> +	__u32	version;
>> +	__u8 s1fmt;
>> +	__u8 s1dss;
>> +	__u8 padding[2];
>> +};
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
