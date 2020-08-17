Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85787C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:47:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11B9E20758
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uof3R/kr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11B9E20758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC734BF6A;
	Mon, 17 Aug 2020 04:47:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bw-lloITthmM; Mon, 17 Aug 2020 04:47:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F32D4BF6E;
	Mon, 17 Aug 2020 04:47:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E55404BF6E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kxKvWbYAoknZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 04:47:47 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E951B4BF6A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:47:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597654067;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=t355WPxa6uPtXL7lonYCwvII2S9kGVc9Ngbl+va3Q60=;
 b=Uof3R/krOg1yAzNoKrFKek7aV/LVfVKB9lE90p7sPmJIXXNP1uub4hTpmJdBBlhHML6MBB
 WX+W13fwbNWLAsc0SSBEp8lglBLp86M4flKfcca5VwOebrCAHEq5gbp6Imab1eOS7iTKK/
 wPDnfKtU0XrRVAZvMKbMLlFNT5lyeL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-jE_OXeiPPe2LKymmUwTwdQ-1; Mon, 17 Aug 2020 04:47:43 -0400
X-MC-Unique: jE_OXeiPPe2LKymmUwTwdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A951D81F010;
 Mon, 17 Aug 2020 08:47:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.210])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7048D5D9D2;
 Mon, 17 Aug 2020 08:47:38 +0000 (UTC)
Date: Mon, 17 Aug 2020 10:47:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Some fixes of PV-time interface document
Message-ID: <20200817084735.xyfdtgcsuxzwgzyr@kamzik.brq.redhat.com>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200817033729.10848-2-zhukeqian1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Aug 17, 2020 at 11:37:27AM +0800, Keqian Zhu wrote:
> Rename PV_FEATURES tp PV_TIME_FEATURES
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
> index 687b60d..94bffe2 100644
> --- a/Documentation/virt/kvm/arm/pvtime.rst
> +++ b/Documentation/virt/kvm/arm/pvtime.rst
> @@ -3,7 +3,7 @@
>  Paravirtualized time support for arm64
>  ======================================
>  
> -Arm specification DEN0057/A defines a standard for paravirtualised time
> +Arm specification DEN0057/A defines a standard for paravirtualized time
>  support for AArch64 guests:
>  
>  https://developer.arm.com/docs/den0057/a
> @@ -19,8 +19,8 @@ Two new SMCCC compatible hypercalls are defined:
>  
>  These are only available in the SMC64/HVC64 calling convention as
>  paravirtualized time is not available to 32 bit Arm guests. The existence of
> -the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
> -mechanism before calling it.
> +the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
> +ARCH_FEATURES mechanism before calling it.
>  
>  PV_TIME_FEATURES
>      ============= ========    ==========
> -- 
> 1.8.3.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
