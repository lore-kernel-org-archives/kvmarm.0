From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: rework kvm_handle_mmio_return
Date: Fri, 8 Apr 2016 17:50:03 +0100
Message-ID: <5707E13B.4050606@arm.com>
References: <1460112230-32543-1-git-send-email-andre.przywara@arm.com>
 <20160408110506.GA7347@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC77940B58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 12:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dvDX+W9g9ykj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 12:48:24 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FC534053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 12:48:23 -0400 (EDT)
In-Reply-To: <20160408110506.GA7347@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/04/16 12:05, Christoffer Dall wrote:
> On Fri, Apr 08, 2016 at 11:43:50AM +0100, Andre Przywara wrote:
>> Currently we call kvm_handle_mmio_return when we need to sync back
>> register content into the guest after a trap.
>> This function expects its arguments packaged into struct kvm_run,
>> which we only naturally use when we emulate in userspace. With
>> in-kernel emulation we have to copy the data into that strcut.
> 
> s/strcut/struct/
> 
>> This patch fixes this by explicitly passing the required variables,
>> so we save the copying in two cases.
> 
> this patch fixes what?

The strcut ;-)

It fixes the unnecessary copying. Indeed worded badly.

>> Also since this function is actually a NOP for an MMIO write, we
>> rename it to kvm_writeback_mmio_data and move the !is_write check to
>> the callers.
>> This fixes a bug where we were missing a writeback for one in-kernel
>> emulation case.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Hi Christoffer,
>>
>> this is my take on fixing the missing MMIO writeback call.
>> This rework kind of hides the actual bug-fix, that's why I dumped
>> it in favour of the one-liner in my series.
>>
> 
> Hmmm, I thought I also sent a patch for this (off list), and I'm not
> sure why your approach is better, but ok, I guess I can review your
> patch...

My approach is not better, just different. I just wanted some opinions
because I wasn't satisfied either.
This run-> wrapping did annoy me already some months ago, so I just took
the opportunity to kill it.

>>
>>  arch/arm/include/asm/kvm_mmio.h   |  3 ++-
>>  arch/arm/kvm/arm.c                | 10 +++++---
>>  arch/arm/kvm/mmio.c               | 54 ++++++++++++++++++---------------------
>>  arch/arm64/include/asm/kvm_mmio.h |  3 ++-
>>  virt/kvm/arm/vgic.c               |  8 ++----
>>  5 files changed, 38 insertions(+), 40 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
>> index d8e90c8..21f97ac 100644
>> --- a/arch/arm/include/asm/kvm_mmio.h
>> +++ b/arch/arm/include/asm/kvm_mmio.h
>> @@ -28,7 +28,8 @@ struct kvm_decode {
>>  	bool sign_extend;
>>  };
>>  
>> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, void *data, int len,
> 
> I think this should be called kvm_write_back_mmio_data() instead.
> 
>> +			    gpa_t addr);
>>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  		 phys_addr_t fault_ipa);
>>  
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index b538431..e9f593c 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -555,9 +555,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  		return ret;
>>  
>>  	if (run->exit_reason == KVM_EXIT_MMIO) {
>> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>> -		if (ret)
>> -			return ret;
>> +		if (!run->mmio.is_write) {
>> +			ret = kvm_writeback_mmio_data(vcpu, run->mmio.data,
>> +						      run->mmio.len,
>> +						      run->mmio.phys_addr);
>> +			if (ret)
>> +				return ret;
>> +		}
> 
> I preferred all the logic be encapsulated in the function instead of
> extracting values in the caller, but it's purely a cosmetic comment.

You mean the "if (!is_write)" or wrapping the values into the kvm_run
struct?
As mentioned in the commit message, only actual userland emulation is
using run->, so for in-kernel emulation we have to set it up, which is
unnecessary copying IMHO.
By un-wrapping the parameters we just would pass is_write to exit the
function immediately if it was false, that's why the move to the callers.
But I agree it is probably bike shedding.

>>  	}
>>  
>>  	if (vcpu->sigset_active)
>> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
>> index 0f6600f..052aa02 100644
>> --- a/arch/arm/kvm/mmio.c
>> +++ b/arch/arm/kvm/mmio.c
>> @@ -86,38 +86,33 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
>>  }
>>  
>>  /**
>> - * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
>> + * kvm_writeback_mmio_data -- Write back emulation data into the guest's
>> + *                            target register after return from userspace.
>>   * @vcpu: The VCPU pointer
>> - * @run:  The VCPU run struct containing the mmio data
>> + * @data: A pointer to the data to be written back
>> + * @len:  The size of the read access
>> + * @addr: The original MMIO address (for the tracepoint only)
>>   *
>>   * This should only be called after returning from userspace for MMIO load
>>   * emulation.
>>   */
>> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, void *data_ptr, int len,
>> +			    gpa_t addr)
>>  {
>>  	unsigned long data;
>> -	unsigned int len;
>>  	int mask;
>>  
>> -	if (!run->mmio.is_write) {
>> -		len = run->mmio.len;
>> -		if (len > sizeof(unsigned long))
>> -			return -EINVAL;
>> +	data = mmio_read_buf(data_ptr, len);
>>  
>> -		data = mmio_read_buf(run->mmio.data, len);
>> -
>> -		if (vcpu->arch.mmio_decode.sign_extend &&
>> -		    len < sizeof(unsigned long)) {
>> -			mask = 1U << ((len * 8) - 1);
>> -			data = (data ^ mask) - mask;
>> -		}
>> -
>> -		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>> -			       data);
>> -		data = vcpu_data_host_to_guest(vcpu, data, len);
>> -		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
>> +	if (vcpu->arch.mmio_decode.sign_extend && len < sizeof(unsigned long)) {
>> +		mask = 1U << ((len * 8) - 1);
>> +		data = (data ^ mask) - mask;
>>  	}
>>  
>> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, addr, data);
>> +	data = vcpu_data_host_to_guest(vcpu, data, len);
>> +	vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -202,22 +197,23 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  				      data_buf);
>>  	}
>>  
>> +	if (!ret) {
>> +		/* We handled the access successfully in the kernel. */
>> +		vcpu->stat.mmio_exit_kernel++;
>> +		if (!is_write)
>> +			kvm_writeback_mmio_data(vcpu, data_buf, len, fault_ipa);
> 
> are you not doing this writeback twice?  Once in the vgic and once here?
> That was the very thing I tried to address in my patch.

Right, I missed that one (which was the actual reason the code worked
before although we missed the write-back.
Not sure why it was actually in in the first place.

I guess I will just go with your patch, because it's simpler.

Cheers,
Andre.

>> +		return 1;
>> +	}
>> +
>>  	/* Now prepare kvm_run for the potential return to userland. */
>>  	run->mmio.is_write	= is_write;
>>  	run->mmio.phys_addr	= fault_ipa;
>>  	run->mmio.len		= len;
>> +	run->exit_reason	= KVM_EXIT_MMIO;
>>  	if (is_write)
>>  		memcpy(run->mmio.data, data_buf, len);
>>  
>> -	if (!ret) {
>> -		/* We handled the access successfully in the kernel. */
>> -		vcpu->stat.mmio_exit_kernel++;
>> -		kvm_handle_mmio_return(vcpu, run);
>> -		return 1;
>> -	} else {
>> -		vcpu->stat.mmio_exit_user++;
>> -	}
>> +	vcpu->stat.mmio_exit_user++;
>>  
>> -	run->exit_reason	= KVM_EXIT_MMIO;
>>  	return 0;
>>  }
>> diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm_mmio.h
>> index fe612a9..00a57bd 100644
>> --- a/arch/arm64/include/asm/kvm_mmio.h
>> +++ b/arch/arm64/include/asm/kvm_mmio.h
>> @@ -30,7 +30,8 @@ struct kvm_decode {
>>  	bool sign_extend;
>>  };
>>  
>> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, void *data, int len,
>> +			    gpa_t addr);
>>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  		 phys_addr_t fault_ipa);
>>  
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 00429b3..7a9aa56 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -821,7 +821,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>  	struct vgic_io_device *iodev = container_of(this,
>>  						    struct vgic_io_device, dev);
>> -	struct kvm_run *run = vcpu->run;
>>  	const struct vgic_io_range *range;
>>  	struct kvm_exit_mmio mmio;
>>  	bool updated_state;
>> @@ -850,12 +849,9 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
>>  		updated_state = false;
>>  	}
>>  	spin_unlock(&dist->lock);
>> -	run->mmio.is_write	= is_write;
>> -	run->mmio.len		= len;
>> -	run->mmio.phys_addr	= addr;
>> -	memcpy(run->mmio.data, val, len);
>>  
>> -	kvm_handle_mmio_return(vcpu, run);
>> +	if (!is_write)
>> +		kvm_writeback_mmio_data(vcpu, val, len, addr);
> 
> see above.
> 
>>  
>>  	if (updated_state)
>>  		vgic_kick_vcpus(vcpu->kvm);
>> -- 
>> 2.7.3
>>
> 
