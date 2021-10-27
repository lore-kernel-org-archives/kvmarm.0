Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AB5C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:46:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 45E7F610C7
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 45E7F610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B498F4B11F;
	Wed, 27 Oct 2021 03:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AzG35vAo59H4; Wed, 27 Oct 2021 03:46:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 500F64B0B9;
	Wed, 27 Oct 2021 03:46:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82FCF4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 03:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3obpcddqozs2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 03:46:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EDAE4B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 03:46:47 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 50601610A4;
 Wed, 27 Oct 2021 07:46:46 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mfde0-001qv7-6d; Wed, 27 Oct 2021 08:46:44 +0100
MIME-Version: 1.0
Date: Wed, 27 Oct 2021 08:46:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH] KVM: arm64: Remove unused TRNG_NO_ENTROPY
In-Reply-To: <20211026210913.57006-1-quic_qiancai@quicinc.com>
References: <20211026210913.57006-1-quic_qiancai@quicinc.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <3fac8ddb626205286f79adde96ea527b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: quic_qiancai@quicinc.com, james.morse@arm.com,
 ardb@kernel.org, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-10-26 22:09, Qian Cai wrote:
> TRNG_NO_ENTROPY was unused when introduced and now. This is also caught 
> by
> GCC (W=2):
> 
> arch/arm64/kvm/trng.c:17: warning: macro "TRNG_NO_ENTROPY" is not used
> [-Wunused-macros]
>    17 | #define TRNG_NO_ENTROPY   ((unsigned long)-3)
> 
> Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
> ---
>  arch/arm64/kvm/trng.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
> index 99bdd7103c9c..6a46b3ac3970 100644
> --- a/arch/arm64/kvm/trng.c
> +++ b/arch/arm64/kvm/trng.c
> @@ -14,7 +14,6 @@
>  #define TRNG_SUCCESS			0UL
>  #define TRNG_NOT_SUPPORTED		((unsigned long)-1)
>  #define TRNG_INVALID_PARAMETER		((unsigned long)-2)
> -#define TRNG_NO_ENTROPY			((unsigned long)-3)
> 
>  #define TRNG_MAX_BITS64			192

That's an architectural definition that doesn't cause any problem.
If anything, that's documentation.

We have *tons* of other definitions with no user all over the
arm64 code. They save the exact same purpose.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
