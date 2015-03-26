From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 06/12] KVM: mark kvm->buses as empty once they were
 destroyed
Date: Thu, 26 Mar 2015 12:41:13 +0000
Message-ID: <5513FE69.9050401@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
 <1427126309-11223-7-git-send-email-andre.przywara@arm.com>
 <5512EBB9.2050304@arm.com> <20150325215940.GE3649@amt.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE4949BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 08:34:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKfRE5sJVPQL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 08:34:17 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2651449BD9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 08:34:16 -0400 (EDT)
In-Reply-To: <20150325215940.GE3649@amt.cnet>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marcelo Tosatti <mtosatti@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marcelo,

On 25/03/15 21:59, Marcelo Tosatti wrote:
> On Wed, Mar 25, 2015 at 05:09:13PM +0000, Marc Zyngier wrote:
>> On 23/03/15 15:58, Andre Przywara wrote:
>>> In kvm_destroy_vm() we call kvm_io_bus_destroy() pretty early,
>>> especially before calling kvm_arch_destroy_vm(). To avoid
>>> unregistering devices from the already destroyed bus, let's mark
>>> the bus with NULL to let other users know it has been destroyed
>>> already.
>>> This avoids a crash on a VM shutdown with the VGIC using the
>>> kvm_io_bus later (the unregistering is in there to be able to roll
>>> back a faulting init).
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>
>> That seems sensible, but I don't see why nobody else hits that. What are
>> we doing differently?

So I checked the other users of kvm_io_bus, none of them seems to
explicitly unregister the kvm_io_bus devices they registered before if
the VM goes down. They all rely on the whole kvm_io_bus being brought
down eventually, so there is no need for an explicit unregister.
The only point they do unregister is when cleaning up after init fails
in the middle.
So I changed my code to match that behaviour: cleaning up in init and
leaving the VM destruction case alone.
This lets me get rid of that patch and actually removes more code in one
of the following patches.

> It should be valid to call kvm_io_bus_unregister_dev after
> kvm_io_bus_destroy.

AFAICS it's not.
kvm_io_bus_unregister_dev reads like this:
        bus = kvm->buses[bus_idx];
        r = -ENOENT;
        for (i = 0; i < bus->dev_count; i++)
So having the actual bus freed already before would lead to an invalid
dereference. As stated above no-one seems to use it like this at the
moment. Shall I make a (separate) patch to fix that theoretical case?
Setting the pointer values to NULL after kfree() and checking them in
kvm_io_bus_unregister_dev()? What about other functions using the buses?

> 
> Are you patching it to handle NULL kvm->buses[bus_idx] ?

No, I handle this is my VGIC clean up function, so that it doesn't try
to call kvm_io_bus_unregister_dev if the bus is already down. But that
will go away with the change mentioned above.

I will check back with Marc how to actually merge those fixes in.

Cheers,
Andre.
