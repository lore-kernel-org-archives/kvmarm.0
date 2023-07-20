Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECDA39B
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689815773; x=1721351773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0X3B3RFBvIohiBDiMK6hMbRCxfxPASWhBjQpW8WFunc=;
  b=hjAlQXaY6PLN1Sw9KT3wtmgXXHYNUSW1TwxtWU07nodBbjC542EuCTHL
   ULK7RD/EfDPvZO6M22Ms9CLbzi7elbt2RFITGO7+eq+tjMPdLtW1VjKj+
   9NC1+KHj733FkFILnifm7utLeWSH2szqLqAG3IEKXOifgILGNchW4oo6v
   qwL2vkUs/6Qb1uv7/i0xUUFs7yIDSjDZPivOM3cCCLYPV1QhaZoddhNwi
   GFmnsXaX6nsF6TEMVlKFqCHBDFoZj2JKzYPuw+7XAyI9Iu1iZY/ql8zK7
   skOv4AslEsVmmYW7VPU6w/V13cDrM9Q6JHf+diHevAV2uEbbweanlR4Vq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="364065916"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="364065916"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 18:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="674516361"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="674516361"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga003.jf.intel.com with ESMTP; 19 Jul 2023 18:15:44 -0700
Date: Thu, 20 Jul 2023 09:15:41 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
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
Subject: Re: [RFC PATCH v11 05/29] KVM: Convert KVM_ARCH_WANT_MMU_NOTIFIER to
 CONFIG_KVM_GENERIC_MMU_NOTIFIER
Message-ID: <20230720011541.6ti5sygwwfwko6ab@yy-desk-7060>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-6-seanjc@google.com>
 <20230719073115.vuedo2cf3mp27xm4@yy-desk-7060>
 <ZLfv7aRq5W52ezek@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLfv7aRq5W52ezek@google.com>
User-Agent: NeoMutt/20171215

On Wed, Jul 19, 2023 at 07:15:09AM -0700, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Yuan Yao wrote:
> > On Tue, Jul 18, 2023 at 04:44:48PM -0700, Sean Christopherson wrote:
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 90a0be261a5c..d2d3e083ec7f 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -255,7 +255,9 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
> > >  #endif
> > >
> > > -#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
> > > +struct kvm_gfn_range;
> >
> > Not sure why a declaration here, it's defined for ARCHs which defined
> > KVM_ARCH_WANT_MMU_NOTIFIER before.
>
> The forward declaration exists to handle cases where CONFIG_KVM=n, specifically
> arch/powerpc/include/asm/kvm_ppc.h's declaration of hooks to forward calls to
> uarch modules:
>
> 	bool (*unmap_gfn_range)(struct kvm *kvm, struct kvm_gfn_range *range);
> 	bool (*age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
> 	bool (*test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
> 	bool (*set_spte_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
>
> Prior to using a Kconfig, a forward declaration wasn't necessary because
> arch/powerpc/include/asm/kvm_host.h would #define KVM_ARCH_WANT_MMU_NOTIFIER even
> if CONFIG_KVM=n.
>
> Alternatively, kvm_ppc.h could declare the struct.  I went this route mainly to
> avoid the possibility of someone encountering the same problem on a different
> architecture.

Ah I see, thanks for your explanation!
