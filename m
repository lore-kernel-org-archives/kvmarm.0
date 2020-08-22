Return-Path: <SRS0=YmwB=CA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F1EC433E1
	for <kvmarm@archiver.kernel.org>; Sat, 22 Aug 2020 23:59:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2085208E4
	for <kvmarm@archiver.kernel.org>; Sat, 22 Aug 2020 23:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GddNTcn1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2085208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 622E64C3F5;
	Sat, 22 Aug 2020 19:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZLl0kWWuC-Oy; Sat, 22 Aug 2020 19:59:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 059B14C479;
	Sat, 22 Aug 2020 19:59:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9D64C450
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Aug 2020 19:59:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rCO9h2dYPD87 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 22 Aug 2020 19:59:41 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BDBD4C3F5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Aug 2020 19:59:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1598140781;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+Xd/WML6fv4hfuR1OfFN0TD9ebk0E/6Wm9/XAtgWESs=;
 b=GddNTcn17sQaMJ/Wdo9mdrBA2s+0HJfbXf8PJ4xIUKcqKnI235N5gLCd1Xr6o8EBKnvN6B
 T0pRWe2dv3MjBIOChf/v9AVVAeRW7LHItEdal336zPcboUYWMjOUl2MxzAE+lgMEaE+KOK
 3BSFGYIAgBk64U2/gCz5jOjH04rKbz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-KyxVtgVsOLChXaylaNHjPQ-1; Sat, 22 Aug 2020 19:59:39 -0400
X-MC-Unique: KyxVtgVsOLChXaylaNHjPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B88CF1005E61;
 Sat, 22 Aug 2020 23:59:37 +0000 (UTC)
Received: from [10.64.54.33] (vpn2-54-33.bne.redhat.com [10.64.54.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91E3727CD4;
 Sat, 22 Aug 2020 23:59:31 +0000 (UTC)
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
To: Marc Zyngier <maz@kernel.org>
References: <20200822024444.28132-1-gshan@redhat.com>
 <87imdbm22j.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <cadec9ec-3d56-a86d-0da1-f17208221692@redhat.com>
Date: Sun, 23 Aug 2020 09:59:26 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87imdbm22j.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Cc: shan.gavin@gmail.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Marc,

On 8/22/20 8:01 PM, Marc Zyngier wrote:
> On Sat, 22 Aug 2020 03:44:44 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> Depending on the kernel configuration, PUD_SIZE could be equal to
>> PMD_SIZE. For example, both of them are 512MB with the following
>> kernel configuration. In this case, both PUD and PMD are folded
>> to PGD.
>>
>>     CONFIG_ARM64_64K_PAGES   y
>>     CONFIG_ARM64_VA_BITS     42
>>     CONFIG_PGTABLE_LEVELS    2
>>
>> With the above configuration, the stage2 PUD is used to backup the
>> 512MB huge page when the stage2 mapping is built. During the mapping,
>> the PUD and its subordinate levels of page table entries are unmapped
>> if the PUD is present and not huge page sensitive in stage2_set_pud_huge().
>> Unfornately, the @addr isn't aligned to S2_PUD_SIZE and wrong page table
>> entries are zapped. It eventually leads to PUD's present bit can't be
>> cleared successfully and infinite loop in stage2_set_pud_huge().
>>
>> This fixes the issue by checking with S2_{PUD, PMD}_SIZE instead of
>> {PUD, PMD}_SIZE to determine if stage2 PUD or PMD is used to back the
>> huge page. For this particular case, the stage2 PMD entry should be
>> used to backup the 512MB huge page with stage2_set_pmd_huge().
> 
> It isn't obvious to me how S2_PMD_SIZE can be different from PMD_SIZE,
> and the current code certainly expects both to be equal (just look at
> how often S2_*_SIZE is used in the current code to convince yourself).
> 
> My guess is that some lesser tested configurations (such as 64k pages)
> break that assumption, and result in the wrong thing happening. Could
> you please shed some light on it?
> 

With the following kernel configuration, PUD_SIZE and PMD_SIZE are equal
and both of them are 512MB because P4D/PUD/PMD are folded into PGD.

    CONFIG_ARM64_64K_PAGES   y
    CONFIG_ARM64_VA_BITS     42
    CONFIG_PGTABLE_LEVELS    2
    PMD_SIZE                 512MB               (include/asm-generic/pgtable-no-pud.h)
    PUD_SIZE                 512MB               (include/asm-generic/pgtable-no-pmd.h)
    P4D_SIZE                 512MB               (include/asm-generic/pgtable-nop4d.h)
    S2_PMD_SIZE              512MB               (stage2_pgtable.h)
    S2_PUD_SIZE                4TB               (stage2_pgtable.h)

For this particular case, S2_PMD_SIZE and PMD_SIZE are equal and both
of them are 512MB. However, the issue is wrong size (PMD_SIZE/PUD_SIZE)
is checked to call stage2_set_pud_huge() or stage2_set_pmd_huge() in
user_mem_abort(). It causes stage2_set_pud_huge() is called to map the
512MB huge page, meaning stage2 PUD is used to back the 512MB huge page.

In stage2_set_pud_huge(), the S2 page table entries are zapped for the
range ((addr & S2_PUD_MASK), S2_PUD_SIZE), whose size is 4TB. However,
we're mapping 512MB huge page (block). It means unrelated page table
entries are cleared.

static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
                           struct kvm_memory_slot *memslot, unsigned long hva,
                           unsigned long fault_status)
{
     :
     if (vma_pagesize == PUD_SIZE) {           /* PUD_SIZE == 512MB */
         ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
     } else if (vma_pagesize == PMD_SIZE) {    /* PMD_SIZE == 512MB */
         ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
     } else {
         ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, flags);
     }
     :
}

The issue was initially reported by Eric and it can be reproduced on
upstream kernel/qemu with the configurations to enable 64KB page size
and 42-bits VA bits (CONFIG_ARM64_VA_BITS). Here is the command I used
to reproduce the issue. Note that the IPA limit reported from the machine
where I reproduced the issue is 44-bits, but qemu just uses 40-bits. It
means the stage2 pagetable has 3 levels.

start_vm_aarch64_hugetlbfs() {
    echo 32 > /sys/kernel/mm/hugepages/hugepages-524288kB/nr_hugepages

    /home/gavin/sandbox/qemu.main/aarch64-softmmu/qemu-system-aarch64           \
    --enable-kvm -machine virt,gic-version=host                                 \
    -cpu host -smp 8,sockets=8,cores=1,threads=1                                \
    -m 8G -mem-prealloc -mem-path /dev/hugepages                                \
    -monitor none -serial mon:stdio -nographic -s                               \
    -bios /home/gavin/sandbox/qemu.main/pc-bios/edk2-aarch64-code.fd            \
    -kernel /home/gavin/sandbox/linux.guest/arch/arm64/boot/Image               \
    -initrd /home/gavin/sandbox/images/rootfs.cpio.xz                           \
    -append "earlycon=pl011,mmio,0x9000000"                                     \
    -device virtio-net-pci,netdev=unet,mac=52:54:00:f1:26:a6                    \
    -netdev user,id=unet,hostfwd=tcp::50959-:22                                 \
    -drive file=/home/gavin/sandbox/images/vm.img,if=none,format=raw,id=nvme0   \
    -device nvme,drive=nvme0,serial=foo                                         \
    -drive file=/home/gavin/sandbox/images/vm1.img,if=none,format=raw,id=nvme1  \
    -device nvme,drive=nvme1,serial=foo1
}

>> Fixes: 3c3736cd32bf ("KVM: arm/arm64: Fix handling of stage2 huge mappings")
> 
> This commit doesn't seem to match the code your changing (it doesn't
> even come near user_mem_abort()). Are there any intermediate commits
> that would better explain the problem?
> 

When stage2_set_pud_huge() is called to map 512MB huge page, we run into
infinite loop to retry unmapping the memory range (S2_PUD_SIZE). With this
reverted, we didn't reproduce the issue. The commit is identified by "git bisect".

>> Cc: stable@vger.kernel.org # v5.1+
>> Reported-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> Tested-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 0121ef2c7c8d..deb1819ba9e2 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1964,7 +1964,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   		(fault_status == FSC_PERM &&
>>   		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
>>   
>> -	if (vma_pagesize == PUD_SIZE) {
>> +	if (vma_pagesize == S2_PUD_SIZE) {
>>   		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
>>   
>>   		new_pud = kvm_pud_mkhuge(new_pud);
>> @@ -1975,7 +1975,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   			new_pud = kvm_s2pud_mkexec(new_pud);
>>   
>>   		ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
>> -	} else if (vma_pagesize == PMD_SIZE) {
>> +	} else if (vma_pagesize == S2_PMD_SIZE) {
>>   		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
>>   
>>   		new_pmd = kvm_pmd_mkhuge(new_pmd);
>> -- 
>> 2.23.0
>>
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
