Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7532F76E;
	Fri, 31 Oct 2025 09:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761902119; cv=none; b=ubeTTsvIZWKhamr9a6vE3ixv/Vg90ioBokdBbpPS0ZXrdyrnGMfmuaRkQX+hr1FVcv2Hic9lkZ9VA1/Nf7vskKgB9qVdy0NBXmbqM6e8ha0H8NxjmCmSBiM0sFZ0Lq9c4Z3VvetZhCrZAmCj/ICubNjFB9CiEDa0bMq8AlOaI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761902119; c=relaxed/simple;
	bh=PEZyjCEAirGsnd1ualshLT165jeP3bC2ATQpTmkSqys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IiOJCxlH8j67suXtlETDeTRZoPtAxRlMQ0ddJwNDNbbS/2ql+LSck8wHjMn2d9nfISJTI6VO+fLDr9z++PZeykoKA+nfrJ+eZxy6Qzz4pz3obCQpYtbouSkhyRtQSrE0KdMF7t7wwgkVxNYA7tr0qpvEb2L/g2fpY7V+EDNvDgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yfzd9f/s; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yfzd9f/s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761902118; x=1793438118;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PEZyjCEAirGsnd1ualshLT165jeP3bC2ATQpTmkSqys=;
  b=Yfzd9f/sIok4+o0zo/xUtlmfatT/+R4jajipZ4d32S6zCp3ywegKYy7E
   ++31N7lSnibtghpT+D7Ttnl4TB1d/IVdgMbw8C8zhxLONeMAifFs11r9O
   piOw7GkpCWFf9lYanm6CjmdSnuuS9amZXbSQYGJ3mJjPc8V1zuV3G5L/6
   Aj1RslXoq4WB9t0dVYyAZso7AbMZQfDkDBRbiuChdAzOMIhjfO6ftaLLF
   +4BM86CMIiIInWCUwUoL6pPKOLrr2BfeapOAKHhKs+fWnJaSKaaqetiMx
   FbKLWmiA43/r7BAcg94AUfv5sbxYPVP2WZgJOZFctHfnEeIROKQ51XCez
   A==;
X-CSE-ConnectionGUID: X8D0DOnFSBqP9G2XF/emNA==
X-CSE-MsgGUID: eZ+n1r19QaKggkcXx8QKyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="67714188"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="67714188"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:15:18 -0700
X-CSE-ConnectionGUID: /aUTuTUZR1CXvXYAACxkEg==
X-CSE-MsgGUID: 8/kgW76KTTCO7UxJ6gCbbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186125404"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:15:09 -0700
Message-ID: <fd65c501-296a-4f77-86fc-7de61a7c5eeb@linux.intel.com>
Date: Fri, 31 Oct 2025 17:15:06 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 23/28] KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU
 to "unlocked" vCPU ioctl
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
 <20251030200951.3402865-24-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-24-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Handle the KVM_TDX_INIT_MEM_REGION and KVM_TDX_INIT_VCPU vCPU sub-ioctls
> in the unlocked variant, i.e. outside of vcpu->mutex, in anticipation of
> taking kvm->lock along with all other vCPU mutexes, at which point the
> sub-ioctls _must_ start without vcpu->mutex held.
>
> No functional change intended.
>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

