From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 03/12] KVM: arm/arm64: Record RDIST Last bit at registration
Date: Mon, 19 Mar 2018 22:06:24 +0100
Message-ID: <f6126707-45b7-309e-4cc9-16833e7d27d4@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
 <1521451220-27754-4-git-send-email-eric.auger@redhat.com>
 <3943c306-5204-3a2b-0e06-7c8a4298c9fc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3943c306-5204-3a2b-0e06-7c8a4298c9fc@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 19/03/18 16:57, Marc Zyngier wrote:
> On 19/03/18 09:20, Eric Auger wrote:
>> To prepare for multiple RDIST regions, let's record the RDIST
>> Last bit field when registering the IO device.
>>
>> As a reminder the Last bit indicates whether the redistributor
>> is the highest one in a series of contiguous redistributor pages.
>>
>> Since at the moment KVM only supports a single redist region,
>> the RDIST tagged with the last bit set to true corresponds to the
>> highest vCPU one.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  include/kvm/arm_vgic.h           | 1 +
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 6 +++++-
>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index cdbd142..1c8c0ff 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -312,6 +312,7 @@ struct vgic_cpu {
>>  	 */
>>  	struct vgic_io_device	rd_iodev;
>>  	struct vgic_io_device	sgi_iodev;
>> +	bool rdist_last; /* Is the RDIST the last one of the RDIST region? */
>>  
>>  	/* Contains the attributes and gpa of the LPI pending tables. */
>>  	u64 pendbaser;
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 671fe81..75fe689 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -184,12 +184,13 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>>  					      gpa_t addr, unsigned int len)
>>  {
>>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>  	int target_vcpu_id = vcpu->vcpu_id;
>>  	u64 value;
>>  
>>  	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
>>  	value |= ((target_vcpu_id & 0xffff) << 8);
>> -	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
>> +	if (vgic_cpu->rdist_last)
>>  		value |= GICR_TYPER_LAST;
>>  	if (vgic_has_its(vcpu->kvm))
>>  		value |= GICR_TYPER_PLPIS;
>> @@ -580,6 +581,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
>>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>  	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
>>  	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
>>  	gpa_t rd_base, sgi_base;
>> @@ -632,6 +634,8 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  	}
>>  
>>  	vgic->vgic_redist_free_offset += 2 * SZ_64K;
>> +	vgic_cpu->rdist_last =
>> +		(vcpu->vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1);
>>  out:
>>  	mutex_unlock(&kvm->slots_lock);
>>  	return ret;
>>
> 
> I don't really like the idea of keeping this "Last" bit around, because
> it doesn't have much to do with the state of a redistributor, and has
> more to do with its position in the region.
agreed. What about putting it in vgic_io_device then?.
> 
> What is wrong with the current approach of dynamically computing the
> Last bit? If you have multiple regions, all you need to know is which
> region this redistributor belongs to. From that point (and assuming you
> know how many redistributors have been instantiated in that region, you
> can know whether the Last bit is set or not.
Well, looked to me more natural to compute the information once when
registering the rdist into its region instead of each time we read the
RDIST TYPER. Especially because at that moment we map the redist, we
need to know anyway if we have sufficient space to put it.
> 
> One of the issue is that the current code works in term of "target cpu",
> while we really want is to use the addr parameter to work out if the
> Last bit is set or not. I'd be a lot more confident if we emulate it
> like that (which is how the HW would generate it too).
Sorry I don't understand your comment above.

Thanks

Eric
> 
> What do you think?
> 
> 	M.
> 
