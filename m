From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 2/4] mm: speed up mremap by 500x on large regions (v2)
Date: Mon, 29 Oct 2018 09:40:02 +1100
Message-ID: <20181028224002.GA16399@350D>
References: <20181013013200.206928-1-joel@joelfernandes.org>
 <20181013013200.206928-3-joel@joelfernandes.org>
 <20181024101255.it4lptrjogalxbey@kshutemo-mobl1>
 <20181024115733.GN8537@350D>
 <20181025021350.GB13560@joelaf.mtv.corp.google.com>
 <20181027102102.GO8537@350D>
 <20181027193917.GA51131@joelaf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181027193917.GA51131@joelaf.mtv.corp.google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-mips@linux-mips.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, mhocko@kernel.org, linux-mm@kvack.org, lokeshgidra@google.com, sparclinux@vger.kernel.org, linux-riscv@lists.infradead.org, elfring@users.sourceforge.net, Jonas Bonn <jonas@southpole.se>, kvmarm@lists.cs.columbia.edu, dancol@google.com, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-xtensa@linux-xtensa.org, linux-hexagon@vger.kernel.org, Helge Deller <deller@gmx.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, hughd@google.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, kasan-dev@googlegroups.com, anton.ivanov@kot-begemot.co.uk, Ingo Molnar <mingo@redhat.com>, Geert
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 27, 2018 at 12:39:17PM -0700, Joel Fernandes wrote:
> Hi Balbir,
> 
> On Sat, Oct 27, 2018 at 09:21:02PM +1100, Balbir Singh wrote:
> > On Wed, Oct 24, 2018 at 07:13:50PM -0700, Joel Fernandes wrote:
> > > On Wed, Oct 24, 2018 at 10:57:33PM +1100, Balbir Singh wrote:
> > > [...]
> > > > > > +		pmd_t pmd;
> > > > > > +
> > > > > > +		new_ptl = pmd_lockptr(mm, new_pmd);
> > > > 
> > > > 
> > > > Looks like this is largely inspired by move_huge_pmd(), I guess a lot of
> > > > the code applies, why not just reuse as much as possible? The same comments
> > > > w.r.t mmap_sem helping protect against lock order issues applies as well.
> > > 
> > > I thought about this and when I looked into it, it seemed there are subtle
> > > differences that make such sharing not worth it (or not possible).
> > >
> > 
> > Could you elaborate on them?
> 
> The move_huge_page function is defined only for CONFIG_TRANSPARENT_HUGEPAGE
> so we cannot reuse it to begin with, since we have it disabled on our
> systems. I am not sure if it is a good idea to split that out and refactor it
> for reuse especially since our case is quite simple compared to huge pages.
> 
> There are also a couple of subtle differences between the move_normal_pmd and
> the move_huge_pmd. Atleast 2 of them are:
> 
> 1. We don't concern ourself with the PMD dirty bit, since the pages being
> moved are normal pages and at the soft-dirty bit accounting is at the PTE
> level, since we are not moving PTEs, we don't need to do that.
> 
> 2. The locking is simpler as Kirill pointed, pmd_lock cannot fail however
> __pmd_trans_huge_lock can.
> 
> I feel it is not super useful to refactor move_huge_pmd to support our case
> especially since move_normal_pmd is quite small, so IMHO the benefit of code
> reuse isn't there very much.
>

My big concern is that any bug fixes will need to monitor both paths.
Do you see a big overhead in checking the soft dirty bit? The locking is
a little different. Having said that, I am not strictly opposed to the
extra code, just concerned about missing fixes/updates as we find them.
 
> Do let me know your thoughts and thanks for your interest in this.
> 
>

Balbir Singh. 
