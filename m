From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
 a platform device
Date: Wed, 2 Sep 2015 12:32:59 +0200
Message-ID: <20150902103259.GI10991@cbox>
References: <20150830140638.GB24113@cbox> <55E48897.4090907@linaro.org>
 <20150831173359.GA10991@cbox> <55E5546C.7040504@linaro.org>
 <20150901092813.GE10991@cbox>
 <CAN9JPjGfuv_YOBEdZA_AD13oHej7wMCR50=zQTZmgzHx-jBj_A@mail.gmail.com>
 <20150901155205.GA19385@cbox>
 <CAN9JPjFwsiYzR6RtDA-5UZYoNALGu8crXVyA+m6ptsWv=qJi5A@mail.gmail.com>
 <20150902092128.GG10991@cbox>
 <CAN9JPjHzPFC1LMuEneXXSYRs1bTXJHZmB6E8Dy+Fp=XRPScEEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6A84141D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 06:31:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nF0PWW1dKBbs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 06:31:15 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF64D413E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 06:31:14 -0400 (EDT)
Received: by lbbmp1 with SMTP id mp1so3364094lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Sep 2015 03:31:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAN9JPjHzPFC1LMuEneXXSYRs1bTXJHZmB6E8Dy+Fp=XRPScEEw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: Linux IOMMU <iommu@lists.linux-foundation.org>, Alex Williamson <alex.williamson@redhat.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 02, 2015 at 11:49:12AM +0200, Baptiste Reynal wrote:
> On Wed, Sep 2, 2015 at 11:21 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Wed, Sep 02, 2015 at 09:21:26AM +0200, Baptiste Reynal wrote:
> >> On Tue, Sep 1, 2015 at 5:52 PM, Christoffer Dall
> >> <christoffer.dall@linaro.org> wrote:
> >> > On Tue, Sep 01, 2015 at 05:32:21PM +0200, Baptiste Reynal wrote:
> >> >> Hi everyone,
> >> >>
> >> >> The usefullness of this patch has already been discussed during the
> >> >> first releases (http://lists.linuxfoundation.org/pipermail/iommu/2014-August/009586.html).
> >> >> I underline the fact that it avoids implementing the logic on the
> >> >> userspace program, as VFIO can be used for many usage (userspace
> >> >> drivers and device assignment).
> >> >>
> >> >> If you're interested in the implementation on the userspace side, an
> >> >> RFC has been suggested for QEMU:
> >> >> http://lists.gnu.org/archive/html/qemu-devel/2015-01/msg01211.html
> >> >
> >> > This one-year-old discussion is hardly exhaustive.
> >> >
> >> > I think you missed the gist of the question for Eric a bit as well.
> >> >
> >> > One important question for me is whether seeing the host DT is always
> >> > sufficient or if the kernel and physical device driver can have more
> >> > information about the device and its configuration which userspace may
> >> > need, which cannot be directly read in the DT (for example because the
> >> > driver has initialized the device in a specific way).  My point is, it's
> >> > really not about DT-specific things (what if you used ACPI?), but it's
> >> > about retrieving properties of a device and its configuration from
> >> > userspace.
> >> >
> >> > Have we thought about the possible ways to achieve this and weight one
> >> > option against the other?
> >>
> >> Problem is that now we only have a very few platform devices behind an
> >> IOMMU, so we don't have the visibility to know if such a case will
> >> occur. With the current use cases, the interface seems to be
> >> sufficient.
> >
> > Ideally we can think about future use cases based on the experience of
> > people in the community and come up with a solution considering future
> > use cases.
> >
> >> By using IOCTL, we can always change the implementation
> >> later without any change on the userspace.
> >
> > Can you be more concrete with what you mean here?
> >
> 
> By using an IOCTL, we define an API that allows to retrieve device
> properties from userspace. The way it is retrieved is handled by the
> kernel (For example for now if OF is unavailable, the kernel will
> retrieve the property using ACPI) and is totally transparent from the
> userspace point of view.

ok, I thought that this series was targeting device tree specifically,
but I see that you changed this approach in v3.

> 
> My point is that we can go with the current naive implementation for
> now, and we might extend it later according to the needs of future
> devices, without changing anything from the userspace point of view.
> 
fair enough.

Is this series exporting properties not already exported through sysfs?

-Christoffer
