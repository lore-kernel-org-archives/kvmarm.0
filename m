From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
 a platform device
Date: Tue, 1 Sep 2015 11:28:13 +0200
Message-ID: <20150901092813.GE10991@cbox>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
 <55DF07F0.3070405@linaro.org>
 <1440691887.20355.27.camel@redhat.com>
 <55DF45D0.5040704@linaro.org> <20150830140638.GB24113@cbox>
 <55E48897.4090907@linaro.org> <20150831173359.GA10991@cbox>
 <55E5546C.7040504@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FC048AF2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2015 05:26:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WVkHbtp7iorq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2015 05:26:33 -0400 (EDT)
Received: from mail-la0-f51.google.com (mail-la0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65C1248A57
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2015 05:26:33 -0400 (EDT)
Received: by laba3 with SMTP id a3so88227762lab.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Sep 2015 02:26:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55E5546C.7040504@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: iommu@lists.linux-foundation.org, Alex Williamson <alex.williamson@redhat.com>, tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On Tue, Sep 01, 2015 at 09:31:56AM +0200, Eric Auger wrote:

[...]

> >>> Can you reiterate why QEMU and VFIO don't already have the information
> >>> necessary to setup resources and present a DT to the guest that the
> >>> guest can use?
> >> A vfio-platform driver was bound to the passthrough'ed device. QEMU
> >> current knows the compat string of the device and the node's name and
> >> that's it.
> >>
> >> The VFIO platform driver currently does not allow to return device
> >> specific information. It just returns generic info such as resource
> >> info. The driver is HW agnostic.
> >>
> >>
> >> The QEMU VFIO device should be able to check some characteristics of the
> >> host device tree. Typically if the host node does not comply with some
> >> constraints it may not be possible to assign the device.
> >>
> >> We do not want the QEMU end-user to have in-depth knowledge of the HW so
> >> passing the info in the QEMU command line does not sound to be the good
> >> solution.
> >>
> >>
> >> As you mentioned /proc/device-tree depends on kernel option. I am able
> >> to find the properties in sysfs too but can we systematically rely on
> >> sysfs (CONFIG_SYSFS)? Also I would have expected the values to be human
> >> readable but they are not. Currently investigating open/read from qemu
> >> but is better than an ioctl API? ...
> >>
> > Yeah it does, but I thought we originally planned that the driver for a
> > specific platform device in QEMU should know these details,
> Yes that's the objective to put this intelligence in the QEMU VFIO
> device or more precisely in the associated function that builds its
> guest dt node.
> 
> Let's take an example. Assuming an xgmac supports different speeds, you
> need to set those on guest. Either you put arbitrary values or you reuse
> the values that were set on host. Typically some values may not be
> supported by the HW.
> 

I see.  I'm no expert here, but I could imagine that drivers could
overwrite some things in the DT or do some advanced probing of the
hardware which is then only exported in the sysfs and not the DT, so I
would go the sysfs approach myself.

> Idea of genericity was ruled out indeed meaning each device needs to
> have a specialized QEMU VFIO device and an associated dt node creation
> function. Now this does not prevent from exploiting host dt information.
> Does that make sense?
> 
Yes, thanks for the explanation.

-Christoffer
