Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6031FC34036
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 10:54:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA4DB22B48
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 10:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQZIkGPA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA4DB22B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D784AF54;
	Tue, 18 Feb 2020 05:54:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hr2tucvpU6aN; Tue, 18 Feb 2020 05:54:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 014E34AF66;
	Tue, 18 Feb 2020 05:54:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6425A4AF54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 05:54:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRKRRArJB+MP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 05:54:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE72D4AF44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 05:54:53 -0500 (EST)
Received: from hump (unknown [109.236.136.226])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 58260207FD;
 Tue, 18 Feb 2020 10:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582023292;
 bh=CMlZZWS7PO9lkPnhA08fc6Islr+OQCEeZuheLiBfVmU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=nQZIkGPAmBAW2q8NANsj3kry2FjoyJoV6/tOeR6LNswBfh2J3GwBoJflFT5WH0M0E
 dfZCuTZ+znP94xdsEPbHpuBFhjabZfi5XCWgerZeTyyA+r8h1bx3I9KPRweYB3ciYM
 WYq+qWxM8vgm+Ut2efYgnUJmpLpvYONcSRjzEgV4=
Date: Tue, 18 Feb 2020 12:54:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v2 07/13] powerpc: add support for folded p4d page tables
Message-ID: <20200218105440.GA1698@hump>
References: <20200216081843.28670-1-rppt@kernel.org>
 <20200216081843.28670-8-rppt@kernel.org>
 <c79b363c-a111-389a-5752-51cf85fa8c44@c-s.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c79b363c-a111-389a-5752-51cf85fa8c44@c-s.fr>
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org,
 Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
 Paul Mackerras <paulus@samba.org>, linux-hexagon@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jonas Bonn <jonas@southpole.se>, linux-arch@vger.kernel.org,
 Brian Cain <bcain@codeaurora.org>, Marc Zyngier <maz@kernel.org>,
 Russell King <linux@armlinux.org.uk>, Ley Foon Tan <ley.foon.tan@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 uclinux-h8-devel@lists.sourceforge.jp, Fenghua Yu <fenghua.yu@intel.com>,
 Arnd Bergmann <arnd@arndb.de>, kvm-ppc@vger.kernel.org,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 openrisc@lists.librecores.org, Stafford Horne <shorne@gmail.com>,
 Guan Xuetao <gxt@pku.edu.cn>, linux-arm-kernel@lists.infradead.org,
 Tony Luck <tony.luck@intel.com>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 nios2-dev@lists.rocketboards.org, Andrew Morton <akpm@linux-foundation.org>,
 linuxppc-dev@lists.ozlabs.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sun, Feb 16, 2020 at 11:41:07AM +0100, Christophe Leroy wrote:
> =

> =

> Le 16/02/2020 =E0 09:18, Mike Rapoport a =E9crit=A0:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > =

> > Implement primitives necessary for the 4th level folding, add walks of =
p4d
> > level where appropriate and replace 5level-fixup.h with pgtable-nop4d.h.
> =

> I don't think it is worth adding all this additionnals walks of p4d, this
> patch could be limited to changes like:
> =

> -		pud =3D pud_offset(pgd, gpa);
> +		pud =3D pud_offset(p4d_offset(pgd, gpa), gpa);
> =

> The additionnal walks should be added through another patch the day power=
pc
> need them.

Ok, I'll update the patch to reduce walking the p4d.
 =

> See below for more comments.
> =

> > =

> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > Tested-by: Christophe Leroy <christophe.leroy@c-s.fr> # 8xx and 83xx
> > ---

...

> > diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerp=
c/include/asm/book3s/64/pgtable.h
> > index 201a69e6a355..ddddbafff0ab 100644
> > --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> > +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> > @@ -2,7 +2,7 @@
> >   #ifndef _ASM_POWERPC_BOOK3S_64_PGTABLE_H_
> >   #define _ASM_POWERPC_BOOK3S_64_PGTABLE_H_
> > -#include <asm-generic/5level-fixup.h>
> > +#include <asm-generic/pgtable-nop4d.h>
> >   #ifndef __ASSEMBLY__
> >   #include <linux/mmdebug.h>
> > @@ -251,7 +251,7 @@ extern unsigned long __pmd_frag_size_shift;
> >   /* Bits to mask out from a PUD to get to the PMD page */
> >   #define PUD_MASKED_BITS		0xc0000000000000ffUL
> >   /* Bits to mask out from a PGD to get to the PUD page */
> > -#define PGD_MASKED_BITS		0xc0000000000000ffUL
> > +#define P4D_MASKED_BITS		0xc0000000000000ffUL
> >   /*
> >    * Used as an indicator for rcu callback functions
> > @@ -949,54 +949,60 @@ static inline bool pud_access_permitted(pud_t pud=
, bool write)
> >   	return pte_access_permitted(pud_pte(pud), write);
> >   }
> > -#define pgd_write(pgd)		pte_write(pgd_pte(pgd))
> > +#define __p4d_raw(x)	((p4d_t) { __pgd_raw(x) })
> > +static inline __be64 p4d_raw(p4d_t x)
> > +{
> > +	return pgd_raw(x.pgd);
> > +}
> > +
> =

> Shouldn't this be defined in asm/pgtable-be-types.h, just like other
> __pxx_raw() ?

Ideally yes, but this creates weird header file dependencies and untangling
them would generate way too much churn.
 =

> > +#define p4d_write(p4d)		pte_write(p4d_pte(p4d))
> > -static inline void pgd_clear(pgd_t *pgdp)
> > +static inline void p4d_clear(p4d_t *p4dp)
> >   {
> > -	*pgdp =3D __pgd(0);
> > +	*p4dp =3D __p4d(0);
> >   }

...

> > @@ -573,9 +596,15 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgta=
ble, pte_t pte,
> >   	/* Traverse the guest's 2nd-level tree, allocate new levels needed */
> >   	pgd =3D pgtable + pgd_index(gpa);
> > -	pud =3D NULL;
> > +	p4d =3D NULL;
> >   	if (pgd_present(*pgd))
> > -		pud =3D pud_offset(pgd, gpa);
> > +		p4d =3D p4d_offset(pgd, gpa);
> > +	else
> > +		new_p4d =3D p4d_alloc_one(kvm->mm, gpa);
> > +
> > +	pud =3D NULL;
> > +	if (p4d_present(*p4d))
> > +		pud =3D pud_offset(p4d, gpa);
> =

> Is it worth adding all this new code ?
> =

> My understanding is that the series objective is to get rid of
> __ARCH_HAS_5LEVEL_HACK, to to add support for 5 levels to an architecture
> that not need it (at least for now).
> If we want to add support for 5 levels, it can be done later in another
> patch.
> =

> Here I think your change could be limited to:
> =

> -		pud =3D pud_offset(pgd, gpa);
> +		pud =3D pud_offset(p4d_offset(pgd, gpa), gpa);

This won't work. Without __ARCH_USE_5LEVEL_HACK defined pgd_present() is
hardwired to 1 and the actual check for the top level is performed with
p4d_present(). The 'else' clause that allocates p4d will never be taken and
it could be removed, but I prefer to keep it for consistency.
 =

> >   	else
> >   		new_pud =3D pud_alloc_one(kvm->mm, gpa);
> > @@ -597,12 +626,18 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgt=
able, pte_t pte,
> >   	/* Now traverse again under the lock and change the tree */
> >   	ret =3D -ENOMEM;
> >   	if (pgd_none(*pgd)) {
> > +		if (!new_p4d)
> > +			goto out_unlock;
> > +		pgd_populate(kvm->mm, pgd, new_p4d);
> > +		new_p4d =3D NULL;
> > +	}
> > +	if (p4d_none(*p4d)) {
> >   		if (!new_pud)
> >   			goto out_unlock;
> > -		pgd_populate(kvm->mm, pgd, new_pud);
> > +		p4d_populate(kvm->mm, p4d, new_pud);
> >   		new_pud =3D NULL;
> >   	}
> > -	pud =3D pud_offset(pgd, gpa);
> > +	pud =3D pud_offset(p4d, gpa);
> >   	if (pud_is_leaf(*pud)) {
> >   		unsigned long hgpa =3D gpa & PUD_MASK;
> > @@ -1220,6 +1255,7 @@ static ssize_t debugfs_radix_read(struct file *fi=
le, char __user *buf,
> >   	pgd_t *pgt;
> >   	struct kvm_nested_guest *nested;
> >   	pgd_t pgd, *pgdp;
> > +	p4d_t p4d, *p4dp;
> >   	pud_t pud, *pudp;
> >   	pmd_t pmd, *pmdp;
> >   	pte_t *ptep;
> > @@ -1298,7 +1334,14 @@ static ssize_t debugfs_radix_read(struct file *f=
ile, char __user *buf,
> >   			continue;
> >   		}
> > -		pudp =3D pud_offset(&pgd, gpa);
> > +		p4dp =3D p4d_offset(&pgd, gpa);
> > +		p4d =3D READ_ONCE(*p4dp);
> > +		if (!(p4d_val(p4d) & _PAGE_PRESENT)) {
> > +			gpa =3D (gpa & P4D_MASK) + P4D_SIZE;
> > +			continue;
> > +		}
> > +
> > +		pudp =3D pud_offset(&p4d, gpa);
> =

> Same, here you are forcing a useless read with READ_ONCE().
> =

> Your change could be limited to
> =

> -		pudp =3D pud_offset(&pgd, gpa);
> +		pudp =3D pud_offset(p4d_offset(&pgd, gpa), gpa);

Here again the actual check must be done against p4d rather than pgd. We
could skip READ_ONCE() for pgd, but since it is a debugfs method I don't
think it is more important than code consistency.
 =

> This comment applies to many other places.

I'll make another pass to see where we can take the shortcut and use =


	pudp =3D pud_offset(p4d_offset(...))
 =

> >   		pud =3D READ_ONCE(*pudp);
> >   		if (!(pud_val(pud) & _PAGE_PRESENT)) {
> >   			gpa =3D (gpa & PUD_MASK) + PUD_SIZE;
> > diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-p=
atching.c
> > index 3345f039a876..7a59f6863cec 100644
> > --- a/arch/powerpc/lib/code-patching.c
> > +++ b/arch/powerpc/lib/code-patching.c
> > @@ -107,13 +107,18 @@ static inline int unmap_patch_area(unsigned long =
addr)
> >   	pte_t *ptep;
> >   	pmd_t *pmdp;
> >   	pud_t *pudp;
> > +	p4d_t *p4dp;
> >   	pgd_t *pgdp;
> >   	pgdp =3D pgd_offset_k(addr);
> >   	if (unlikely(!pgdp))
> >   		return -EINVAL;
> > -	pudp =3D pud_offset(pgdp, addr);
> > +	p4dp =3D p4d_offset(pgdp, addr);
> > +	if (unlikely(!p4dp))
> > +		return -EINVAL;
> > +
> > +	pudp =3D pud_offset(p4dp, addr);
> >   	if (unlikely(!pudp))
> >   		return -EINVAL;
> > diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/=
mmu.c
> > index 0a1c65a2c565..b2fc3e71165c 100644
> > --- a/arch/powerpc/mm/book3s32/mmu.c
> > +++ b/arch/powerpc/mm/book3s32/mmu.c
> > @@ -312,7 +312,7 @@ void hash_preload(struct mm_struct *mm, unsigned lo=
ng ea)
> >   	if (!Hash)
> >   		return;
> > -	pmd =3D pmd_offset(pud_offset(pgd_offset(mm, ea), ea), ea);
> > +	pmd =3D pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, ea), ea), ea)=
, ea);
> =

> If we continue like this, in ten years this like is going to be many
> kilometers long.
> =

> I think the above would be worth a generic helper.

Agree. My plan was to first unify all the architectures and then start
introducing the generic helpers, like e.g. pmd_offset_mm().
 =

> >   	if (!pmd_none(*pmd))
> >   		add_hash_page(mm->context.id, ea, pmd_val(*pmd));
> >   }
> > diff --git a/arch/powerpc/mm/book3s32/tlb.c b/arch/powerpc/mm/book3s32/=
tlb.c
> > index 2fcd321040ff..175bc33b41b7 100644
> > --- a/arch/powerpc/mm/book3s32/tlb.c
> > +++ b/arch/powerpc/mm/book3s32/tlb.c
> > @@ -87,7 +87,7 @@ static void flush_range(struct mm_struct *mm, unsigne=
d long start,
> >   	if (start >=3D end)
> >   		return;
> >   	end =3D (end - 1) | ~PAGE_MASK;
> > -	pmd =3D pmd_offset(pud_offset(pgd_offset(mm, start), start), start);
> > +	pmd =3D pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, start), start=
), start), start);
> >   	for (;;) {
> >   		pmd_end =3D ((start + PGDIR_SIZE) & PGDIR_MASK) - 1;
> >   		if (pmd_end > end)
> > @@ -145,7 +145,7 @@ void flush_tlb_page(struct vm_area_struct *vma, uns=
igned long vmaddr)
> >   		return;
> >   	}
> >   	mm =3D (vmaddr < TASK_SIZE)? vma->vm_mm: &init_mm;
> > -	pmd =3D pmd_offset(pud_offset(pgd_offset(mm, vmaddr), vmaddr), vmaddr=
);
> > +	pmd =3D pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, vmaddr), vmad=
dr), vmaddr), vmaddr);
> >   	if (!pmd_none(*pmd))
> >   		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
> >   }
> > diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/=
book3s64/hash_pgtable.c
> > index 64733b9cb20a..9cd15937e88a 100644
> > --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
> > +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
> > @@ -148,6 +148,7 @@ void hash__vmemmap_remove_mapping(unsigned long sta=
rt,
> >   int hash__map_kernel_page(unsigned long ea, unsigned long pa, pgprot_=
t prot)
> >   {
> >   	pgd_t *pgdp;
> > +	p4d_t *p4dp;
> >   	pud_t *pudp;
> >   	pmd_t *pmdp;
> >   	pte_t *ptep;
> > @@ -155,7 +156,8 @@ int hash__map_kernel_page(unsigned long ea, unsigne=
d long pa, pgprot_t prot)
> >   	BUILD_BUG_ON(TASK_SIZE_USER64 > H_PGTABLE_RANGE);
> >   	if (slab_is_available()) {
> >   		pgdp =3D pgd_offset_k(ea);
> > -		pudp =3D pud_alloc(&init_mm, pgdp, ea);
> > +		p4dp =3D p4d_offset(pgdp, ea);
> > +		pudp =3D pud_alloc(&init_mm, p4dp, ea);
> =

> Could be a single line, without a new var.
> =

> -		pudp =3D pud_alloc(&init_mm, pgdp, ea);
> +		pudp =3D pud_alloc(&init_mm, p4d_offset(pgdp, ea), ea);
> =

> =

> Same kind of comments as already done apply to the rest.
> =

> Christophe

-- =

Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
