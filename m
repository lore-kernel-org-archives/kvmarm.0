Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A855CC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 17:08:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A4549F38;
	Wed,  2 Mar 2022 12:08:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vjoLBVjk8AfL; Wed,  2 Mar 2022 12:07:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBAC249F1C;
	Wed,  2 Mar 2022 12:07:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0464E49F1C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:07:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0C844l+cthgN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:07:55 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C356849F0E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:07:55 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DD7D961959;
 Wed,  2 Mar 2022 17:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD7C004E1;
 Wed,  2 Mar 2022 17:07:51 +0000 (UTC)
Date: Wed, 2 Mar 2022 17:07:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 18/40] arm64/sme: Implement traps and syscall
 handling for SME
Message-ID: <Yh+kY7/oP8XDQ9yn@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-19-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220225165923.1474372-19-broonie@kernel.org>
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

On Fri, Feb 25, 2022 at 04:59:01PM +0000, Mark Brown wrote:
> By default all SME operations in userspace will trap.  When this happens
> we allocate storage space for the SME register state, set up the SVE
> registers and disable traps.  We do not need to initialize ZA since the
> architecture guarantees that it will be zeroed when enabled and when we
> trap ZA is disabled.
> 
> On syscall we exit streaming mode if we were previously in it and ensure
> that all but the lower 128 bits of the registers are zeroed while
> preserving the state of ZA. This follows the aarch64 PCS for SME, ZA
> state is preserved over a function call and streaming mode is exited.
> Since the traps for SME do not distinguish between streaming mode SVE
> and ZA usage if ZA is in use rather than reenabling traps we instead
> zero the parts of the SVE registers not shared with FPSIMD and leave SME
> enabled, this simplifies handling SME traps. If ZA is not in use then we
> reenable SME traps and fall through to normal handling of SVE.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
