Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD8D29B8D2
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 05:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752643501; cv=none; b=ls6Ik8ZrWD8dO6mMo+krFDkSP5KTp7x6zTfQHKWsU4BaGOz46b5MsRIFahKlNtHH8KMcsn9kW997REQ2CU8AhKlg5QieeDrHXZkTChIwiqm7C8Kfv1pibzh1k9vdsHzE7wyeNnXTTwu6giL7l11l7k1KP3O0WQhy1jOICkglE/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752643501; c=relaxed/simple;
	bh=858M61+pTJeW4vVadFBhzBuGsh9DKhlYXvrOJHC8eC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzG1M8xf1qcrjDeRBNgIBJe4+dMjllB1TshAhfF8qFwd9fxZeTiGqFW4uODGToB+fWHylhQzVaFYLzIpK5fhnwdD2U36p8q1Qs1IX7DnrHj4o653LzgG09ex8Bz5D4FDsdoEHVJCjVjILpeXqDw+d7NaBJ4tO447u7War8gs09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QLpCJykx; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QLpCJykx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752643499; x=1784179499;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=858M61+pTJeW4vVadFBhzBuGsh9DKhlYXvrOJHC8eC0=;
  b=QLpCJykxPAb4Xorb5L2UiuCsgYQkYwZQGFHYbp3dEqSoZOkxprkPJ59j
   ayuVXYuH4g/emyoIkCXUoxB0IfpSjiJeFMcb7m/7LIm4cKu4kcLgOsvRv
   rRMuRhG6fnIESisKUL+6xNJvP4E1oWnGqbGwrzLEB2WEjqiQdn2I2UStl
   NXwdAQzOGlTgqNGoM1KF4qJdr/S8Ibf4NoqjiCmH+6Cb6w/QcsCTkxsXy
   CIOeYlEUggopdD5AD8QgTYhd43aSLLb7bhgAPVVEJWgjl1wnWfpqSYaFt
   LM7cfmTFPI56Uqc3gC2glnLKEsT0t7UbWUerrskIy6kNpN7HiGGrcf+Vv
   Q==;
X-CSE-ConnectionGUID: 3KXRpZjRTvSmPn/94Cjh5A==
X-CSE-MsgGUID: 9fRVeIlYRU6+4IAHKKR9Jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54967867"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="54967867"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:24:59 -0700
X-CSE-ConnectionGUID: 6SeRMSYwQBueRNOE00WnsQ==
X-CSE-MsgGUID: mGk2KYScRM+1zZJqkDYI4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="161723805"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:24:43 -0700
Message-ID: <1b4badaa-8336-464e-89d3-b5d94f8487df@intel.com>
Date: Wed, 16 Jul 2025 13:24:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/21] KVM: Fix comment that refers to kvm uapi header
 path
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-8-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> The comment that points to the path where the user-visible memslot flags
> are refers to an outdated path and has a typo.
> 
> Update the comment to refer to the correct path.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   include/linux/kvm_host.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9c654dfb6dce..1ec71648824c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -52,7 +52,7 @@
>   /*
>    * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
>    * used in kvm, other bits are visible for userspace which are defined in
> - * include/linux/kvm_h.
> + * include/uapi/linux/kvm.h.
>    */
>   #define KVM_MEMSLOT_INVALID	(1UL << 16)
>   

