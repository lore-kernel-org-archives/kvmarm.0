From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH V2] mm: Introduce GFP_PGTABLE
Date: Wed, 16 Jan 2019 13:44:31 +0100
Message-ID: <20190116124431.GK24149@dhcp22.suse.cz>
References: <1547619692-7946-1-git-send-email-anshuman.khandual@arm.com>
 <20190116065703.GE24149@dhcp22.suse.cz>
 <20190116123018.GF6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7654C4A3A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 07:44:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6gEJIN5hj5oN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jan 2019 07:44:39 -0500 (EST)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 858234A3AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 07:44:39 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190116123018.GF6310@bombadil.infradead.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, will.deacon@arm.com, linux-mm@kvack.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, greentime@andestech.com, linux@armlinux.org.uk, mingo@redhat.com, vbabka@suse.cz, rientjes@google.com, palmer@sifive.com, Anshuman Khandual <anshuman.khandual@arm.com>, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, robin.murphy@arm.com, linux-kernel@vger.kernel.org, aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed 16-01-19 04:30:18, Matthew Wilcox wrote:
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

Yes, I believe the only reason this is x86 only is that each arch would
have to be tweaked separately. So a cleanup in _that_ regard would be
helpful. There is no real reason to have ptes accounted only for x86.
There might be some exceptions but well, our asm-generic allows to opt
in for generic implementation or override it with a special one. The
later should be an exception rather than the rule.
-- 
Michal Hocko
SUSE Labs
