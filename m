From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: Introduce GFP_PGTABLE
Date: Sat, 12 Jan 2019 08:50:42 -0800
Message-ID: <CALvZod5XfFujzzMC0n2dZmofjof0juWw45RF4475CAEu9nAv3Q@mail.gmail.com>
References: <1547288798-10243-1-git-send-email-anshuman.khandual@arm.com>
 <20190112121230.GQ6310@bombadil.infradead.org>
 <ddd59fdc-3d8f-4015-e851-e7f099193a1b@c-s.fr>
 <20190112154944.GT6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190112154944.GT6310@bombadil.infradead.org>
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
Cc: mark.rutland@arm.com, Michal Hocko <mhocko@suse.com>, linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, Dave Hansen <dave.hansen@linux.intel.com>, will.deacon@arm.com, christoffer.dall@arm.com, Linux MM <linux-mm@kvack.org>, kvmarm@lists.cs.columbia.edu, aneesh.kumar@linux.ibm.com, linux@armlinux.org.uk, Ingo Molnar <mingo@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, Anshuman Khandual <anshuman.khandual@arm.com>, marc.zyngier@arm.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Christophe Leroy <christophe.leroy@c-s.fr>, ard.biesheuvel@linaro.org, linuxppc-dev@lists.ozlabs.org, steve.capper@arm.com, LKML <linux-kernel@vger.kernel.org>, james.morse@arm.com, Andrew Morton <akpm@linux-foundation>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 12, 2019 at 7:50 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Jan 12, 2019 at 02:49:29PM +0100, Christophe Leroy wrote:
> > As far as I can see,
> >
> > #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
> >
> > So what's the difference between:
> >
> > (GFP_KERNEL_ACCOUNT | __GFP_ZERO) & ~__GFP_ACCOUNT
> >
> > and
> >
> > (GFP_KERNEL | __GFP_ZERO) & ~__GFP_ACCOUNT
>
> Nothing.  But there's a huge difference in the other parts of that same
> file where GFP_ACCOUNT is _not_ used.
>
> I think this unification is too small to bother with.  Something I've
> had on my todo list for some time and have not done anything about
> is to actually unify all of the architecture pte/pmd/... allocations.
> There are tricks some architectures use that others would benefit from.

Can you explain a bit more on this? If this is too low priority on
your todo list then maybe me or someone else can pick that up.

Shakeel
