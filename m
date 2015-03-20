From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 08/12] KVM: arm/arm64: implement kvm_io_bus MMIO handling
 for the VGIC
Date: Fri, 20 Mar 2015 12:40:02 +0000
Message-ID: <550C1522.80105@arm.com>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-9-git-send-email-andre.przywara@arm.com>
 <20150314142720.GD10935@cbox> <550AEEF3.80702@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112CF494AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2015 08:33:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6sJj-Uc-DJ0n for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2015 08:33:45 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A90D494AB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2015 08:33:44 -0400 (EDT)
In-Reply-To: <550AEEF3.80702@arm.com>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/19/2015 03:44 PM, Andre Przywara wrote:
> Hej Christoffer,
> 

[ ... ]

>>> +static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
>>> +				   struct kvm_io_device *this, gpa_t addr,
>>> +				   int len, void *val, bool is_write)
>>> +{
>>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>> +	struct vgic_io_device *iodev = container_of(this,
>>> +						    struct vgic_io_device, dev);
>>> +	struct kvm_run *run = vcpu->run;
>>> +	const struct vgic_io_range *range;
>>> +	struct kvm_exit_mmio mmio;
>>> +	bool updated_state;
>>> +	gpa_t offset;
>>> +
>>> +	offset = addr - iodev->addr;
>>> +	range = vgic_find_range(iodev->reg_ranges, len, offset);
>>> +	if (unlikely(!range || !range->handle_mmio)) {
>>> +		pr_warn("Unhandled access %d %08llx %d\n", is_write, addr, len);
>>> +		return -ENXIO;
>>> +	}
>>> +
>>> +	mmio.phys_addr = addr;
>>> +	mmio.len = len;
>>> +	mmio.is_write = is_write;
>>> +	if (is_write)
>>> +		memcpy(mmio.data, val, len);
>>> +	mmio.private = iodev->redist_vcpu;
>>> +
>>> +	spin_lock(&dist->lock);
>>> +	offset -= range->base;
>>> +	if (vgic_validate_access(dist, range, offset)) {
>>> +		updated_state = call_range_handler(vcpu, &mmio, offset, range);
>>> +		if (!is_write)
>>> +			memcpy(val, mmio.data, len);
>>> +	} else {
>>> +		if (!is_write)
>>> +			memset(val, 0, len);
>>> +		updated_state = false;
>>> +	}
>>> +	spin_unlock(&dist->lock);
>>> +	kvm_prepare_mmio(run, &mmio);
>>
>> we're not the only user of kvm_exit_mmio I believe, so we could rename
> 
> (assuming you mean we _are_ the only user here, which I can acknowledge)
> 
>> this to vgic_io as well and you could change the mmio.data array to be a
>> void *val pointer, which just gets set to the pointer passed into this
>> function (which I think points to the kvm_run structs data array) and
>> you can avoid all these memcopies, right?
> 
> That sounds indeed tempting, but the comment on the struct kvm_exit_mmio
> declaration reads:
> /*
>  * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
>  * which is an anonymous type. Use our own type instead.
>  */
> How I understand this the structure was introduced to _not_ use the same
> memory, but use a copy instead. Do you remember any reason for this? And
> in how far is this type anonymous? It's even in an uapi header.
> 
> Briefly looking at the code we do quite some memcpy on the way.
> I am about to go all the way down into that ARM MMIO handling cave now
> to check this (Marc, if I am not showing up again after some hours,
> please come and rescue me ;-)

So, I feel that there is quite some unneeded copying and masking on the
way, but a real fix would be quite invasive and needs quite some testing
and review. I don't feel like rushing this into a v2 of this series.
I quickly did what you proposed (replacing memcpy by pointer
assignment), and that seems to work, but I don't have many chances of
testing this this weekend, since I am on the road. Also I have to dig
out my cross-endian test scripts first. So not sure if you want to take
the risk with this series.
I changed the other minor points you mentioned in the review though, so
do you want to have a "v1.5" or how do we proceed from here?

Cheers,
Andre.
