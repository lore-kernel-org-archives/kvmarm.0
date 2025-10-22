Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5622FE0A;
	Wed, 22 Oct 2025 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112633; cv=none; b=lHpxRfpGHnRnJii8jixy9dQjgEuDisWaKxAn2OHf779cyCjN+qYcVo2U2zsE1GRjXwDYkI9ZZKxmcL5y0fsucgNWNv4RJUVvibJJokmLZdkV2nhvt5vKWLSUnBuwvYtMDy9K8iEt5OE0qMjrwmNLeiBrNtBq0IYHD0lXSMgL5aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112633; c=relaxed/simple;
	bh=Oq4fzkS01zCv2I4qOypTEqukIE12MkuzMGCj+rV1CCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8beWpQYU8kDDB0hGfHzBb51xtmh4CrnUn99Xiit+whnvuJetiTkofomXtjkmXjupJu7U+4tgeh32jH2AmxvHImeW9sc5MQPaOZTNVEfc0QFIzfD8CfShQnfSKOo75SBsIMYQM2KIhGZyQopu76fCPY1Tbe/+GxPDw+ypRmUeJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7Jfqqcd; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7Jfqqcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761112631; x=1792648631;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Oq4fzkS01zCv2I4qOypTEqukIE12MkuzMGCj+rV1CCw=;
  b=E7Jfqqcdu7VQT1dxrFmwMMNAG5K7CoSj6nOrzt4x7aIA+SIH9WASa5dI
   i1AP78MKcZ87csLhzI+funJzjC1R+n7awfOxP2gYyMUNU5k7rgJeaoXVB
   wpzZ9yfNenup1BpwBpvRAcoDhSzIBCK1Mv+q0Mi3bF1clrloQOrP/k1Is
   4csnRM4NjzKFLc4rvl4RRjtrGgtf/Oq3nTGydaLfxZKovYO6Mk+b90t5s
   5Tfw9lBgIXzkp9TYnhE/1rZ8st4YLBIfEoGkS2L7mKs/TBQGyySTzMzi5
   4WixOG036XIQOZ7TvC27lkSBtBke8uDHVqoQeSmNEfGfvVnRYzBuLN6z0
   A==;
X-CSE-ConnectionGUID: DO1qtQB4SLGa4YG4iq7W8Q==
X-CSE-MsgGUID: OmIDiPE9T6SDNdKtQIYUaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63146730"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="63146730"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:57:11 -0700
X-CSE-ConnectionGUID: jQ221r4UTleoxdP+jV1Nkg==
X-CSE-MsgGUID: d9hLZVuOTp+rHjN7swLSrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="184184728"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:57:02 -0700
Message-ID: <bfe00290-6ab3-4c09-b0bf-46bb7af09d60@linux.intel.com>
Date: Wed, 22 Oct 2025 13:57:00 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/25] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_page_prefault()
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
 <20251017003244.186495-7-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251017003244.186495-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> Rename kvm_tdp_map_page() to kvm_tdp_page_prefault() now that it's used
> only by kvm_arch_vcpu_pre_fault_memory().
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
