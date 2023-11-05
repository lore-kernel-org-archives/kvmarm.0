Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1023B3
	for <kvmarm@lists.linux.dev>; Sun,  5 Nov 2023 13:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/7+cBYV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699189480; x=1730725480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mFE9c4kKSFVvQT9y1x5f+rwwI1//UOO/ul+Hvls5bPM=;
  b=l/7+cBYVIf7uc8W+1N+ffCLoWuzaUYUnSAPMV2Fteh+D3rMH4/FgudPA
   OoV33iD7J8N2XwIaQzj+iO5goL7EuR0IXh+xYzoYkY/3O07RZpo+zHSEr
   aCMl/dfJQQRiiuw96x8GK3RrkPbFik2yw+TQzDDjIt9trFc6xGa9prI/o
   d4cNMRlKRRVomp5woU7BzY8cYulj3+EkYPrFeInSRMJJYSoOKarUeSunf
   Wfwwv4YkLow5e3FEfTT8AQB64OmZ196WkXX7xvI7ObND2uMRGyfWfXjFn
   kG2cCcwLKY7w4uqNtZvH9jveqb6HC63LWc1tZvUoeJctmrW3n+16I5xZD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10884"; a="388033712"
X-IronPort-AV: E=Sophos;i="6.03,279,1694761200"; 
   d="scan'208";a="388033712"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2023 05:04:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,279,1694761200"; 
   d="scan'208";a="10206430"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2023 05:04:02 -0800
Date: Sun, 5 Nov 2023 21:02:32 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Anish Moorthy <amoorthy@google.com>,
	David Matlack <dmatlack@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	David Hildenbrand <david@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v13 20/35] KVM: x86/mmu: Handle page fault for private
 memory
Message-ID: <ZUeSaAKRemlSRQpO@yilunxu-OptiPlex-7050>
References: <20231027182217.3615211-1-seanjc@google.com>
 <20231027182217.3615211-21-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027182217.3615211-21-seanjc@google.com>

> +static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> +					      struct kvm_page_fault *fault)
> +{
> +	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> +				      PAGE_SIZE, fault->write, fault->exec,
> +				      fault->is_private);
> +}
> +
> +static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> +				   struct kvm_page_fault *fault)
> +{
> +	int max_order, r;
> +
> +	if (!kvm_slot_can_be_private(fault->slot)) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return -EFAULT;
> +	}
> +
> +	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
> +			     &max_order);
> +	if (r) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return r;

Why report KVM_EXIT_MEMORY_FAULT here? even with a ret != -EFAULT? This is
different from the decription where KVM_EXIT_MEMORY_FAULT is introduced:

  KVM_EXIT_MEMORY_FAULT will be used to report memory faults that appear to
  be implicit conversions.

  To allow for future possibilities where KVM reports KVM_EXIT_MEMORY_FAULT
  and fills run->memory_fault on _any_ unresolved fault, KVM returns
  "-EFAULT"

Thanks,
Yilun

> +	}
> +
> +	fault->max_level = min(kvm_max_level_for_order(max_order),
> +			       fault->max_level);
> +	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> +
> +	return RET_PF_CONTINUE;
> +}
