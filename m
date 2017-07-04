From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 3/3] arm64: kvm: inject SError with user space
 specified syndrome
Date: Tue, 4 Jul 2017 12:46:23 +0800
Message-ID: <429e4a67-3795-1449-f0b1-12df3012629a@huawei.com>
References: <1498481199-24118-1-git-send-email-gengdongjiu@huawei.com>
 <20170703083903.GE4066@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170703083903.GE4066@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@linaro.org>
Cc: corbet@lwn.net, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, Gaozhihui <zhihui.gao@huawei.com>, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, huhuajun@huawei.com, james.morse@arm.com, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
  thanks for the review.


On 2017/7/3 16:39, Christoffer Dall wrote:
> Hi Dongjiu,
> =

> On Mon, Jun 26, 2017 at 08:46:39PM +0800, Dongjiu Geng wrote:
>> when SError happen, kvm notifies user space to record the CPER,
>> user space specifies and passes the contents of ESR_EL1 on taking
>> a virtual SError interrupt to KVM, KVM enables virtual system
>> error or asynchronous abort with this specifies syndrome. This
>> patch modify the world-switch to restore VSESR_EL2, VSESR_EL2
>> saves the virtual SError syndrome, it becomes the ESR_EL1 value when
>> HCR_EL2.VSE injects an SError. This register is added by the
>> RAS Extensions.
> =

> This commit message is confusing and doesn't help me understand the
> patch.
(1) what is the rationale for the guest OS SError interrupt(SEI) handling i=
n the RAS solution?
  you can refer to document: "RAS_Extension_PRD03-PRDC-010953-32-0, 6.5.3 E=
xample software sequences"
  a). In the firmware-first RAS solution, when guest OS happen a SError int=
errupt (SEI), it will firstly trap to EL3(SCR_EL3.EA =3D 1);
  b). The firmware logs, triages, and delegates the error exception to the =
hypervisor. As the error came from guest OS  EL1, firmware
      does by faking an SError interrupt exception entry to EL2.
  c). Control transfers to the hypervisor's delegated error recovery agent.=
Because HCR_EL2.AMO is set to 1, the hypervisor can use a
      Virtual SError interrupt to delegate an asynchronous abort to EL1, by=
 setting HCR_EL2.VSE to 1 and using VESR_EL2 to pass syndrome.

(2) what is this patch mainly do?
  As mentioned above, the hypervisor needs to enable virtual SError and pas=
s the virtual syndrome to the guest OS.

  a). when Control transfers to the hypervisor from firmware by faking an S=
Error interrupt, the hypervisor delivered the syndrome_info(esr_el2) and
      host VA address( Qemu translate this VA address to the virtual machin=
e physical address(IPA)) using below new added "serror_intr" struct.
  		/* KVM_EXIT_SERROR_INTR */
 		struct {
			__u32 syndrome_info;
			__u64 address;
		} serror_intr;

  b). Qemu gets the address(host VA) delivered by KVM, translate this host =
VA address to virtual machine physical address(IPA), and runtime record thi=
s virtual
     machine physical address(IPA) to the guest OS's APEI table.

  c). Qemu gets the syndrome_info delivered by KVM, it refers to this syndr=
ome value(but can be different from it) to specify the virtual SError inter=
rupt's syndrome through setting VESR_EL2.

        the vsesr_el2 is armv8.2 register, its explanation can be found in =
"RAS_Extension_PRD03-PRDC-010953-33-0, 5.6.18 VSESR_EL2, Virtual SError Exc=
eption Syndrome Register"

	>>The VSESR_EL2 characteristics are:
	>>Purpose:
	>>Provides the syndrome value reported to software on taking a virtual SEr=
ror interrupt exception:
	>>	=97 If the virtual SError interrupt is taken to EL1 using AArch64 then =
VSESR_EL2 provides the
	>>syndrome value reported in ESR_EL1.
	>>	=97 If the virtual SError interrupt is taken to EL1 using AArch32 then =
VSESR_EL2 provides the
	>>	  syndrome values reported in DFSR.{AET, ExT} and the remainder of the =
DFSR is set as
	>>	 defined by VMSAv8-32.

     so in the KVM, I added a new IOCTL(#define KVM_ARM_SEI  _IO(KVMIO,  0x=
b8)) to pass the virtual SError syndrome value specified by Qemu and enable=
 a virtual System Error.


 d). when world switch to guest OS, guest OS will happen virtual SError(thi=
s virtual SError can not be route to EL3 firmware), guest OS uses the speci=
fied syndrome value to do the recovery and
     parses the guest OS CPER which is dynamically recorded by the Qemu in =
the APEI table .



> =

> I think this patch is trying to do too many things.  I suggest you split
> the patch into (at least) one patch that captures exception information
> from the world-switch path, one patch that deals with the new exit
> reason, and finally a patch with the new ioctl.  That way you can write
> a commit message for each patch describing first what the patch does,
> and then why this is a good idea.
  Ok, thanks for the good suggestion.

> =

> Neverthess, I added some random comments below.
> =

>>
>> Changes since v3:
>> (1) Move restore VSESR_EL2 value logic to a helper method
>> (2) In the world-switch, not save VSESR_EL2, because no one cares the
>>     old VSESR_EL2 value
>> (3) Add a new KVM_ARM_SEI ioctl to set the VSESR_EL2 value and pend
>>     a virtual system error
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Quanming Wu <wuquanming@huawei.com>
>> ---
>>  Documentation/virtual/kvm/api.txt    | 10 ++++++++++
>>  arch/arm/include/asm/kvm_host.h      |  1 +
>>  arch/arm/kvm/arm.c                   |  7 +++++++
>>  arch/arm/kvm/guest.c                 |  5 +++++
>>  arch/arm64/include/asm/esr.h         |  2 ++
>>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
>>  arch/arm64/include/asm/kvm_host.h    |  2 ++
>>  arch/arm64/include/asm/sysreg.h      |  3 +++
>>  arch/arm64/kvm/guest.c               | 14 ++++++++++++++
>>  arch/arm64/kvm/handle_exit.c         | 25 +++++++++++++++++++------
>>  arch/arm64/kvm/hyp/switch.c          | 14 ++++++++++++++
>>  include/uapi/linux/kvm.h             |  8 ++++++++
>>  12 files changed, 95 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/k=
vm/api.txt
>> index 3c248f7..852ac55 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -3377,6 +3377,16 @@ struct kvm_ppc_resize_hpt {
>>  	__u32 pad;
>>  };
>>  =

>> +4.104 KVM_ARM_SEI
>> +
>> +Capability: KVM_EXIT_SERROR_INTR
>> +Architectures: arm/arm64
>> +Type: vcpu ioctl
>> +Parameters: u64 (syndrome)
>> +Returns: 0 in case of success
>> +
>> +Pend an virtual system error or asynchronous abort with user space spec=
ified.
>> +
> =

> I don't understand enough about what this ioctl does by just reading
> this text.  Did you mean to say something like "Record that userspace
> wishes to inject a pending virtual system error to the VCPU.  Next time
> the VCPU is run, th
Christoffer, sorry to confuse you.
This IOCTL mainly do two things:

(1) set the VCPU struct's vsesr_el2 to pass the virtual SError's syndrome v=
alue that Qemu specified.
(2) enable virtual SError

 +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
 +{
 +	u64 reg =3D *syndrome;
 +
 +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && reg)
 +		/* set vsesr_el2[24:0] with value that user space specified */
 +		kvm_vcpu_set_vsesr(vcpu, reg & VSESR_ELx_IDS_ISS_MASK);

 +
 +	/* inject virtual system Error or asynchronous abort */
 +	kvm_inject_vabt(vcpu);
 +
 +	return 0;
 +}

> =

>>  5. The kvm_run structure
>>  ------------------------
>>  =

>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_=
host.h
>> index 31ee468..566292a 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -244,6 +244,7 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, co=
nst struct kvm_one_reg *);
>>  =

>>  int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  		int exception_index);
>> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
>>  =

>>  static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
>>  				       unsigned long hyp_stack_ptr,
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 96dba7c..583294f 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -987,6 +987,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  			return -EFAULT;
>>  		return kvm_arm_vcpu_has_attr(vcpu, &attr);
>>  	}
>> +	case KVM_ARM_SEI: {
>> +		u64 syndrome;
>> +
>> +		if (copy_from_user(&syndrome, argp, sizeof(syndrome)))
>> +			return -EFAULT;
>> +		return kvm_vcpu_ioctl_sei(vcpu, &syndrome);
>> +	}
>>  	default:
>>  		return -EINVAL;
>>  	}
>> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
>> index fa6182a..72505bf 100644
>> --- a/arch/arm/kvm/guest.c
>> +++ b/arch/arm/kvm/guest.c
>> @@ -248,6 +248,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *=
vcpu,
>>  	return -EINVAL;
>>  }
>>  =

>> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
>> +{
>> +	return 0;
>> +}
>> +
>>  int __attribute_const__ kvm_target_cpu(void)
>>  {
>>  	switch (read_cpuid_part()) {
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index 22f9c90..d009c99 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -127,6 +127,8 @@
>>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>>  #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
>>  =

>> +#define VSESR_ELx_IDS_ISS_MASK    ((1UL << 25) - 1)
>> +
>>  /* ESR value templates for specific events */
>>  =

>>  /* BRK instruction trap from AArch64 state */
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/a=
sm/kvm_emulate.h
>> index 5f64ab2..93dc3d1 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -155,6 +155,16 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm=
_vcpu *vcpu)
>>  	return vcpu->arch.fault.esr_el2;
>>  }
>>  =

>> +static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
>> +{
>> +		return vcpu->arch.fault.vsesr_el2;
>> +}
>> +
>> +static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned l=
ong val)
>> +{
>> +		vcpu->arch.fault.vsesr_el2 =3D val;
>> +}
>> +
>>  static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>>  {
>>  	u32 esr =3D kvm_vcpu_get_hsr(vcpu);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/=
kvm_host.h
>> index e7705e7..b6242fb 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -86,6 +86,7 @@ struct kvm_vcpu_fault_info {
>>  	u32 esr_el2;		/* Hyp Syndrom Register */
>>  	u64 far_el2;		/* Hyp Fault Address Register */
>>  	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
>> +	u32 vsesr_el2;		/* Virtual SError Exception Syndrome Register */
>>  };
>>  =

>>  /*
>> @@ -385,6 +386,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>>  			       struct kvm_device_attr *attr);
>>  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>  			       struct kvm_device_attr *attr);
>> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome);
>>  =

>>  static inline void __cpu_init_stage2(void)
>>  {
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sy=
sreg.h
>> index 32964c7..3af6907 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -125,6 +125,9 @@
>>  #define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
>>  #define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
>>  =

>> +/* virtual SError exception syndrome register in armv8.2 */
>> +#define REG_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
>> +
>>  #define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |=
	\
>>  				      (!!x)<<8 | 0x1f)
>>  #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |=
	\
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index b37446a..21c20b0 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -277,6 +277,20 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *=
vcpu,
>>  	return -EINVAL;
>>  }
>>  =

>> +int kvm_vcpu_ioctl_sei(struct kvm_vcpu *vcpu, u64 *syndrome)
>> +{
>> +	u64 reg =3D *syndrome;
>> +
>> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && reg)
>> +		/* set vsesr_el2[24:0] with value that user space specified */
>> +		kvm_vcpu_set_vsesr(vcpu, reg & VSESR_ELx_IDS_ISS_MASK);
> =

> Are you really supposed to fail silently here if trying to do this on a
> system that doesn't have RAS ?
This register vsesr_el2 is only introduced by armv8.2.
so if system does not have RAS, the setting will be failed because this reg=
ister does not exist. I need to "return -EINVAL"
for this case. thank you for pointing that.


> =

> Why can you not set reg to 0 here?  That doesn't seem to be documented
> anywhere, and shouldn't the function return -EINVAL in this case?
Because the default value is 0. if want to set to 0, it can not call this A=
PI.
zero is meaningless syndrome value. no one care the zero value.


> =

> Also, if you do this, but don't run the VCPU, then migrate the VM, and
> run the VCPU on the new destination, isn't this information lost?
> =

> =

>> +
>> +	/* inject virtual system Error or asynchronous abort */
>> +	kvm_inject_vabt(vcpu);
>> +
>> +	return 0;
>> +}
>> +
>>  int __attribute_const__ kvm_target_cpu(void)
>>  {
>>  	unsigned long implementor =3D read_cpuid_implementor();
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index c89d83a..23c02c2 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -180,7 +180,11 @@ static exit_handle_fn kvm_get_exit_handler(struct k=
vm_vcpu *vcpu)
>>  =

>>  static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *=
run)
>>  {
>> -	unsigned long fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
>> +	unsigned long hva, fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
>> +	struct kvm_memory_slot *memslot;
>> +	int hsr, ret =3D 1;
>> +	bool writable;
>> +	gfn_t gfn;
>>  =

>>  	if (handle_guest_sei((unsigned long)fault_ipa,
>>  				kvm_vcpu_get_hsr(vcpu))) {
>> @@ -190,9 +194,20 @@ static int kvm_handle_guest_sei(struct kvm_vcpu *vc=
pu, struct kvm_run *run)
>>  				(unsigned long)kvm_vcpu_get_hsr(vcpu));
>>  =

>>  		kvm_inject_vabt(vcpu);
>> +	} else {
>> +		hsr =3D kvm_vcpu_get_hsr(vcpu);
>> +
>> +		gfn =3D fault_ipa >> PAGE_SHIFT;
>> +		memslot =3D gfn_to_memslot(vcpu->kvm, gfn);
>> +		hva =3D gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>> +
>> +		run->exit_reason =3D KVM_EXIT_SERROR_INTR;
>> +		run->serror_intr.syndrome_info =3D hsr;
>> +		run->serror_intr.address =3D hva;
>> +		ret =3D 0;
>>  	}
>>  =

>> -	return 0;
>> +	return ret;
>>  }
>>  =

>>  /*
>> @@ -218,8 +233,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_ru=
n *run,
>>  			*vcpu_pc(vcpu) -=3D adj;
>>  		}
>>  =

>> -		kvm_handle_guest_sei(vcpu, run);
>> -		return 1;
>> +		return kvm_handle_guest_sei(vcpu, run);
>>  	}
>>  =

>>  	exception_index =3D ARM_EXCEPTION_CODE(exception_index);
>> @@ -228,8 +242,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_ru=
n *run,
>>  	case ARM_EXCEPTION_IRQ:
>>  		return 1;
>>  	case ARM_EXCEPTION_EL1_SERROR:
>> -		kvm_handle_guest_sei(vcpu, run);
>> -		return 1;
>> +		return kvm_handle_guest_sei(vcpu, run);
>>  	case ARM_EXCEPTION_TRAP:
>>  		/*
>>  		 * See ARM ARM B1.14.1: "Hyp traps on instructions
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index aede165..6d17c97 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -67,6 +67,13 @@ static hyp_alternate_select(__activate_traps_arch,
>>  			    __activate_traps_nvhe, __activate_traps_vhe,
>>  			    ARM64_HAS_VIRT_HOST_EXTN);
>>  =

>> +static void __hyp_text __sysreg_set_vsesr(struct kvm_vcpu *vcpu)
>> +{
>> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
>> +			(vcpu->arch.hcr_el2 & HCR_VSE))
>> +		write_sysreg_s(vcpu->arch.fault.vsesr_el2, REG_VSESR_EL2);
>> +}
>> +
>>  static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>>  {
>>  	u64 val;
>> @@ -86,6 +93,13 @@ static void __hyp_text __activate_traps(struct kvm_vc=
pu *vcpu)
>>  		isb();
>>  	}
>>  	write_sysreg(val, hcr_el2);
>> +
>> +	/*
>> +	 * If the virtual SError interrupt is taken to EL1 using AArch64,
>> +	 * then VSESR_EL2 provides the syndrome value reported in ESR_EL1.
>> +	 */
>> +	__sysreg_set_vsesr(vcpu);
>> +
>>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>>  	write_sysreg(1 << 15, hstr_el2);
>>  	/*
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 27fe556..ab91fe3 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -205,6 +205,7 @@ struct kvm_hyperv_exit {
>>  #define KVM_EXIT_S390_STSI        25
>>  #define KVM_EXIT_IOAPIC_EOI       26
>>  #define KVM_EXIT_HYPERV           27
>> +#define KVM_EXIT_SERROR_INTR      28
>>  =

>>  /* For KVM_EXIT_INTERNAL_ERROR */
>>  /* Emulate instruction failed. */
>> @@ -360,6 +361,11 @@ struct kvm_run {
>>  		struct {
>>  			__u8 vector;
>>  		} eoi;
>> +		/* KVM_EXIT_SERROR_INTR */
>> +		struct {
>> +			__u32 syndrome_info;
>> +			__u64 address;
>> +		} serror_intr;
>>  		/* KVM_EXIT_HYPERV */
>>  		struct kvm_hyperv_exit hyperv;
>>  		/* Fix the size of the union. */
>> @@ -1301,6 +1307,8 @@ struct kvm_s390_ucas_mapping {
>>  #define KVM_S390_GET_IRQ_STATE	  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_=
state)
>>  /* Available with KVM_CAP_X86_SMM */
>>  #define KVM_SMI                   _IO(KVMIO,   0xb7)
>> +/* Available with KVM_EXIT_SERROR_INTR */
>> +#define KVM_ARM_SEI               _IO(KVMIO,   0xb8)
>>  =

>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>> -- =

>> 2.10.1
>>
> =

> Thanks,
> -Christoffer
> =

> .
> =
