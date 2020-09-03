Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AEFC433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 05:00:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D8E72072A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 05:00:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVCIdF4n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D8E72072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D64D4B255;
	Thu,  3 Sep 2020 01:00:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mx+Vf7X+nXH9; Thu,  3 Sep 2020 01:00:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3C84B215;
	Thu,  3 Sep 2020 01:00:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86F124B1DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 01:00:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zurfrKWTB3Bx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 01:00:27 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD234B1F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 01:00:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599109227;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Erjn+okjugfCqf+kdI+3fYOoVqZwyxKZAWHPn/nf6DI=;
 b=eVCIdF4nXWNMEOR3f8/D4SFmiOuhKLi2pfBz4SNb/5MlCjs5pgh8qbugLQtXUPRL2FU/yv
 x04wIcOH85zf6AqBNCdl7ypBNvR4ltpfqLygfW1IyAFA4A8e0LHTjPnmpmvXjPV2lC6KFG
 EZBmMVQFqRuXc1X/MVkPtAdOqzcr5FU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-rz22YC0QNtafUFUL5sH0tA-1; Thu, 03 Sep 2020 01:00:25 -0400
X-MC-Unique: rz22YC0QNtafUFUL5sH0tA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA2AA100747E;
 Thu,  3 Sep 2020 05:00:23 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 737A560C0F;
 Thu,  3 Sep 2020 05:00:21 +0000 (UTC)
Subject: Re: [PATCH v3 18/21] KVM: arm64: Check the pgt instead of the pgd
 when modifying page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-19-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <802004d9-a351-1028-1c02-e14255af8392@redhat.com>
Date: Thu, 3 Sep 2020 15:00:19 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-19-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
> In preparation for removing the 'pgd' field of 'struct kvm_s2_mmu',
> update the few remaining users to check the 'pgt' field instead.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cfbf32cae3a5..050eab71de31 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1813,7 +1813,7 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *dat
>   int kvm_unmap_hva_range(struct kvm *kvm,
>   			unsigned long start, unsigned long end, unsigned flags)
>   {
> -	if (!kvm->arch.mmu.pgd)
> +	if (!kvm->arch.mmu.pgt)
>   		return 0;
>   
>   	trace_kvm_unmap_hva_range(start, end);
> @@ -1876,7 +1876,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
>   
>   int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
>   {
> -	if (!kvm->arch.mmu.pgd)
> +	if (!kvm->arch.mmu.pgt)
>   		return 0;
>   	trace_kvm_age_hva(start, end);
>   	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
> @@ -1884,7 +1884,7 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
>   
>   int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
>   {
> -	if (!kvm->arch.mmu.pgd)
> +	if (!kvm->arch.mmu.pgt)
>   		return 0;
>   	trace_kvm_test_age_hva(hva);
>   	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
