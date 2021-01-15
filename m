Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C11FC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 13:05:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D026B22473
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 13:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D026B22473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35E0D4B1AA;
	Fri, 15 Jan 2021 08:05:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K9BRxETu2Mon; Fri, 15 Jan 2021 08:04:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F8D4B1B0;
	Fri, 15 Jan 2021 08:04:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F356D4B188
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 08:04:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mQn4v78XJzDU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 08:04:56 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E79664B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 08:04:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610715896;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7c420dPECbiXPZhECKBffZnsx/9MKvakAMA3MQ54v9c=;
 b=fVczHQXfEel8YHm1H/ZuRUxVRwiWHb59DryTjTE49quNqVNNb4l1cI7PextXGniYNuLKcd
 5iVD8lX7xFJoDgbYjutSqjT+32mmjHXn3JqK7cVOYIl5flfQnqB+A7LszyBha0VE1hKSSI
 JhQKYkdQq46TtpvFAr3OvZ9BK3s2mOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-LBE-i0UNM52kNqy9mYLSlg-1; Fri, 15 Jan 2021 08:04:54 -0500
X-MC-Unique: LBE-i0UNM52kNqy9mYLSlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A1DD9CDA2;
 Fri, 15 Jan 2021 13:04:53 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7994C6A8E7;
 Fri, 15 Jan 2021 13:04:50 +0000 (UTC)
Subject: Re: [PATCH 3/6] KVM: arm64: Add handling of AArch32 PCMEID{2, 3} PMUv3
 registers
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-4-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <aba855dc-6300-fced-e063-34e5323454a7@redhat.com>
Date: Fri, 15 Jan 2021 14:04:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114105633.2558739-4-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kernel-team@android.com
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

Hi Marc,

On 1/14/21 11:56 AM, Marc Zyngier wrote:
> Despite advertising support for AArch32 PMUv3p1, we fail to handle
> the PMCEID{2,3} registers, which conveniently alias with with the top
s/with with/with
> bits of PMCEID{0,1}_EL1.
> 
> Implement these registers with the usual AA32(HI/LO) aliasing
> mechanism.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/kvm/sys_regs.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ce08d28ab15c..2bea0494b81d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -685,14 +685,18 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 pmceid;
> +	u64 pmceid, mask, shift;
>  
>  	BUG_ON(p->is_write);
>  
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> +	get_access_mask(r, &mask, &shift);
> +
>  	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
> +	pmceid &= mask;
> +	pmceid >>= shift;
>  
>  	p->regval = pmceid;
>  
> @@ -1895,8 +1899,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
> +	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
> +	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
> @@ -1904,6 +1908,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
> +	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 4), access_pmceid },
> +	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 5), access_pmceid },
>  
>  	/* PRRR/MAIR0 */
>  	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
