Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0F7C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 13:40:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B41920878
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 13:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSzmrQ8F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B41920878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0B5B4B1F0;
	Fri, 18 Sep 2020 09:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eInvJlrs8MRc; Fri, 18 Sep 2020 09:39:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B814B1C8;
	Fri, 18 Sep 2020 09:39:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 289B04B1F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 09:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dney3KYSlzNa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 09:39:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1185C4B1B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 09:39:57 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5DB6023719;
 Fri, 18 Sep 2020 13:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600436396;
 bh=GSnIIuUFYXpIssBAW7DbkqIo0fNlUI8e605Tajn3awY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kSzmrQ8FJFBO/IFG8qAMoXRtiAKoQMEE58zmnxyMBZ6d/jdHDrleOKoxtkxj29RSh
 JfhmBGvxkPDK0OHi0FP6jfd/OPCuqfw4PfceFpXjgkjRMoTdQfbv3nKZ6swEXhNCWQ
 Oi9MSAMCQq5pUiD7nMggLgwGi+Og/pEHkNo0Y08k=
Date: Fri, 18 Sep 2020 14:39:51 +0100
From: Will Deacon <will@kernel.org>
To: Tian Tao <tiantao6@hisilicon.com>
Subject: Re: [PATCH] KVM: arm64: fix inject_fault.c kernel-doc warnings
Message-ID: <20200918133950.GE31232@willie-the-truck>
References: <1600154512-44624-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1600154512-44624-1-git-send-email-tiantao6@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, linuxarm@huawei.com, catalin.marinas@arm.com,
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

On Tue, Sep 15, 2020 at 03:21:52PM +0800, Tian Tao wrote:
> Fix kernel-doc warnings.
> arch/arm64/kvm/inject_fault.c:210: warning: Function parameter or member
> 'vcpu' not described in 'kvm_inject_undefined'
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  arch/arm64/kvm/inject_fault.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index ebfdfc2..c90d144 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -202,6 +202,7 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
>  
>  /**
>   * kvm_inject_undefined - inject an undefined instruction into the guest
> + * @vcpu: The VCPU to receive the undefined instruction

Better as "The vCPU in which to inject the exception"

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
