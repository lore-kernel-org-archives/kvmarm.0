From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
 a platform device
Date: Tue, 01 Sep 2015 09:31:56 +0200
Message-ID: <55E5546C.7040504@linaro.org>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
 <55DF07F0.3070405@linaro.org> <1440691887.20355.27.camel@redhat.com>
 <55DF45D0.5040704@linaro.org> <20150830140638.GB24113@cbox>
 <55E48897.4090907@linaro.org> <20150831173359.GA10991@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB90848B05
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2015 03:32:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kYmmdOVr2HCr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2015 03:32:29 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 836B248AB0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2015 03:32:29 -0400 (EDT)
Received: by wibz8 with SMTP id z8so22035678wib.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Sep 2015 00:32:45 -0700 (PDT)
In-Reply-To: <20150831173359.GA10991@cbox>
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
Cc: iommu@lists.linux-foundation.org, Alex Williamson <alex.williamson@redhat.com>, tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/31/2015 07:33 PM, Christoffer Dall wrote:
> On Mon, Aug 31, 2015 at 07:02:15PM +0200, Eric Auger wrote:
>> Hi Christoffer,
>> On 08/30/2015 04:06 PM, Christoffer Dall wrote:
>>> Hi Eric,
>>>
>>> On Thu, Aug 27, 2015 at 07:16:00PM +0200, Eric Auger wrote:
>>>> Hi Alex,
>>>> On 08/27/2015 06:11 PM, Alex Williamson wrote:
>>>>> On Thu, 2015-08-27 at 14:52 +0200, Eric Auger wrote:
>>>>>> Hi Baptiste, Antonios,
>>>>>>
>>>>>> What are the plans wrt this series? I am currently integrating another
>>>>>> QEMU VFIO platform devices where this series could be useful I think
>>>>>> (Feb 2015). Do you intend to follow up and bring it upstream?
>>>>>>
>>>>>> Alex, do you see some show-stoppers in this series or do you advise to
>>>>>> simply follow-up?
>>>>>
>>>>> I'm at a bit of a disadvantage not really knowing what types of
>>>>> properties a user will be able to retrieve here.  The interface itself
>>>>> seems sort of like a game of Go Fish.  Should the properties we're
>>>>> looking for be generally available via sysfs?  The ioctl proposed needs
>>>>> some work to fit within the argsz/flags model that vfio typically uses.
>>>>> It's unclear what argsz vs length represents and defining the flags
>>>>> field as 'type' limits the future extensions of the ioctl.  Thanks,
>>>>
>>>> The properties that I need can be found in /proc/device-tree too. They
>>>> are of different types, with void cell value, with string cell
>>>> values(single & multiple), with integer cell value(s), array ...
>>>>
>>>> The aim is to be able to assign a highly configurable platform device to
>>>> a guest, read some property values on host and write the same values in
>>>> guest dt node.
>>>>
>>> Can you reiterate why QEMU and VFIO don't already have the information
>>> necessary to setup resources and present a DT to the guest that the
>>> guest can use?
>> A vfio-platform driver was bound to the passthrough'ed device. QEMU
>> current knows the compat string of the device and the node's name and
>> that's it.
>>
>> The VFIO platform driver currently does not allow to return device
>> specific information. It just returns generic info such as resource
>> info. The driver is HW agnostic.
>>
>>
>> The QEMU VFIO device should be able to check some characteristics of the
>> host device tree. Typically if the host node does not comply with some
>> constraints it may not be possible to assign the device.
>>
>> We do not want the QEMU end-user to have in-depth knowledge of the HW so
>> passing the info in the QEMU command line does not sound to be the good
>> solution.
>>
>>
>> As you mentioned /proc/device-tree depends on kernel option. I am able
>> to find the properties in sysfs too but can we systematically rely on
>> sysfs (CONFIG_SYSFS)? Also I would have expected the values to be human
>> readable but they are not. Currently investigating open/read from qemu
>> but is better than an ioctl API? ...
>>
> Yeah it does, but I thought we originally planned that the driver for a
> specific platform device in QEMU should know these details,
Yes that's the objective to put this intelligence in the QEMU VFIO
device or more precisely in the associated function that builds its
guest dt node.

Let's take an example. Assuming an xgmac supports different speeds, you
need to set those on guest. Either you put arbitrary values or you reuse
the values that were set on host. Typically some values may not be
supported by the HW.

Idea of genericity was ruled out indeed meaning each device needs to
have a specialized QEMU VFIO device and an associated dt node creation
function. Now this does not prevent from exploiting host dt information.
Does that make sense?

Eric
 and that you
> simply have to add code for each supported device, instead of trying to
> solve this generically.  (It was never the user who should supply it on
> the command line).  But perhaps we moved on from our original idea?
> 
> I think relying on sysfs is probably reasonable, but I'm really not an
> expert in the right ways here.
> 
> Thanks,
> -Christoffer
> 
