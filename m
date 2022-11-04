Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811CAC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 20:47:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA63C41081;
	Fri,  4 Nov 2022 16:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I9f5xYQNtupv; Fri,  4 Nov 2022 16:47:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4354106C;
	Fri,  4 Nov 2022 16:47:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 532FE40FB6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 16:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MbfIa7hF0JTs for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 16:47:26 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00CC340F59
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 16:47:25 -0400 (EDT)
Date: Fri, 4 Nov 2022 20:47:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667594844;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SCB5ELX6zZgbFvMbSeADp4LrffKecUl6OwVcbH2Uzy8=;
 b=fSsh80Ev9RKwyRPXTjPjZnU8OndKbEKKb2oub4IYYNx7/0r0Cl5NPxk7/2oQHRgCEwv50o
 ks3wuR9pOiR7dGF97YOFpa66PwHv7iJ7CIm/sj9Idto43b75OQM2kTtxmGk56r3h2povFz
 toC5JLi8D2aRcFtpZmqyN/ZTcLqeX+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for
 PMUv3p7 and IMP_DEF
Message-ID: <Y2V6WIu40Cg2ShXV@google.com>
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221028105402.2030192-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Fri, Oct 28, 2022 at 11:53:49AM +0100, Marc Zyngier wrote:
> Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

FYI, another pile of ID reg changes is on the way that'll move DFR0 to a
generated definition.

https://lore.kernel.org/linux-arm-kernel/20220930140211.3215348-1-james.morse@arm.com/

--
Thanks,
Oliver

> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 7d301700d1a9..84f59ce1dc6d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -698,6 +698,8 @@
>  #define ID_DFR0_PERFMON_8_1		0x4
>  #define ID_DFR0_PERFMON_8_4		0x5
>  #define ID_DFR0_PERFMON_8_5		0x6
> +#define ID_DFR0_PERFMON_8_7		0x7
> +#define ID_DFR0_PERFMON_IMP_DEF		0xf
>  
>  #define ID_ISAR4_SWP_FRAC_SHIFT		28
>  #define ID_ISAR4_PSR_M_SHIFT		24
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
