Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12F10A1E;
	Wed, 22 Oct 2025 03:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761102958; cv=none; b=tj0Kvb2NrdktbuXYqsH/fOqM/NSINO7T6m7tgjKroVP07iw+Ixlu6KJ6fN8OVcCmBWpXvrNa6qin6TioXzwpi/DG83WyuxQTdOHbdNeVQ7irUIB+89eV7YfStipzgORvRQ4mXfMlr+QjiBISLPNsmWFiZnQBW0HZ+clkqHow040=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761102958; c=relaxed/simple;
	bh=C4vq3UaKFDwToRnrsRh+czOcOkuL3mJDA1+8OYAo9rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gu4Fq4ThJouKmI059knzqUexvDUURd7s58dOQH7l8KoDyOR9z+bHr8PVwm4TR9Eh+kGnRg/tPEvN0XAQX/cYqU5JcNAfDRl5CWwJQvEzmkRDlT7bVzax/3lFHvcQo9AXG8WFtNUDFN+gSDbg3VFWQQnZ4jhhFB3LI9I7jufewZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c1dF5BzX; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c1dF5BzX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761102957; x=1792638957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C4vq3UaKFDwToRnrsRh+czOcOkuL3mJDA1+8OYAo9rg=;
  b=c1dF5BzXVYtW+jp3sfR1qhzfA8ZF449I9Lbtqaog71z2iVJfxlVGRoUM
   OCBbiZ2eAZ+0+lpoyEDddzGuv+13yzwfCxgbuYiKzL64Rg5AmeS6Umbsl
   VpJ2Zmq5/YSi6SgCaoAseLPDIcs/kdo59SxbbWhnOD4IZPZuUTwTKJgJG
   OVYT8Nh3H91+FSLI0fG1PGGglhlNRqa0g8l5Z9h2ailbcra/w/wHnETPR
   7kDh0aae/ISBGwMeFF9WP+5xJpurSNXfVHr0agldMZ3pUEvANHv7N8EkV
   9MhwLVHr5wF3dZ+iioMAFELCJBhcYaFebxZFUKej0RvJRVzFU9/B8Gwvu
   A==;
X-CSE-ConnectionGUID: 6GQYs9eXRJqFIxL/1uZM9w==
X-CSE-MsgGUID: Xc1SgF56SQGp2xH0mLZYBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80865336"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="80865336"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 20:15:56 -0700
X-CSE-ConnectionGUID: rS/w9ShoRTOr0LOxJ5xyUg==
X-CSE-MsgGUID: oNdfq1G9T4yNJ67V9X9aAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="184159739"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 20:15:49 -0700
Message-ID: <eb6a2ca0-84eb-4770-8300-cd8892eae6ad@linux.intel.com>
Date: Wed, 22 Oct 2025 11:15:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/25] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
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
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-4-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251017003244.186495-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> Drop TDX's sanity check that a mirror EPT mapping isn't zapped between
> creating said mapping and doing TDH.MEM.PAGE.ADD, as the check is
> simultaneously superfluous and incomplete.  Per commit 2608f1057601
> ("KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU"), the
> justification for introducing kvm_tdp_mmu_gpa_is_mapped() was to check
> that the target gfn was pre-populated, with a link that points to this
> snippet:
>
>   : > One small question:
>   : >
>   : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
>   : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
>   : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
>   : > return error when it finds the region hasn't been pre-populated?
>   :
>   : Return an error.  I don't love the idea of bleeding so many TDX details into
>   : userspace, but I'm pretty sure that ship sailed a long, long time ago.
>
> But that justification makes little sense for the final code, as the check
> on nr_premapped after TDH.MEM.PAGE.ADD will detect and return an error if
> KVM attempted to zap a S-EPT entry (tdx_sept_zap_private_spte() will fail
> on TDH.MEM.RANGE.BLOCK due lack of a valid S-EPT entry).  And as evidenced
> by the "is mapped?" code being guarded with CONFIG_KVM_PROVE_MMU=y, KVM is
> NOT relying on the check for general correctness.
>
> The sanity check is also incomplete in the sense that mmu_lock is dropped
> between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
> zap SPTEs in a very specific window (note, this also applies to the check
> on nr_premapped).
>
> Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
> which has no business being exposed to vendor code, and more importantly
> will pave the way for eliminating the "pre-map" approach entirely in favor
> of doing TDH.MEM.PAGE.ADD under mmu_lock.
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 14 --------------
>   1 file changed, 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 326db9b9c567..4c3014befe9f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3181,20 +3181,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	if (ret < 0)
>   		goto out;
>   
> -	/*
> -	 * The private mem cannot be zapped after kvm_tdp_map_page()
> -	 * because all paths are covered by slots_lock and the
> -	 * filemap invalidate lock.  Check that they are indeed enough.
> -	 */
> -	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> -		scoped_guard(read_lock, &kvm->mmu_lock) {
> -			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -	}
> -
>   	ret = 0;
>   	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
>   			       src_page, &entry, &level_state);

