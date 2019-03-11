From: Auger Eric <eric.auger@redhat.com>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Mon, 11 Mar 2019 10:47:22 +0100
Message-ID: <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C434A36B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 05:47:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mYe591GRqH-3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Mar 2019 05:47:28 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BC524A369
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 05:47:28 -0400 (EDT)
In-Reply-To: <20190311093958.GF13422@leoy-ThinkPad-X240s>
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
To: Leo Yan <leo.yan@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Leo,

On 3/11/19 10:39 AM, Leo Yan wrote:
> Hi Auger,
> 
> On Mon, Mar 11, 2019 at 09:23:20AM +0100, Auger Eric wrote:
> 
> [...]
> 
>>> P.s. I also checked the sysfs node and found it doesn't contain node
>>> 'iommu_group':
>>>
>>> # ls /sys/bus/pci/devices/0000\:08\:00.0/iommu_group
>>> ls: cannot access '/sys/bus/pci/devices/0000:08:00.0/iommu_group': No
>>> such file or directory
>>
>> please can you give the output of the following command:
>> find /sys/kernel/iommu_groups/
> 
> I get below result on Juno board:
> 
> root@debian:~# find /sys/kernel/iommu_groups/
> /sys/kernel/iommu_groups/
> /sys/kernel/iommu_groups/1
> /sys/kernel/iommu_groups/1/devices
> /sys/kernel/iommu_groups/1/devices/20070000.etr
> /sys/kernel/iommu_groups/1/type
> /sys/kernel/iommu_groups/1/reserved_regions
> /sys/kernel/iommu_groups/0
> /sys/kernel/iommu_groups/0/devices
> /sys/kernel/iommu_groups/0/devices/7ffb0000.ohci
> /sys/kernel/iommu_groups/0/devices/7ffc0000.ehci
> /sys/kernel/iommu_groups/0/type
> /sys/kernel/iommu_groups/0/reserved_regions
> 
> So the 'iommu_groups' is not created for pci-e devices, right?

Yes that's correct.
> 
> Will debug into dt binding and related code and keep posted at here.OK

Thanks

Eric
> 
>> when booting your host without noiommu=true
>>
>> At first sight I would say you have trouble with your iommu groups.
> 
> Thanks a lot for guidance.
> Leo Yan
> 
