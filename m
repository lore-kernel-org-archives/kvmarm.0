Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AF3C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 14:34:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D5FF221FE
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 14:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVF+5GoO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D5FF221FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9294BFA6;
	Thu, 26 Nov 2020 09:34:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id riEwcYf-4ppb; Thu, 26 Nov 2020 09:34:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2329C4C067;
	Thu, 26 Nov 2020 09:34:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECFD44C063
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 09:34:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FhCxbNVfXv2X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 09:34:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D88C84BFA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 09:34:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 92B222065E;
 Thu, 26 Nov 2020 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606401247;
 bh=nW1sXw6H/dTIFX6V22eJXB6e4NbOKedFUzjyvGKSLr0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=AVF+5GoOXLlh9O1yo+6ohnxF30UWvY9SJ1zSpeTqhKV2vB2D13tqP4WDCIcT11Fg+
 T7RGhk4R5jcoAUN0XifY1MVP1if9eAYPGaAUm87Q0Yuj4u+tImw79XfH21Q6bhhDZ5
 mWl3lYiZoIeTEq0ZJnfyoXUlh/kwCvkTxEg6Qcm4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiILV-00DpZS-Dr; Thu, 26 Nov 2020 14:34:05 +0000
MIME-Version: 1.0
Date: Thu, 26 Nov 2020 14:34:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/2] KVM: arm64: CSSELR_EL1 max is 13
In-Reply-To: <20201126143200.eezs474ks3xdlnsl@kamzik.brq.redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
 <20201126134641.35231-2-drjones@redhat.com>
 <163d00024402dbb518a6f8d669579bfa@kernel.org>
 <20201126143200.eezs474ks3xdlnsl@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5106d82b42174b86dd62bc9637b2b6a4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-26 14:32, Andrew Jones wrote:
> On Thu, Nov 26, 2020 at 02:13:44PM +0000, Marc Zyngier wrote:
>> On 2020-11-26 13:46, Andrew Jones wrote:
>> > Not counting TnD, which KVM doesn't currently consider, CSSELR_EL1
>> > can have a maximum value of 0b1101 (13), which corresponds to an
>> > instruction cache at level 7. With CSSELR_MAX set to 12 we can
>> > only select up to cache level 6. Change it to 14.
>> >
>> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index c1fac9836af1..ef453f7827fa 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -169,7 +169,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64
>> > val, int reg)
>> >  static u32 cache_levels;
>> >
>> >  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
>> > -#define CSSELR_MAX 12
>> > +#define CSSELR_MAX 14
>> >
>> >  /* Which cache CCSIDR represents depends on CSSELR value. */
>> >  static u32 get_ccsidr(u32 csselr)
>> 
>> Huh, nice catch. Do we need a CC: stable tag for this?
>> 
> 
> Hi Marc,
> 
> I wasn't thinking so, because I'm not expecting there to actually
> be hardware with seven cache levels in the wild any time soon. You
> have more knowledge about what's out there and coming, though, so
> feel free CC stable if needed.

That's actually what I was wondering, whether you had seen that in the
wild already. Since you haven't (and I'm not aware of such a 
monstrosity),
I'll queue it for 5.11.

Do you want me to take the selftest stuff at the same time?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
