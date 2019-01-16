From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 17/21] iommu/smmuv3: Report non recoverable faults
Date: Wed, 16 Jan 2019 12:25:38 +0000
Message-ID: <c0328bbe-e02c-c337-ec52-c899dc0025d3@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-18-eric.auger@redhat.com>
 <dae89fd8-6a82-d2f0-a8c7-ddbf12a7b047@arm.com>
 <e634adee-f7ab-b90d-aac6-06400fa9ffb4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9F444A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 07:25:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z7pOutYvddyj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jan 2019 07:25:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 938474A332
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 07:25:57 -0500 (EST)
In-Reply-To: <e634adee-f7ab-b90d-aac6-06400fa9ffb4@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/2019 21:06, Auger Eric wrote:
>>> +		iommu_report_device_fault(master->dev, &event);
>>
>> We should return here if the fault is successfully injected
> 
> Even if the fault gets injected in the guest can't it be still useful to
> get the message below on host side?

I don't think we should let the guest flood the host log by issuing
invalid DMA (or are there other cases where the guest can freely print
stuff in the host?) We do print all errors at the moment, but we should
tighten this once there is an upstream solution to let the guest control
DMA mappings.

Thanks,
Jean
