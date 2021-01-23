Return-Path: <SRS0=6Z91=G2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A128DC433E0
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:20:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F24D22D75
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F24D22D75
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A152B4B14A;
	Sat, 23 Jan 2021 09:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iAnuykZfx3h3; Sat, 23 Jan 2021 09:20:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AAD74B15A;
	Sat, 23 Jan 2021 09:20:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 867334B14A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:20:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A4QwqDzvIU8C for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jan 2021 09:19:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C5DD4B12D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:19:59 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA3F722D5A;
 Sat, 23 Jan 2021 14:19:55 +0000 (UTC)
Date: Sat, 23 Jan 2021 14:19:53 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 18/21] arm64: Move "nokaslr" over to the early
 cpufeature infrastructure
Message-ID: <YAwwiRF4QnIoPS20@Catalins-MacBook-Air.local>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-19-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-19-maz@kernel.org>
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

On Mon, Jan 18, 2021 at 09:45:30AM +0000, Marc Zyngier wrote:
> Given that the early cpufeature infrastructure has borrowed quite
> a lot of code from the kaslr implementation, let's reimplement
> the matching of the "nokaslr" option with it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/idreg-override.c | 17 ++++++++++++++
>  arch/arm64/kernel/kaslr.c          | 37 +++---------------------------
>  2 files changed, 20 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 1db54878b2c4..143fe7b8e3ce 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -33,8 +33,24 @@ static const struct reg_desc mmfr1 __initdata = {
>  	},
>  };
>  
> +extern u64 kaslr_feature_val;
> +extern u64 kaslr_feature_mask;
> +
> +static const struct reg_desc kaslr __initdata = {
> +	.name		= "kaslr",

We might as well rename this ftr_override or something more generic as
we no longer describe registers here. Otherwise:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
