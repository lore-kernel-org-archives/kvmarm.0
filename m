Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3ED2F5A1F;
	Thu, 19 Feb 2026 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771529481; cv=none; b=SDCLDGxH6kR9J8mj2Yx8eAFadEEx4REVxRTRAwIro1uUBWSwDwSdZ4TkueVS+8JQL+8egJ6aGyxHAi02DFEJL7TTQFR0ZBweuJnwzEN4KBk8I/zkU/yWqmSMI3ZWqskCGARVpgzsU8qfATVAX/ptesWVptl9zRHx1EimkOTlSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771529481; c=relaxed/simple;
	bh=eEbIoo2q1/IW9azGPa53pZmcMQrNecjqCKNKnaoLUAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anj4Tg8KXq8MKO5t1r+3FJ/fLUiBnafoLmD5HWL0JQbetjaZzPVOKnTjazK+mqTKNJ1vjdeWB7LleIPvoAVRCZLhqRTEHrRElPw6R89mnW2Lu9VMdqVegSTpI4UA+7U9Lejg8H982IsFVNPLPzQb+NQWOsJWjAeYI6HpUxoCvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFaGOqs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFaGOqs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0939BC4CEF7;
	Thu, 19 Feb 2026 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771529481;
	bh=eEbIoo2q1/IW9azGPa53pZmcMQrNecjqCKNKnaoLUAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eFaGOqs/Ut2CksfJcyyCXPz/G+49WQAqARVkkt7s0uuz77lzNCcFABEsPoxLrM/+/
	 stFVezcwfKsdB5T+uHpWZIfYS+Xkw+9tMLF2j9W7gXqlB2NK2jloyauUQ5R1KtMQ+C
	 pEy8TliEZzi8KHpeXkl39ilFhF+tz5Z7pFd+wMpggDxJcQxP7N1LWGJ+O+4gytrAnf
	 FHPVhqTzXarIfMAIh88xDSwQ9dAJ8j2Tyg6iW+wqHVBG+M2S/f7rDdHSvEn10qzOF7
	 Nt+ju4WrkNa+cagWpaRY3uoJtyitTIw3KEO2S0qTJbt9irBD5+Lm3zpUm4L0Icp1F8
	 QvqvcyrboX9nA==
Date: Thu, 19 Feb 2026 11:31:18 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v6 42/44] KVM: VMX: Dedup code for adding MSR to VMCS's
 auto list
Message-ID: <aZdlBkLEQyv9q5ll@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-43-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251206001720.468579-43-seanjc@google.com>

Hello,

On Fri, Dec 05, 2025 at 04:17:18PM -0800, Sean Christopherson wrote:
> Add a helper to add an MSR to a VMCS's "auto" list to deduplicate the code
> in add_atomic_switch_msr(), and so that the functionality can be used in
> the future for managing the MSR auto-store list.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 018e01daab68..3f64d4b1b19c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1093,12 +1093,28 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  	vm_exit_controls_setbit(vmx, exit);
>  }
>  
> +static void vmx_add_auto_msr(struct vmx_msrs *m, u32 msr, u64 value,
> +			     unsigned long vmcs_count_field, struct kvm *kvm)
> +{
> +	int i;
> +
> +	i = vmx_find_loadstore_msr_slot(m, msr);
> +	if (i < 0) {
> +		if (KVM_BUG_ON(m->nr == MAX_NR_LOADSTORE_MSRS, kvm))
> +			return;
> +
> +		i = m->nr++;
> +		m->val[i].index = msr;
> +		vmcs_write32(vmcs_count_field, m->nr);
> +	}
> +	m->val[i].value = value;
> +}
> +
>  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  				  u64 guest_val, u64 host_val)
>  {
>  	struct msr_autoload *m = &vmx->msr_autoload;
>  	struct kvm *kvm = vmx->vcpu.kvm;
> -	int i;
>  
>  	switch (msr) {
>  	case MSR_EFER:
> @@ -1132,27 +1148,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  		wrmsrq(MSR_IA32_PEBS_ENABLE, 0);
>  	}
>  
> -	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> -	if (i < 0) {
> -		if (KVM_BUG_ON(m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> -			return;
> -
> -		i = m->guest.nr++;
> -		m->guest.val[i].index = msr;
> -		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
> -	}
> -	m->guest.val[i].value = guest_val;
> -
> -	i = vmx_find_loadstore_msr_slot(&m->host, msr);
> -	if (i < 0) {
> -		if (KVM_BUG_ON(m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> -			return;
> -
> -		i = m->host.nr++;
> -		m->host.val[i].index = msr;
> -		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> -	}
> -	m->host.val[i].value = host_val;
> +	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
> +	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);

Shouldn't it be &m->host for the host_val?

Thanks,
Namhyung

>  }
>  
>  static bool update_transition_efer(struct vcpu_vmx *vmx)
> -- 
> 2.52.0.223.gf5cc29aaa4-goog
> 
