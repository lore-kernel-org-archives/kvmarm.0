Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB9D3C16
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xpyoj7E7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5b064442464so15880807b3.3
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698939894; x=1699544694; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MWop9ChiDn+5U1d7ZFSKgT7XQaKJkOCdphsca+5hdRc=;
        b=Xpyoj7E79s5/x5vpanG63dDabLQxCxZ1xI6+3j0BPp0GvTwoIUZfAxMxqEk6as25S+
         soyhtb18GLfH5PM39hkY8Rfk7ivfyj3zeBjRmfx842d8TelPuz86YPw/LeiDKjYc303V
         U5vnOcIXPJP3UaZsa/MEYBvrNcYxp71cnOX4ttvReNdWXhBGo85a5w2QSI16wCb5TD6f
         Fofed+bsalEieLvFsuvLypRUe76MlchsWePSwftpBmVfOO0+OGBHaGiybSmd+k58LhIK
         zb187RToc4MZ9XsA+sqrPRa9wPUAECeBrEdIZKW1osVnnfzcsLgSzFcCzu/eX6CB+Ic8
         q86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698939894; x=1699544694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MWop9ChiDn+5U1d7ZFSKgT7XQaKJkOCdphsca+5hdRc=;
        b=BLRFN+VZ27K4bBHub44fP9WCShewBLNmr7uxyjh0aSX+C6KwJOa8CHbMP95tPBlZKv
         ykGioydwYsVt7UTkq6+fzt/TQab61RrYJMwcnGMdaHgT9i5/Gnn1i7t3p7kovJu/xw0x
         SVGinBMySVbeQUNqvWrYc2ewmpSLcfUbwOHgdIrSe/Cj2Vxraq1nEvQ3+OjQm2zoWcs7
         o2HlJP44QWiAUwjEAE8K93UFR5/h4nFf+IwB8Zx3gRvNpfVEuvPyjqwxSa7iVkBGKV5k
         UO50ub8WEXqQUZcA5wd2vKf34eG+Vufgrz2U+3Wc426Bdkwu8DrcUy4Yb2sSXqSyf2pc
         Ii0Q==
X-Gm-Message-State: AOJu0Yx2d0wmnmCo7Q+TMtk+WHetncLuq4B/5ztm7KBS9DabNbivdxAK
	zp8lUudSumyDcz/jZGoFkL7dFyC/PvA=
X-Google-Smtp-Source: AGHT+IEDx2fXN1mZpC4wdLenC0gEZqGHeyYGeZi/NHNboFx849UKp0hRFulm5OGynaHR+kwHxlTzuAC9hXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d785:0:b0:59b:c811:a709 with SMTP id
 z127-20020a0dd785000000b0059bc811a709mr3270ywd.0.1698939893755; Thu, 02 Nov
 2023 08:44:53 -0700 (PDT)
Date: Thu, 2 Nov 2023 08:44:52 -0700
In-Reply-To: <496b78bb-ad12-4eed-a62c-8c2fd725ec61@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-10-seanjc@google.com>
 <482bfea6f54ea1bb7d1ad75e03541d0ba0e5be6f.camel@intel.com>
 <ZUKMsOdg3N9wmEzy@google.com> <64e3764e36ba7a00d94cc7db1dea1ef06b620aaf.camel@intel.com>
 <32cb71700aedcbd1f65276cf44a601760ffc364b.camel@intel.com> <496b78bb-ad12-4eed-a62c-8c2fd725ec61@redhat.com>
Message-ID: <ZUPD9NWF4eOXqeiA@google.com>
Subject: Re: [PATCH v13 09/35] KVM: Add KVM_EXIT_MEMORY_FAULT exit to report
 faults to userspace
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "mic@digikod.net" <mic@digikod.net>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "david@redhat.com" <david@redhat.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "amoorthy@google.com" <amoorthy@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "tabba@google.com" <tabba@google.com>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, Vishal Annapurve <vannapurve@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "maz@kernel.org" <maz@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "dmatlack@google.com" <dmatlack@google.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, 
	"yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>, Yilun Xu <yilun.xu@intel.com>, 
	"qperret@google.com" <qperret@google.com>, "brauner@kernel.org" <brauner@kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Wei W Wang <wei.w.wang@intel.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Paolo Bonzini wrote:
> On 11/2/23 10:35, Huang, Kai wrote:
> > IIUC KVM can already handle the case of poisoned
> > page by sending signal to user app:
> > 
> > 	static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, 			struct
> > kvm_page_fault *fault)                                               	{
> > 		...
> > 
> >        		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> >               		kvm_send_hwpoison_signal(fault->slot, fault->gfn);

No, this doesn't work, because that signals the host virtual address

	unsigned long hva = gfn_to_hva_memslot(slot, gfn);

	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);

which is the *shared* page.

> >                 	return RET_PF_RETRY;
> > 	}
> > 	}
> 
> EHWPOISON is not implemented by this series, so it should be left out of the
> documentation.

EHWPOISON *is* implemented.  kvm_gmem_get_pfn() returns -EWPOISON as appropriate,
and kvm_faultin_pfn() returns that directly without going through kvm_handle_error_pfn().

  kvm_faultin_pfn_private()
  |
  |-> kvm_gmem_get_pfn()
      |
      |-> if (folio_test_hwpoison(folio)) {
		r = -EHWPOISON;
		goto out_unlock;
	  }

          |
          |-> 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
			     &max_order);
		if (r) {
			kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
			return r;
		}

		|
		|-> ret = __kvm_faultin_pfn(vcpu, fault);
		    if (ret != RET_PF_CONTINUE)
			    return ret;

		    if (unlikely(is_error_pfn(fault->pfn)))
			    return kvm_handle_error_pfn(vcpu, fault);
