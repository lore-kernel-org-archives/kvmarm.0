From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for
 a platform device
Date: Mon, 5 Oct 2015 11:37:39 +0200
Message-ID: <20151005093739.GF9011@cbox>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
 <1443814099.26107.124.camel@redhat.com>
 <20151002202844.GD32011@cbox>
 <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39BC64141A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 05:35:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3BTtZ36CkLSK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 05:35:40 -0400 (EDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
 [209.85.217.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F137741294
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 05:35:39 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so54550961lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Oct 2015 02:37:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, iommu@lists.linux-foundation.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 11:53:07PM +0100, Peter Maydell wrote:
> On 2 October 2015 at 21:28, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > We discussed this for the purposes of ARM during SFO15 last week, and
> > basically arrived at the conclusion that the resonable thing to do is to
> > rely on sysfs device tree parsing in userspace.  We don't have a great
> > solution for ACPI yet, but we also don't know of any ACPI-only devices
> > that want platform device passthrough yet.
> 
> I wasn't hugely happy with that approach though:
>  * it's DT specific and just won't work on ACPI platforms; implementing
>    features with a "needs DT" dependency seems like it will come back to
>    bite us later

I tend to agree with that point of view, but I don't have hugely better
ideas.

>  * I don't really want to build in a lot of infrastructure into
>    QEMU to either build the DTC compiler into it or else introduce
>    a runtime dependency on the dtc binary

what level of complexity are we really talking about here?  Doesn't QEMU
already link against libfdt and doesn't it support exactly what we're
trying to do here?

> , if this is just going
>    to be a stopgap solution until somebody says "has to work on
>    ACPI" and we need to do it some other way
> 
> On the other hand I don't exactly have a better approach to suggest

I also don't think this is the job of VFIO, assuming there is some
better place to do this.  I initially thought exposing device properties
in some canonical format from sysfs independently from whether the
system was booted with ACPI or DT was the right thing to do, but the
counter argument to this was essentially that the guest kernel needs the
same description as the host kernel and therefore we really have to find
a way to pass the HW description bits on to the guest.

> (except "don't do device passthrough for platform devices, insist
> on a real bus like PCI"...)
> 
While I appreciate the simplicity of this solution from our
(maintainers') point of view, I still see the latter point as relatively
moot.  We have hardware with 10G platform ethernet devices that people
want to do device assignment on already, and I think we should try to
find a reasonable set of boundaries for setups that we can support
upstream instead of this becoming a black hole of derivative code bases
to do this sort of thing.

Thanks,
-Christoffer
