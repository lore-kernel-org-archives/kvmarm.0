From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Tue, 23 Jan 2018 19:06:33 +0000
Message-ID: <5A6787B9.3080906@arm.com>
References: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com> <1515254577-6460-6-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1515254577-6460-6-git-send-email-gengdongjiu@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, robert.moore@intel.com, lv.zheng@intel.com, corbet@lwn.net, will.deacon@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 06/01/18 16:02, Dongjiu Geng wrote:
> The ARM64 RAS SError Interrupt(SEI) syndrome value is specific to the
> guest and user space needs a way to tell KVM this value. So we add a
> new ioctl. Before user space specifies the Exception Syndrome Register
> ESR(ESR), it firstly checks that whether KVM has the capability to
> set the guest ESR, If has, will set it. Otherwise, nothing to do.
> 
> For this ESR specifying, Only support for AArch64, not support AArch32.

After this patch user-space can trigger an SError in the guest. If it wants to
migrate the guest, how does the pending SError get migrated?

I think we need to fix migration first. Andrew Jones suggested using
KVM_GET/SET_VCPU_EVENTS:
https://www.spinics.net/lists/arm-kernel/msg616846.html

Given KVM uses kvm_inject_vabt() on v8.0 hardware too, we should cover systems
without the v8.2 RAS Extensions with the same API. I think this means a bit to
read/write whether SError is pending, and another to indicate the ESR should be
set/read.
CPUs without the v8.2 RAS Extensions can reject pending-SError that had an ESR.

user-space can then use the 'for migration' calls to make a 'new' SError pending.

Now that the cpufeature bits are queued, I think this can be split up into two
separate series for v4.16-rc1, one to tackle NOTIFY_SEI and the associated
plumbing. The second for the KVM 'make SError pending' API.


> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5c7f657..738ae90 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -277,6 +277,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  	return -EINVAL;
>  }
>  
> +int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u32 *syndrome)
> +{
> +	return -EINVAL;
> +}

Does nothing in the patch that adds the support? This is a bit odd.
(oh, its hiding in patch 6...)


Thanks,

James

