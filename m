From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH 0/6] vfio: Add interface to map MSI pages
Date: Tue, 12 Jan 2016 10:30:33 +0100
Message-ID: <5694C7B9.4040607@linaro.org>
References: <1443625060-24396-1-git-send-email-Bharat.Bhushan@freescale.com>
 <5694BF96.3060606@linaro.org>
 <DB5PR04MB0997BAF414A71E02C5C2A9829ACA0@DB5PR04MB0997.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B548349B96
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2016 04:26:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nq1xTxfDgA+V for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2016 04:26:46 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0AA449B60
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2016 04:26:46 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id u188so247392011wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2016 01:30:48 -0800 (PST)
In-Reply-To: <DB5PR04MB0997BAF414A71E02C5C2A9829ACA0@DB5PR04MB0997.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bharat Bhushan <bharat.bhushan@nxp.com>, Bharat Bhushan <Bharat.Bhushan@freescale.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Cc: "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Bharat,
On 01/12/2016 10:00 AM, Bharat Bhushan wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: Eric Auger [mailto:eric.auger@linaro.org]
>> Sent: Tuesday, January 12, 2016 2:26 PM
>> To: Bharat Bhushan <Bharat.Bhushan@freescale.com>;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
>> alex.williamson@redhat.com
>> Cc: christoffer.dall@linaro.org; pranavkumar@linaro.org;
>> marc.zyngier@arm.com; will.deacon@arm.com; Pavel Fedin
>> <p.fedin@samsung.com>; Pranavkumar Sawargaonkar
>> <pranavkumar@linaro.org>
>> Subject: Re: [RFC PATCH 0/6] vfio: Add interface to map MSI pages
>>
>> Hi Bharat, all,
>>
>> I now have access to HW that allows to bring out that task on ARM and I
>> would be happy to try contributing on this thread on both kernel and QEMU
>> side. Bharat, do you intend to respin shortly or can I try to pursue your
>> efforts while keeping credit to you (and also take into account Pranav and
>> Pavel contributions too if relevant)?
> 
> It is pending for long and I do think I will be able to work in next couple of months on this activity. It will be helpful if you can take on from whatever little I have done.
> 
OK thanks for your quick answer. I will do my utmost ;-)

Best Regards

Eric
> Thanks
> -Bharat
> 
>>
>> Thanks in advance
>>
>> Best Regards
>>
>> Eric
>>
>> /2015 04:57 PM, Bharat Bhushan wrote:
>>> This patch series add the interface to map MSI pages in iommu for
>>> msi-capable device pass-through using vfio.
>>>
>>> First patch adds a generic interface to set reserved iova regions.
>>> These reserved regions can be used for mapping physical address.
>>> Follow-up patches uses these reserved iova for mapping msi-pages.
>>>
>>> This patch series does not provide interface to let user-space know
>>> how many minimum reserved iova regions are required on a given
>> platform.
>>> This interface can be added once this patches series get reviewed and
>>> will be in acceptable state.
>>>
>>> Bharat Bhushan (6):
>>>   vfio: Add interface for add/del reserved iova region
>>>   iommu: Add interface to get msi-pages mapping attributes
>>>   vfio: Extend iommu-info to return MSIs automap state
>>>   vfio: Add interface to iommu-map/unmap MSI pages
>>>   vfio-pci: Create iommu mapping for msi interrupt
>>>   arm-smmu: Allow to set iommu mapping for MSI
>>>
>>>  drivers/iommu/arm-smmu.c          |   8 +
>>>  drivers/iommu/fsl_pamu_domain.c   |   3 +
>>>  drivers/iommu/iommu.c             |  14 ++
>>>  drivers/vfio/pci/vfio_pci_intrs.c |  36 +++-
>>>  drivers/vfio/vfio.c               |  52 ++++++
>>>  drivers/vfio/vfio_iommu_type1.c   | 344
>> +++++++++++++++++++++++++++++++++++++-
>>>  include/linux/iommu.h             |   9 +-
>>>  include/linux/vfio.h              |   9 +-
>>>  include/uapi/linux/vfio.h         |  46 +++++
>>>  9 files changed, 516 insertions(+), 5 deletions(-)
>>>
> 
