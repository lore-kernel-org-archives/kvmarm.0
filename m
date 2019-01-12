From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: Introduce GFP_PGTABLE
Date: Sat, 12 Jan 2019 07:49:44 -0800
Message-ID: <20190112154944.GT6310@bombadil.infradead.org>
References: <1547288798-10243-1-git-send-email-anshuman.khandual@arm.com>
 <20190112121230.GQ6310@bombadil.infradead.org>
 <ddd59fdc-3d8f-4015-e851-e7f099193a1b@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ddd59fdc-3d8f-4015-e851-e7f099193a1b@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, mark.rutland@arm.com, mhocko@suse.com, linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, linux@armlinux.org.uk, mingo@redhat.com, vbabka@suse.cz, rientjes@google.com, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, robin.murphy@arm.com, steve.capper@arm.com, christoffer.dall@arm.com, james.morse@arm.com, aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 12, 2019 at 02:49:29PM +0100, Christophe Leroy wrote:
> As far as I can see,
> 
> #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
> 
> So what's the difference between:
> 
> (GFP_KERNEL_ACCOUNT | __GFP_ZERO) & ~__GFP_ACCOUNT
> 
> and
> 
> (GFP_KERNEL | __GFP_ZERO) & ~__GFP_ACCOUNT

Nothing.  But there's a huge difference in the other parts of that same
file where GFP_ACCOUNT is _not_ used.

I think this unification is too small to bother with.  Something I've
had on my todo list for some time and have not done anything about
is to actually unify all of the architecture pte/pmd/... allocations.
There are tricks some architectures use that others would benefit from.
