From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Mon, 11 Mar 2019 17:39:58 +0800
Message-ID: <20190311093958.GF13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5D94A426
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 05:40:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7MLTloujyKdA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Mar 2019 05:40:04 -0400 (EDT)
Received: from mail-yw1-f65.google.com (mail-yw1-f65.google.com
 [209.85.161.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7271E4A41C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 05:40:04 -0400 (EDT)
Received: by mail-yw1-f65.google.com with SMTP id s204so3323564ywg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 02:40:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Auger,

On Mon, Mar 11, 2019 at 09:23:20AM +0100, Auger Eric wrote:

[...]

> > P.s. I also checked the sysfs node and found it doesn't contain node
> > 'iommu_group':
> > 
> > # ls /sys/bus/pci/devices/0000\:08\:00.0/iommu_group
> > ls: cannot access '/sys/bus/pci/devices/0000:08:00.0/iommu_group': No
> > such file or directory
> 
> please can you give the output of the following command:
> find /sys/kernel/iommu_groups/

I get below result on Juno board:

root@debian:~# find /sys/kernel/iommu_groups/
/sys/kernel/iommu_groups/
/sys/kernel/iommu_groups/1
/sys/kernel/iommu_groups/1/devices
/sys/kernel/iommu_groups/1/devices/20070000.etr
/sys/kernel/iommu_groups/1/type
/sys/kernel/iommu_groups/1/reserved_regions
/sys/kernel/iommu_groups/0
/sys/kernel/iommu_groups/0/devices
/sys/kernel/iommu_groups/0/devices/7ffb0000.ohci
/sys/kernel/iommu_groups/0/devices/7ffc0000.ehci
/sys/kernel/iommu_groups/0/type
/sys/kernel/iommu_groups/0/reserved_regions

So the 'iommu_groups' is not created for pci-e devices, right?

Will debug into dt binding and related code and keep posted at here.

> when booting your host without noiommu=true
> 
> At first sight I would say you have trouble with your iommu groups.

Thanks a lot for guidance.
Leo Yan
