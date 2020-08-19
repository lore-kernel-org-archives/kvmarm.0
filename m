Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0949BC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 04:46:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81F8020738
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 04:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BepHXZHl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81F8020738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18CAD4BA14;
	Wed, 19 Aug 2020 00:46:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZNHBIHTH+zbc; Wed, 19 Aug 2020 00:46:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16FC64BA01;
	Wed, 19 Aug 2020 00:46:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DDA4B9F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 00:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t9FSqqS60dsb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 00:46:04 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 776B64B980
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 00:46:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597812364;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bAI+D7Juob+Rkh/t1AsQW5cDL0ypfVqXCo1MpBwkMH0=;
 b=BepHXZHlZKBixlngqkaCvJTtnituWCHtMpnzouVM5BhI0AxO98GWLiYeydw9vmv7qIijMD
 zY93DcZ1dHa0ELGt+ExEFftIGf5SPDLadpaqncj8F+HBiYsf1zTqaAVLsc/f2nclvd1+cN
 QeMmRbjQd0ZP+QziDK/kqIkxJsVqO9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-1uuMC1XROSex1D2bP05B-w-1; Wed, 19 Aug 2020 00:45:58 -0400
X-MC-Unique: 1uuMC1XROSex1D2bP05B-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 979B0186A561;
 Wed, 19 Aug 2020 04:45:57 +0000 (UTC)
Received: from [10.64.54.198] (vpn2-54-198.bne.redhat.com [10.64.54.198])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2795756C3;
 Wed, 19 Aug 2020 04:45:55 +0000 (UTC)
Subject: Re: [PATCH v2 02/22] KVM: arm64: Remove kvm_mmu_free_memory_caches()
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200818132818.16065-1-will@kernel.org>
 <20200818132818.16065-3-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <32fa5558-862b-554e-1325-24bab7c9bfec@redhat.com>
Date: Wed, 19 Aug 2020 14:45:52 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200818132818.16065-3-will@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

On 8/18/20 11:27 PM, Will Deacon wrote:
> kvm_mmu_free_memory_caches() is only called by kvm_arch_vcpu_destroy(),
> so inline the implementation and get rid of the extra function.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 2 --
>   arch/arm64/kvm/arm.c             | 2 +-
>   arch/arm64/kvm/mmu.c             | 5 -----
>   3 files changed, 1 insertion(+), 8 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 189839c3706a..0f078b1920ff 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -141,8 +141,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   
>   int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>   
> -void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
> -
>   phys_addr_t kvm_mmu_get_httbr(void);
>   phys_addr_t kvm_get_idmap_vector(void);
>   int kvm_mmu_init(void);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 691d21e4c717..c958c8f03144 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -283,7 +283,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
>   		static_branch_dec(&userspace_irqchip_in_use);
>   
> -	kvm_mmu_free_memory_caches(vcpu);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>   	kvm_timer_vcpu_terminate(vcpu);
>   	kvm_pmu_vcpu_destroy(vcpu);
>   
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4a24ebdc6fc6..9bc1a5d5a310 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2322,11 +2322,6 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
>   				 kvm_test_age_hva_handler, NULL);
>   }
>   
> -void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> -{
> -	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> -}
> -
>   phys_addr_t kvm_mmu_get_httbr(void)
>   {
>   	if (__kvm_cpu_uses_extended_idmap())
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
