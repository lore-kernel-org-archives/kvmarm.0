From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 06/12] KVM: arm64: implement basic ITS register handlers
Date: Fri, 3 Jun 2016 16:42:34 +0100
Message-ID: <3cd7a371-8fc6-b4e7-f034-2a0d4d4719f1@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-7-git-send-email-andre.przywara@arm.com>
 <5706704C.5060307@arm.com> <671b7144-7929-df7b-14f4-20dc6a32abdb@arm.com>
 <5746BD87.9060206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B35EE412C2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 11:37:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8YOSyoLc-npp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 11:37:51 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F02541267
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 11:37:50 -0400 (EDT)
In-Reply-To: <5746BD87.9060206@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I addressed some comments of yours in v5, just some rationale for the
others (sorry for the late reply on these!):

...

>>>> +static int vgic_mmio_read_its_typer(struct kvm_vcpu *vcpu,
>>>> +				    struct kvm_io_device *this,
>>>> +				    gpa_t addr, int len, void *val)
>>>> +{
>>>> +	u64 reg = GITS_TYPER_PLPIS;
>>>> +
>>>> +	/*
>>>> +	 * We use linear CPU numbers for redistributor addressing,
>>>> +	 * so GITS_TYPER.PTA is 0.
>>>> +	 * To avoid memory waste on the guest side, we keep the
>>>> +	 * number of IDBits and DevBits low for the time being.
>>>> +	 * This could later be made configurable by userland.
>>>> +	 * Since we have all collections in linked list, we claim
>>>> +	 * that we can hold all of the collection tables in our
>>>> +	 * own memory and that the ITT entry size is 1 byte (the
>>>> +	 * smallest possible one).
>>>
>>> All of this is going to bite us when we want to implement migration,
>>> specially the HW collection bit.
>>
>> How so? Clearly we keep the number of VCPUs constant, so everything
>> guest visible stays the same even upon migrating to a much different
>> host? Or are we talking about different things here?
> 
> Let me rephrase this: How are you going to address HW collections from
> userspace in order to dump them? Short of having memory tables, you cannot.

I was just hoping for addressing first things first. Having the
collection table entirely in the kernel makes things easier for now.

How is that save/restore story covered by a hardware ITS? Is it just
ignored since it's not needed/used there?

That being said I would be happy to change this when we get migration
support for the ITS register state and we have agreed on an API for
userland ITS save/restore.

>>>
>>>> +	 */
>>>> +	reg |= 0xff << GITS_TYPER_HWCOLLCNT_SHIFT;
>>>> +	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
>>>> +	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
>>>> +
>>>> +	write_mask64(reg, addr & 7, len, val);
>>>> +
>>>> +	return 0;
>>>> +}

.....

>>>> +static int vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
>>>> +				     struct kvm_io_device *this,
>>>> +				     gpa_t addr, int len, void *val)
>>>> +{
>>>> +	struct vgic_io_device *iodev = container_of(this,
>>>> +						    struct vgic_io_device, dev);
>>>> +	u32 reg = 0;
>>>> +	int idreg = (addr & ~3) - iodev->base_addr + GITS_IDREGS_BASE;
>>>> +
>>>> +	switch (idreg) {
>>>> +	case GITS_PIDR2:
>>>> +		reg = GIC_PIDR2_ARCH_GICv3;
>>>
>>> Are we leaving the lowest 4 bits to zero?
>>
>> I couldn't stuff "42" in 4 bits, so: yes ;-)
> 
> The 4 bottom bits are "Implementation Defined", so you could fit
> something in it if you wanted.
> 
>>
>>>> +		break;
>>>> +	case GITS_PIDR4:
>>>> +		/* This is a 64K software visible page */
>>>> +		reg = 0x40;
>>>
>>> Same question.
>>>
>>> Also, how about all the others PIDR registers?
>>
>> I guess I was halfway undecided between going with the pure
>> architectural requirements (which only mandate bits 7:4 in PIDR2) and
>> complying with the recommendation later in the spec.
>> So I will just fill PIDR0, PIDR2 and the rest of PIDR2 as well.
>>
>>>> +		break;
>>>> +	/* Those are the ID registers for (any) GIC. */
>>>> +	case GITS_CIDR0:
>>>> +		reg = 0x0d;
>>>> +		break;
>>>> +	case GITS_CIDR1:
>>>> +		reg = 0xf0;
>>>> +		break;
>>>> +	case GITS_CIDR2:
>>>> +		reg = 0x05;
>>>> +		break;
>>>> +	case GITS_CIDR3:
>>>> +		reg = 0xb1;
>>>> +		break;
>>>> +	}
>>>
>>> Given that these values are directly taken from the architecture, and
>>> seem common to the whole GICv3 architecture when implemented by ARM, we
>>> could have a common handler for the whole GICv3 implementatuin. Not a
>>> bit deal though.

I tried it, but it turned out to be more involved than anticipated, so I
shelved it for now. I can make a patch on top later.

>>
>> Agreed.
>>
>>>> +
>>>> +	write_mask32(reg, addr & 3, len, val);
>>>> +
>>>> +	return 0;
>>>> +}

....

>>>> +/*
>>>> + * By writing to CWRITER the guest announces new commands to be processed.
>>>> + * Since we cannot read from guest memory inside the ITS spinlock, we
>>>> + * iterate over the command buffer (with the lock dropped) until the read
>>>> + * pointer matches the write pointer. Other VCPUs writing this register in the
>>>> + * meantime will just update the write pointer, leaving the command
>>>> + * processing to the first instance of the function.
>>>> + */
>>>> +static int vgic_mmio_write_its_cwriter(struct kvm_vcpu *vcpu,
>>>> +				       struct kvm_io_device *this,
>>>> +				       gpa_t addr, int len, const void *val)
>>>> +{
>>>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>> +	struct vgic_its *its = &dist->its;
>>>> +	gpa_t cbaser = its_cmd_buffer_base(vcpu->kvm);
>>>> +	u64 cmd_buf[4];
>>>> +	u32 reg;
>>>> +	bool finished;
>>>> +
>>>> +	reg = mask64(its->cwriter & 0xfffe0, addr & 7, len, val);
>>>> +	reg &= 0xfffe0;
>>>> +	if (reg > its_cmd_buffer_size(vcpu->kvm))
>>>> +		return 0;
>>>> +
>>>> +	spin_lock(&its->lock);
>>>> +
>>>> +	/*
>>>> +	 * If there is still another VCPU handling commands, let this
>>>> +	 * one pick up the new CWRITER and process "our" new commands as well.
>>>> +	 */
>>>
>>> How do you detect that condition? All I see is a massive race here, with
>>> two threads processing the queue in parallel, possibly corrupting each
>>> other's data.
>>>
>>> Please explain why you think this is safe.
>>
>> OK, here you go: Actually we are handling the command queue
>> synchronously: The first writer to CWRITER will end up here and will
>> iterate over all commands below. From the guests point of view it will
>> take some time to do the CWRITER MMIO write, but upon the writel
>> returning the queue is actually already empty again.
>> That means that any _sane_ guest will _never_ trigger the case where two
>> threads/VCPUs are handling the queue, because a concurrent write to
>> CWRITER without a lock in the guest would be broken by design.
> 
> That feels very fragile, and you're relying on a well behaved guest.

No, I don't rely on it, as mentioned in the next sentence.
I just don't optimize for that case, because in reality it should never
happen - apart from a malicious guest. Let me think about the security
implications, though (whether a misbehaved guest could hog a physical CPU).

>> However I am not sure we can rely on this, so I added this precaution
>> scheme:

>> The first writer takes our ITS (emulation) lock and examines cwriter and
>> creadr to see if they are equal. If they are, then the queue is
>> currently empty, which means we are the first one and need to take care
>> of the commands. We update our copy of cwriter (now marking the queue as
>> non-empty) and drop the lock. As we kept the queue-was-empty status in a
>> local variable, we now can start iterating through the queue. We only
>> take the lock briefly when really needed in this process (for instance
>> when one command has been processed and creadr is incremented).
>>
>> If now a second VCPU writes CWRITER, we also take the lock and compare
>> creadr and cwriter. Now they are different, because the first thread is
>> still busy with handling the commands and hasn't finished yet.
>> So we set our local "finished" to true. Also we update cwriter to the
>> new value, then drop the lock. The while loop below will not be entered
>> in this thread and we return to the guest.
>> Now the first thread has handled another command, takes the lock to
>> increase creadr and compares it with cwriter. Without the second writer
>> it may have been finished already, but now cwriter has grown, so it will
>> just carry on with handling the commands.
>>
>> A bit like someone washing the dishes while another person adds some
>> more dirty plates to the pile ;-)
> 
> I'm sorry, this feels incredibly complicated, and will make actual
> debugging/tracing a nightmare. It also penalize the first vcpu that gets
> to submitting a command, leading to scheduling imbalances.

Well, as mentioned that would never happen apart from that
malicious/misbehaved guest case - so I don't care so much about
scheduling imbalances _for the guest_. As said above I have to think
about how this affects the host cores, though.

And frankly I don't see how this is overly complicated (in the context
of SMP locking schemes in general) - apart from me explaining it badly
above. It's just a bit tricky, but guarantees a strict order of command
processing.
On another approach we could just qualify a concurrent access as illegal
and ignore it - on real hardware you would have no guarantee for this to
work either - issuing two CWRITER MMIO writes at the same time would
just go bonkers.

> Why can't you simply turn the ITS lock into a mutex and keep it held,
> processing each batch in the context of the vcpu that is writing to
> GITC_CWRITER?

Frankly I spent quite some time to make this locking more fine grained
after some comments on earlier revisions - and I think it's better now,
since we don't hog all of the ITS data structures during the command
processing. Pessimistically one core could issue a big number of
commands, which would block the whole ITS.
Instead MSI injections happening in parallel now have a good chance of
iterating our lists and tables in between. This should improve scalability.

Thanks,
Andre.
