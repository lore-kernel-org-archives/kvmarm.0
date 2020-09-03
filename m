Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE17C433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 05:10:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4697207EA
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 05:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwGJonlf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4697207EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36CC54B2EA;
	Thu,  3 Sep 2020 01:10:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nvyIVoXaINtD; Thu,  3 Sep 2020 01:10:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 032E74B343;
	Thu,  3 Sep 2020 01:10:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21EAB4B2EA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 01:10:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ueAte9R7isN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 01:09:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0A14B2AF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 01:09:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599109798;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EijqDN/r5sSiZpHtNIn2jyZiuE6aC7OPRYlm92JjbJ8=;
 b=fwGJonlf5Zbe0gzh7/EHujLABRqlOVS5ROYicvWZ3FLm7jNiLdoL64kEFZJ0KXExq816nh
 lxvzOddMShixmu1Fctk8r7tPOmQdBp3PZpwSKwFqkpDd8x2JNexbVACWwepDDCaotPclOX
 tHBS17Xg5N1q5AhUKUrbtaCBeJ833nA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-D2lPaIvUNnCWupM6cKVaTw-1; Thu, 03 Sep 2020 01:09:56 -0400
X-MC-Unique: D2lPaIvUNnCWupM6cKVaTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 554A110ABDB1;
 Thu,  3 Sep 2020 05:09:55 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B0D8196F3;
 Thu,  3 Sep 2020 05:09:52 +0000 (UTC)
Subject: Re: [PATCH v3 21/21] KVM: arm64: Don't constrain maximum IPA size
 based on host configuration
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-22-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <492420d8-91d7-a258-cf8a-17da29719d86@redhat.com>
Date: Thu, 3 Sep 2020 15:09:50 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-22-will@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
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
> Now that the guest stage-2 page-tables are managed independently from
> the host stage-1 page-tables, we can avoid constraining the IPA size
> based on the host and instead limit it only based on the PARange field
> of the ID_AA64MMFR0 register.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/reset.c | 38 +++++---------------------------------
>   1 file changed, 5 insertions(+), 33 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index ee33875c5c2a..471ee9234e40 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -339,7 +339,7 @@ u32 get_kvm_ipa_limit(void)
>   
>   int kvm_set_ipa_limit(void)
>   {
> -	unsigned int ipa_max, pa_max, va_max, parange, tgran_2;
> +	unsigned int parange, tgran_2;
>   	u64 mmfr0;
>   
>   	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> @@ -376,38 +376,10 @@ int kvm_set_ipa_limit(void)
>   		break;
>   	}
>   
> -	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
> -
> -	/* Clamp the IPA limit to the PA size supported by the kernel */
> -	ipa_max = (pa_max > PHYS_MASK_SHIFT) ? PHYS_MASK_SHIFT : pa_max;
> -	/*
> -	 * Since our stage2 table is dependent on the stage1 page table code,
> -	 * we must always honor the following condition:
> -	 *
> -	 *  Number of levels in Stage1 >= Number of levels in Stage2.
> -	 *
> -	 * So clamp the ipa limit further down to limit the number of levels.
> -	 * Since we can concatenate upto 16 tables at entry level, we could
> -	 * go upto 4bits above the maximum VA addressable with the current
> -	 * number of levels.
> -	 */
> -	va_max = PGDIR_SHIFT + PAGE_SHIFT - 3;
> -	va_max += 4;
> -
> -	if (va_max < ipa_max)
> -		ipa_max = va_max;
> -
> -	/*
> -	 * If the final limit is lower than the real physical address
> -	 * limit of the CPUs, report the reason.
> -	 */
> -	if (ipa_max < pa_max)
> -		pr_info("kvm: Limiting the IPA size due to kernel %s Address limit\n",
> -			(va_max < pa_max) ? "Virtual" : "Physical");
> -
> -	WARN(ipa_max < KVM_PHYS_SHIFT,
> -	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
> -	kvm_ipa_limit = ipa_max;
> +	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
> +	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
> +	     "KVM IPA limit (%d bit) is smaller than default size\n",
> +	     kvm_ipa_limit);
>   	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
>   
>   	return 0;
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
