Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A22E6123
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 06:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694760449; x=1726296449;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nbiNTtCye3B4MOA9keAnL3jGRC3Z0ZFqO6c5ckMzgn4=;
  b=DezGOKHC77KnfZ4+W70StJamxTSX9G4/vDZdgQgNkmJIk7xKsOuLSTYd
   cgKsiTGD3QE09NWsL3cAWG68GTXvv5fq9AgKzzppeQsXlM1SBDVSfJ5Ch
   SXC+NRFKy6ldk/xVL2WSxP5xFTRdU7YFuayf9MdfOczejFnrkfqQ9yh4B
   m6+tMlP58l9OELQLiwb7Ee67casNkwmXlg5kz4Tv078X15bd29OlPsYaY
   MoM4ado6curPC/YXYlQ6SdpMhVQN68HcqUQPjP4fWdk/UPHfhRZEHjKH9
   odvwn9MhuZaDV50NsLT/fHnCzQvtjmWAppnb8ilkwCCgVcrvbbBjtMdIH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="383000900"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="383000900"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 23:47:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="744857575"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="744857575"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 23:47:16 -0700
Message-ID: <d4166c97-6ab3-89a2-eb12-f492f7521f69@intel.com>
Date: Fri, 15 Sep 2023 14:47:13 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v12 01/33] KVM: Tweak kvm_hva_range and hva_handler_t
 to allow reusing for gfn ranges
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>,
 Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
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
 <20230914015531.1419405-2-seanjc@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230914015531.1419405-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/2023 9:54 AM, Sean Christopherson wrote:
> Rework and rename "struct kvm_hva_range" into "kvm_mmu_notifier_range" so
> that the structure can be used to handle notifications that operate on gfn
> context, i.e. that aren't tied to a host virtual address.
> 
> Practically speaking, this is a nop for 64-bit kernels as the only
> meaningful change is to store start+end as u64s instead of unsigned longs.
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
>   1 file changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 486800a7024b..0524933856d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -541,18 +541,22 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
>   	return container_of(mn, struct kvm, mmu_notifier);
>   }
>   
> -typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
> +typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);

Is it worth mentioning the rename of it as well in changelog?

Anyway,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
