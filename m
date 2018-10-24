From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/4] mm: speed up mremap by 500x on large regions (v2)
Date: Wed, 24 Oct 2018 15:57:24 +0300
Message-ID: <20181024125724.yf6frdimjulf35do@kshutemo-mobl1>
References: <20181013013200.206928-1-joel@joelfernandes.org>
 <20181013013200.206928-3-joel@joelfernandes.org>
 <20181024101255.it4lptrjogalxbey@kshutemo-mobl1>
 <20181024115733.GN8537@350D>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181024115733.GN8537@350D>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Balbir Singh <bsingharora@gmail.com>
Cc: linux-mips@linux-mips.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, mhocko@kernel.org, linux-mm@kvack.org, lokeshgidra@google.com, "Joel Fernandes (Google)" <joel@joelfernandes.org>, linux-riscv@lists.infradead.org, elfring@users.sourceforge.net, Jonas Bonn <jonas@southpole.se>, kvmarm@lists.cs.columbia.edu, dancol@google.com, Yoshinori Sato <ysato@users.sourceforge.jp>, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-hexagon@vger.kernel.org, Helge Deller <deller@gmx.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, hughd@google.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, kasan-dev@googlegroups.com, anton.ivanov@kot-b
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 24, 2018 at 10:57:33PM +1100, Balbir Singh wrote:
> On Wed, Oct 24, 2018 at 01:12:56PM +0300, Kirill A. Shutemov wrote:
> > On Fri, Oct 12, 2018 at 06:31:58PM -0700, Joel Fernandes (Google) wrote:
> > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > index 9e68a02a52b1..2fd163cff406 100644
> > > --- a/mm/mremap.c
> > > +++ b/mm/mremap.c
> > > @@ -191,6 +191,54 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
> > >  		drop_rmap_locks(vma);
> > >  }
> > >  
> > > +static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
> > > +		  unsigned long new_addr, unsigned long old_end,
> > > +		  pmd_t *old_pmd, pmd_t *new_pmd, bool *need_flush)
> > > +{
> > > +	spinlock_t *old_ptl, *new_ptl;
> > > +	struct mm_struct *mm = vma->vm_mm;
> > > +
> > > +	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK)
> > > +	    || old_end - old_addr < PMD_SIZE)
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * The destination pmd shouldn't be established, free_pgtables()
> > > +	 * should have release it.
> > > +	 */
> > > +	if (WARN_ON(!pmd_none(*new_pmd)))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * We don't have to worry about the ordering of src and dst
> > > +	 * ptlocks because exclusive mmap_sem prevents deadlock.
> > > +	 */
> > > +	old_ptl = pmd_lock(vma->vm_mm, old_pmd);
> > > +	if (old_ptl) {
> > 
> > How can it ever be false?
> > 
> > > +		pmd_t pmd;
> > > +
> > > +		new_ptl = pmd_lockptr(mm, new_pmd);
> 
> 
> Looks like this is largely inspired by move_huge_pmd(), I guess a lot of
> the code applies, why not just reuse as much as possible? The same comments
> w.r.t mmap_sem helping protect against lock order issues applies as well.

pmd_lock() cannot fail, but __pmd_trans_huge_lock() can. We should not
copy the code blindly.

-- 
 Kirill A. Shutemov
