Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D994C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 18:32:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 637C449F48;
	Thu, 10 Feb 2022 13:32:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id swJeDfK7zSAG; Thu, 10 Feb 2022 13:32:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBAF49F0A;
	Thu, 10 Feb 2022 13:32:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86BEC49F0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 13:32:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id umXhKsm6aVhY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 13:32:55 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12C1B49EEA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 13:32:55 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 276A861E69;
 Thu, 10 Feb 2022 18:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A94C004E1;
 Thu, 10 Feb 2022 18:32:50 +0000 (UTC)
Date: Thu, 10 Feb 2022 18:32:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YgVaTounTtunlGU6@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-7-broonie@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On Mon, Feb 07, 2022 at 03:20:35PM +0000, Mark Brown wrote:
> diff --git a/Documentation/arm64/sme.rst b/Documentation/arm64/sme.rst
> new file mode 100644
> index 000000000000..15df3157c592
> --- /dev/null
> +++ b/Documentation/arm64/sme.rst
[...]
> +3.  Sharing of streaming and non-streaming mode SVE state
> +---------------------------------------------------------
> +
> +It is implementation defined which if any parts of the SVE state are shared
> +between streaming and non-streaming modes.  When switching between modes
> +via software interfaces such as ptrace if no register content is provided as
> +part of switching no state will be assumed to be shared and everything will
> +be zeroed.

Is there anything other than ptrace() here? I read the sigreturn() case
below but did not say anything about changing PSTATE.SM via the
sigcontext. I guess it's similar to ptrace().

> +4.  System call behaviour
> +-------------------------
> +
> +* On syscall PSTATE.ZA is preserved, if PSTATE.ZA==1 then the contents of the
> +  ZA matrix are preserved.

Sorry if this was discussed. What is the rationale for preserving the ZA
registers on syscall? We don't do this for the top part of the Z
registers.

> +* On syscall PSTATE.SM will be cleared and the SVE registers will be handled
> +  as normal.

What does that mean? Is this as per the sve.rst doc (unspecified but
zeroed in practice)?

> +* Neither the SVE registers nor ZA are used to pass arguments to or receive
> +  results from any syscall.
> +
> +* On creation fork() or clone() the newly created process will have PSTATE.SM
> +  and PSTATE.ZA cleared.

This looks slightly inconsistent with the first bullet point on ZA being
preserved on syscalls. Why do these differ?

[...]
> +References
> +==========
> +
> +[1] arch/arm64/include/uapi/asm/sigcontext.h
> +    AArch64 Linux signal ABI definitions
> +
> +[2] arch/arm64/include/uapi/asm/ptrace.h
> +    AArch64 Linux ptrace ABI definitions
> +
> +[3] Documentation/arm64/cpu-feature-registers.rst
> +
> +[4] ARM IHI0055C
> +    http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055c/IHI0055C_beta_aapcs64.pdf
> +    http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
> +    Procedure Call Standard for the ARM 64-bit Architecture (AArch64)

The second link no longer works. I also couldn't find any reference to
[4] but there's a lot of text to scan, so I may have missed it.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
