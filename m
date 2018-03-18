From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v10 2/5] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Sun, 18 Mar 2018 07:33:59 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201B6C27D@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "bp@alien8.de" <bp@alien8.de>, "lenb@kernel.org" <lenb@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, devel@acpic
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
   Thanks for your time to review and give comments.

[...]
> > +
> > +8.14 KVM_CAP_ARM_SET_SERROR_ESR
> > +
> > +Architectures: arm, arm64
> > +
> > +This capability indicates that userspace can specify syndrome value
> > +reported to guest OS when guest takes a virtual SError interrupt exception.
> 
> "when userspace triggers a virtual SError"... how?

In the user space(QEMU), it will call kvm_arch_put_registers() or kvm_arch_get_registers() to set or get KVM registers through KVM_SET_ONE_REG/ KVM_GET_ONE_REG IOCTL, at the same time the two functions will separately call kvm_arm_vcpu_get_events() and kvm_arm_vcpu_set_events() to get/set vcpu events. If user space want to trigger a virtual SError with specified ESR, it only need to setup the kvm_vcpu_events struct(exception.serror_pending = 1; exception.serror_has_esr=1; serror_esr=xxxxx), then KVM will trigger this virtual SError.

userspace can trigger it at any time, for example, for debug purpose.  Or simulate a SError after recording a CPER for guest. But before triggering a virtual SError, it needs to know whether KVM has such capability, so KVM needs to export this capability to user space. If has this capability, User space will call kvm_arm_vcpu_set_events() to trigger a virtual SError.

> 
> 
> > +If KVM has this capability, userspace can only specify the ISS field
> > +for the ESR syndrome, can not specify the EC field which is not under control by KVM.
> 
> Where do I put the ESR?
> If you re-order this after the patch that adds the API, you can describe how this can be used.

Ok, thank a lot for your suggestion.

> 
> 
> Thanks,
> 
> James
> 
> 
> 
> > +If this virtual SError is taken to EL1 using AArch64, this value will
> > +be reported into ISS filed of ESR_EL1.
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c index
> > 3256b92..38c8a64 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_ARM_PMU_V3:
> >  		r = kvm_arm_support_pmu_v3();
> >  		break;
> > +	case KVM_CAP_ARM_INJECT_SERROR_ESR:
> > +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
> > +		break;
> >  	case KVM_CAP_SET_GUEST_DEBUG:
> >  	case KVM_CAP_VCPU_ATTRIBUTES:
> >  		r = 1;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h index
> > 8fb90a0..3587b33 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -934,6 +934,7 @@ struct kvm_ppc_resize_hpt {  #define
> > KVM_CAP_S390_AIS_MIGRATION 150  #define KVM_CAP_PPC_GET_CPU_CHAR 151
> > #define KVM_CAP_S390_BPB 152
> > +#define KVM_CAP_ARM_INJECT_SERROR_ESR 153
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> >
