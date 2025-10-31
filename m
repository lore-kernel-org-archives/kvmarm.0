Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D841E32E697;
	Fri, 31 Oct 2025 09:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901261; cv=none; b=lRn9P7aEs0hcxQ+VI0fouw8xg0SteUjT86hxlsNvnKsJfEvefIa86oLy8q4XcyEaqvttNoxck9IUL2GZyMmYTBN0CvOom8MEQm7fJbJcu5mdgVuf+vCdiwDBS6gEOpg9vcpLr2+ZHG+gbV/uQLBEAa5yKmFRMDjO+xLBdJLh6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901261; c=relaxed/simple;
	bh=WrRAkZWX2mY1Sn4BYh8lP0+Uv8J4x4xta8TyjbzO6EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eg+ZTc3qFaUR+ZD07xUR4jhwRToYCCqj/hnYD+0zbR6zSm/MjXc7vnpeVNtX6YVh1W8JbaBAYWsyyA2caXYulvJYJp8KbSsCkPfgilCIP01t9cFFFU3Qj6X2QHNTkq94M82nyBrTTWwbZUPAsiR6ienGkhyi67DKlUKijO6OfSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTugHwwU; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTugHwwU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901260; x=1793437260;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WrRAkZWX2mY1Sn4BYh8lP0+Uv8J4x4xta8TyjbzO6EM=;
  b=TTugHwwU+23SqVUVibsuWwEOF4Fdnbuqg8M1H39ZZP3qhgOIG5s0oDuR
   pmJv4GaQFR2H64IeJJJ5Vvkacx4M0jB8CjnXZbbfQncvkJXKhLcH4EnO3
   oOPb9NmilMUsapWwkONJwozxx4QsmBagYhWtpmE7uwgH6pYb+qCJFv9rD
   KagFgqYLc7+X3CsXoZyBeobSWkpUJMg51c2k7xLLyvuL7hoBXqL1MmcQi
   Ov2gl3NzlMLym/NZFEzDIZJwWItdbivu3oHMAApd5SnbwnOAOfDbYDtjA
   EvspXlq+M2MpoRe0dwTGJ86qqwlfr7UifMeBEmv9GrLDszByiz3W4oTc6
   w==;
X-CSE-ConnectionGUID: 3FV/qJz2Tqac0AmliiXDZQ==
X-CSE-MsgGUID: LFhn08ZXT+e3dDyw9kynNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63754340"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="63754340"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:00:58 -0700
X-CSE-ConnectionGUID: Dd9eBStPTB2R+zNgqb0uKQ==
X-CSE-MsgGUID: AT1MnrH1RWGItLZni9BlRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186120016"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:00:50 -0700
Message-ID: <326290aa-def6-478c-9ef3-1649e027e5d5@linux.intel.com>
Date: Fri, 31 Oct 2025 17:00:48 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/28] KVM: TDX: Derive error argument names from the
 local variable names
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
 <20251030200951.3402865-20-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> When printing SEAMCALL errors, use the name of the variable holding an
> error parameter instead of the register from whence it came, so that flows
> which use descriptive variable names will similarly print descriptive
> error messages.
>
> Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5e6f2d8b6014..63d4609cc3bc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -41,14 +41,15 @@
>   #define TDX_BUG_ON(__err, __fn, __kvm)				\
>   	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
>   
> -#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
> -	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
> +#define TDX_BUG_ON_1(__err, __fn, a1, __kvm)			\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx", a1)
>   
> -#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
> -	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
> +#define TDX_BUG_ON_2(__err, __fn, a1, a2, __kvm)	\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 " 0x%llx", a1, a2)
>   
> -#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
> -	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
> +#define TDX_BUG_ON_3(__err, __fn, a1, a2, a3, __kvm)	\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 ", 0x%llx, " #a3 " 0x%llx", \
> +		     a1, a2, a3)
>   
>   
>   bool enable_tdx __ro_after_init;

