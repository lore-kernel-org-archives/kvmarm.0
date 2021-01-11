Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48102C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 18:42:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99DDE22A83
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 18:42:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99DDE22A83
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC37C4B22A;
	Mon, 11 Jan 2021 13:42:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id In3X4lFvRCjT; Mon, 11 Jan 2021 13:42:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C594B2A9;
	Mon, 11 Jan 2021 13:42:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC614B230
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 13:42:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4zJPvW7Cktm2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 13:42:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A55944B22A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 13:42:01 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65CE22251F;
 Mon, 11 Jan 2021 18:41:57 +0000 (UTC)
Date: Mon, 11 Jan 2021 18:41:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
Message-ID: <20210111184154.GC17941@gaia>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210111132811.2455113-10-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

Hi Marc,

On Mon, Jan 11, 2021 at 01:27:59PM +0000, Marc Zyngier wrote:
> Add a facility to globally override a feature, no matter what
> the HW says. Yes, this is dangerous.

Yeah, it's dangerous. We can make it less so if we only allow safe
values (e.g. lower if FTR_UNSIGNED).

> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 9a555809b89c..465d2cb63bfc 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -75,6 +75,8 @@ struct arm64_ftr_reg {
>  	u64				sys_val;
>  	u64				user_val;
>  	const struct arm64_ftr_bits	*ftr_bits;
> +	u64				*override_val;
> +	u64				*override_mask;
>  };

At the arm64_ftr_reg level, we don't have any information about the safe
values for a feature. Could we instead move this to arm64_ftr_bits? We
probably only need a single field. When populating the feature values,
we can make sure it doesn't go above the hardware one.

I attempted a feature modification for MTE here, though I dropped the
entire series in the meantime as we clarified the ARM ARM:

https://lore.kernel.org/linux-arm-kernel/20200515171612.1020-24-catalin.marinas@arm.com/

Srinivas copied it in his patch (but forgot to give credit ;)):

https://lore.kernel.org/linux-arm-msm/1610152163-16554-3-git-send-email-sramana@codeaurora.org/

The above adds a filter function but, instead, just use your mechanism in
this series for idreg.feature setting via cmdline. The arm64_ftr_value()
function extracts the hardware value and lowers it if a cmdline argument
was passed.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
