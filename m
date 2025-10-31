Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC62F2E6105;
	Fri, 31 Oct 2025 08:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761898771; cv=none; b=TgtMGJOS14N00uCIDOTDbGXOG/AHDXiQRnJ9lK+uNHMIS5GJvThVF7Cy4yq32TcgWQC4+Is7uFkWXOud/PYQKY8nauFD5MApqRu+hIzUftkts88eLBR8KTnUoketQH5fujuQ8uCOOBWztM+II7LukSs0BcULv48dNpJCbIE7Ykc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761898771; c=relaxed/simple;
	bh=EzjqWFPbYzjEfpDteBcncRVxcsQvYXXWJGNfJY3z6Qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T91HlWOFQc8hUHB5ZoEIdgRMftFqe9nE4qp6JDJg/ad/dDrNc+/8wMq4cSkzvMZ12sYfTNSawSctfe2+LDGN5cAWckfv5I9P1FZN9v+s4JUaqSqmPPIe2WsTHru6nuhmEEor+O9LJpHmlqFsklkmyJus3euvDNI0o0P4YjHRi8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h5PR8BBI; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h5PR8BBI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761898769; x=1793434769;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EzjqWFPbYzjEfpDteBcncRVxcsQvYXXWJGNfJY3z6Qw=;
  b=h5PR8BBIcIayQULuVhwLHSGYdeIzmMIi45leB1FQsJsPHaQtZ9hkKggZ
   1Zx89h1VGzbUCoYibZecue/QkLPxh7u0pJ8FyZEM6da1M8ohXQTBnRLLK
   fB0OtthS2UnIJICWthh6v2R1xuKqyoVC3auGIITxTg88f8jR1DhderWh+
   NavU3SvZ39OSanI8UCgZVrGNWRyy4pX1ag6lKrOY9YekTAnfW6SKP0LqO
   EKYy0cUzqZzqgs9suRjgw1t0XHBqKQdnxEqGqb00yvfHabHd4kTuTpniV
   uO2qB8rFLWCqQ8fF0sExTxJB9OuG5DyztvrS4svS5feJ0LkFQFEQF1w+a
   w==;
X-CSE-ConnectionGUID: qJlVLwSARsCzphMMYgVShA==
X-CSE-MsgGUID: 887wWfi+QGGD3Ao5bFtM5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63073660"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="63073660"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:19:29 -0700
X-CSE-ConnectionGUID: ln37oo4sSVGgtPADrikf7g==
X-CSE-MsgGUID: Cf3BSL1nT0KAv+tRtGKg6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="186112068"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:19:22 -0700
Message-ID: <af023723-63d5-46d3-85bb-c2d2dcfe7b15@linux.intel.com>
Date: Fri, 31 Oct 2025 16:19:18 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/28] KVM: TDX: WARN if mirror SPTE doesn't have full
 RWX when creating S-EPT mapping
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
 <20251030200951.3402865-13-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Pass in the mirror_spte to kvm_x86_ops.set_external_spte() to provide
> symmetry with .remove_external_spte(), and assert in TDX that the mirror
> SPTE is shadow-present with full RWX permissions (the TDX-Module doesn't
> allow the hypervisor to control protections).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

