From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: rework kvm_handle_mmio_return
Date: Fri, 8 Apr 2016 19:08:03 +0200
Message-ID: <20160408170803.GB13247@cbox>
References: <1460112230-32543-1-git-send-email-andre.przywara@arm.com>
 <20160408110506.GA7347@cbox> <5707E13B.4050606@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E859407A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 13:06:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9ZbaBHouYSpx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 13:06:23 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A85B74053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 13:06:23 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id u206so30245807wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 10:07:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5707E13B.4050606@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 08, 2016 at 05:50:03PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 08/04/16 12:05, Christoffer Dall wrote:
> > On Fri, Apr 08, 2016 at 11:43:50AM +0100, Andre Przywara wrote:
> >> Currently we call kvm_handle_mmio_return when we need to sync back
> >> register content into the guest after a trap.
> >> This function expects its arguments packaged into struct kvm_run,
> >> which we only naturally use when we emulate in userspace. With
> >> in-kernel emulation we have to copy the data into that strcut.
> > 
> > s/strcut/struct/
> > 
> >> This patch fixes this by explicitly passing the required variables,
> >> so we save the copying in two cases.
> > 
> > this patch fixes what?
> 
> The strcut ;-)
> 
> It fixes the unnecessary copying. Indeed worded badly.
> 
> >> Also since this function is actually a NOP for an MMIO write, we
> >> rename it to kvm_writeback_mmio_data and move the !is_write check to
> >> the callers.
> >> This fixes a bug where we were missing a writeback for one in-kernel
> >> emulation case.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >> Hi Christoffer,
> >>
> >> this is my take on fixing the missing MMIO writeback call.
> >> This rework kind of hides the actual bug-fix, that's why I dumped
> >> it in favour of the one-liner in my series.
> >>
> > 
> > Hmmm, I thought I also sent a patch for this (off list), and I'm not
> > sure why your approach is better, but ok, I guess I can review your
> > patch...
> 
> My approach is not better, just different. I just wanted some opinions
> because I wasn't satisfied either.

I just felt like I had implemented and tested a fix for a problem, and
then I also had to review an alternative approach, but oh well, no
worries.

> This run-> wrapping did annoy me already some months ago, so I just took
> the opportunity to kill it.
> 
> >>
> >>  arch/arm/include/asm/kvm_mmio.h   |  3 ++-
> >>  arch/arm/kvm/arm.c                | 10 +++++---
> >>  arch/arm/kvm/mmio.c               | 54 ++++++++++++++++++---------------------
> >>  arch/arm64/include/asm/kvm_mmio.h |  3 ++-
> >>  virt/kvm/arm/vgic.c               |  8 ++----
> >>  5 files changed, 38 insertions(+), 40 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
> >> index d8e90c8..21f97ac 100644
> >> --- a/arch/arm/include/asm/kvm_mmio.h
> >> +++ b/arch/arm/include/asm/kvm_mmio.h
> >> @@ -28,7 +28,8 @@ struct kvm_decode {
> >>  	bool sign_extend;
> >>  };
> >>  
> >> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> >> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, void *data, int len,
> > 
> > I think this should be called kvm_write_back_mmio_data() instead.
> > 
> >> +			    gpa_t addr);
> >>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  		 phys_addr_t fault_ipa);
> >>  
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index b538431..e9f593c 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -555,9 +555,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>  		return ret;
> >>  
> >>  	if (run->exit_reason == KVM_EXIT_MMIO) {
> >> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> >> -		if (ret)
> >> -			return ret;
> >> +		if (!run->mmio.is_write) {
> >> +			ret = kvm_writeback_mmio_data(vcpu, run->mmio.data,
> >> +						      run->mmio.len,
> >> +						      run->mmio.phys_addr);
> >> +			if (ret)
> >> +				return ret;
> >> +		}
> > 
> > I preferred all the logic be encapsulated in the function instead of
> > extracting values in the caller, but it's purely a cosmetic comment.
> 
> You mean the "if (!is_write)" or wrapping the values into the kvm_run
> struct?
> As mentioned in the commit message, only actual userland emulation is
> using run->, so for in-kernel emulation we have to set it up, which is
> unnecessary copying IMHO.
> By un-wrapping the parameters we just would pass is_write to exit the
> function immediately if it was false, that's why the move to the callers.
> But I agree it is probably bike shedding.
> 
> >>  	}
> >>  
> >>  	if (vcpu->sigset_active)
> >> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> >> index 0f6600f..052aa02 100644
> >> --- a/arch/arm/kvm/mmio.c
> >> +++ b/arch/arm/kvm/mmio.c
> >> @@ -86,38 +86,33 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
> >>  }
> >>  
> >>  /**
> >> - * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
> >> + * kvm_writeback_mmio_data -- Write back emulation data into the guest's
> >> + *                            target register after return from userspace.
> >>   * @vcpu: The VCPU pointer
> >> - * @run:  The VCPU run struct containing the mmio data
> >> + * @data: A pointer to the data to be written back
> >> + * @len:  The size of the read access
> >> + * @addr: The original MMIO address (for the tracepoint only)
> >>   *
> >>   * This should only be called after returning from userspace for MMIO load
> >>   * emulation.
> >>   */
> >> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, void *data_ptr, int len,
> >> +			    gpa_t addr)
> >>  {
> >>  	unsigned long data;
> >> -	unsigned int len;
> >>  	int mask;
> >>  
> >> -	if (!run->mmio.is_write) {
> >> -		len = run->mmio.len;
> >> -		if (len > sizeof(unsigned long))
> >> -			return -EINVAL;
> >> +	data = mmio_read_buf(data_ptr, len);
> >>  
> >> -		data = mmio_read_buf(run->mmio.data, len);
> >> -
> >> -		if (vcpu->arch.mmio_decode.sign_extend &&
> >> -		    len < sizeof(unsigned long)) {
> >> -			mask = 1U << ((len * 8) - 1);
> >> -			data = (data ^ mask) - mask;
> >> -		}
> >> -
> >> -		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
> >> -			       data);
> >> -		data = vcpu_data_host_to_guest(vcpu, data, len);
> >> -		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
> >> +	if (vcpu->arch.mmio_decode.sign_extend && len < sizeof(unsigned long)) {
> >> +		mask = 1U << ((len * 8) - 1);
> >> +		data = (data ^ mask) - mask;
> >>  	}
> >>  
> >> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, addr, data);
> >> +	data = vcpu_data_host_to_guest(vcpu, data, len);
> >> +	vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -202,22 +197,23 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  				      data_buf);
> >>  	}
> >>  
> >> +	if (!ret) {
> >> +		/* We handled the access successfully in the kernel. */
> >> +		vcpu->stat.mmio_exit_kernel++;
> >> +		if (!is_write)
> >> +			kvm_writeback_mmio_data(vcpu, data_buf, len, fault_ipa);
> > 
> > are you not doing this writeback twice?  Once in the vgic and once here?
> > That was the very thing I tried to address in my patch.
> 
> Right, I missed that one (which was the actual reason the code worked
> before although we missed the write-back.
> Not sure why it was actually in in the first place.
> 
> I guess I will just go with your patch, because it's simpler.
> 

I do agree about the weirdness of using the mmio struct designed for
userspace in the kernel.  On the other hand, that struct encapsulates
all that's needed, which why I think the code was done the way it is
currently.

I think we originally considered only the vgic as an in-kernel thing
that needed to do the write-back, hence the 'bug' or situation or
whatever we have today.

I don't care strongly which way we go about it.  If you prefer building
the new vgic on top of your patch, then just address the double-copying
in the gic.  It's really up to you, whatever makes the shitty job of
managing the giant new vgic implementation for you.

Thanks,
-Christoffer
