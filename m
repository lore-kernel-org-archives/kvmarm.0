From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2] mm: Introduce GFP_PGTABLE
Date: Wed, 16 Jan 2019 13:34:27 +0100
Message-ID: <20190116123427.GE10803@hirez.programming.kicks-ass.net>
References: <1547619692-7946-1-git-send-email-anshuman.khandual@arm.com>
 <20190116065703.GE24149@dhcp22.suse.cz>
 <20190116123018.GF6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190116123018.GF6310@bombadil.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matthew Wilcox <willy@infradead.org>
Cc: mark.rutland@arm.com, christoffer.dall@arm.com, linux-sh@vger.kernel.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, will.deacon@arm.com, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, greentime@andestech.com, linux@armlinux.org.uk, mingo@redhat.com, vbabka@suse.cz, rientjes@google.com, palmer@sifive.com, Anshuman Khandual <anshuman.khandual@arm.com>, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, robin.murphy@arm.com, steve.capper@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com, aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 16, 2019 at 04:30:18AM -0800, Matthew Wilcox wrote:
> On Wed, Jan 16, 2019 at 07:57:03AM +0100, Michal Hocko wrote:
> > On Wed 16-01-19 11:51:32, Anshuman Khandual wrote:
> > > All architectures have been defining their own PGALLOC_GFP as (GFP_KERNEL |
> > > __GFP_ZERO) and using it for allocating page table pages. This causes some
> > > code duplication which can be easily avoided. GFP_KERNEL allocated and
> > > cleared out pages (__GFP_ZERO) are required for page tables on any given
> > > architecture. This creates a new generic GFP flag flag which can be used
> > > for any page table page allocation. Does not cause any functional change.
> > > 
> > > GFP_PGTABLE is being added into include/asm-generic/pgtable.h which is the
> > > generic page tabe header just to prevent it's potential misuse as a general
> > > allocation flag if included in include/linux/gfp.h.
> > 
> > I haven't reviewed the patch yet but I am wondering whether this is
> > really worth it without going all the way down to unify the common code
> > and remove much more code duplication. Or is this not possible for some
> > reason?
> 
> Exactly what I suggested doing in response to v1.
> 
> Also, the approach taken here is crazy.  x86 has a feature that no other
> architecture has bothered to implement yet -- accounting page tables
> to the process.  Yet instead of spreading that goodness to all other
> architectures, Anshuman has gone to more effort to avoid doing that.

Also, s390 (of course, who else) has a fun custom page-table allocator
for reasons that don't apply to many other archs.
