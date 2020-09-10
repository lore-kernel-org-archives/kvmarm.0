Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0648C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 17:36:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47E07221E3
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 17:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTn8sYHc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47E07221E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84AD34B2FA;
	Thu, 10 Sep 2020 13:36:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vQwTce+ongf7; Thu, 10 Sep 2020 13:36:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 459F74B2FB;
	Thu, 10 Sep 2020 13:36:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E638E4B2F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 13:36:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oltFebVD9jiG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 13:36:24 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E27754B1AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 13:36:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599759384;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=//D9w3KZTfa+Y2ktZ6gH6a4P/XSjpG6StGXtoEpGRTE=;
 b=OTn8sYHc7ox3d4IAPQqKlhgEa+4CRg8UWMfn/ESUdcTXhwxlKJRDTTwk7MuohpCwq41sJS
 X3mHO5m3ibjB3/X93qL/O+G644ymaSnfNrADpDT2udjRod9W4P9lZGbRO+OGfsA1bllW73
 cBBe/X+43hjNfuo5p29tifdw93pDp2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-Zk6OaMdBOBmVuvrjyXK9Pw-1; Thu, 10 Sep 2020 13:36:20 -0400
X-MC-Unique: Zk6OaMdBOBmVuvrjyXK9Pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FFC464081;
 Thu, 10 Sep 2020 17:36:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.124])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B71E775121;
 Thu, 10 Sep 2020 17:36:12 +0000 (UTC)
Date: Thu, 10 Sep 2020 19:36:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across reset
Message-ID: <20200910173609.niujn2ngnjzvx7ub@kamzik.brq.redhat.com>
References: <20200910164243.29253-1-graf@amazon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910164243.29253-1-graf@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 10, 2020 at 06:42:43PM +0200, Alexander Graf wrote:
> We allow user space to set the PMCR register to any value. However,
> when time comes for a vcpu reset (for example on PSCI online), PMCR
> is reset to the hardware capabilities.
> 
> I would like to explicitly expose different PMU capabilities (number
> of supported event counters) to the guest than hardware supports.
> Ideally across vcpu resets.
> 
> So this patch adopts the reset path to only populate the immutable
> PMCR register bits from hardware when they were not initialized
> previously. This effectively means that on a normal reset, only the
> guest settable fields are reset, while on vcpu creation the register
> gets populated from hardware like before.
> 
> With this in place and a change in user space to invoke SET_ONE_REG
> on the PMCR for every vcpu, I can reliably set the PMU event counter
> number to arbitrary values.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 20ab2a7d37ca..28f67550db7f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
>  
> -	pmcr = read_sysreg(pmcr_el0);
> +	/*
> +	 * If we already received PMCR from a previous ONE_REG call,
> +	 * maintain its immutable flags
> +	 */
> +	pmcr = __vcpu_sys_reg(vcpu, r->reg);
> +	if (!__vcpu_sys_reg(vcpu, r->reg))
> +		pmcr = read_sysreg(pmcr_el0);
> +
>  	/*
>  	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
>  	 * except PMCR.E resetting to zero.
> -- 
> 2.16.4
>

Aha, a much simpler patch than I expected. With this approach we don't
need a get_user() function, or to use 'val', but don't we still want to
add sanity checks with a set_user() function? At least to ensure immutable
flags match and that PMCR_EL0.N isn't too big?

Silently changing the user's input, which I see we also do for e.g. MPIDR,
isn't super user friendly.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
