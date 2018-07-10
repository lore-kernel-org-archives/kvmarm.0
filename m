From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 6/6] KVM: arm/arm64: vgic: Allow configuration of
 interrupt groups
Date: Tue, 10 Jul 2018 09:33:50 +0100
Message-ID: <51bb02d7-61d8-41bc-33e2-342364f659b5@arm.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
 <1530697100-22419-7-git-send-email-christoffer.dall@arm.com>
 <7f875ead-d3cb-1fec-bc84-56e64526e6a7@arm.com>
 <20180709224836.GA26579@u002843.usa.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA5949EA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 04:21:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id byifDo79es7Z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 04:21:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D106540196
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 04:21:10 -0400 (EDT)
In-Reply-To: <20180709224836.GA26579@u002843.usa.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/18 23:48, Christoffer Dall wrote:
> On Mon, Jul 09, 2018 at 09:42:40AM +0100, Marc Zyngier wrote:
>> On 04/07/18 10:38, Christoffer Dall wrote:
>>> Implement the required MMIO accessors for GICv2 and GICv3 for the
>>> IGROUPR distributor and redistributor registers.
>>>
>>> This can allow guests to change behavior compared to running on previous
>>> versions of KVM, but only to align with the architecture and hardware
>>> implementations.
>>>
>>> This also allows userspace to configure the groups for interrupts.  Note
>>> that this potentially results in GICv2 guests not receiving interrupts
>>> after migration if migrating from an older kernel that exposes GICv2
>>> interrupts as group 1.
>>>
>>> Cc: Andrew Jones <drjones@redhat.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>> I implemented (but stashed) a version of this which predicated the
>>> behavior based on the value of GICD_IIDR revision field, falling back to
>>> ignoring writes and resetting GICv2 groups to 0 if the guest wrote a
>>> revision less than 2.  However, current QEMU implementations simply
>>> don't write the GICD_IIDR, so this doesn't help at all without changing
>>> QEMU anyhow.
>>>
>>> The only actual fix I can see here to work around the problem in the
>>> kernel is to require an opt-in to allow restoring groups from userspace,
>>> but that's a lot of logic to support cross-kernel version migration.
>>>
>>> Question: Do we expect that cross-kernel version migration is a critical
>>> feature that people really expect to work, and do we actually have
>>> examples of catering to this in the kernel elsewhere?  (Also, how would
>>> then that relate to the whole 'adding a new sysreg breaks migration'
>>> situation?)
>>
>> I don't really get why QEMU doesn't try to restore GICD_IIDR, while it
>> is definitely trying to restore RO sysregs (and that's how we detect
>> incompatibilities).
>>
>> I think we should at least give userspace a chance to do the right
>> thing. If it doesn't, well, too bad.
> 
> This series should give userspace an option to adjust its behavior.
> 
> My main concern is that this version of the series results in the worst
> kind of migration failures, where the guest simply doesn't run on the
> destination side with no warnings or error messages returned to the
> user..

I agree, which is why I'm suggesting we make IIDR writeable. And yes, it
still requires userspace to be fixed to actually write IIDR.

> 
> We could add logic to return an error code if trying to write a
> different revision than what the kernel has (similar to the invariant
> sysregs), so that a simple fix to QEMU to save restore the GICD_IIDR
> register at least results in an error being returned to userspace.
> 
> However, as QEMU doesn't do anything useful here today (not blaming
> anyone, I wrote the apparently broken GIC save/restore code for QEMU
> myself), we could also argue that QEMU might as well just fix things up
> if it detects a different IIDR.
> 
>>
>> How bad is that "writable GICD_IIDR" patch? Because at this stage, and
>> in the absence of any comment, I'm close to just pick that series and
>> merge it for 4.19.
>>
> 
> My guess is that a patch to "save/restore GICD_IIDR" is simple enough,
> but requires additional logic in the kernel that returns an error if the
> GICD_IIDR don't match on write.
> 
> A patch which changes the groups and bumps the IIDR in userspace is
> probably more complex.
> 
> Sounds like I should add the GICD_IIDR checking patch.  Thoughts?

I'm quite keen on that. It makes the userspace change trivial, aligns it
somehow on the sysreg and ITS ABI behaviours.

> What I would really like to know is whether this is really an issue or
> not.  Do people who run products based on KVM, such as RHEV, have any
> expectations about cross-kernel version migration?

I'd like to know as well.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
