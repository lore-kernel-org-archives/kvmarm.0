Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85701C47082
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 19:28:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF8AB610E7
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 19:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF8AB610E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB2840878;
	Mon,  7 Jun 2021 15:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id khguDEOWTKlX; Mon,  7 Jun 2021 15:28:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 379C5407F1;
	Mon,  7 Jun 2021 15:28:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1778407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 15:28:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SjBJ7NkrGoqA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 15:28:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A10514018F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 15:28:25 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53433610E7;
 Mon,  7 Jun 2021 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1623094104;
 bh=LgMVcXHCCZU1jYKLjL4s5tdikm1++Ag5rp8bnWWw3lE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=g/tE2FBq7fiZ7DeyFtkCLJgQkpMjzxLkRQjgPuKLy5ypbUnd25TCSPOrsAVFYPXOE
 5tCsqbGyEn5D2Ui856zBHz0kh1PacpRxrFlpYpTcY2KSwWHewJNH3ffXWyu6TYuzFl
 YatR/862y2R+Qmj8R9Kiou+zGCJXfHsFx2490HUHCrGqTv8OEpXfSzJjGZIHzZEACt
 K7Tw0F0i8ZYTgh6ARZ9b+tX41CtivZqpI9SdJQVmNf9UBb1fWp8u7PHXQA9XvpptaM
 Dtv95JMfcK/BBjx/Woi+DnMMAu954VAV/pyucIzW7JA8rLz+FUCY+6pPu8t/1RMl1l
 cYqHZYN/buthw==
Date: Mon, 7 Jun 2021 20:28:18 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Ignore 'kvm-arm.mode=protected' when
 using VHE
Message-ID: <20210607192818.GA7929@willie-the-truck>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-2-will@kernel.org>
 <20210604140117.GA69333@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210604140117.GA69333@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jun 04, 2021 at 03:01:17PM +0100, Mark Rutland wrote:
> On Thu, Jun 03, 2021 at 07:33:44PM +0100, Will Deacon wrote:
> > Ignore 'kvm-arm.mode=protected' when using VHE so that kvm_get_mode()
> > only returns KVM_MODE_PROTECTED on systems where the feature is available.
> 
> IIUC, since the introduction of the idreg-override code, and the
> mutate_to_vhe stuff, passing 'kvm-arm.mode=protected' should make the
> kernel stick to EL1, right? So this should only affect M1 (or other HW
> with a similar impediment).

It's not just about the M1, unfortunately. You can boot with:

	"kvm-arm.mode=protected id_aa64mmfr1.vh=1"

which will force VHE mode, so we should fail protected mode in that case.

> One minor comment below; otherwise:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks, I'll keep the tag but please yell if you want me to drop it.

> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index efed2830d141..dc1f2e747828 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -1773,15 +1773,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
> >  #ifdef CONFIG_KVM
> >  static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
> >  {
> > -	if (kvm_get_mode() != KVM_MODE_PROTECTED)
> > -		return false;
> > -
> > -	if (is_kernel_in_hyp_mode()) {
> > -		pr_warn("Protected KVM not available with VHE\n");
> > -		return false;
> > -	}
> > -
> > -	return true;
> > +	return kvm_get_mode() == KVM_MODE_PROTECTED;
> >  }
> >  #endif /* CONFIG_KVM */
> >  
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 1cb39c0803a4..8d5e23198dfd 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2121,7 +2121,11 @@ static int __init early_kvm_mode_cfg(char *arg)
> >  		return -EINVAL;
> >  
> >  	if (strcmp(arg, "protected") == 0) {
> > -		kvm_mode = KVM_MODE_PROTECTED;
> > +		if (!is_kernel_in_hyp_mode())
> > +			kvm_mode = KVM_MODE_PROTECTED;
> > +		else
> > +			pr_warn_once("Protected KVM not available with VHE\n");
> 
> ... assuming this is only for M1, it might be better to say:
> 
> 	Protected KVM not available on this hardware
> 
> ... since that doesn't suggest that other VHE-capable HW is also not
> PKVM-capable.

I'm just moving the existing string here, but as above, it's not M1
specific.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
