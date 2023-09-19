Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CE630F96
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695114108; x=1726650108;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3lbpMHnCnN4tgBMsnlxIOe9ua6EYGffh/u6hevJylxY=;
  b=SEv6rbhcAG8Brikv8KxJ0iQqqHg8DpUiAaNs2NfGenCq9A8bNsfHsqOn
   1ZdP+JZplJJalD33nSs/kZOqOBBD8MM7rSCvpNUB5aF+SoCpiSAEB1WWw
   Po/wTwi0+8idSbCLrB6wiqfT5vA2PB11nF/c9fQfjLAlGnyGmOwGD/dmO
   YSf81UZ7oFrzNhOeiSr0zH5pDk10Hn3XPvP5ZzyGyEnPVMNgkWvItHiGX
   r+oihA0xvHZhdqaDCXXZnBu7uN741b++en1OTt1h3oZxNUDUJBqhGThHb
   zLPyIHzCI1l/ckkx2RbKOxocPk6DBUYn9r51JpbsfpI0zzxnl/zJB5zVm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="377201123"
X-IronPort-AV: E=Sophos;i="6.02,159,1688454000"; 
   d="scan'208";a="377201123"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 02:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="695833326"
X-IronPort-AV: E=Sophos;i="6.02,159,1688454000"; 
   d="scan'208";a="695833326"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.84]) ([10.238.8.84])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 02:01:36 -0700
Message-ID: <e397d30c-c6af-e68f-d18e-b4e3739c5389@linux.intel.com>
Date: Tue, 19 Sep 2023 17:01:31 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v12 14/33] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>,
 Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Maciej Szmigiero <mail@maciej.szmigiero.name>,
 David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>,
 Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
 Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230914015531.1419405-1-seanjc@google.com>
 <20230914015531.1419405-15-seanjc@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230914015531.1419405-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/2023 9:55 AM, Sean Christopherson wrote:
[...]
> +
> +static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> +				      pgoff_t end)
> +{
> +	struct kvm_memory_slot *slot;
> +	struct kvm *kvm = gmem->kvm;
> +	unsigned long index;
> +	bool flush = false;
> +
> +	KVM_MMU_LOCK(kvm);
> +
> +	kvm_mmu_invalidate_begin(kvm);
> +
> +	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
> +		pgoff_t pgoff = slot->gmem.pgoff;
> +
> +		struct kvm_gfn_range gfn_range = {
> +			.start = slot->base_gfn + max(pgoff, start) - pgoff,
> +			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
> +			.slot = slot,
> +			.may_block = true,
> +		};
> +
> +		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
> +	}
> +
> +	if (flush)
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	KVM_MMU_UNLOCK(kvm);
> +}
> +
> +static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
> +				    pgoff_t end)
> +{
> +	struct kvm *kvm = gmem->kvm;
> +
> +	KVM_MMU_LOCK(kvm);
> +	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT))
> +		kvm_mmu_invalidate_end(kvm);
kvm_mmu_invalidate_begin() is called unconditionally in 
kvm_gmem_invalidate_begin(),
but kvm_mmu_invalidate_end() is not here.
This makes the kvm_gmem_invalidate_{begin, end}() calls asymmetric.


> +	KVM_MMU_UNLOCK(kvm);
> +}
> +
> +static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
> +{
> +	struct list_head *gmem_list = &inode->i_mapping->private_list;
> +	pgoff_t start = offset >> PAGE_SHIFT;
> +	pgoff_t end = (offset + len) >> PAGE_SHIFT;
> +	struct kvm_gmem *gmem;
> +
> +	/*
> +	 * Bindings must stable across invalidation to ensure the start+end
> +	 * are balanced.
> +	 */
> +	filemap_invalidate_lock(inode->i_mapping);
> +
> +	list_for_each_entry(gmem, gmem_list, entry) {
> +		kvm_gmem_invalidate_begin(gmem, start, end);
> +		kvm_gmem_invalidate_end(gmem, start, end);
> +	}
Why to loop for each gmem in gmem_list here?

IIUIC, offset is the offset according to the inode, it is only 
meaningful to the
inode passed in, i.e, it is only meaningful to the gmem binding with the 
inode,
not others.


> +
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return 0;
> +}
> +
[...]
