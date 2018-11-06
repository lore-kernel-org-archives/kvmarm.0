From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH -next 0/3] Add support for fast mremap
Date: Mon, 5 Nov 2018 20:36:00 -0800
Message-ID: <20181106043600.GB139199@google.com>
References: <20181103040041.7085-1-joelaf@google.com>
 <6886607.O3ZT5bM3Cy@blindfold>
 <e1d039a5-9c83-b9b9-98b5-d39bc48f04e0@kot-begemot.co.uk>
 <20181103183208.GA56850@google.com>
 <D6FB3C15-A8C1-4694-A434-A7489F590E05@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <D6FB3C15-A8C1-4694-A434-A7489F590E05@oracle.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: William Kucharski <william.kucharski@oracle.com>
Cc: linux-mips@linux-mips.org, linux-m68k@vger.kernel.org, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, lokeshgidra@google.com, sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-riscv@lists.infradead.org, elfring@users.sourceforge.net, Jonas Bonn <jonas@southpole.se>, kvmarm@lists.cs.columbia.edu, dancol@google.com, linux-ia64@vge.kvack.org, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-xtensa@linux-xtensa.org, Richard Weinberger <richard@nod.at>, Helge Deller <deller@gmx.de>, r.kernel.org@lithops.sigma-star.at, hughd@google.com, "James E.J. Bottomley" <jejb@paris>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Nov 04, 2018 at 12:56:48AM -0600, William Kucharski wrote:
> 
> 
> > On Nov 3, 2018, at 12:32 PM, Joel Fernandes <joel@joelfernandes.org> wrote:
> > 
> > Looks like more architectures don't define set_pmd_at. I am thinking the
> > easiest way forward is to just do the following, instead of defining
> > set_pmd_at for every architecture that doesn't care about it. Thoughts?
> > 
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 7cf6b0943090..31ad64dcdae6 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -281,7 +281,8 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
> > 			split_huge_pmd(vma, old_pmd, old_addr);
> > 			if (pmd_trans_unstable(old_pmd))
> > 				continue;
> > -		} else if (extent == PMD_SIZE && IS_ENABLED(CONFIG_HAVE_MOVE_PMD)) {
> > +		} else if (extent == PMD_SIZE) {
> > +#ifdef CONFIG_HAVE_MOVE_PMD
> > 			/*
> > 			 * If the extent is PMD-sized, try to speed the move by
> > 			 * moving at the PMD level if possible.
> > @@ -296,6 +297,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
> > 				drop_rmap_locks(vma);
> > 			if (moved)
> > 				continue;
> > +#endif
> > 		}
> > 
> > 		if (pte_alloc(new_vma->vm_mm, new_pmd))
> > 
> 
> That seems reasonable as there are going to be a lot of architectures that never have
> mappings at the PMD level.

Ok, I will do it like this and resend.

> Have you thought about what might be needed to extend this paradigm to be able to
> perform remaps at the PUD level, given many architectures already support PUD-mapped
> pages?
> 

I have thought about this. I believe it is doable in the future. Off the top
I don't see an issue doing it, and it will also reduce the number of flushes.

thanks,

- Joel
