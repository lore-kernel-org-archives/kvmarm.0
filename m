Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDE8DF67
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 10:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689936449; x=1721472449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lqUeKJjFv2Sxri0zg/OC/DAKL78i5iZqhBI02xpLRko=;
  b=IHdX0I2DDc7BXFiXGKmPzqM+saihPobA3njOZJYB232B5tuzFh0/OJlP
   HWRaw7RPFnO/WaMumrZwJSkUPe0ko+4QIX8nw962RvLarzbO4LIxI8nd9
   zPDA5leFFhJPEjgX6T6OXZAX1zrKLSCc6Ap8TTf3/O8mrTqAJdGoc/2ZH
   wtIX4twv2to15J+zHjSwdIHY8/qyFMeg3KpMQt7oMcO4meIkIrLyg7ItR
   YLnhmSmLRRbya9B0lpDpuYIfl+6Vx+aRg5ZJOvvhqziYoDuDNfsR8dL1u
   Nzqm1IGoTTWvrfO5cXTP2VHfuTKn4GItBTQiuu+ofUCEqHhYTUWEJWqJA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="365884902"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="365884902"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 03:47:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="724827627"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="724827627"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga002.jf.intel.com with ESMTP; 21 Jul 2023 03:47:13 -0700
Date: Fri, 21 Jul 2023 18:45:26 +0800
From: Xu Yilun <yilun.xu@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC PATCH v11 01/29] KVM: Wrap kvm_gfn_range.pte in a
 per-action union
Message-ID: <ZLphxpSTL9Fpn1ye@yilunxu-OptiPlex-7050>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-2-seanjc@google.com>
 <ZLolA2U83tP75Qdd@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLolA2U83tP75Qdd@yzhao56-desk.sh.intel.com>

On 2023-07-21 at 14:26:11 +0800, Yan Zhao wrote:
> On Tue, Jul 18, 2023 at 04:44:44PM -0700, Sean Christopherson wrote:
> 
> May I know why KVM now needs to register to callback .change_pte()?

I can see the original purpose is to "setting a pte in the shadow page
table directly, instead of flushing the shadow page table entry and then
getting vmexit to set it"[1].

IIUC, KVM is expected to directly make the new pte present for new
pages in this callback, like for COW.

> As also commented in kvm_mmu_notifier_change_pte(), .change_pte() must be
> surrounded by .invalidate_range_{start,end}().
> 
> While kvm_mmu_notifier_invalidate_range_start() has called kvm_unmap_gfn_range()
> to zap all leaf SPTEs, and page fault path will not install new SPTEs
> successfully before kvm_mmu_notifier_invalidate_range_end(),
> kvm_set_spte_gfn() should not be able to find any shadow present leaf entries to
> update PFN.

I also failed to figure out how the kvm_set_spte_gfn() could pass
several !is_shadow_present_pte(iter.old_spte) check then write the new
pte.


[1] https://lore.kernel.org/all/200909222039.n8MKd4TL002696@imap1.linux-foundation.org/

Thanks,
Yilun

> 
> Or could we just delete completely
> "kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);"
> from kvm_mmu_notifier_change_pte() ?
