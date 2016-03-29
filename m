From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC v5 03/17] iommu: introduce a reserved iova cookie
Date: Tue, 29 Mar 2016 19:26:25 +0200
Message-ID: <56FABAC1.1020506@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
 <1456856877-4817-4-git-send-email-eric.auger@linaro.org>
 <56D865B7.7000404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56D865B7.7000404@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>, eric.auger@st.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julien,
On 03/03/2016 05:26 PM, Julien Grall wrote:
> Hi Eric,
> 
> On 01/03/16 18:27, Eric Auger wrote:
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 0e3b009..7b2bb94 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1072,6 +1072,7 @@ static struct iommu_domain
>> *__iommu_domain_alloc(struct bus_type *bus,
>>
>>       domain->ops  = bus->iommu_ops;
>>       domain->type = type;
>> +    mutex_init(&domain->reserved_mutex);
> 
> For consistency, the RB-tree reserved_binding_list should be initialized
> too:
> 
> domain->reserved_binding_list = RB_ROOT;
Sure

Thank you

Eric
> 
> Cheers,
> 
