From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Mon, 11 Mar 2019 14:57:32 +0800
Message-ID: <20190311065732.GD13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0A5D4A447
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 02:57:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KOejHYQE8Rkz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Mar 2019 02:57:38 -0400 (EDT)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC7CD4A41E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 02:57:38 -0400 (EDT)
Received: by mail-yw1-f68.google.com with SMTP id a199so2106504ywa.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Mar 2019 23:57:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190311064248.GC13422@leoy-ThinkPad-X240s>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com
Cc: Daniel Thompson <daniel.thompson@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 11, 2019 at 02:42:48PM +0800, Leo Yan wrote:
> Hi all,
> 
> I am trying to enable PCI-e device pass-through mode with KVM, since
> Juno-r2 board has PCI-e bus so I firstly try to use vfio to
> passthrough the network card on PCI-e bus.

Sorry for spamming, just want to add info for Linux kernel version.

I am using Linux mainline kernel 5.0-rc7 with the latest commit:

commit a215ce8f0e00c2d707080236f1aafec337371043 (origin/master, origin/HEAD)
Merge: 2d28e01dca1a cffaaf0c8162
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Mar 1 09:13:04 2019 -0800

    Merge tag 'iommu-fix-v5.0-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu

    Pull IOMMU fix from Joerg Roedel:
     "One important fix for a memory corruption issue in the Intel VT-d
      driver that triggers on hardware with deep PCI hierarchies"

    * tag 'iommu-fix-v5.0-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu:
      iommu/dmar: Fix buffer overflow during PCI bus notification

[...]

Thanks,
Leo Yan
