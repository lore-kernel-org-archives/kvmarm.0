Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEB2C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 11:19:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 040C764FA9
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 11:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 040C764FA9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 805884B3C1;
	Fri,  5 Feb 2021 06:19:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oVEN8R5sCp45; Fri,  5 Feb 2021 06:19:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D3E4B3C4;
	Fri,  5 Feb 2021 06:19:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 961734B3C1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 06:19:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hRIPSc51JeWC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 06:19:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EFF54B3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 06:19:30 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA91164DB2;
 Fri,  5 Feb 2021 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612523969;
 bh=rm+DO8jRG9vXb505ghtG8o6BLLgA2frdzJnefVazWtA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TVK/pTsxIGKrL2Rz+z/51yT19TZeajQ+aLcfVitT1Fqz5q/iMvcQQyu8ESXGfjgqv
 ecxqDKAe9VHSgFoSOogOoqySVc3g5WUTu3Qhngd0P66a/4eroS5CiS96qn6Oi+cPTh
 xOCpwNInjgkQ7Hp5XTXsjGwD342+UMQAslRNTx1KKkaygNZo41zS1uC8vi2AWUKgma
 S3jfqQyd6pu4wKBjeOInrk/2Rs+sygNeh6Dvv7Bqb/Enq8GsotJX3pCY5Cclr8JC0d
 y/E8Mp1XhsE0lqRnqolLBbGfazddNLImalbB55ElDEW1Dd7AQMsvtO07TCKBsRBruz
 /9qyn1GHLifpw==
Date: Fri, 5 Feb 2021 11:19:22 +0000
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v17 1/7] arm/arm64: Probe for the presence of KVM
 hypervisor
Message-ID: <20210205111921.GA22109@willie-the-truck>
References: <20210202141204.3134855-1-maz@kernel.org>
 <20210202141204.3134855-2-maz@kernel.org>
 <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: justin.he@arm.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 richardcochran@gmail.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 Andre.Przywara@arm.com, netdev@vger.kernel.org, john.stultz@linaro.org,
 yangbo.lu@nxp.com, pbonzini@redhat.com, tglx@linutronix.de,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Feb 05, 2021 at 09:11:00AM +0000, Steven Price wrote:
> On 02/02/2021 14:11, Marc Zyngier wrote:
> > diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
> > new file mode 100644
> > index 000000000000..23ce1ded88b4
> > --- /dev/null
> > +++ b/drivers/firmware/smccc/kvm_guest.c
> > @@ -0,0 +1,51 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#define pr_fmt(fmt) "smccc: KVM: " fmt
> > +
> > +#include <linux/init.h>
> > +#include <linux/arm-smccc.h>
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +
> > +static DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) __ro_after_init = { };
> > +
> > +void __init kvm_init_hyp_services(void)
> > +{
> > +	int i;
> > +	struct arm_smccc_res res;
> > +
> > +	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_HVC)
> > +		return;
> > +
> > +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, &res);
> > +	if (res.a0 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 ||
> > +	    res.a1 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 ||
> > +	    res.a2 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 ||
> > +	    res.a3 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3)
> > +		return;
> > +
> > +	memset(&res, 0, sizeof(res));
> > +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, &res);
> > +	for (i = 0; i < 32; ++i) {
> > +		if (res.a0 & (i))
> > +			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> > +		if (res.a1 & (i))
> > +			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> > +		if (res.a2 & (i))
> > +			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> > +		if (res.a3 & (i))
> > +			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> 
> The bit shifts are missing, the tests should be of the form:
> 
> 	if (res.a0 & (1 << i))
> 
> Or indeed using a BIT() macro.

Maybe even test_bit()?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
