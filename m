Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6853171D8
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689864387; x=1721400387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K1NwaJnTR9TKmGdPrMBjNm/Xn1+Yu2b1Z2uzK/Twzrs=;
  b=YNkI1uT372myB60tlr9ev9AAqP/jAAoUPwKfY1VmdjY+23NfI+UhmNu6
   h7lSpxUddu3nu5VXdY1Hj0h5ZTpGvD+dUwomzOtAMpYkboDDyGm0kjPMh
   kHBHhHrV+ml1FmmIZCGV/h9f2SKpOMGlqAe8M35mDUipLY8o+KTqu/1tB
   IzCf1XUrG/3ufnyjVYMrttx/BJM0a8nfb1yGHuo0L3shhz5/IgiBMS1GZ
   IDYjkRilyLtIuQel2XijvsG7W70GuiqoUNJSJYpdLdXTjwAYR+40K08pm
   sEB+PM0zGnRHVXOZcG67OumQyEOWdHyt1tkndebTrxM7uOruXSPiYX8pZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364218119"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="364218119"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:46:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="971059338"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="971059338"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:45:52 -0700
Message-ID: <83eb5c50-7287-7845-ffc3-a7c58e638ea5@intel.com>
Date: Thu, 20 Jul 2023 22:45:48 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230718234512.1690985-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/2023 7:44 AM, Sean Christopherson wrote:
> @@ -5134,6 +5167,16 @@ static long kvm_vm_ioctl(struct file *filp,
>   	case KVM_GET_STATS_FD:
>   		r = kvm_vm_ioctl_get_stats_fd(kvm);
>   		break;
> +	case KVM_CREATE_GUEST_MEMFD: {
> +		struct kvm_create_guest_memfd guest_memfd;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&guest_memfd, argp, sizeof(guest_memfd)))
> +			goto out;
> +
> +		r = kvm_gmem_create(kvm, &guest_memfd);
> +		break;
> +	}

Does it need a new CAP to indicate the support of guest_memfd?

This is patch series introduces 3 new CAPs and it seems any one of them 
can serve as the indicator of guest_memfd.

+#define KVM_CAP_USER_MEMORY2 230
+#define KVM_CAP_MEMORY_ATTRIBUTES 231
+#define KVM_CAP_VM_TYPES 232

or we just go and try the ioctl, the return value will tell the result?
