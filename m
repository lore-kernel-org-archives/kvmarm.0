From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Wed, 07 Jun 2017 10:41:23 +0100
Message-ID: <5937CA43.7060108@arm.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <20170601222235.GN20919@cbox> <59313AEA.2060705@arm.com>
 <20170602104345.GA397@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A1C40A74
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:38:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pAqNJC9FKc+s for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Jun 2017 05:38:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27E0140905
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:38:02 -0400 (EDT)
In-Reply-To: <20170602104345.GA397@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 02/06/17 11:43, Christoffer Dall wrote:
> On Fri, Jun 02, 2017 at 11:16:10AM +0100, James Morse wrote:
>> On 01/06/17 23:22, Christoffer Dall wrote:
>>> On Wed, May 24, 2017 at 05:32:50PM +0100, James Morse wrote:
>>>> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64, notifications for
>>>> broken memory can call memory_failure() in mm/memory-failure.c to deliver
>>>> SIGBUS to any user space process using the page, and notify all the
>>>> in-kernel users.
>>>>
>>>> If the page corresponded with guest memory, KVM will unmap this page
>>>> from its stage2 page tables. The user space process that allocated
>>>> this memory may have never touched this page in which case it may not
>>>> be mapped meaning SIGBUS won't be delivered.
>>
>>> Sorry, I don't remember, what is the scenario where KVM can have a
>>> mapping in stage 2 without there being a corresponding mapping for user
>>> space?
>>
>> (looks like I mean more than one thing by mapping... oops.)
>>
>> Mapping in that there is a physical page for this user-space address, but when
>> qemu first touches it, it will be faulted in as its not been touched before.
> 
> So that's where I still get confused.  When KVM faults in the page on
> behalf of an initial VM access, it calls get_user_pages() (or something
> equivalent through a series of indirections like gfn_to_pfn_prot()), and
> wouldn't that create the equivalent mapping in the normal user space
> page table?
> 
> (I may be forgetting some important detail here though).

I evidently stopped before I got to the bottom of this, the commit message is
based on the way I first hit this (physical address not found in any rmaps:
nothing signalled). Maybe there is another bug, or I hit a bug that has been
fixed. I will go back to reproducing this.
(I think we still need the patch if a guest is allowed to keep running while
parts of its memory are hwpoisoned)

You're right this should behave the same as a fault from user-space, on arm64
this path is roughly:
> do_page_fault()
> __do_page_fault()
> handle_mm_fault()
> __handle_mm_fault()
> handle_pte_fault()

__handle_mm_fault() then allocates pud/pmd and calls handle_pte_fault() .. which
disappears back into the jungle.

On a stage2 fault from a guest, the path is roughly:
> kvm_handle_guest_abort()
> user_mem_abort()
> gfn_to_pfn_prot()
> hva_to_pfn()
> hva_to_pfn_slow()
> get_user_pages_unlocked()
> __get_user_pages_unlocked()
> __get_user_pages_locked()
> __get_user_pages()
> faultin_page()
> handle_mm_fault()

>From where the path/behaviour should be the same as the fault through arch code.

FOLL_POPULATE is a red-herring, it doesn't seem to mean anything unless
FOLL_MLOCK is set too.


> Right, I figured it was just the commit message that needed updating.
> 
> Sorry about being pedantic, but having a misleading record of this
> change is guaranteed to confuse me in the future.

If it's wrong it needs fixing. I'm a fan of pedantry in all its forms!



Thanks,

James
