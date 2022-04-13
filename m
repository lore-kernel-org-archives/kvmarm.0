Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B92AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 09:22:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D894B28D;
	Wed, 13 Apr 2022 05:22:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qUZ9allu44nv; Wed, 13 Apr 2022 05:22:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C0D4B295;
	Wed, 13 Apr 2022 05:22:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFF214B28B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 05:22:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8c85EaLlDxfm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 05:22:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AABE34B288
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 05:22:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649841764;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=etNogBidbFvzG587dPz0EWEzFmzslPPD/UlHCJ6dM0k=;
 b=HHPk9zulm9EBud6K5T4/40wtx9jYLFesICnRo9jwU6RDo/+5GVIMErvtOhRVq3AG0Ub/G+
 ds/RlhAuMM3puRnYhgO1nHvx9xgWhz3RwOcXPbAzUHMw5i2qNcydM95XWr0T1ZHhmwVEc8
 5kU675eEKsCY7xUjCCLa56AlhAIMeKg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-EfPFCYQhPdGHFp6PNVnNaQ-1; Wed, 13 Apr 2022 05:22:40 -0400
X-MC-Unique: EfPFCYQhPdGHFp6PNVnNaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 298FD296A60B;
 Wed, 13 Apr 2022 09:22:40 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A55CAC15E73;
 Wed, 13 Apr 2022 09:22:33 +0000 (UTC)
Subject: Re: [PATCH v5 10/10] selftests: KVM: aarch64: Add
 KVM_REG_ARM_FW_REG(3) to get-reg-list
To: Raghavendra Rao Ananta <rananta@google.com>, Marc Zyngier
 <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-11-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b3cfe975-de18-ea21-f174-1124803f314d@redhat.com>
Date: Wed, 13 Apr 2022 17:22:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220407011605.1966778-11-rananta@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Raghavendra,

On 4/7/22 9:16 AM, Raghavendra Rao Ananta wrote:
> Add the register KVM_REG_ARM_FW_REG(3)
> (KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3) to the base_regs[] of
> get-reg-list.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 281c08b3fdd2..7049c31aa443 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -691,6 +691,7 @@ static __u64 base_regs[] = {
>   	KVM_REG_ARM_FW_REG(0),
>   	KVM_REG_ARM_FW_REG(1),
>   	KVM_REG_ARM_FW_REG(2),
> +	KVM_REG_ARM_FW_REG(3),
>   	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
>   	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
>   	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
> 

It seems the same fixup has been done in another patch.

https://www.mail-archive.com/kvmarm@lists.cs.columbia.edu/msg38027.html

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
