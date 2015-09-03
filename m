From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
 a platform device
Date: Thu, 03 Sep 2015 18:46:49 +0200
Message-ID: <55E87979.9060604@linaro.org>
References: <1440691887.20355.27.camel@redhat.com>	<55DF45D0.5040704@linaro.org>	<20150830140638.GB24113@cbox>	<55E48897.4090907@linaro.org>	<20150831173359.GA10991@cbox>	<55E5546C.7040504@linaro.org>	<20150901092813.GE10991@cbox>	<CAN9JPjGfuv_YOBEdZA_AD13oHej7wMCR50=zQTZmgzHx-jBj_A@mail.gmail.com>	<20150901155205.GA19385@cbox>	<CAN9JPjFwsiYzR6RtDA-5UZYoNALGu8crXVyA+m6ptsWv=qJi5A@mail.gmail.com>	<20150902092128.GG10991@cbox>	<CAN9JPjHzPFC1LMuEneXXSYRs1bTXJHZmB6E8Dy+Fp=XRPScEEw@mail.gmail.com>	<1441212724.20355.306.camel@redhat.com>
 <CAN9JPjF0Lex2wD=_iiriTaYdukva+rxhdwPTQnGqC5kQFCEYGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DE514141D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:47:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GEsk6B7JGhmb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2015 12:47:16 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 498C9412FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:47:15 -0400 (EDT)
Received: by wiclk2 with SMTP id lk2so14700805wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2015 09:47:39 -0700 (PDT)
In-Reply-To: <CAN9JPjF0Lex2wD=_iiriTaYdukva+rxhdwPTQnGqC5kQFCEYGg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Baptiste Reynal <b.reynal@virtualopensystems.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Dear all,
On 09/03/2015 09:42 AM, Baptiste Reynal wrote:
> On Wed, Sep 2, 2015 at 6:52 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
>> On Wed, 2015-09-02 at 11:49 +0200, Baptiste Reynal wrote:
>>> On Wed, Sep 2, 2015 at 11:21 AM, Christoffer Dall
>>> <christoffer.dall@linaro.org> wrote:
>>>> On Wed, Sep 02, 2015 at 09:21:26AM +0200, Baptiste Reynal wrote:
>>>>> On Tue, Sep 1, 2015 at 5:52 PM, Christoffer Dall
>>>>> <christoffer.dall@linaro.org> wrote:
>>>>>> On Tue, Sep 01, 2015 at 05:32:21PM +0200, Baptiste Reynal wrote:
>>>>>>> Hi everyone,
>>>>>>>
>>>>>>> The usefullness of this patch has already been discussed during the
>>>>>>> first releases (http://lists.linuxfoundation.org/pipermail/iommu/2014-August/009586.html).
>>>>>>> I underline the fact that it avoids implementing the logic on the
>>>>>>> userspace program, as VFIO can be used for many usage (userspace
>>>>>>> drivers and device assignment).
>>>>>>>
>>>>>>> If you're interested in the implementation on the userspace side, an
>>>>>>> RFC has been suggested for QEMU:
>>>>>>> http://lists.gnu.org/archive/html/qemu-devel/2015-01/msg01211.html
>>>>>>
>>>>>> This one-year-old discussion is hardly exhaustive.
>>>>>>
>>>>>> I think you missed the gist of the question for Eric a bit as well.
>>>>>>
>>>>>> One important question for me is whether seeing the host DT is always
>>>>>> sufficient or if the kernel and physical device driver can have more
>>>>>> information about the device and its configuration which userspace may
>>>>>> need, which cannot be directly read in the DT (for example because the
>>>>>> driver has initialized the device in a specific way).  My point is, it's
>>>>>> really not about DT-specific things (what if you used ACPI?), but it's
>>>>>> about retrieving properties of a device and its configuration from
>>>>>> userspace.
>>>>>>
>>>>>> Have we thought about the possible ways to achieve this and weight one
>>>>>> option against the other?
>>>>>
>>>>> Problem is that now we only have a very few platform devices behind an
>>>>> IOMMU, so we don't have the visibility to know if such a case will
>>>>> occur. With the current use cases, the interface seems to be
>>>>> sufficient.
>>>>
>>>> Ideally we can think about future use cases based on the experience of
>>>> people in the community and come up with a solution considering future
>>>> use cases.
>>>>
>>>>> By using IOCTL, we can always change the implementation
>>>>> later without any change on the userspace.
>>>>
>>>> Can you be more concrete with what you mean here?
>>>>
>>>
>>> By using an IOCTL, we define an API that allows to retrieve device
>>> properties from userspace. The way it is retrieved is handled by the
>>> kernel (For example for now if OF is unavailable, the kernel will
>>> retrieve the property using ACPI) and is totally transparent from the
>>> userspace point of view.
>>>
>>> My point is that we can go with the current naive implementation for
>>> now, and we might extend it later according to the needs of future
>>> devices, without changing anything from the userspace point of view.
>>
>> I don't really like "ioctl" and "naive implementation" in the same
>> thought.  The ioctl itself needs to be well thought out for current and
>> future needs, including independence from the source data type
>> (OF/DT/ACPI/etc), proven that it's necessary, it's not redundant to
>> existing interfaces, and vfio should be the one hosting it.  Thanks,
>>
> 
> The word we used, naive, does not mean a bad implementation of the
> IOCTL interface but rather it was referring to the fact that at this
> moment we export 1-to-1 the information available in the device tree
> via sys or proc file system. So one could obtain the same result
> without such interface, however our implementation is aready
> independent from the source of such information, since OF and ACPI are
> supported already, and there will be no problem in extending the
> interface to support more.
I rebooted my host in ACPI mode and I am not able to find the attribute
files anymore in sysfs. the of_node directory where the files were
located does not exist anymore (/sys/firmware/devicetree/base) and I
wonder whether we can get access to those same info somewhere in sysfs
(/sys/firmware). Obviously they are in the ACPI tables but ... Alex do
you know how it works on x86?

So I wonder whether the userspace has a unified way to fetch data in
sysfs whatever the type of HW description (DT, ACPI) or at least if it
not a unified way whether he have a simple way to achieve that on userspace.

As opposed to that the kernel offers that feature through the unified
device properties API, the one used in this series.

Best Regards

Eric
> 
> The next release will take into account your comments about argsz and flags.
> 
> Regards,
> Baptiste
> 
>> Alex
>>
