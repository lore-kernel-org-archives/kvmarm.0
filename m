Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7B5C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 01:20:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAAE84B091;
	Thu, 16 Jun 2022 21:20:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hZ3WvLPNQG4O; Thu, 16 Jun 2022 21:20:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67EB24B20D;
	Thu, 16 Jun 2022 21:20:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED8E4B091
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 21:20:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RD3obji+NQDD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 21:20:02 -0400 (EDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04C634B108
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 21:20:01 -0400 (EDT)
Received: by mail-pj1-f42.google.com with SMTP id e24so2807643pjt.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 18:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Y2sVZsV4hLehRdszdnSTiRASTciGWgNQoaJ3cAo1Ors=;
 b=VgqagXTj5gYeuGBOqkJi0z+m2/qgp8DtTjsHnD2H1fdiPe5a+h53X5IDLvvGxTBb+7
 z/UhozWkKJxpm01YkMrl/83qvJJ9oU8HdBLSXena+tlqm9MoE7str7TPBo0C1Z8s0VHJ
 y/h551EQ8Chsrrp4wWtojUaTTtVzpYEnubqp4tjud7imeGs+BTP0jekJFZF8svXgWkGD
 9o6+Y1D8Z67aWQyixlKShCPbYHJmKoumWI+AIz1ZcA8JTK+mJy8aoa9CA7gV9Ezc+v6z
 ipERzAumHZgNczr5HXDrRC5qr2dYG2gAbZ/0wCuSCkkOs/QzdoWPiEafUR1/rX2ELPgj
 AiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Y2sVZsV4hLehRdszdnSTiRASTciGWgNQoaJ3cAo1Ors=;
 b=PEDtgR9Bdv/g1SwRn/2VPmsOLIy7rCvfBAknXwb+qnUNpt2swsg1CDi5VvxqGc+Rd3
 oWJsw6IWwCOwbRExfvJTlvXBUaURLlp7PlexcAPLRenF8l2TfxQyXKmxHYNuB6c8FQEZ
 0kbHziGGvkoPPLEWmB6+59q4UcRs5TPW52kNr31p1TcXsOjNZwa3H7B/nUUxM8yUnAXH
 DyIvEcyX5KSe7TlFLnshLXv+AcoG1klSgpwjcLSeW+bqpVOz3F+fHuVooDLhRUDqTMlj
 O+3VqYTjc7t29wVKnev7o2qdkpTJCB4SrUMOcQFXYeNUOgXnTNcxGVTPkiQQ+Rrj/94e
 gOVA==
X-Gm-Message-State: AJIora8Ug4oei2rSlqFotJQAxEfiCz0SUTC+InpPhTfxmCfoLQqu8wZ9
 TfW1UpkVKoDT8hZfrqBd9DAB+Q==
X-Google-Smtp-Source: AGRyM1tvkgciSGisoF7rebBN+b2h+lQqZ1NtBxEPIyWm8m8y2GMhDR1d4VVJ7J0JBRwGdIbf805KEg==
X-Received: by 2002:a17:90b:3a90:b0:1e6:a203:c7dd with SMTP id
 om16-20020a17090b3a9000b001e6a203c7ddmr19135466pjb.144.1655428800798; 
 Thu, 16 Jun 2022 18:20:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 iq11-20020a17090afb4b00b001e31fea8c85sm1948836pjb.14.2022.06.16.18.20.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 18:20:00 -0700 (PDT)
Date: Fri, 17 Jun 2022 01:19:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 04/22] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YqvWvBv27fYzOFdE@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-5-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, May 16, 2022, David Matlack wrote:
> Instead of computing the shadow page role from scratch for every new
> page, derive most of the information from the parent shadow page.  This
> eliminates the dependency on the vCPU root role to allocate shadow page
> tables, and reduces the number of parameters to kvm_mmu_get_page().
> 
> Preemptively split out the role calculation to a separate function for
> use in a following commit.
> 
> Note that when calculating the MMU root role, we can take
> @role.passthrough, @role.direct, and @role.access directly from
> @vcpu->arch.mmu->root_role. Only @role.level and @role.quadrant still
> must be overridden for PAE page directories.

Nit, instead of "for PAE page directories", something like "when shadowing 32-bit
guest page tables with PAE page tables".  Not all PAE PDEs need to be overridden.

> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 98 +++++++++++++++++++++++-----------
>  arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
>  2 files changed, 71 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a9d28bcabcbb..515e0b33144a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c

...

> -	if (level <= vcpu->arch.mmu->cpu_role.base.level)
> -		role.passthrough = 0;
> -
>  	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>  	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
>  		if (sp->gfn != gfn) {

...

> +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> +{
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> +	union kvm_mmu_page_role role;
> +
> +	role = parent_sp->role;
> +	role.level--;
> +	role.access = access;
> +	role.direct = direct;
> +	role.passthrough = 0;

I don't love that this subtly relies on passthrough being limited to 5-level nNPT
with 4-level L1 NPT.  That's really just an implementation oddity, e.g. KVM can
and (hopefully) will eventually use passthrough pages for at least level=4 when
shadowing 3-level or 2-level NPT.

The easiest thing would be to add a WARN so that we don't forget to handle this
when this collides with Lai's series, and to document why KVM never sets "passthrough"
for child shadow pages.  The latter is especially confusing because it does have
other passthrough pages, they just don't happen to have an associated "struct kvm_mmu_page".

	/*
	 * KVM currently doesn't use "struct kvm_mmu_page" to track passthrough
	 * pages when the guest is using 3-level or 2-level NPT, and instead
	 * uses bare page allocations (see pml4/5_root and pae_root).  The only
	 * scenario where KVM uses a passthrough "struct kvm_mmu_page" is when
	 * shadowing 4-level NPT with 5-level nNPT.  So even though passthrough
	 * child pages do exist, such pages aren't tracked in the list of shadow
	 * pages and so don't need to compute a role.
	 */
	WARN_ON_ONCE(role.passthrough && role.level != PT64_ROOT_4LEVEL);
	role.passthrough = 0;

> +
> +	/*
> +	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
> +	 * 2-level, non-PAE paging. KVM shadows such guests with PAE paging
> +	 * (i.e. 8-byte PTEs). The difference in PTE size means that KVM must
> +	 * shadow each guest page table with multiple shadow page tables, which
> +	 * requires extra bookkeeping in the role.
> +	 *
> +	 * Specifically, to shadow the guest's page directory (which covers a
> +	 * 4GiB address space), KVM uses 4 PAE page directories, each mapping

Nit, it's worth explicitly saying "virtual address space" at least once.

> +	 * 1GiB of the address space. @role.quadrant encodes which quarter of
> +	 * the address space each maps.
> +	 *
> +	 * To shadow the guest's page tables (which each map a 4MiB region), KVM
> +	 * uses 2 PAE page tables, each mapping a 2MiB region. For these,
> +	 * @role.quadrant encodes which half of the region they map.

Oof, so I really like this comment because it simplifies the concept, but it glosses
over one very crucial detail.  The 32-bit GPTE consumes bits 21:12, and the 64-bit PTE
consumes bits 20:12.  So while it's absolutely correct to state the the quadrant
encodes which half, bit 21 is consumed when doing a lookup in the _parent_, which
is the _least_ significant bit in when indexing PDEs, hence the quadrant essentially
becomes evens and odds.  Specifically, it does NOT split the parent PD down the middle.

Paolo's more concrete comment about bits helps a map things out explicit.  Paolo is
going to snag the above, so for your looming rebase, how about replacing the paragraph
below with a version of Paolo's concrete example to pair with your abstract definition?

	 *
	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
	 * quadrant is assigned in mmu_alloc_root().  To consume bit 21, KVM
	 * uses an additional PDE in every PD; the page table being configured
	 * here is what's pointed at by the PDE.  Thus, bit 21 is the _least_
	 * significant bit of the PDE index pointing at the shadow PT.
	 */

[*] https://lore.kernel.org/all/090e701d-6893-ea25-1237-233ff3dd01ee@redhat.com

> +	 *
> +	 * Note, the 4 PAE page directories are pre-allocated and the quadrant
> +	 * assigned in mmu_alloc_root(). So only page tables need to be handled
> +	 * here.
> +	 */
> +	if (role.has_4_byte_gpte) {
> +		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
> +		role.quadrant = (sptep - parent_sp->spt) % 2;

Oh hell no.  LOL.  It took me a _long_ time to realize you're doing pointer arithmetic
on "u64 *".  I actually booted a 32-bit VM with printks and even then it still took
me a good 20 seconds wondering if I was having a brain fart and simply forgot how mod
works.

The calculation is also unnecessarily costly; not that anyone is likely to notice,
but still.  The compiler doesn't know that sptep and parent_sp->spt are intertwined
and so can't optimize, i.e. is forced to do the subtraction.

A more efficient equivalent that doesn't require pointer arithmetic:

	role.quadrant = ((unsigned long)sptep / sizeof(*sptep)) & 1;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
