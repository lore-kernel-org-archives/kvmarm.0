From: Alexander Graf <agraf@suse.de>
Subject: Re: Building assigned device guest dt node from host device tree ...
Date: Tue, 1 Sep 2015 19:00:53 +0200
Message-ID: <83D37F6C-FFE9-4C3C-AA1C-F12603954C2A@suse.de>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
 <55DF07F0.3070405@linaro.org> <1440691887.20355.27.camel@redhat.com>
 <55DF45D0.5040704@linaro.org> <20150830140638.GB24113@cbox>
 <55E48897.4090907@linaro.org> <20150831173359.GA10991@cbox>
 <55E5546C.7040504@linaro.org> <20150901092813.GE10991@cbox>
 <55E5C46A.2050309@linaro.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A092448AB3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2015 13:00:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BTNlyLGUNOIE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2015 13:00:38 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47C6348A57
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2015 13:00:37 -0400 (EDT)
In-Reply-To: <55E5C46A.2050309@linaro.org>
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
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Alex Williamson <alex.williamson@redhat.com>, "eric.auger@st.com" <eric.auger@st.com>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



> Am 01.09.2015 um 17:29 schrieb Eric Auger <eric.auger@linaro.org>:
> 
> Dear all,
> 
> I am currently investigating the usage of sysfs to retrieve info from
> the host device tree to build guest dt node for assigned devices (just
> to explain a bit of context for Peter & Alex added in cc). For more
> complex devices we could typically copy host settings on guest side (mac
> @, various speeds, functional modes, ...).
> 
> This follows the "Re: [RFC PATCH v3 0/3] vfio: platform: return device
> properties for a platform device" thread.
> 
> I have some questions:
> 
> - the device directory can be somewhere in /sys/devices/platform, ie.
> can be in sub-directories. The first difficulty is to locate it. Do you
> know any C routing doing find-file matching a file name pattern? Didn't
> find any in qemu, nor in glib.

Best path imho is to have the vfio fd expose its path via an ioctl. Didn't we have that?

> 
> - I currently prototype this functionality using popen + find. That
> works but relies on "find" executable availability. Is it a valid
> assumption?

No :)

> 
> - I would need to build various utility functions such as
> read_u32_array_prop(char *path, const char *prop_name,
>                               uint32_t *props, uint32 num)
> path being the of_node directory path, prop_name being the name of the
> property to get the value; this for each type of property I need to
> fetch and assign to the guest ... Is it the right direction?

I don't know yet. Start with very specific needs for very specific devices first, create a list for your use case. Then go through each property and see whether you really need to get it from the host and how many there really are.

Alex

> 
> Putting things on kernel - VOSYS approach - and exposing new VFIO IOTCL
> enable to use std kernel APIs and remove the problem of finding data on
> the fs ...
> 
> Please advise on the direction to follow, continue exploring the sysfs
> method or revert to VOSYS approach?
> 
> Thank you in advance
> 
> Best Regards
> 
> Eric
> 
> 
> 
>> On 09/01/2015 11:28 AM, Christoffer Dall wrote:
>> Hi Eric,
>> 
>> On Tue, Sep 01, 2015 at 09:31:56AM +0200, Eric Auger wrote:
>> 
>> [...]
>> 
>>>>>> Can you reiterate why QEMU and VFIO don't already have the information
>>>>>> necessary to setup resources and present a DT to the guest that the
>>>>>> guest can use?
>>>>> A vfio-platform driver was bound to the passthrough'ed device. QEMU
>>>>> current knows the compat string of the device and the node's name and
>>>>> that's it.
>>>>> 
>>>>> The VFIO platform driver currently does not allow to return device
>>>>> specific information. It just returns generic info such as resource
>>>>> info. The driver is HW agnostic.
>>>>> 
>>>>> 
>>>>> The QEMU VFIO device should be able to check some characteristics of the
>>>>> host device tree. Typically if the host node does not comply with some
>>>>> constraints it may not be possible to assign the device.
>>>>> 
>>>>> We do not want the QEMU end-user to have in-depth knowledge of the HW so
>>>>> passing the info in the QEMU command line does not sound to be the good
>>>>> solution.
>>>>> 
>>>>> 
>>>>> As you mentioned /proc/device-tree depends on kernel option. I am able
>>>>> to find the properties in sysfs too but can we systematically rely on
>>>>> sysfs (CONFIG_SYSFS)? Also I would have expected the values to be human
>>>>> readable but they are not. Currently investigating open/read from qemu
>>>>> but is better than an ioctl API? ...
>>>> Yeah it does, but I thought we originally planned that the driver for a
>>>> specific platform device in QEMU should know these details,
>>> Yes that's the objective to put this intelligence in the QEMU VFIO
>>> device or more precisely in the associated function that builds its
>>> guest dt node.
>>> 
>>> Let's take an example. Assuming an xgmac supports different speeds, you
>>> need to set those on guest. Either you put arbitrary values or you reuse
>>> the values that were set on host. Typically some values may not be
>>> supported by the HW.
>> 
>> I see.  I'm no expert here, but I could imagine that drivers could
>> overwrite some things in the DT or do some advanced probing of the
>> hardware which is then only exported in the sysfs and not the DT, so I
>> would go the sysfs approach myself.
>> 
>>> Idea of genericity was ruled out indeed meaning each device needs to
>>> have a specialized QEMU VFIO device and an associated dt node creation
>>> function. Now this does not prevent from exploiting host dt information.
>>> Does that make sense?
>> Yes, thanks for the explanation.
>> 
>> -Christoffer
> 
