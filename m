Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE75C352BE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 09:47:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80F76207FC
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 09:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80F76207FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 022CD4B112;
	Fri, 17 Apr 2020 05:47:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QY+gBM3mRBum; Fri, 17 Apr 2020 05:47:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8414B113;
	Fri, 17 Apr 2020 05:47:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84DB74B113
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 05:47:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r+zkulrm7VKG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 05:47:14 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05A7D4B0DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 05:47:13 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id D82F383C57B3FD2E2153;
 Fri, 17 Apr 2020 17:47:10 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0;
 Fri, 17 Apr 2020 17:47:00 +0800
Subject: Re: [PATCH v2] KVM/arm64: Support enabling dirty log gradually in
 small chunks
To: Marc Zyngier <maz@kernel.org>
References: <20200413122023.52583-1-zhukeqian1@huawei.com>
 <20200416160833.728017e9@why>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <44ce4553-5215-2290-5956-2e6c577d030b@huawei.com>
Date: Fri, 17 Apr 2020 17:46:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200416160833.728017e9@why>
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Jay Zhou <jianjay.zhou@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/4/16 23:08, Marc Zyngier wrote:
> On Mon, 13 Apr 2020 20:20:23 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> There is already support of enabling dirty log graually in small chunks
> 
> gradually
> 
>> for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
>> small chunks"). This adds support for arm64.
>>
>> x86 still writes protect all huge pages when DIRTY_LOG_INITIALLY_ALL_SET
>> is eanbled. However, for arm64, both huge pages and normal pages can be
> 
> enabled
> 
>> write protected gradually by userspace.
>>
>> Under the Huawei Kunpeng 920 2.6GHz platform, I did some tests on 128G
>> Linux VMs with different page size. The memory pressure is 127G in each
>> case. The time taken of memory_global_dirty_log_start in QEMU is listed
>> below:
>>
>> Page Size      Before    After Optimization
>>   4K            650ms         1.8ms
>>   2M             4ms          1.8ms
>>   1G             2ms          1.8ms
> 
> These numbers are different from what you have advertised before. What
> changed?
In patch RFC, the numbers is got when memory pressure is 100G, so the number
is bigger here.
> 
>>
>> Besides the time reduction, the biggest income is that we will minimize
> 
> s/income/improvement/
> 
>> the performance side effect (because of dissloving huge pages and marking
> 
> dissolving
embarrassed for these misspell :(
> 
>> memslots dirty) on guest after enabling dirty log.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  Documentation/virt/kvm/api.rst    |  2 +-
>>  arch/arm64/include/asm/kvm_host.h |  3 +++
>>  virt/kvm/arm/mmu.c                | 12 ++++++++++--
>>  3 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index efbbe570aa9b..0017f63fa44f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5777,7 +5777,7 @@ will be initialized to 1 when created.  This also improves performance because
>>  dirty logging can be enabled gradually in small chunks on the first call
>>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
>> -x86 for now).
>> +x86 and arm64 for now).
>>  
>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 32c8a675e5a4..a723f84fab83 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -46,6 +46,9 @@
>>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>>  
>> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>> +				     KVM_DIRTY_LOG_INITIALLY_SET)
>> +
>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>  
>>  extern unsigned int kvm_sve_max_vl;
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e3b9ee268823..1077f653a611 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -2265,8 +2265,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>  	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
>>  	 * memory slot is write protected.
>>  	 */
>> -	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
>> -		kvm_mmu_wp_memory_region(kvm, mem->slot);
>> +	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>> +		/*
>> +		 * If we're with initial-all-set, we don't need to write
>> +		 * protect any pages because they're all reported as dirty.
>> +		 * Huge pages and normal pages will be write protect gradually.
>> +		 */
>> +		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
>> +			kvm_mmu_wp_memory_region(kvm, mem->slot);
>> +		}
>> +	}
>>  }
>>  
>>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
> 
> As it is, it is pretty good. The one thing that isn't clear to me is
> why we have a difference in behaviour between x86 and arm64. What
> prevents x86 from having the same behaviour as arm64?
I am also not very clear about the difference. Maybe there is historic reason.

Before introducing DIRTY_LOG_INITIALLY_ALL_SET, all pages will be write
protected when starting dirty log, but only normal pages are needed
to be write protected again during dirty log sync, because huge pages will
be dissolved to normal pages.

For that x86 uses different routine to write protect huge pages and normal pages,
and arm64 uses same routine to do this, so arm64 still write protect all
pages again during dirty log sync, but x86 didn't.

So I think that x86 can write protect huge pages gradually too, just need to add
some code legs in dirty log sync.

Thanks,
Keqian
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
