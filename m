Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507CBC2BCA1
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 12:47:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7773208C3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 12:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7773208C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F6E94A4E6;
	Fri,  7 Jun 2019 08:47:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7JngfBfbUT9g; Fri,  7 Jun 2019 08:47:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15D094A389;
	Fri,  7 Jun 2019 08:47:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A587F4A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 08:47:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxhzeqFkcPKA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 08:47:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AA764A331
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 08:47:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 226E53EF;
 Fri,  7 Jun 2019 05:47:49 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E0D640151;
 Fri,  7 Jun 2019 05:47:47 -0700 (PDT)
Subject: Re: [PATCH v8 25/29] vfio-pci: Add a new VFIO_REGION_TYPE_NESTED
 region type
To: Auger Eric <eric.auger@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-26-eric.auger@redhat.com>
 <20190603163159.31e7ae23@x1.home>
 <9c1ea2db-5ba0-3cf5-3b38-2c4a125460e6@redhat.com>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <6a640710-bb9d-8923-cfef-e57786ed699f@arm.com>
Date: Fri, 7 Jun 2019 13:47:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9c1ea2db-5ba0-3cf5-3b38-2c4a125460e6@redhat.com>
Content-Language: en-US
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Marc Zyngier <Marc.Zyngier@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 Vincent Stehle <Vincent.Stehle@arm.com>, Robin Murphy <Robin.Murphy@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
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

On 07/06/2019 09:28, Auger Eric wrote:
>>> +static const struct vfio_pci_fault_abi fault_abi_versions[] = {
>>> +	[0] = {
>>> +		.entry_size = sizeof(struct iommu_fault),
>>> +	},
>>> +};
>>> +
>>> +#define NR_FAULT_ABIS ARRAY_SIZE(fault_abi_versions)
>>
>> This looks like it's leading to some dangerous complicated code to
>> support multiple user selected ABIs.  How many ABIs do we plan to
>> support?  The region capability also exposes a type, sub-type, and
>> version.  How much of this could be exposed that way?  ie. if we need
>> to support multiple versions, expose multiple regions.
> 
> This is something that was discussed earlier and suggested by
> Jean-Philippe that we may need to support several versions of the ABI
> (typicallu when adding PRI support).
> Exposing multiple region is an interesting idea and I will explore that
> direction.

At the moment the ABI support errors and PRI. We're considering setting
the fault report structure to 64 or 128 bytes (see "[PATCH v2 2/4]
iommu: Introduce device fault data"). 64-byte allows for 2 additional
fields before we have to introduce a new ABI version, while 128 byte
should last us a while.

But that's for adding new fields to existing fault types. It's probably
a good idea to have different region types in VFIO for different fault
types, since userspace isn't necessarily prepared to deal with them. For
example right now userspace doesn't have a method to complete
recoverable faults, so we can't add them to the queue.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
