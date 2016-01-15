From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 00/11] pci/arm: add PCI bus support
Date: Fri, 15 Jan 2016 16:42:20 +0100
Message-ID: <20160115154220.GR3915@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7CA749A37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:38:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bs++rnuVEiU1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:38:10 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC22A49A16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:38:10 -0500 (EST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
 (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
 by mx1.redhat.com (Postfix) with ESMTPS id 1A6BD42E5DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 15:42:24 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <cover.1452341807.git.agordeev@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Gordeev <agordeev@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 09, 2016 at 01:22:47PM +0100, Alexander Gordeev wrote:
> This series extends the kvm-unit-tests/arm framework to support PCI.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> 
> Alexander Gordeev (11):
>   arm/pci: Device tree PCI probing
>   arm/pci: PCI bus scanning
>   arm/pci: Read devices BARs
>   arm/pci: Allocate and assign memory/io space resources
>   arm/pci: Add pci_find_dev() and pci_bar_addr() functions
>   arm/pci: PCI testdev existence test
>   arm/pci: PCI device operation test
>   arm/pci: PCI device read/write test
>   arm/pci: PCI host bridge info printing
>   arm/pci: PCI devices basic info printing
>   arm/pci: PCI testdev test flavour printing
> 
>  arm/pci-test.c               |  32 +++
>  config/config-arm-common.mak |   6 +-
>  lib/alloc.c                  |   3 -
>  lib/libcflat.h               |   3 +
>  lib/pci-host-generic.c       | 502 +++++++++++++++++++++++++++++++++++++++++++
>  lib/pci-host-generic.h       |  37 ++++
>  lib/pci-testdev.c            | 198 +++++++++++++++++
>  lib/pci.h                    |  33 +++
>  8 files changed, 810 insertions(+), 4 deletions(-)
>  create mode 100644 arm/pci-test.c
>  create mode 100644 lib/pci-host-generic.c
>  create mode 100644 lib/pci-host-generic.h
>  create mode 100644 lib/pci-testdev.c
>  create mode 100644 lib/pci.h
> 
> -- 
> 1.8.3.1
>

Nice start! I think we can reduce some of it down a bit though by
integrating with x86 right now. I'll post a series that starts that
effort. If x86 people like it, then you can rebase on that, do some
patch squashing, and post again. Soon we'll have pci-testdev vmexit
tests for ARM!

Thanks,
drew
