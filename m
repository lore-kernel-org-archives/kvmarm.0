Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B44E32E6A9;
	Fri, 31 Oct 2025 09:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901543; cv=none; b=LPyZ9XkBpYOQ9YLD+8KBbnxuSQDjrxVKclXAD9NnIwMqCHkaYANfU9npNIo1kCNr8fJmw5frGkuzOm8cKHGdImjMk9mbieorz1bJEqillYv0sFXjq2iu6+0q02EnDoU74eV5VyGih1kSpN11R4wffE70Ve0X+Zmj11X2cs50Ifs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901543; c=relaxed/simple;
	bh=qFNmSQUeXMaY7XvP4sAPgKkJ8Ev3XCXyw2q+qbAZDIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TZtIRDwloHfyHwy3VJ534s0en2Sf3A1vK4enEa/vI5OwQ1MhGq63sWTd6XRa9D9wKSKU0cvt6UGYsdEYzT+BxML4MsF7Opzrn65rEn9drXsmCluEUOxJ3mnnmMsUHcEp3desBP4pfa6mWKFiUNUQG/DXtF/DAud5hvalSimkwac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLoDFWfg; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLoDFWfg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901542; x=1793437542;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qFNmSQUeXMaY7XvP4sAPgKkJ8Ev3XCXyw2q+qbAZDIU=;
  b=GLoDFWfgYfyyVM6THq+0w0et6Dy6x1RJKFpc2zzmvtLLfG+grJaGQow0
   GD3OKm8rIBp3WmaA/inQlEWC2wW9oA/TwuPrf+lkFz5mGf+XEFARVPK6g
   7eVhZdEsJJbcVWOnrT1JCeFFRS8r9xDcUMMU86UEKrIiER1o+vAbeBMsn
   UzS3BlwZ6vsl8n7Jpn/U58NekV0Ed7FxcTCfORLYn5D/JNGGol5eEjOmO
   mDr0FGxDxXeK3g78WiFdgwX4YrvBacu3yAsZ8WCWrYoUdnnOHGWYd/TZi
   QKOvuzyQbTcENGMkzYcG7y9/Wrizkvak2om1ZwMM623LmM31+Hb8/oa50
   A==;
X-CSE-ConnectionGUID: GrNpOKH8Sl+ifmtXdddh1A==
X-CSE-MsgGUID: GuLoC197SEWA8yPYHEPB5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="75508367"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="75508367"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:05:41 -0700
X-CSE-ConnectionGUID: wf1Dt5UnRy6jaWYzdx9wDQ==
X-CSE-MsgGUID: x9G1JpmbTtGdOFT3heo6QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186121954"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:05:32 -0700
Message-ID: <18ecf186-c3b9-4027-a54b-7f3e5ba9f484@linux.intel.com>
Date: Fri, 31 Oct 2025 17:05:34 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/28] KVM: TDX: Assert that mmu_lock is held for write
 when removing S-EPT entries
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-21-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Unconditionally assert that mmu_lock is held for write when removing S-EPT
> entries, not just when removing S-EPT entries triggers certain conditions,
> e.g. needs to do TDH_MEM_TRACK or kick vCPUs out of the guest.
> Conditionally asserting implies that it's safe to hold mmu_lock for read
> when those paths aren't hit, which is simply not true, as KVM doesn't
> support removing S-EPT entries under read-lock.
>
> Only two paths lead to remove_external_spte(), and both paths asserts that
                                                                 ^
                                                               assert
> mmu_lock is held for write (tdp_mmu_set_spte() via lockdep, and
> handle_removed_pt() via KVM_BUG_ON()).
>
> Deliberately leave lockdep assertions in the "no vCPUs" helpers to document
> that wait_for_sept_zap is guarded by holding mmu_lock for write, and keep
> the conditional assert in tdx_track() as well, but with a comment to help
> explain why holding mmu_lock for write matters (above and beyond why
> tdx_sept_remove_private_spte()'s requirements).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 63d4609cc3bc..999b519494e9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1715,6 +1715,11 @@ static void tdx_track(struct kvm *kvm)
>   	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
>   		return;
>   
> +	/*
> +	 * The full sequence of TDH.MEM.TRACK and forcing vCPUs out of guest
> +	 * mode must be serialized, as TDH.MEM.TRACK will fail if the previous
> +	 * tracking epoch hasn't completed.
> +	 */
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	err = tdh_mem_track(&kvm_tdx->td);
> @@ -1762,6 +1767,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	gpa_t gpa = gfn_to_gpa(gfn);
>   	u64 err, entry, level_state;
>   
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
>   	/*
>   	 * HKID is released after all private pages have been removed, and set
>   	 * before any might be populated. Warn if zapping is attempted when

