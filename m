Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7242C80
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 05:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695791983; x=1727327983;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XWRHK3XHMCPUS7DjwBYEn6sN3WEf4Pd1a63R09LlTdM=;
  b=IkVua2/1L3QXZK2DUAvNCtEr9cS7mcR2wJvcJB55XEJ6zOh2zIH5jd8D
   dNXoxoKyq//fJytp+mrp9AbkRE2Lz3gJd8KorArJhP6U82KPw+AC70+qf
   hucRbDJzFgMDZsTzv2JcUQLYzxIBZU/4+i5rDXL5caZNzwM2ZIDcryzas
   L90JRTqsIElugeydmuZhoxPSivXBxFFhEllKl/Kshx+KE/PwpIs46BpWY
   BTreaDVfpnq/WqeIo9UQd1odVwg4DgOEOL6QdLOa2GJNqAwjELoG5j/bs
   9kfIk9SF55qfnfvqc/LJXqCybz+7RS07bhgYbHza8pLHKKeFFgFnuJR1y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="381633590"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="381633590"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 22:19:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="725676254"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="725676254"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.84]) ([10.238.8.84])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 22:19:32 -0700
Message-ID: <483f9e1e-7d01-5f06-3bfa-3788d2554724@linux.intel.com>
Date: Wed, 27 Sep 2023 13:19:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v12 11/33] KVM: Introduce per-page memory attributes
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
 <20230914015531.1419405-12-seanjc@google.com>
 <d66795f8-e524-2912-4b71-92ca4ffe8807@linux.intel.com>
 <ZQteNbPfx6P3r6B8@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZQteNbPfx6P3r6B8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/21/2023 5:03 AM, Sean Christopherson wrote:
> On Mon, Sep 18, 2023, Binbin Wu wrote:
>>
>> On 9/14/2023 9:55 AM, Sean Christopherson wrote:
>>> From: Chao Peng <chao.p.peng@linux.intel.com>
>> [...]
>>> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>>> +/*
>>> + * Returns true if _all_ gfns in the range [@start, @end) have attributes
>>> + * matching @attrs.
>>> + */
>>> +bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>>> +				     unsigned long attrs)
>>> +{
>>> +	XA_STATE(xas, &kvm->mem_attr_array, start);
>>> +	unsigned long index;
>>> +	bool has_attrs;
>>> +	void *entry;
>>> +
>>> +	rcu_read_lock();
>>> +
>>> +	if (!attrs) {
>>> +		has_attrs = !xas_find(&xas, end);
>> IIUIC, xas_find() is inclusive for "end", so here should be "end - 1" ?
> Yes, that does appear to be the case.  Inclusive vs. exclusive on gfn ranges has
> is the bane of my existence.

Seems this one is not included in the "KVM: guest_memfd fixes" patch series?
https://lore.kernel.org/kvm/20230921203331.3746712-1-seanjc@google.com/



