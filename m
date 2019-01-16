From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH V2] mm: Introduce GFP_PGTABLE
Date: Wed, 16 Jan 2019 06:20:14 -0800
Message-ID: <20190116142014.GJ6310@bombadil.infradead.org>
References: <1547619692-7946-1-git-send-email-anshuman.khandual@arm.com>
 <20190116065703.GE24149@dhcp22.suse.cz>
 <20190116123018.GF6310@bombadil.infradead.org>
 <07d6a264-dccd-78ab-e8a9-2410bbef7b97@arm.com>
 <20190116131827.GH6310@bombadil.infradead.org>
 <521d8511-4c87-49c6-de03-67a71d5bacca@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <521d8511-4c87-49c6-de03-67a71d5bacca@c-s.fr>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-riscv/>
List-Post: <mailto:linux-riscv@lists.infradead.org>
List-Help: <mailto:linux-riscv-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=subscribe>
Sender: "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Errors-To: linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: mark.rutland@arm.com, christoffer.dall@arm.com, linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, palmer@sifive.com, will.deacon@arm.com, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, aneesh.kumar@linux.ibm.com, greentime@andestech.com, linux@armlinux.org.uk, mingo@redhat.com, linux-arm-kernel@lists.infradead.org, rientjes@google.com, dave.hansen@linux.intel.com, Anshuman Khandual <anshuman.khandual@arm.com>, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, vbabka@suse.cz, ard.biesheuvel@linaro.org, linuxppc-dev@lists.ozlabs.org, steve.capper@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com, akpm@linux-foundation.org, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 16, 2019 at 02:47:16PM +0100, Christophe Leroy wrote:
> Le 16/01/2019 =E0 14:18, Matthew Wilcox a =E9crit=A0:
> > I disagree with your objective.  Making more code common is a great ide=
a,
> > but this patch is too unambitious.  We should be heading towards one or
> > two page table allocation functions instead of having every architectur=
e do
> > its own thing.
> > =

> > So start there.  Move the x86 function into common code and convert one
> > other architecture to use it too.
> =

> Are we talking about pte_alloc_one_kernel() and pte_alloc_one() ?
> =

> I'm not sure x86 function is the best common one, as it seems to allocate=
 a
> multiple of PAGE_SIZE only.

And that's the common case.  Most architectures use a single page for at
least one level of the pte/pmd/pud/p4d/pgd hierarchy.  Some use multiple
pages and some use a fraction of a page.

> Some arches like powerpc use pagetables which are smaller than a page, for
> instance powerpc 8xx uses 4k pagetables even with 16k pages, which means a
> single page can be used by 4 pagetables.

Those can be added later.  Note I said "one or two", and that's what I
had in mind; I think we want one function that allocates just a page
and another that allocates a page fragment.  Then we can have a good
discussion about what method we use; s390 and ppc use different techniques
today and there's really no good reason for that.
