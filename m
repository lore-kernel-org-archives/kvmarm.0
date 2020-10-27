Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A10AC4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 04:05:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADFF321556
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 04:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V5M9Ky29"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADFF321556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B62F94B08E;
	Tue, 27 Oct 2020 00:05:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wMnHDlYf8waV; Tue, 27 Oct 2020 00:05:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99FB94B584;
	Tue, 27 Oct 2020 00:05:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF98B4B57D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 00:05:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tmjDG5FjJB4K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 00:05:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1054B57B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 00:05:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603771504;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=z63apBRGyy3e8g8mUKeHgVcKfFAFQyjLMsXxTptfmGQ=;
 b=V5M9Ky29lE3vzcu/QvsfhN1HXM6RSzsKURSId7OTqMCX76YVLUa65ruHELe96gHUh8HqCu
 0qvQArDuCix6mSvJvNNe9kfALuRKkueuVQ42wOVJHGO2jZ5dGvWW9mGS2bd6k8K/gCaZzW
 6Tez2oeH4c5h7Ur82NYnu1kF0sAyXVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-B0_6d6n2MFWoKYU7dRmPiA-1; Tue, 27 Oct 2020 00:04:59 -0400
X-MC-Unique: B0_6d6n2MFWoKYU7dRmPiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CAF8E9000;
 Tue, 27 Oct 2020 04:04:57 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79FBC5D9E8;
 Tue, 27 Oct 2020 04:04:54 +0000 (UTC)
Subject: Re: [PATCH v2 1/1] KVM: arm64: Correctly handle the mmio faulting
To: Santosh Shukla <sashukla@nvidia.com>, maz@kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
References: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
 <1603711447-11998-2-git-send-email-sashukla@nvidia.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b86a29e1-1e25-d3e7-5718-77f4a37da575@redhat.com>
Date: Tue, 27 Oct 2020 15:04:51 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1603711447-11998-2-git-send-email-sashukla@nvidia.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: mcrossley@nvidia.com, kwankhede@nvidia.com, cjia@nvidia.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org
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

Hi Santosh,

On 10/26/20 10:24 PM, Santosh Shukla wrote:
> The Commit:6d674e28 introduces a notion to detect and handle the
> device mapping. The commit checks for the VM_PFNMAP flag is set
> in vma->flags and if set then marks force_pte to true such that
> if force_pte is true then ignore the THP function check
> (/transparent_hugepage_adjust()).
> 
> There could be an issue with the VM_PFNMAP flag setting and checking.
> For example consider a case where the mdev vendor driver register's
> the vma_fault handler named vma_mmio_fault(), which maps the
> host MMIO region in-turn calls remap_pfn_range() and maps
> the MMIO's vma space. Where, remap_pfn_range implicitly sets
> the VM_PFNMAP flag into vma->flags.
> 
> Now lets assume a mmio fault handing flow where guest first access
> the MMIO region whose 2nd stage translation is not present.
> So that results to arm64-kvm hypervisor executing guest abort handler,
> like below:
> 
> kvm_handle_guest_abort() -->
>   user_mem_abort()--> {
> 
>      ...
>      0. checks the vma->flags for the VM_PFNMAP.
>      1. Since VM_PFNMAP flag is not yet set so force_pte _is_ false;
>      2. gfn_to_pfn_prot() -->
>          __gfn_to_pfn_memslot() -->
>              fixup_user_fault() -->
>                  handle_mm_fault()-->
>                      __do_fault() -->
>                         vma_mmio_fault() --> // vendor's mdev fault handler
>                          remap_pfn_range()--> // Here sets the VM_PFNMAP
>                                                  flag into vma->flags.
>      3. Now that force_pte is set to false in step-2),
>         will execute transparent_hugepage_adjust() func and
>         that lead to Oops [4].
>   }
> 
> The proposition is to set force_pte=true if kvm_is_device_pfn is true.
> 
> [4] THP Oops:
>> pc: kvm_is_transparent_hugepage+0x18/0xb0
>> ...
>> ...
>> user_mem_abort+0x340/0x9b8
>> kvm_handle_guest_abort+0x248/0x468
>> handle_exit+0x150/0x1b0
>> kvm_arch_vcpu_ioctl_run+0x4d4/0x778
>> kvm_vcpu_ioctl+0x3c0/0x858
>> ksys_ioctl+0x84/0xb8
>> __arm64_sys_ioctl+0x28/0x38
> 
> Tested on Huawei Kunpeng Taishan-200 arm64 server, Using VFIO-mdev device.
> Linux-5.10-rc1 tip: 3650b228
> 
> Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
> ---
> v2:
> - Per Marc's suggestion - setting force_pte=true.
> - Rebased and tested for 5.10-rc1 commit: 3650b228
> 
> v1: https://lkml.org/lkml/2020/10/21/460
> 
> arch/arm64/kvm/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 19aacc7..d4cd253 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -839,6 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   
>   	if (kvm_is_device_pfn(pfn)) {
>   		device = true;
> +		force_pte = true;
>   	} else if (logging_active && !write_fault) {
>   		/*
>   		 * Only actually map the page as writable if this was a write
> 

Cheers,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
