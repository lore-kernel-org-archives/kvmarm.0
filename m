Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5D5C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 15:47:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56D1D61D96
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 15:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56D1D61D96
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7894B422;
	Wed, 12 May 2021 11:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5eHO76sABW8v; Wed, 12 May 2021 11:47:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52FF34B552;
	Wed, 12 May 2021 11:47:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FCB04B4B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 11:47:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OYhy30ufFHfQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 11:47:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B0954B422
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 11:47:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78E1E31B;
 Wed, 12 May 2021 08:47:01 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5D473F719;
 Wed, 12 May 2021 08:46:53 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v11 2/6] arm64: kvm: Introduce MTE VM feature
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-3-steven.price@arm.com> <20210428170705.GB4022@arm.com>
 <c3293d47-a5f2-ea4a-6730-f5cae26d8a7e@arm.com> <YJGHApOCXl811VK3@arm.com>
 <329286e8-a8f3-ea1a-1802-58813255a4a5@arm.com>
 <20210507182538.GF26528@arm.com> <20210510183506.GA10910@arm.com>
Message-ID: <c891d4eb-b388-1658-8c8a-e76477062463@arm.com>
Date: Wed, 12 May 2021 16:46:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510183506.GA10910@arm.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 10/05/2021 19:35, Catalin Marinas wrote:
> On Fri, May 07, 2021 at 07:25:39PM +0100, Catalin Marinas wrote:
>> On Thu, May 06, 2021 at 05:15:25PM +0100, Steven Price wrote:
>>> On 04/05/2021 18:40, Catalin Marinas wrote:
>>>> On Thu, Apr 29, 2021 at 05:06:41PM +0100, Steven Price wrote:
>>>>> Given the changes to set_pte_at() which means that tags are restored from
>>>>> swap even if !PROT_MTE, the only race I can see remaining is the creation of
>>>>> new PROT_MTE mappings. As you mention an attempt to change mappings in the
>>>>> VMM memory space should involve a mmu notifier call which I think serialises
>>>>> this. So the remaining issue is doing this in a separate address space.
>>>>>
>>>>> So I guess the potential problem is:
>>>>>
>>>>>    * allocate memory MAP_SHARED but !PROT_MTE
>>>>>    * fork()
>>>>>    * VM causes a fault in parent address space
>>>>>    * child does a mprotect(PROT_MTE)
>>>>>
>>>>> With the last two potentially racing. Sadly I can't see a good way of
>>>>> handling that.
>>>>
>>>> Ah, the mmap lock doesn't help as they are different processes
>>>> (mprotect() acquires it as a writer).
>>>>
>>>> I wonder whether this is racy even in the absence of KVM. If both parent
>>>> and child do an mprotect(PROT_MTE), one of them may be reading stale
>>>> tags for a brief period.
>>>>
>>>> Maybe we should revisit whether shared MTE pages are of any use, though
>>>> it's an ABI change (not bad if no-one is relying on this). However...
> [...]
>>>> Thinking about this, we have a similar problem with the PG_dcache_clean
>>>> and two processes doing mprotect(PROT_EXEC). One of them could see the
>>>> flag set and skip the I-cache maintenance while the other executes
>>>> stale instructions. change_pte_range() could acquire the page lock if
>>>> the page is VM_SHARED (my preferred core mm fix). It doesn't immediately
>>>> solve the MTE/KVM case but we could at least take the page lock via
>>>> user_mem_abort().
> [...]
>>> This is the real issue I see - the race in PROT_MTE case is either a data
>>> leak (syncing after setting the bit) or data loss (syncing before setting
>>> the bit).
> [...]
>>> But without serialising through a spinlock (in mte_sync_tags()) I haven't
>>> been able to come up with any way of closing the race. But with the change
>>> to set_pte_at() to call mte_sync_tags() even if the PTE isn't PROT_MTE that
>>> is likely to seriously hurt performance.
>>
>> Yeah. We could add another page flag as a lock though I think it should
>> be the core code that prevents the race.
>>
>> If we are to do it in the arch code, maybe easier with a custom
>> ptep_modify_prot_start/end() where we check if it's VM_SHARED and
>> VM_MTE, take a (big) lock.
> 
> I think in the general case we don't even need VM_SHARED. For example,
> we have two processes mapping a file, read-only. An mprotect() call in
> both processes will race on the page->flags via the corresponding
> set_pte_at(). I think an mprotect() with a page fault in different
> processes can also race.
> 
> The PROT_EXEC case can be easily fixed, as you said already. The
> PROT_MTE with MAP_PRIVATE I think can be made safe by a similar
> approach: test flag, clear tags, set flag. A subsequent write would
> trigger a CoW, so different page anyway.
> 
> Anyway, I don't think ptep_modify_prot_start/end would buy us much, it
> probably makes the code even harder to read.
> 
>> In the core code, something like below (well, a partial hack, not tested
>> and it doesn't handle huge pages but just to give an idea):
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 94188df1ee55..6ba96ff141a6 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -114,6 +113,10 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>>   			}
>>   
>>   			oldpte = ptep_modify_prot_start(vma, addr, pte);
>> +			if (vma->vm_flags & VM_SHARED) {
>> +				page = vm_normal_page(vma, addr, oldpte);
>> +				lock_page(page);
>> +			}
>>   			ptent = pte_modify(oldpte, newprot);
>>   			if (preserve_write)
>>   				ptent = pte_mk_savedwrite(ptent);
>> @@ -138,6 +141,8 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>>   				ptent = pte_mkwrite(ptent);
>>   			}
>>   			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
>> +			if (page)
>> +				unlock_page(page);
>>   			pages++;
>>   		} else if (is_swap_pte(oldpte)) {
>>   			swp_entry_t entry = pte_to_swp_entry(oldpte);
> 
> That's bogus: lock_page() might sleep but this whole code sequence is
> under the ptl spinlock. There are some lock_page_* variants but that
> would involve either a busy loop on this path or some bailing out,
> waiting for a release.
> 
> Options:
> 
> 1. Change the mte_sync_tags() code path to set the flag after clearing
>     and avoid reading stale tags. We document that mprotect() on
>     MAP_SHARED may lead to tag loss. Maybe we can intercept this in the
>     arch code and return an error.

This is the best option I've come up with so far - but it's not a good
one! We can replace the set_bit() with a test_and_set_bit() to catch the
race after it has occurred - but I'm not sure what we can do about it
then (we've already wiped the data). Returning an error doesn't seem
particularly useful at that point, a message in dmesg is about the best
I can come up with.

> 2. Figure out some other locking in the core code. However, if
>     mprotect() in one process can race with a handle_pte_fault() in
>     another, on the same shared mapping, it's not trivial.
>     filemap_map_pages() would take the page lock before calling
>     do_set_pte(), so mprotect() would need the same page lock.

I can't see how this is going to work without harming the performance of
non-MTE work. Ultimately we're trying to add some sort of locking for
two (mostly) unrelated processes doing page table operations, which will
hurt scalability.

> 3. Use another PG_arch_3 bit as a lock to spin on in the arch code (i.e.
>     set it around the other PG_arch_* bit setting).

This is certainly tempting, although sadly the existing
wait_on_page_bit() is sleeping - so this would either be a literal spin,
or we'd need to implement a new non-sleeping wait mechanism.

> I ran out of ideas.
> 

4. Sledgehammer locking in mte_sync_page_tags(), add a spinlock only for
the MTE case where we have to sync tags (see below). What the actual
performance impact of this is I've no idea. It could certainly be bad
if there are a lot of pages with MTE enabled, which sadly is exactly
the case if KVM is used with MTE :(

Steve

--->8----
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 0d320c060ebe..389ad40256f6 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -25,23 +25,33 @@
  u64 gcr_kernel_excl __ro_after_init;
  
  static bool report_fault_once = true;
+static spinlock_t tag_sync_lock;
  
  static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap,
  			       bool pte_is_tagged)
  {
  	pte_t old_pte = READ_ONCE(*ptep);
  
+	if (!is_swap_pte(old_pte) && !pte_is_tagged)
+		return;
+
+	spin_lock_irqsave(&tag_sync_lock, flags);
+
+	/* Recheck with the lock held */
+	if (test_bit(PG_mte_tagged, &page->flags))
+		goto out;
+
  	if (check_swap && is_swap_pte(old_pte)) {
  		swp_entry_t entry = pte_to_swp_entry(old_pte);
  
  		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
  			set_bit(PG_mte_tagged, &page->flags);
-			return;
+			goto out;
  		}
  	}
  
  	if (!pte_is_tagged)
-		return;
+		goto out;
  
  	page_kasan_tag_reset(page);
  	/*
@@ -55,6 +65,9 @@ static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap,
  	mte_clear_page_tags(page_address(page));
  
  	set_bit(PG_mte_tagged, &page->flags);
+
+out:
+	spin_unlock_irqrestore(&tag_sync_lock, flags);
  }
  
  void mte_sync_tags(pte_t *ptep, pte_t pte)
@@ -63,6 +76,11 @@ void mte_sync_tags(pte_t *ptep, pte_t pte)
  	long i, nr_pages = compound_nr(page);
  	bool check_swap = nr_pages == 1;
  	bool pte_is_tagged = pte_tagged(pte);
+	unsigned long flags;
+
+	/* Early out if there's nothing to do */
+	if (!check_swap && !pte_is_tagged)
+		return;
  
  	/* if PG_mte_tagged is set, tags have already been initialised */
  	for (i = 0; i < nr_pages; i++, page++) {
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
