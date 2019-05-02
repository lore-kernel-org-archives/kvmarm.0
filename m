Return-Path: <SRS0=zWKl=TC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4248CC43219
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 10:54:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0BF020656
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 10:54:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0BF020656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11D674A4FE;
	Thu,  2 May 2019 06:54:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HaapWvQ77x7x; Thu,  2 May 2019 06:53:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D238D4A4EC;
	Thu,  2 May 2019 06:53:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 676974A4C3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 06:53:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cC61rod8s2H1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 May 2019 06:53:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A4B4A4AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 06:53:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29549A78;
 Thu,  2 May 2019 03:53:56 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E6CF3F719;
 Thu,  2 May 2019 03:53:52 -0700 (PDT)
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
To: Auger Eric <eric.auger@redhat.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>, Will Deacon
 <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-6-eric.auger@redhat.com>
 <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
 <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <6af5ddb7-75ad-7d3f-b303-f6f06adb1bf0@arm.com>
Date: Thu, 2 May 2019 11:53:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
Content-Language: en-US
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 Vincent Stehle <Vincent.Stehle@arm.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190502105334.KIYJqMLbS1k8l7j6lGhPJoDH6U9acx8KOHeMAKTwkFE@z>

On 02/05/2019 07:58, Auger Eric wrote:
> Hi Jean-Philippe,
> 
> On 5/1/19 12:38 PM, Jean-Philippe Brucker wrote:
>> On 08/04/2019 13:18, Eric Auger wrote:
>>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
>>> +			   struct iommu_cache_invalidate_info *inv_info)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (unlikely(!domain->ops->cache_invalidate))
>>> +		return -ENODEV;
>>> +
>>> +	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
>>> +
>>> +	return ret;
>>
>> Nit: you don't really need ret
>>
>> The UAPI looks good to me, so
>>
>> Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Just to make sure, do you accept changes proposed by Jacob in
> https://lkml.org/lkml/2019/4/29/659 ie.
> - the addition of NR_IOMMU_INVAL_GRANU in enum iommu_inv_granularity and
> - the addition of NR_IOMMU_CACHE_TYPE

Ah sorry, I forgot about that, I'll review the next version. Yes they
can be useful (maybe call them IOMMU_INV_GRANU_NR and
IOMMU_CACHE_INV_TYPE_NR?). I guess it's legal to export in UAPI values
that will change over time, as VFIO also does it in its enums.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
