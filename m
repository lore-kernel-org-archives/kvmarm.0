Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2B6180
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 00:08:43 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59c12d31d04so36887157b3.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695082122; x=1695686922; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dInZugQi4I3jT3AsjQuL7R2MGGG9K+dIBnr86/ph3q8=;
        b=GmkZKmC1wLS7I9Kuqm9W8ruPNvs1lFHUbwBTnnTYxNHX51xEX7shNX0U0tVAy9IE7L
         jLOaAw5jhD6ETEro/vsaQHwSQ7RyDjhqZpYxto/F0mryCzI+WTmG9h/GzH4NMn/UdJzt
         eW9/qgYaizfC+WJuuBtUMG0BXA9uyDKXJo/li6WSXtDpSv7nHIGjbiyIgeSV9je6cYv3
         YLu4qEP7DML0sRCdzc+k+7IApoT7gd9xXXlgGEmR6XKk3EItoEMx9crRlyeVoY8Jtvz0
         PDKObbytslyzP/MGSrgrzlz+EC+3c10Shsx8qBxxb7gyQNzFIYn1K137VGK8aqJJl8Jj
         m5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695082122; x=1695686922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dInZugQi4I3jT3AsjQuL7R2MGGG9K+dIBnr86/ph3q8=;
        b=a6RqAwsidGxtZlxI+JVmLINLkm1T/RBluCQl/aqwO7C1jtnpulxkUPnow+XfDjB8uT
         JKIroy6Vieq976280usxbKXvDCG5ZjvsuFrW5fqcleGfkrnhXM6QJX1FIlPF9vJ2JoTD
         TGE/8pWreiNCXgEwDiFVn4QOhItHyg1t8DSEKM9mcq8AEVgK2I2FbUDwn1jZioyIJDUs
         gAAeNEoPIA/qhGtYy5mWEMrLAfd0CSdAEMafztldbbqSFILU7MWgiVDeU/U3H/LW8yRJ
         0kb4lPgCECw+ncltPJVmrbh/KJl7LhFuFzve4jTPhG2pyV6boKRDc3vpBYTaQImbwcu7
         Sn3g==
X-Gm-Message-State: AOJu0YyLGsOZg1hRoUrf8CyItM5ZwbX2NzcZrUw/OXK1u4J1kPxwN2Uy
	4Gk6E/mp8Kzb9PLiHffLncdszSQK8h4=
X-Google-Smtp-Source: AGHT+IHHNvt5OesaYTZ4SrOkO6G/E0GpOB67x3jgD/5Z7IEbZFEyHH5t/MUiil/50JGkevI3xvv2hT/ge04=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11cf:b0:d80:23ff:ae7f with SMTP id
 n15-20020a05690211cf00b00d8023ffae7fmr237508ybu.4.1695082122578; Mon, 18 Sep
 2023 17:08:42 -0700 (PDT)
Date: Mon, 18 Sep 2023 17:08:40 -0700
In-Reply-To: <20230918180754.iomoaqnw75j3rrxb@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-11-seanjc@google.com>
 <20230918180754.iomoaqnw75j3rrxb@amd.com>
Message-ID: <ZQjmiE7cQ/4UynNz@google.com>
Subject: Re: [RFC PATCH v12 10/33] KVM: Set the stage for handling only shared
 mappings in mmu_notifier events
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ashish Kalra <Ashish.Kalra@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 18, 2023, Michael Roth wrote:
> On Wed, Sep 13, 2023 at 06:55:08PM -0700, Sean Christopherson wrote:
> > Add flags to "struct kvm_gfn_range" to let notifier events target only
> > shared and only private mappings, and write up the existing mmu_notifier
> > events to be shared-only (private memory is never associated with a
> > userspace virtual address, i.e. can't be reached via mmu_notifiers).
> > 
> > Add two flags so that KVM can handle the three possibilities (shared,
> > private, and shared+private) without needing something like a tri-state
> > enum.
> > 
> > Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  include/linux/kvm_host.h | 2 ++
> >  virt/kvm/kvm_main.c      | 7 +++++++
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index d8c6ce6c8211..b5373cee2b08 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -263,6 +263,8 @@ struct kvm_gfn_range {
> >  	gfn_t start;
> >  	gfn_t end;
> >  	union kvm_mmu_notifier_arg arg;
> > +	bool only_private;
> > +	bool only_shared;
> >  	bool may_block;
> >  };
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 174de2789657..a41f8658dfe0 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -635,6 +635,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
> >  			 * the second or later invocation of the handler).
> >  			 */
> >  			gfn_range.arg = range->arg;
> > +
> > +			/*
> > +			 * HVA-based notifications aren't relevant to private
> > +			 * mappings as they don't have a userspace mapping.
> > +			 */
> > +			gfn_range.only_private = false;
> > +			gfn_range.only_shared = true;
> >  			gfn_range.may_block = range->may_block;
> 
> Who is supposed to read only_private/only_shared? Is it supposed to be
> plumbed onto arch code and handled specially there?

Yeah, that's the idea.  Though I don't know that it's worth using for SNP, the
cost of checking the RMP may be higher than just eating the extra faults.

> I ask because I see elsewhere you have:
> 
>     /*
>      * If one or more memslots were found and thus zapped, notify arch code
>      * that guest memory has been reclaimed.  This needs to be done *after*
>      * dropping mmu_lock, as x86's reclaim path is slooooow.
>      */
>     if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
>             kvm_arch_guest_memory_reclaimed(kvm);
> 
> and if there are any MMU notifier events that touch HVAs, then
> kvm_arch_guest_memory_reclaimed()->wbinvd_on_all_cpus() will get called,
> which causes the performance issues for SEV and SNP that Ashish had brought
> up. Technically that would only need to happen if there are GPAs in that
> memslot that aren't currently backed by gmem pages (and then gmem could handle
> its own wbinvd_on_all_cpus() (or maybe clflush per-page)). 
> 
> Actually, even if there are shared pages in the GPA range, the
> kvm_arch_guest_memory_reclaimed()->wbinvd_on_all_cpus() can be skipped for
> guests that only use gmem pages for private memory. Is that acceptable?

Yes, that was my original plan.  I may have forgotten that exact plan at one point
or another and not communicated it well.  But the idea is definitely that if a VM
type, a.k.a. SNP guests, is required to use gmem for private memory, then there's
no need to blast WBINVD because barring a KVM bug, the mmu_notifier event can't
have freed private memory, even if it *did* zap SPTEs.

For gmem, if KVM doesn't precisely zap only shared SPTEs for SNP (is that even
possible to do race-free?), then KVM needs to blast WBINVD when freeing memory
from gmem even if there are no SPTEs.  But that seems like a non-issue for a
well-behaved setup because the odds of there being *zero* SPTEs should be nil.

> Just trying to figure out where this only_private/only_shared handling ties
> into that (or if it's a separate thing entirely).

It's mostly a TDX thing.  I threw it in this series mostly to "formally" document
that the mmu_notifier path only affects shared mappings.  If the code causes
confusion without the TDX context, and won't be used by SNP, we can and should
drop it from the initial merge and have it go along with the TDX series.
