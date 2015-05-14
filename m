From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 14:28:49 +0200
Message-ID: <55549501.2010000@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
 <20150514112910.GR32765@cbox> <55548777.9000702@redhat.com>
 <20150514113634.GS32765@cbox> <5554893E.4030105@redhat.com>
 <20150514120039.GU32765@cbox> <55549051.1090007@redhat.com>
 <20150514122413.GV32765@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B2C514B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:19:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cEgjrpXmv8+V for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 08:19:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC40D514AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:19:49 -0400 (EDT)
In-Reply-To: <20150514122413.GV32765@cbox>
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
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Laszlo Ersek <lersek@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 14/05/2015 14:24, Christoffer Dall wrote:
> On Thu, May 14, 2015 at 02:08:49PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 14/05/2015 14:00, Christoffer Dall wrote:
>>> So, getting back to my original question.  Is the point then that UEFI
>>> must assume (from ACPI/DT) the cache-coherency properties of the PCI
>>> controller which exists in hardware on the system you're running on,
>>> even for the virtual PCI bus because that will be the semantics for
>>> assigned devices?
>>>
>>> And in that case, we have no way to distinguish between passthrough
>>> devices and virtual devices plugged into the virtual PCI bus?
>>
>> Well, we could use the subsystem id.  But it's a hack, and may cause
>> incompatibilities with some drivers.  Michael, any ideas?
>>
>>> What about the idea of having two virtual PCI buses on your system where
>>> one is always cache-coherent and uses for virtual devices, and the other
>>> is whatever the hardware is and used for passthrough devices?
>>
>> I think that was rejected before.
> 
> Do you remember where?  I just remember Catalin mentioning the idea to
> me verbally.

In the last centithread on the subject. :)

At least I and Peter disagreed.  It's not about the heavy added use of
resources, it's more about it being really easy to misconfigure.

> But I'm still not sure why UEFI/Linux currently sees our PCI bus as
> being non-coherent when in fact it is and we have no passthrough issues
> currently.  Are all PCI controllers always non-coherent for some reason
> and therefore we model it as such too?

Well, PCI BARs are generally MMIO resources, and hence should not be cached.

As an optimization, OS drivers can mark them as cacheable or
write-combining or something like that, but in general it's a safe
default to leave them uncached---one would think.

Paolo
