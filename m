Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7951D1BEE4
	for <kvmarm@lists.linux.dev>; Thu, 27 Jul 2023 03:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690428446; x=1721964446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zZw7shzyeqWcwUz/3pXk4wTr0ManqzTTZSighI1zgHU=;
  b=dRUXKvkH6V56pvie6C1nF0+imp5QOmv/BsMHKdoVOB9ngW1bSKtz+lZt
   a3E7O1kTWcCQcZR8VFbXFdBNHqbKWXrwYNSgmXAKg4voxVyb6jpTWmdkw
   55KbfRBTc97stm9rU2Vb/7xg023Bf4E9dsA0scUsbOLnZWzgFotIUSGwE
   E1Sb3LyOy10nYdESkOTrWGiG6rpO7S8Z4BnMG1pZgtEbGQhevc6oNb2gw
   zVBpayuKbeTlizkFqzYC2nNgsfSNuoS7Uh1/8vFnH9pKEJOT5yAGDRjcq
   yS51kU6RQMy57MmwMLRJg6E2bKjeI2Epr7lpV+MZpTe0WmR87Ghl044fd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="347798997"
X-IronPort-AV: E=Sophos;i="6.01,233,1684825200"; 
   d="scan'208";a="347798997"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 20:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="870179046"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jul 2023 20:26:15 -0700
Date: Thu, 27 Jul 2023 11:24:22 +0800
From: Xu Yilun <yilun.xu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [RFC PATCH v11 08/29] KVM: Introduce per-page memory attributes
Message-ID: <ZMHjZvcmzxMhTyM3@yilunxu-OptiPlex-7050>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-9-seanjc@google.com>
 <ZL4BiQWihfrD0TOJ@yilunxu-OptiPlex-7050>
 <ZMFC+V6Llv1JWLEt@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMFC+V6Llv1JWLEt@google.com>

On 2023-07-26 at 08:59:53 -0700, Sean Christopherson wrote:
> On Mon, Jul 24, 2023, Xu Yilun wrote:
> > On 2023-07-18 at 16:44:51 -0700, Sean Christopherson wrote:
> > > +	if (WARN_ON_ONCE(start == end))
> > > +		return -EINVAL;
> > 
> > Also, is this check possible to be hit? Maybe remove it?
> 
> It should be impossible to, hence the WARN.  I added the check for two reasons:
> (1) to help document that end is exclusive, and (2) to guard against future bugs.

Understood. I'm good to it.
