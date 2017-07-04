From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 3/3] arm64: kvm: inject SError with user space
 specified syndrome
Date: Tue, 4 Jul 2017 10:49:52 +0200
Message-ID: <20170704084952.GN4066@cbox>
References: <1498481199-24118-1-git-send-email-gengdongjiu@huawei.com>
 <20170703083903.GE4066@cbox>
 <429e4a67-3795-1449-f0b1-12df3012629a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <429e4a67-3795-1449-f0b1-12df3012629a@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: corbet@lwn.net, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, Gaozhihui <zhihui.gao@huawei.com>, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, huhuajun@huawei.com, james.morse@arm.com, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu,

On Tue, Jul 04, 2017 at 12:46:23PM +0800, gengdongjiu wrote:
> Hi Christoffer,
>   thanks for the review.
> 
> 
> On 2017/7/3 16:39, Christoffer Dall wrote:
> > Hi Dongjiu,
> > 
> > On Mon, Jun 26, 2017 at 08:46:39PM +0800, Dongjiu Geng wrote:
> >> when SError happen, kvm notifies user space to record the CPER,
> >> user space specifies and passes the contents of ESR_EL1 on taking
> >> a virtual SError interrupt to KVM, KVM enables virtual system
> >> error or asynchronous abort with this specifies syndrome. This
> >> patch modify the world-switch to restore VSESR_EL2, VSESR_EL2
> >> saves the virtual SError syndrome, it becomes the ESR_EL1 value when
> >> HCR_EL2.VSE injects an SError. This register is added by the
> >> RAS Extensions.
> > 
> > This commit message is confusing and doesn't help me understand the
> > patch.
> (1) what is the rationale for the guest OS SError interrupt(SEI) handling in the RAS solution?
>   you can refer to document: "RAS_Extension_PRD03-PRDC-010953-32-0, 6.5.3 Example software sequences"
>   a). In the firmware-first RAS solution, when guest OS happen a SError interrupt (SEI), it will firstly trap to EL3(SCR_EL3.EA = 1);
>   b). The firmware logs, triages, and delegates the error exception to the hypervisor. As the error came from guest OS  EL1, firmware
>       does by faking an SError interrupt exception entry to EL2.
>   c). Control transfers to the hypervisor's delegated error recovery agent.Because HCR_EL2.AMO is set to 1, the hypervisor can use a
>       Virtual SError interrupt to delegate an asynchronous abort to EL1, by setting HCR_EL2.VSE to 1 and using VESR_EL2 to pass syndrome.
> 
> (2) what is this patch mainly do?
>   As mentioned above, the hypervisor needs to enable virtual SError and pass the virtual syndrome to the guest OS.
> 
>   a). when Control transfers to the hypervisor from firmware by faking an SError interrupt, the hypervisor delivered the syndrome_info(esr_el2) and
>       host VA address( Qemu translate this VA address to the virtual machine physical address(IPA)) using below new added "serror_intr" struct.
>   		/* KVM_EXIT_SERROR_INTR */
>  		struct {
> 			__u32 syndrome_info;
> 			__u64 address;
> 		} serror_intr;
> 
>   b). Qemu gets the address(host VA) delivered by KVM, translate this host VA address to virtual machine physical address(IPA), and runtime record this virtual
>      machine physical address(IPA) to the guest OS's APEI table.
> 
>   c). Qemu gets the syndrome_info delivered by KVM, it refers to this syndrome value(but can be different from it) to specify the virtual SError interrupt's syndrome through setting VESR_EL2.
> 
>         the vsesr_el2 is armv8.2 register, its explanation can be found in "RAS_Extension_PRD03-PRDC-010953-33-0, 5.6.18 VSESR_EL2, Virtual SError Exception Syndrome Register"
> 
> 	>>The VSESR_EL2 characteristics are:
> 	>>Purpose:
> 	>>Provides the syndrome value reported to software on taking a virtual SError interrupt exception:
> 	>>	— If the virtual SError interrupt is taken to EL1 using AArch64 then VSESR_EL2 provides the
> 	>>syndrome value reported in ESR_EL1.
> 	>>	— If the virtual SError interrupt is taken to EL1 using AArch32 then VSESR_EL2 provides the
> 	>>	  syndrome values reported in DFSR.{AET, ExT} and the remainder of the DFSR is set as
> 	>>	 defined by VMSAv8-32.
> 
>      so in the KVM, I added a new IOCTL(#define KVM_ARM_SEI  _IO(KVMIO,  0xb8)) to pass the virtual SError syndrome value specified by Qemu and enable a virtual System Error.
> 
> 
>  d). when world switch to guest OS, guest OS will happen virtual SError(this virtual SError can not be route to EL3 firmware), guest OS uses the specified syndrome value to do the recovery and
>      parses the guest OS CPER which is dynamically recorded by the Qemu in the APEI table .
> 
> 

Please format the text nicely, and try to simplify the message when
resubmitting these patches.  I hope it will be easier for you to write
a meaningful commit message if you split these patches into multiple
ones.

One specific thing currently lacking from the commit message is a
discussion of why this API is needed in the first place - why can't we
reuse KVM_SET_ONE_REG, for example.

> 
> > 
> > I think this patch is trying to do too many things.  I suggest you split
> > the patch into (at least) one patch that captures exception information
> > from the world-switch path, one patch that deals with the new exit
> > reason, and finally a patch with the new ioctl.  That way you can write
> > a commit message for each patch describing first what the patch does,
> > and then why this is a good idea.
>   Ok, thanks for the good suggestion.
> 
> > 
> > Neverthess, I added some random comments below.
> > 
> >>
> >> Changes since v3:
> >> (1) Move restore VSESR_EL2 value logic to a helper method
> >> (2) In the world-switch, not save VSESR_EL2, because no one cares the
> >>     old VSESR_EL2 value
> >> (3) Add a new KVM_ARM_SEI ioctl to set the VSESR_EL2 value and pend
> >>     a virtual system error
> >>
> >> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> >> Signed-off-by: Quanming Wu <wuquanming@huawei.com>
> >> ---
> >>  Documentation/virtual/kvm/api.txt    | 10 ++++++++++
> >>  arch/arm/include/asm/kvm_host.h      |  1 +
> >>  arch/arm/kvm/arm.c                   |  7 +++++++
> >>  arch/arm/kvm/guest.c                 |  5 +++++
> >>  arch/arm64/include/asm/esr.h         |  2 ++
> >>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
> >>  arch/arm64/include/asm/kvm_host.h    |  2 ++
> >>  arch/arm64/include/asm/sysreg.h      |  3 +++
> >>  arch/arm64/kvm/guest.c               | 14 ++++++++++++++
> >>  arch/arm64/kvm/handle_exit.c         | 25 +++++++++++++++++++------
> >>  arch/arm64/kvm/hyp/switch.c          | 14 ++++++++++++++
> >>  include/uapi/linux/kvm.h             |  8 ++++++++
> >>  12 files changed, 95 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> >> index 3c248f7..852ac55 100644
> >> --- a/Documentation/virtual/kvm/api.txt
> >> +++ b/Documentation/virtual/kvm/api.txt
> >> @@ -3377,6 +3377,16 @@ struct kvm_ppc_resize_hpt {
> >>  	__u32 pad;
> >>  };
> >>  
> >> +4.104 KVM_ARM_SEI
> >> +
> >> +Capability: KVM_EXIT_SERROR_INTR
> >> +Architectures: arm/arm64
> >> +Type: vcpu ioctl
> >> +Parameters: u64 (syndrome)
> >> +Returns: 0 in case of success
> >> +
> >> +Pend an virtual system error or asynchronous abort with user space specified.
> >> +
> > 
> > I don't understand enough about what this ioctl does by just reading
> > this text.  Did you mean to say something like "Record that userspace
> > wishes to inject a pending virtual system error to the VCPU.  Next time
> > the VCPU is run, th
> Christoffer, sorry to confuse you.
> This IOCTL mainly do two things:
> 
> (1) set the VCPU struct's vsesr_el2 to pass the virtual SError's syndrome value that Qemu specified.
> (2) enable virtual SError
> 
>  +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
>  +{
>  +	u64 reg = *syndrome;
>  +
>  +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && reg)
>  +		/* set vsesr_el2[24:0] with value that user space specified */
>  +		kvm_vcpu_set_vsesr(vcpu, reg & VSESR_ELx_IDS_ISS_MASK);
> 
>  +
>  +	/* inject virtual system Error or asynchronous abort */
>  +	kvm_inject_vabt(vcpu);
>  +
>  +	return 0;
>  +}
> 

Dongjiu, I can read the code, of course.  My comment was to tell you
that the text you add to the api.txt file should be meaningful and
explanatory on its own; that's the whole point of having such a file.

> > 
> >>  5. The kvm_run structure
> >>  ------------------------
> >>  
> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >> index 31ee468..566292a 100644
> >> --- a/arch/arm/include/asm/kvm_host.h
> >> +++ b/arch/arm/include/asm/kvm_host.h
> >> @@ -244,6 +244,7 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
> >>  
> >>  int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  		int exception_index);
> >> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
> >>  
> >>  static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
> >>  				       unsigned long hyp_stack_ptr,
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index 96dba7c..583294f 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -987,6 +987,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >>  			return -EFAULT;
> >>  		return kvm_arm_vcpu_has_attr(vcpu, &attr);
> >>  	}
> >> +	case KVM_ARM_SEI: {
> >> +		u64 syndrome;
> >> +
> >> +		if (copy_from_user(&syndrome, argp, sizeof(syndrome)))
> >> +			return -EFAULT;
> >> +		return kvm_vcpu_ioctl_sei(vcpu, &syndrome);
> >> +	}
> >>  	default:
> >>  		return -EINVAL;
> >>  	}
> >> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> >> index fa6182a..72505bf 100644
> >> --- a/arch/arm/kvm/guest.c
> >> +++ b/arch/arm/kvm/guest.c
> >> @@ -248,6 +248,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> >>  	return -EINVAL;
> >>  }
> >>  
> >> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >>  int __attribute_const__ kvm_target_cpu(void)
> >>  {
> >>  	switch (read_cpuid_part()) {
> >> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> >> index 22f9c90..d009c99 100644
> >> --- a/arch/arm64/include/asm/esr.h
> >> +++ b/arch/arm64/include/asm/esr.h
> >> @@ -127,6 +127,8 @@
> >>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
> >>  #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
> >>  
> >> +#define VSESR_ELx_IDS_ISS_MASK    ((1UL << 25) - 1)
> >> +
> >>  /* ESR value templates for specific events */
> >>  
> >>  /* BRK instruction trap from AArch64 state */
> >> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> >> index 5f64ab2..93dc3d1 100644
> >> --- a/arch/arm64/include/asm/kvm_emulate.h
> >> +++ b/arch/arm64/include/asm/kvm_emulate.h
> >> @@ -155,6 +155,16 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
> >>  	return vcpu->arch.fault.esr_el2;
> >>  }
> >>  
> >> +static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
> >> +{
> >> +		return vcpu->arch.fault.vsesr_el2;
> >> +}
> >> +
> >> +static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned long val)
> >> +{
> >> +		vcpu->arch.fault.vsesr_el2 = val;
> >> +}
> >> +
> >>  static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> >>  {
> >>  	u32 esr = kvm_vcpu_get_hsr(vcpu);
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index e7705e7..b6242fb 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -86,6 +86,7 @@ struct kvm_vcpu_fault_info {
> >>  	u32 esr_el2;		/* Hyp Syndrom Register */
> >>  	u64 far_el2;		/* Hyp Fault Address Register */
> >>  	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
> >> +	u32 vsesr_el2;		/* Virtual SError Exception Syndrome Register */
> >>  };
> >>  
> >>  /*
> >> @@ -385,6 +386,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> >>  			       struct kvm_device_attr *attr);
> >>  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >>  			       struct kvm_device_attr *attr);
> >> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
> >>  
> >>  static inline void __cpu_init_stage2(void)
> >>  {
> >> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> >> index 32964c7..3af6907 100644
> >> --- a/arch/arm64/include/asm/sysreg.h
> >> +++ b/arch/arm64/include/asm/sysreg.h
> >> @@ -125,6 +125,9 @@
> >>  #define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
> >>  #define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
> >>  
> >> +/* virtual SError exception syndrome register in armv8.2 */
> >> +#define REG_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
> >> +
> >>  #define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
> >>  				      (!!x)<<8 | 0x1f)
> >>  #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
> >> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> index b37446a..21c20b0 100644
> >> --- a/arch/arm64/kvm/guest.c
> >> +++ b/arch/arm64/kvm/guest.c
> >> @@ -277,6 +277,20 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> >>  	return -EINVAL;
> >>  }
> >>  
> >> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
> >> +{
> >> +	u64 reg = *syndrome;
> >> +
> >> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && reg)
> >> +		/* set vsesr_el2[24:0] with value that user space specified */
> >> +		kvm_vcpu_set_vsesr(vcpu, reg & VSESR_ELx_IDS_ISS_MASK);
> > 
> > Are you really supposed to fail silently here if trying to do this on a
> > system that doesn't have RAS ?
> This register vsesr_el2 is only introduced by armv8.2.
> so if system does not have RAS, the setting will be failed because this register does not exist. I need to "return -EINVAL"
> for this case. thank you for pointing that.
> 
> 
> > 
> > Why can you not set reg to 0 here?  That doesn't seem to be documented
> > anywhere, and shouldn't the function return -EINVAL in this case?
> Because the default value is 0. if want to set to 0, it can not call this API.
> zero is meaningless syndrome value. no one care the zero value.
> 

What if userspace wants to drive a CPU reset of some form.  Is there any
mechanism for resetting the register then?

> 
> > 
> > Also, if you do this, but don't run the VCPU, then migrate the VM, and
> > run the VCPU on the new destination, isn't this information lost?
> > 
> > 

Please consider the migration point for your next version as well.

Thanks,
-Christoffer
