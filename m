Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A11C20
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 07:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695023515; x=1726559515;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F92rNU2upp1sAb9O/m30BxSQQfs05gdxlTOIwaluPho=;
  b=gb7QfdLj4L4ihjLLOdTuzP5NQV5P4uW9ry5TMuFR+qGTTL8tk9tg2hAS
   +FA9C1A+STzOT2Zfdx9AodyatFQNUuqo/cL4NoP87EGW4VHh+D6SqINnM
   bO8ldFVJOf+GwVG4b5rncPstb0wKDqmk0df9xBFm8LHQQv5XALa1B1Vs8
   qYfKxpIWGVWh8cU9BHZa6VyvAeEA8NSlcPsPOi4mX/HxcjLTl9RgZeWGO
   +0fvkETy1/Jq0AubCahWBZJ1ZrGNFmeQMJY1KS0KiDUv2Phz+mna0bxLU
   ZFAA1BHEz22zpDPmaWKWsKV7gLZrJ0gcr7bW1dM6Ox1gKw45olY9+KT4l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="382335530"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="382335530"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 00:51:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="811262156"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="811262156"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.84]) ([10.238.8.84])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 00:51:45 -0700
Message-ID: <d66795f8-e524-2912-4b71-92ca4ffe8807@linux.intel.com>
Date: Mon, 18 Sep 2023 15:51:43 +0800
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
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230914015531.1419405-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/2023 9:55 AM, Sean Christopherson wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
[...]
>   
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +/*
> + * Returns true if _all_ gfns in the range [@start, @end) have attributes
> + * matching @attrs.
> + */
> +bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +				     unsigned long attrs)
> +{
> +	XA_STATE(xas, &kvm->mem_attr_array, start);
> +	unsigned long index;
> +	bool has_attrs;
> +	void *entry;
> +
> +	rcu_read_lock();
> +
> +	if (!attrs) {
> +		has_attrs = !xas_find(&xas, end);
IIUIC, xas_find() is inclusive for "end", so here should be "end - 1" ?


> +		goto out;
> +	}
> +
> +	has_attrs = true;
> +	for (index = start; index < end; index++) {
> +		do {
> +			entry = xas_next(&xas);
> +		} while (xas_retry(&xas, entry));
> +
> +		if (xas.xa_index != index || xa_to_value(entry) != attrs) {
> +			has_attrs = false;
> +			break;
> +		}
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +	return has_attrs;
> +}
> +
>
[...]
