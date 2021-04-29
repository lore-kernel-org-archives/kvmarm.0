Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F0DC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 10:32:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65D8361457
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 10:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65D8361457
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8EC24B329;
	Thu, 29 Apr 2021 06:32:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PyIKcpBEJZ0p; Thu, 29 Apr 2021 06:32:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7DD4B33D;
	Thu, 29 Apr 2021 06:32:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32F764B325
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 06:32:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VP4KMUNhKrD5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 06:32:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3FF64B2FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 06:32:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA2911FB;
 Thu, 29 Apr 2021 03:31:59 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67D8F3F70D;
 Thu, 29 Apr 2021 03:31:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20210426103605.616908-1-maz@kernel.org>
 <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com> <YIgsbp/hRxM9U+ZN@myrica>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <35d5f174-3814-a019-a6e3-14cffad69763@arm.com>
Date: Thu, 29 Apr 2021 11:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIgsbp/hRxM9U+ZN@myrica>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Krishna Reddy <vdumpa@nvidia.com>, Sumit Gupta <sumitg@nvidia.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi Jean,

On 4/27/21 4:23 PM, Jean-Philippe Brucker wrote:
> On Tue, Apr 27, 2021 at 03:52:46PM +0100, Alexandru Elisei wrote:
>> The comment [1] suggested that the panic is triggered during page aging.
> I think only with an out-of-tree patch applied
> https://jpbrucker.net/git/linux/commit/?h=sva/2021-03-01&id=d32d8baaf293aaefef8a1c9b8a4508ab2ec46c61
> which probably is not going upstream.

Thanks for that, that explains why I wasn't able to trigger the notification.

I did a grep for all the places where mmu_notifier_change_pte() and
set_pte_at_notify() are used in the kernel, and from what I can tell they are only
called for a new pte which has a struct page. From my investigation, the notifiers
are called from ksm (which deals with physical memory), swap migration (so still
pages in memory) and on copy-on-write.

On Linux v5.12, I tried to trigger the copy-on-write notification by forking
kvmtool right after the BAR region is mapped and then reading from the userspace
BAR address, but the new pte (for which the notifier is called) is valid.

I also looked at what x86 does, but I couldn't find where cache maintenance is
performed (wouldn't surprise me if it's not necessary at all).

So I guess my question is what kind of pfns the MMU notifiers for the secondary
MMUs are required to handle. If the requirement is that they should handle both
device and struct page backed pfns, then the patch looks correct to me
(user_mem_abort() also uses kvm_is_device_pfn() to decide if dcache maintenance is
needed).

Thanks,

Alex

> Thanks,
> Jean
>
>> vfio_pci_mmap() sets the VM_PFNMAP for the VMA and I see in the Documentation that
>> pages with VM_PFNMAP are added to the unevictable LRU list, doesn't that mean it's
>> not subject the page aging? I feel like there's something I'm missing.
>>
>> [1]
>> https://lore.kernel.org/kvm/BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com/
>>
>> Thanks,
>>
>> Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
