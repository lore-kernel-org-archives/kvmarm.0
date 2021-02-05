Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87BAC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 17:00:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F14964F2D
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 17:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F14964F2D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94BFD4B458;
	Fri,  5 Feb 2021 12:00:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p0-89MBc4p6c; Fri,  5 Feb 2021 12:00:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DB794B44A;
	Fri,  5 Feb 2021 12:00:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7ABA4B422
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 12:00:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rw32i8E694uA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 12:00:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F5D14B3BD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 12:00:14 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A7564F2C;
 Fri,  5 Feb 2021 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612544413;
 bh=bYsyypHJHkCDMPq/yGSFgDLzazYUpF+GyWHhaLu3g4k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=b1jCslKGu5syM6wrgfzO+JQED3kse4raQl0d6FfhlQitKk+PIqGWsucshvT5xTTDT
 pFgPhLBLy0lnyOoljOXKrQtVRJRYMQY0OAWwFJk+4+Fp8+fCoMCCz8RiNq/7A8GvwT
 scyQNLe4GsQOdJx6RRmimhK+Iv6oHqD20IyhZq7qoah7ToC4DQ5H24blnfQCoo6qxA
 zJ3fFY25tCWmIi2HnxEzY5JqdsQbVmqld1lGesBnu1pP5ENmCt4t4tE0NUWf9f2GbF
 qS492rMyHch6HYBMm9czMXIuew2DqXpXu5d/HH0b2PJ6rjESiv0gM/XUS4YUwFRLvT
 9NXR0ve6CzKgw==
Date: Fri, 5 Feb 2021 17:00:06 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v17 1/7] arm/arm64: Probe for the presence of KVM
 hypervisor
Message-ID: <20210205170005.GC22665@willie-the-truck>
References: <20210202141204.3134855-1-maz@kernel.org>
 <20210202141204.3134855-2-maz@kernel.org>
 <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
 <20210205111921.GA22109@willie-the-truck>
 <e2eefee823f6a8e448f6d477cef315d4@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e2eefee823f6a8e448f6d477cef315d4@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Andre.Przywara@arm.com,
 john.stultz@linaro.org, yangbo.lu@nxp.com, pbonzini@redhat.com,
 tglx@linutronix.de, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Feb 05, 2021 at 04:50:27PM +0000, Marc Zyngier wrote:
> On 2021-02-05 11:19, Will Deacon wrote:
> > On Fri, Feb 05, 2021 at 09:11:00AM +0000, Steven Price wrote:
> > > On 02/02/2021 14:11, Marc Zyngier wrote:
> > > > +	for (i = 0; i < 32; ++i) {
> > > > +		if (res.a0 & (i))
> > > > +			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> > > > +		if (res.a1 & (i))
> > > > +			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> > > > +		if (res.a2 & (i))
> > > > +			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> > > > +		if (res.a3 & (i))
> > > > +			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> > > 
> > > The bit shifts are missing, the tests should be of the form:
> > > 
> > > 	if (res.a0 & (1 << i))
> > > 
> > > Or indeed using a BIT() macro.
> > 
> > Maybe even test_bit()?
> 
> Actually, maybe not doing things a-bit-at-a-time is less error prone.
> See below what I intend to fold in.
> 
> Thanks,
> 
>         M.
> 
> diff --git a/drivers/firmware/smccc/kvm_guest.c
> b/drivers/firmware/smccc/kvm_guest.c
> index 00bf3c7969fc..08836f2f39ee 100644
> --- a/drivers/firmware/smccc/kvm_guest.c
> +++ b/drivers/firmware/smccc/kvm_guest.c
> @@ -2,8 +2,8 @@
> 
>  #define pr_fmt(fmt) "smccc: KVM: " fmt
> 
> -#include <linux/init.h>
>  #include <linux/arm-smccc.h>
> +#include <linux/bitmap.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> 
> @@ -13,8 +13,8 @@ static DECLARE_BITMAP(__kvm_arm_hyp_services,
> ARM_SMCCC_KVM_NUM_FUNCS) __ro_afte
> 
>  void __init kvm_init_hyp_services(void)
>  {
> -	int i;
>  	struct arm_smccc_res res;
> +	u32 val[4];
> 
>  	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_HVC)
>  		return;
> @@ -28,16 +28,13 @@ void __init kvm_init_hyp_services(void)
> 
>  	memset(&res, 0, sizeof(res));
>  	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, &res);
> -	for (i = 0; i < 32; ++i) {
> -		if (res.a0 & (i))
> -			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> -		if (res.a1 & (i))
> -			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> -		if (res.a2 & (i))
> -			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> -		if (res.a3 & (i))
> -			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> -	}
> +
> +	val[0] = lower_32_bits(res.a0);
> +	val[1] = lower_32_bits(res.a1);
> +	val[2] = lower_32_bits(res.a2);
> +	val[3] = lower_32_bits(res.a3);
> +
> +	bitmap_from_arr32(__kvm_arm_hyp_services, val, ARM_SMCCC_KVM_NUM_FUNCS);

Nice! That's loads better.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
