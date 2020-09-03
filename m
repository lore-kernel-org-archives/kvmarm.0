Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81C9C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 05:07:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 566582065E
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 05:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKGeuPgT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 566582065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B955A4B388;
	Thu,  3 Sep 2020 01:07:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UhAwRsspgzCo; Thu,  3 Sep 2020 01:07:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938C44B38B;
	Thu,  3 Sep 2020 01:07:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 559444B388
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 01:07:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r9dNSzMMurrY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 01:07:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40B754B35A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 01:07:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599109646;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=weMxr7wdefcFu3lhAtUW/ZGVlS24UpPpY8VmtuLKvJ8=;
 b=dKGeuPgT2Ce9unls28o73GhE7jdDRH5XWQO4Nl7sXkNHyOVrNbyVCO6Js565S3LGnpW6IX
 lfodhEkMzaPxShTp8cfWvUVkPKRc9Z6Qhv5RqA66oWxQqluO4kLqeVhhyqmyU9wywuYzSZ
 DJj39dlJoo0BlO7VR7aQNpeYb7Dso9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-ZPrdevr5PxiOxM_OaQadqQ-1; Thu, 03 Sep 2020 01:07:23 -0400
X-MC-Unique: ZPrdevr5PxiOxM_OaQadqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26D64E75D;
 Thu,  3 Sep 2020 05:07:22 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8AEB77C1B;
 Thu,  3 Sep 2020 05:07:19 +0000 (UTC)
Subject: Re: [PATCH v3 20/21] KVM: arm64: Remove unused 'pgd' field from
 'struct kvm_s2_mmu'
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-21-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f0a64bb2-5371-9f44-1c64-035cbc6dcf5b@redhat.com>
Date: Thu, 3 Sep 2020 15:07:17 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-21-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> The stage-2 page-tables are entirely encapsulated by the 'pgt' field of
> 'struct kvm_s2_mmu', so remove the unused 'pgd' field.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h | 1 -
>   arch/arm64/kvm/mmu.c              | 2 --
>   2 files changed, 3 deletions(-)
> 

I think this might be folded into PATCH[18] as both patches are
simple enough. I'm not sure the changes introduced in PATCH[19]
prevent us doing this.

There is another question below.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0b7c702b2151..41caf29bd93c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -79,7 +79,6 @@ struct kvm_s2_mmu {
>   	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
>   	 * canonical stage-2 page tables.
>   	 */
> -	pgd_t		*pgd;
>   	phys_addr_t	pgd_phys;
>   	struct kvm_pgtable *pgt;
>   
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ddeec0b03666..f28e03dcb897 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -384,7 +384,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>   	mmu->kvm = kvm;
>   	mmu->pgt = pgt;
>   	mmu->pgd_phys = __pa(pgt->pgd);
> -	mmu->pgd = (void *)pgt->pgd;
>   	mmu->vmid.vmid_gen = 0;
>   	return 0;
>   
> @@ -470,7 +469,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	spin_lock(&kvm->mmu_lock);
>   	pgt = mmu->pgt;
>   	if (pgt) {
> -		mmu->pgd = NULL;
>   		mmu->pgd_phys = 0;
>   		mmu->pgt = NULL;
>   		free_percpu(mmu->last_vcpu_ran);
> 

I guess mmu->pgd_phys might be removed either because kvm_get_vttbr()
is the only consumer.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
