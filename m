From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] mm: Introduce GFP_PGTABLE
Date: Mon, 14 Jan 2019 09:58:14 +0530
Message-ID: <48f81a76-2b2d-5060-d9bc-c42d5b5975c3@arm.com>
References: <1547288798-10243-1-git-send-email-anshuman.khandual@arm.com>
 <20190112121230.GQ6310@bombadil.infradead.org>
 <ddd59fdc-3d8f-4015-e851-e7f099193a1b@c-s.fr>
 <20190112154944.GT6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBFE24A3F0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Jan 2019 23:28:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ChH+w28WEHg8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Jan 2019 23:28:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 042674A3BF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Jan 2019 23:28:22 -0500 (EST)
In-Reply-To: <20190112154944.GT6310@bombadil.infradead.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Matthew Wilcox <willy@infradead.org>, Christophe Leroy <christophe.leroy@c-s.fr>
Cc: mhocko@suse.com, linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, will.deacon@arm.com, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, aneesh.kumar@linux.ibm.com, linux@armlinux.org.uk, mingo@redhat.com, vbabka@suse.cz, rientjes@google.com, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 01/12/2019 09:19 PM, Matthew Wilcox wrote:
> On Sat, Jan 12, 2019 at 02:49:29PM +0100, Christophe Leroy wrote:
>> As far as I can see,
>>
>> #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
>>
>> So what's the difference between:
>>
>> (GFP_KERNEL_ACCOUNT | __GFP_ZERO) & ~__GFP_ACCOUNT
>>
>> and
>>
>> (GFP_KERNEL | __GFP_ZERO) & ~__GFP_ACCOUNT
> 
> Nothing.  But there's a huge difference in the other parts of that same
> file where GFP_ACCOUNT is _not_ used.
> 
> I think this unification is too small to bother with.  Something I've
> had on my todo list for some time and have not done anything about
> is to actually unify all of the architecture pte/pmd/... allocations.
> There are tricks some architectures use that others would benefit from.

Sure. Could you please elaborate on this ?

Invariably all kernel pgtable page allocations should use GFP_PGTABLE and
all user page table allocation should use (GFP_PGTABLE | __GFP_ACCOUNT).
Ideally there should be default generic functions user_pgtable_gfp() or
kernel_pgtable_gfp() returning these values. Overrides can be provided if
an arch still wants some more control.
