From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for a
 platform device
Date: Mon, 5 Oct 2015 12:04:00 +0200
Message-ID: <CAN9JPjH7m28Y8U+xuN91MOro_2qfRz53uOmQ2kCUpfp-eoM4dg@mail.gmail.com>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
 <1443814099.26107.124.camel@redhat.com>
 <20151002202844.GD32011@cbox>
 <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
 <CAN9JPjF+gYJaxm1kO5c4Swps4TDKrHxJ3v-NP2D_YzEghkn1DA@mail.gmail.com>
 <20151005095325.GG9011@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D221041291
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 06:02:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MjVA16h4R9e7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 06:02:10 -0400 (EDT)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
 [209.85.192.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 024EC4117C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 06:02:09 -0400 (EDT)
Received: by qgx61 with SMTP id 61so144960597qgx.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Oct 2015 03:04:01 -0700 (PDT)
In-Reply-To: <20151005095325.GG9011@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, Linux IOMMU <iommu@lists.linux-foundation.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 5, 2015 at 11:53 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> [why are you top-posting?]
>
> On Mon, Oct 05, 2015 at 11:42:38AM +0200, Baptiste Reynal wrote:
>> In this patch series we want to wrap an already available kernel
>> interface to expose a device property to userspace,
>
> which 'already available kernel interface' is that exactly?

We use the unified device property interface.

>
>> in order to keep
>> the code lighter on the userspace. We need those properties in VFIO as
>
> I'm not sure I agree with your 'need those properties in VFIO' statement
> here, can you elaborate?
>

For device assignment, we need to transfer those properties to the
guest in order to fully exploit the device (and not simply transfer
generic properties for a given device).

The example I have in mind is the PL330 which can have optionnal
properties, as described in
Documentation/devicetree/bindings/dma/arm-pl330.txt

>> VFIO grants the possibility to develop userspace drivers.
>>
>> The sysfs doesn't seems to be ready for this kind of usage. We can
>> only find raw data that require heavy parsing. Here we retrieve
>> directly usable data and it can be extended later according to new
>> needs (as it is already done with ACPI).
>
> Why couldn't you expose this kind of data through sysfs instead of VFIO
> and independently of VFIO?  Would that be more wrong/difficult/whatever?
>

This has been bound to VFIO as we needed it for VFIO, but I don't see
any reasons not to expose it somewhere else if it may be reused.

>>
>> This interface has been developed for VFIO and is currently bound to
>> it, though there is no special dependencies with it. We could make it
>> more generic, but I can only think of VFIO to use it.
>
> Thanks,
> -Christoffer
