Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407051E51A
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689954140; x=1721490140;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=dgWqCDpNSWuzZvJih5GvRdqDtkxO0fYOrqXInsikkp8=;
  b=Bdht11JlzuM2IdRQlA1az3gNEKhWCb7NqR0Oa8NKVofUZXGhau7NEP7m
   M8M++jhSyV9vrEr7h8KlT+0e4ky/yI8GdWzETWzz9vImVT636zJMLk2pc
   t9AxN3VmF4CmgIE8D+LoHiJmGkXwW1SCyLEAIb6K8TJrsJ735qxbA9V1H
   DldHGmduttvOlgbA7DjGTG/KqMvU/cTol/qNyMlPQlx7EWficFvoOH0HJ
   E3N7MEa5Qnrui6MhWdSx66QzXYFnQl4h93gLETJXHoYXEpUGAvkDck1Jj
   0mFJZgYqBSgAYFKhP0OkqlmtzQVpaFOnq78zzd4pgihoDRQpX6F2bgV8x
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10778"; a="367087036"
X-IronPort-AV: E=Sophos;i="6.01,222,1684825200"; 
   d="scan'208";a="367087036"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 08:42:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="868274880"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 08:42:09 -0700
Message-ID: <29baac45-7736-a28c-3b2d-2a6e45171b8b@intel.com>
Date: Fri, 21 Jul 2023 23:42:04 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
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
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Maciej Szmigiero <mail@maciej.szmigiero.name>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>,
 Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>,
 Wang <wei.w.wang@intel.com>, Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-13-seanjc@google.com>
 <fdc155f5-041b-a1b1-15aa-8f970180a13a@intel.com>
In-Reply-To: <fdc155f5-041b-a1b1-15aa-8f970180a13a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/21/2023 11:05 PM, Xiaoyao Li wrote:
> On 7/19/2023 7:44 AM, Sean Christopherson wrote:
>> @@ -6255,12 +6298,17 @@ int kvm_init(unsigned vcpu_size, unsigned 
>> vcpu_align, struct module *module)
>>       if (r)
>>           goto err_async_pf;
>> +    r = kvm_gmem_init();
>> +    if (r)
>> +        goto err_gmem;
>> +
>>       kvm_chardev_ops.owner = module;
>>       kvm_preempt_ops.sched_in = kvm_sched_in;
>>       kvm_preempt_ops.sched_out = kvm_sched_out;
>>       kvm_init_debug();
>> +    kvm_gmem_init();
> 
> why kvm_gmem_init() needs to be called again? by mistake?

I'm sure it's a mistake.

I'm testing the gmem QEMU with this series. SW_PROTECTED_VM gets stuck 
in a loop in early OVMF code due to two shared page of OVMF get zapped 
and re-mapped infinitely. Removing the second call of kvm_gmem_init() 
can solve the issue, though I'm not sure about the reason.
