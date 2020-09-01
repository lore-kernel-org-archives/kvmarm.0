Return-Path: <SRS0=zihn=CK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCACC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  1 Sep 2020 16:51:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01AEA20767
	for <kvmarm@archiver.kernel.org>; Tue,  1 Sep 2020 16:51:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbosT5jq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01AEA20767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DDD4B101;
	Tue,  1 Sep 2020 12:51:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xar4ZWk3TZPP; Tue,  1 Sep 2020 12:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23CFE4B103;
	Tue,  1 Sep 2020 12:51:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA934B101
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 12:51:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hkQ8o9JygLkZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2020 12:51:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA5174B0F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 12:51:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 763DA20767;
 Tue,  1 Sep 2020 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598979059;
 bh=1nmnZ3FKPqcbnnw74A1zVpz7b4ZKMHUOGqdVtujWcTQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=XbosT5jqmXyS3rmjfk2Np7k6aZ/j01Shnd2cvsAvR45REomU6AQ0GoYXQLaNcax+Q
 P4g+2SQpALlCHHxLfRoTBHZVC1WfvE+9lhUaiMrvwCWemJHqReImC3ayZsjAfSxyNr
 ipnuDisRlwKhfG5AJSAp648xvjLDyBh0RM7yQVvs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kD9Un-008MrJ-SA; Tue, 01 Sep 2020 17:50:58 +0100
MIME-Version: 1.0
Date: Tue, 01 Sep 2020 17:50:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
In-Reply-To: <cadec9ec-3d56-a86d-0da1-f17208221692@redhat.com>
References: <20200822024444.28132-1-gshan@redhat.com>
 <87imdbm22j.wl-maz@kernel.org>
 <cadec9ec-3d56-a86d-0da1-f17208221692@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <361e3092fc04063eeced68648e8c8994@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.cs.columbia.edu,
 eric.auger@redhat.com, shan.gavin@gmail.com, suzuki.poulose@arm.com,
 james.morse@arm.com, qperret@google.com, will@kernel.org,
 alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: shan.gavin@gmail.com, Will Deacon <will@kernel.org>,
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

Hi Gavin,

On 2020-08-23 00:59, Gavin Shan wrote:
> Hi Marc,
> 
> On 8/22/20 8:01 PM, Marc Zyngier wrote:
>> On Sat, 22 Aug 2020 03:44:44 +0100,
>> Gavin Shan <gshan@redhat.com> wrote:
>>> 
>>> Depending on the kernel configuration, PUD_SIZE could be equal to
>>> PMD_SIZE. For example, both of them are 512MB with the following
>>> kernel configuration. In this case, both PUD and PMD are folded
>>> to PGD.
>>> 
>>>     CONFIG_ARM64_64K_PAGES   y
>>>     CONFIG_ARM64_VA_BITS     42
>>>     CONFIG_PGTABLE_LEVELS    2
>>> 
>>> With the above configuration, the stage2 PUD is used to backup the
>>> 512MB huge page when the stage2 mapping is built. During the mapping,
>>> the PUD and its subordinate levels of page table entries are unmapped
>>> if the PUD is present and not huge page sensitive in 
>>> stage2_set_pud_huge().
>>> Unfornately, the @addr isn't aligned to S2_PUD_SIZE and wrong page 
>>> table
>>> entries are zapped. It eventually leads to PUD's present bit can't be
>>> cleared successfully and infinite loop in stage2_set_pud_huge().
>>> 
>>> This fixes the issue by checking with S2_{PUD, PMD}_SIZE instead of
>>> {PUD, PMD}_SIZE to determine if stage2 PUD or PMD is used to back the
>>> huge page. For this particular case, the stage2 PMD entry should be
>>> used to backup the 512MB huge page with stage2_set_pmd_huge().
>> 
>> It isn't obvious to me how S2_PMD_SIZE can be different from PMD_SIZE,
>> and the current code certainly expects both to be equal (just look at
>> how often S2_*_SIZE is used in the current code to convince yourself).
>> 
>> My guess is that some lesser tested configurations (such as 64k pages)
>> break that assumption, and result in the wrong thing happening. Could
>> you please shed some light on it?
>> 
> 
> With the following kernel configuration, PUD_SIZE and PMD_SIZE are 
> equal
> and both of them are 512MB because P4D/PUD/PMD are folded into PGD.
> 
>    CONFIG_ARM64_64K_PAGES   y
>    CONFIG_ARM64_VA_BITS     42
>    CONFIG_PGTABLE_LEVELS    2
>    PMD_SIZE                 512MB
> (include/asm-generic/pgtable-no-pud.h)
>    PUD_SIZE                 512MB
> (include/asm-generic/pgtable-no-pmd.h)
>    P4D_SIZE                 512MB
> (include/asm-generic/pgtable-nop4d.h)
>    S2_PMD_SIZE              512MB               (stage2_pgtable.h)
>    S2_PUD_SIZE                4TB               (stage2_pgtable.h)

For a start, this last value makes no sense at all. If that we only
have 2 levels, S2_PUD_SIZE is wrong, and should either be ignored or
be the same as S2_PMD_SIZE (4TB represents the whole of the guest's
IPA space).

> For this particular case, S2_PMD_SIZE and PMD_SIZE are equal and both
> of them are 512MB. However, the issue is wrong size (PMD_SIZE/PUD_SIZE)
> is checked to call stage2_set_pud_huge() or stage2_set_pmd_huge() in
> user_mem_abort(). It causes stage2_set_pud_huge() is called to map the
> 512MB huge page, meaning stage2 PUD is used to back the 512MB huge 
> page.

Which should be fine, because that's all we can map. 2 levels, remember?
The real bug is that we consider that mapping a PUD is valid, while 
there
is no real PUD in this context.

> 
> In stage2_set_pud_huge(), the S2 page table entries are zapped for the
> range ((addr & S2_PUD_MASK), S2_PUD_SIZE), whose size is 4TB. However,
> we're mapping 512MB huge page (block). It means unrelated page table
> entries are cleared.

We can't map 4TB. That's not possible for such configuration (and I
doubt you have more than 4TB of contiguous memory on your system).

> 
> static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_memory_slot *memslot, unsigned 
> long hva,
>                           unsigned long fault_status)
> {
>     :
>     if (vma_pagesize == PUD_SIZE) {           /* PUD_SIZE == 512MB */
>         ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
>     } else if (vma_pagesize == PMD_SIZE) {    /* PMD_SIZE == 512MB */
>         ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
>     } else {
>         ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, 
> flags);
>     }
>     :
> }
> 
> The issue was initially reported by Eric and it can be reproduced on
> upstream kernel/qemu with the configurations to enable 64KB page size
> and 42-bits VA bits (CONFIG_ARM64_VA_BITS). Here is the command I used
> to reproduce the issue. Note that the IPA limit reported from the 
> machine
> where I reproduced the issue is 44-bits, but qemu just uses 40-bits. It
> means the stage2 pagetable has 3 levels.

No. KVM, in its current form, cannot have more levels at stage-2 than it
has at stage-1 (that's one the things we are fixing with Will's 
patches).

> 
> start_vm_aarch64_hugetlbfs() {
>    echo 32 > /sys/kernel/mm/hugepages/hugepages-524288kB/nr_hugepages

Ah, hugetlb. I wonder if we have something funky here. Alexandru (cc'd)
was looking at something in this area (see [1]).

> 
>    /home/gavin/sandbox/qemu.main/aarch64-softmmu/qemu-system-aarch64    
>        \
>    --enable-kvm -machine virt,gic-version=host                          
>        \
>    -cpu host -smp 8,sockets=8,cores=1,threads=1                         
>        \
>    -m 8G -mem-prealloc -mem-path /dev/hugepages                         
>        \
>    -monitor none -serial mon:stdio -nographic -s                        
>        \
>    -bios /home/gavin/sandbox/qemu.main/pc-bios/edk2-aarch64-code.fd     
>        \
>    -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image        
>        \
>    -initrd /home/gavin/sandbox/images/rootfs.cpio.xz                    
>        \
>    -append "earlycon=pl011,mmio,0x9000000"                              
>        \
>    -device virtio-net-pci,netdev=unet,mac=52:54:00:f1:26:a6             
>        \
>    -netdev user,id=unet,hostfwd=tcp::50959-:22                          
>        \
>    -drive 
> file=/home/gavin/sandbox/images/vm.img,if=none,format=raw,id=nvme0   \
>    -device nvme,drive=nvme0,serial=foo                                  
>        \
>    -drive 
> file=/home/gavin/sandbox/images/vm1.img,if=none,format=raw,id=nvme1  \
>    -device nvme,drive=nvme1,serial=foo1
> }

I'll try to reproduce this.

         M.

[1] 
https://lore.kernel.org/r/20200901133357.52640-1-alexandru.elisei@arm.com
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
