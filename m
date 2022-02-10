Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E568C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 11:39:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 858EA49ED9;
	Thu, 10 Feb 2022 06:39:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iWd4N08Ksx5j; Thu, 10 Feb 2022 06:39:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D27549EF2;
	Thu, 10 Feb 2022 06:39:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE63949E36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 06:39:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 25msry6F3J8x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 06:39:11 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69DD640FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 06:39:11 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 334F761D02;
 Thu, 10 Feb 2022 11:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A8CC004E1;
 Thu, 10 Feb 2022 11:39:06 +0000 (UTC)
Date: Thu, 10 Feb 2022 11:39:03 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 03/40] arm64: cpufeature: Always specify and use a
 field width for capabilities
Message-ID: <YgT5Vxej8zW3zTyY@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-4-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-4-broonie@kernel.org>
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

On Mon, Feb 07, 2022 at 03:20:32PM +0000, Mark Brown wrote:
> Since all the fields in the main ID registers are 4 bits wide we have up
> until now not bothered specifying the width in the code. Since we now
> wish to use this mechanism to enumerate features from the floating point
> feature registers which do not follow this pattern add a width to the
> table.  This means updating all the existing table entries but makes it
> less likely that we run into issues in future due to implicitly assuming
> a 4 bit width.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |   1 +
>  arch/arm64/kernel/cpufeature.c      | 167 +++++++++++++++++-----------
>  2 files changed, 102 insertions(+), 66 deletions(-)

I know it's a positive diffstat but I prefer being explicit with the
field width. So:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
