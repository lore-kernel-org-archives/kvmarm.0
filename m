From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH V13 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Mar 2017 17:53:38 +0800
Message-ID: <5c7f6092-9358-08ac-5341-2364637c2008@huawei.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vg
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2017/3/22 6:47, Tyler Baicar wrote:
> +	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +
> +	/* The host kernel will handle the synchronous external abort. There
> +	 * is no need to pass the error into the guest.
> +	 */
> +	if (is_abort_synchronous(fault_status))
> +		sea_status = handle_guest_sea((unsigned long)fault_ipa,
> +				    kvm_vcpu_get_hsr(vcpu));
>  
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> -	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>  		kvm_inject_vabt(vcpu);
>  		return 1;
>  	}
       After the host kernel correctly handle the synchronous external abort, the sea_status
       will return 0, so the code logical will be continue go-no, whether it is better directly return
       after correctly handle the SEA? such as below.

	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
  		kvm_inject_vabt(vcpu);
  		return 1;
  	} else
                return 1;

>  
> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> -
>  	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
>  			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
>  
> -	/* Check the stage-2 fault is trans. fault or write fault */
> -	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>  	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&

