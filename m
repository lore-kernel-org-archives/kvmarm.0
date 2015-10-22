From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 6/6] vfio: platform: move get/put reset at open/release
Date: Thu, 22 Oct 2015 09:40:44 -0600
Message-ID: <1445528444.5050.8.camel@redhat.com>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <4304536.D7eNHjlsvD@wuerfel> <5628E41F.5050602@linaro.org>
 <9413126.UTMuRq7fA0@wuerfel> <5628F17C.9030907@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF512410D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 11:38:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xE8Pag7WFzt5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 11:38:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EE5F40FF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 11:38:08 -0400 (EDT)
In-Reply-To: <5628F17C.9030907@linaro.org>
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
Cc: Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-10-22 at 16:23 +0200, Eric Auger wrote:
> On 10/22/2015 04:10 PM, Arnd Bergmann wrote:
> > On Thursday 22 October 2015 15:26:55 Eric Auger wrote:
> >>>> @@ -181,6 +182,8 @@ static int vfio_platform_open(void *device_data)
> >>>>                 if (ret)
> >>>>                         goto err_irq;
> >>>>  
> >>>> +               vfio_platform_get_reset(vdev);
> >>>> +
> >>>>                 if (vdev->reset)
> >>>>                         vdev->reset(vdev);
> >>>>
> >>>
> >>> This needs some error handling to ensure that the open() fails
> >>> if there is no reset handler.
> >>
> >> Is that really what we want? The code was meant to allow the use case
> >> where the VFIO platform driver would be used without such reset module.
> >>
> >> I think the imperious need for a reset module depends on the device and
> >> more importantly depends on the IOMMU mapping. With QEMU VFIO
> >> integration this is needed because the whole VM memory is IOMMU mapped
> >> but in a simpler user-space driver context, we might live without.
> >>
> >> Any thought?
> > 
> > I would think we need a reset driver for any device that can start DMA,
> > otherwise things can go wrong as soon as you attach it to a different domain
> > while there is ongoing DMA.
> > 
> > Maybe we could just allow devices to be attached without a reset handler,
> > but then disallow DMA on them?
> 
> Well I am tempted to think that most assigned devices will perform DMA
> accesses so to me this somehow comes to the same result, ie disallowing
> functional passthrough for devices not properly/fully integrated.
> 
> Alex/Baptiste, any opinion on this?

We have an IOMMU and the user doesn't get access to the device until the
IOMMU domain is established.  So, ideally yes, we should have a way to
reset the device, but I don't see it as a requirement.  Thanks,

Alex
