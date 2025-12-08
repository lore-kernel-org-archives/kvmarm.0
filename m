Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBC0327208;
	Mon,  8 Dec 2025 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186335; cv=none; b=Jb7WCr/w0yB2NCYnp5aTfjtFhHNmOTRrwJT1QgUDjWroSCOBwjyHjo3mXD/yKs1L4Vw9b1YkL6/KapxnH3EAF3gNmMpVuw8zw3z1fJACmGdLQloup8FeSCpvtGV8+dWL0TPfFPQ2JrMx33sR+156cxByk+5N0n8dQHJrNNjk6Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186335; c=relaxed/simple;
	bh=GYQaZ3LGrXDq/3mzDZllqKTFLOorC/Poy7Wcg2fCybE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nTYLIIXBs9WzWyfIqnZLLCD2Xfer/tV9iZMy+MKj/OoJFgLoJpcuxb/sU4QLSNbp03g7XSmr3ROu9wJuDN4yDfdssl3dlJo6t3tgWIOs/J0paqZUAfslBOjDICPetGikWSVtpGStJnzTcpqNnx7W0xKy/Y45emgUB/KfMDhPG1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqHxtImL; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqHxtImL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186333; x=1796722333;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GYQaZ3LGrXDq/3mzDZllqKTFLOorC/Poy7Wcg2fCybE=;
  b=DqHxtImLc+xU09Sf0NeDIaZa76tYTuvBHINhyN8oiVWqPvgPUw1RFi4T
   wz/OE2puXulvvmQe+jPGCOxGygcoKrbgRtbci+ypqAE6AUPy2ZI6uIwDi
   1dim/e5tOAXhuRhewexVJZY1Q2EcejSCyGfTwmAj5PckknmmBp53uQjG/
   RxxUnJxQpXxdnU1NTc/RrHhkDo82H4la9QHnSnAIpx3c8/9iRHYOB+HSf
   bBMARtZNPx4agc+4n+qr8Lu7DhlAGYcVWCDXRU9sI89CarvKGgEHVsgKp
   MWGKHY5drEdDIWe+2Li6/x9F1y0fcN0ZgzfRJgTwlFIbd7ENNCyoIxsl3
   A==;
X-CSE-ConnectionGUID: sHmmjvKmRdON4ybfi16Gog==
X-CSE-MsgGUID: pfabbFKBTdev8dd9G3NYSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="70979536"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="70979536"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:32:13 -0800
X-CSE-ConnectionGUID: ypr0CVsRRuCL80dlOYG7Uw==
X-CSE-MsgGUID: sHpFM58aQWi8jT8QK4x6Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200067937"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:32:04 -0800
Message-ID: <f551c638-a8c8-4aab-9fb7-f04df124ff15@linux.intel.com>
Date: Mon, 8 Dec 2025 17:32:01 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 38/44] KVM: VMX: Drop unused @entry_only param from
 add_atomic_switch_msr()
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-39-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-39-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Drop the "on VM-Enter only" parameter from add_atomic_switch_msr() as it
> is no longer used, and for all intents and purposes was never used.  The
> functionality was added, under embargo, by commit 989e3992d2ec
> ("x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs"),
> and then ripped out by commit 2f055947ae5e ("x86/kvm: Drop L1TF MSR list
> approach") just a few commits later.
>
>   2f055947ae5e x86/kvm: Drop L1TF MSR list approach
>   72c6d2db64fa x86/litf: Introduce vmx status variable
>   215af5499d9e cpu/hotplug: Online siblings when SMT control is turned on
>   390d975e0c4e x86/KVM/VMX: Use MSR save list for IA32_FLUSH_CMD if required
>   989e3992d2ec x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs
>
> Furthermore, it's extremely unlikely KVM will ever _need_ to load an MSR
> value via the auto-load lists only on VM-Enter.  MSRs writes via the lists
> aren't optimized in any way, and so the only reason to use the lists
> instead of a WRMSR are for cases where the MSR _must_ be load atomically
> with respect to VM-Enter (and/or VM-Exit).  While one could argue that
> command MSRs, e.g. IA32_FLUSH_CMD, "need" to be done exact at VM-Enter, in
> practice doing such flushes within a few instructons of VM-Enter is more
> than sufficient.
>
> Note, the shortlog and changelog for commit 390d975e0c4e ("x86/KVM/VMX: Use
> MSR save list for IA32_FLUSH_CMD if required") are misleading and wrong.
> That commit added MSR_IA32_FLUSH_CMD to the VM-Enter _load_ list, not the
> VM-Enter save list (which doesn't exist, only VM-Exit has a store/save
> list).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a51f66d1b201..38491962b2c1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1094,7 +1094,7 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  }
>  
>  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> -				  u64 guest_val, u64 host_val, bool entry_only)
> +				  u64 guest_val, u64 host_val)
>  {
>  	int i, j = 0;
>  	struct msr_autoload *m = &vmx->msr_autoload;
> @@ -1132,8 +1132,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	}
>  
>  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> -	if (!entry_only)
> -		j = vmx_find_loadstore_msr_slot(&m->host, msr);
> +	j = vmx_find_loadstore_msr_slot(&m->host, msr);
>  
>  	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
>  	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
> @@ -1148,9 +1147,6 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	m->guest.val[i].index = msr;
>  	m->guest.val[i].value = guest_val;
>  
> -	if (entry_only)
> -		return;
> -
>  	if (j < 0) {
>  		j = m->host.nr++;
>  		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> @@ -1190,8 +1186,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
>  		if (!(guest_efer & EFER_LMA))
>  			guest_efer &= ~EFER_LME;
>  		if (guest_efer != kvm_host.efer)
> -			add_atomic_switch_msr(vmx, MSR_EFER,
> -					      guest_efer, kvm_host.efer, false);
> +			add_atomic_switch_msr(vmx, MSR_EFER, guest_efer, kvm_host.efer);
>  		else
>  			clear_atomic_switch_msr(vmx, MSR_EFER);
>  		return false;
> @@ -7350,7 +7345,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  			clear_atomic_switch_msr(vmx, msrs[i].msr);
>  		else
>  			add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
> -					msrs[i].host, false);
> +					      msrs[i].host);
>  }
>  
>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


