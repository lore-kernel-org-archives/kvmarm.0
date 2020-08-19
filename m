Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4766EC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 04:38:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B68FA2078B
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 04:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btBqRnok"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B68FA2078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16B924B9EB;
	Wed, 19 Aug 2020 00:38:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z5CK1DirgUG1; Wed, 19 Aug 2020 00:38:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 068FB4B9CF;
	Wed, 19 Aug 2020 00:38:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E494B9C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 00:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NdbcCszk-Plv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 00:38:51 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D89264B90F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 00:38:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597811931;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VRdgNMkQwVuG00VIpQl/DsMlfi6VqkYpcwWD5ujuhtU=;
 b=btBqRnok6EvFu2/UgnhpbW6XgeC4bbnbcx2DGyQMbLOflxe1Zz3kguz/slDw2tFtSooCAG
 kPGuLq1T/KjaVn+boeLZOOzBWoFkGhnweujG5AkipTf4bVA/FOzm4PKbGb4zhZdxqLfgjv
 xOH+KKkBfws7VRp4jI1fDLlg8J6UK+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-Jz_5CkvTNPGgx4CrGc2ODg-1; Wed, 19 Aug 2020 00:38:47 -0400
X-MC-Unique: Jz_5CkvTNPGgx4CrGc2ODg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AE20186A561;
 Wed, 19 Aug 2020 04:38:46 +0000 (UTC)
Received: from [10.64.54.198] (vpn2-54-198.bne.redhat.com [10.64.54.198])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20EDA7849A;
 Wed, 19 Aug 2020 04:38:43 +0000 (UTC)
Subject: Re: [PATCH v2 01/22] KVM: arm64: Don't free memcache pages in
 kvm_phys_addr_ioremap()
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200818132818.16065-1-will@kernel.org>
 <20200818132818.16065-2-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <47f7bfc2-1880-908f-4345-b25da500b0ff@redhat.com>
Date: Wed, 19 Aug 2020 14:38:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200818132818.16065-2-will@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On 8/18/20 11:27 PM, Will Deacon wrote:
> kvm_phys_addr_ioremap() unconditionally empties out the memcache pages
> for the current vCPU on return. This causes subsequent topups to allocate
> fresh pages and is at odds with the behaviour when mapping memory in
> user_mem_abort().
> 
> Remove the call to kvm_mmu_free_memory_cache() from
> kvm_phys_addr_ioremap(), allowing the cached pages to be used by a later
> mapping.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 662b0c99a63d..4a24ebdc6fc6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1489,19 +1489,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   		ret = kvm_mmu_topup_memory_cache(&cache,
>   						 kvm_mmu_cache_min_pages(kvm));
>   		if (ret)
> -			goto out;
> +			break;
>   		spin_lock(&kvm->mmu_lock);
>   		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
>   				     KVM_S2PTE_FLAG_IS_IOMAP);
>   		spin_unlock(&kvm->mmu_lock);
>   		if (ret)
> -			goto out;
> +			break;
>   
>   		pfn++;
>   	}
>   
> -out:
> -	kvm_mmu_free_memory_cache(&cache);
>   	return ret;
>   }
>   

It seems incorrect. The cache is tracked by local variable (@cache),
meaning the cache is only visible to kvm_phys_addr_ioremap() and its
callee. So it's correct to free unused pages in two cases: (1) error
is returned (2) high level of page tables were previously populated
and not all pre-allocated pages are used. Otherwise, this leads to
memory leakage.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
