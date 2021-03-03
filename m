Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEF4C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 17:32:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C66964EE4
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 17:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C66964EE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E8044B4BC;
	Wed,  3 Mar 2021 12:32:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3G2PEsRR6tOe; Wed,  3 Mar 2021 12:32:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B71AB4B4D4;
	Wed,  3 Mar 2021 12:32:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B384B3AD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 12:32:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ARfCXMKqOaD2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 12:32:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23ED74B3A9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 12:32:40 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFF7A31B;
 Wed,  3 Mar 2021 09:32:39 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6C2C3F7D7;
 Wed,  3 Mar 2021 09:32:38 -0800 (PST)
Date: Wed, 3 Mar 2021 17:32:34 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] lib: arm64: Consolidate register
 definitions to sysreg.h
Message-ID: <20210303173234.6d6cec51@slackpad.fritz.box>
In-Reply-To: <20210227104201.14403-5-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
 <20210227104201.14403-5-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Sat, 27 Feb 2021 10:41:59 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Move system register field definitions to sysreg.h, where the opcodes for
> system register access are defined, to align ourselves with the Linux
> kernel. EL2 support, needed for EFI and nested virtualization testing, will
> require additional register and field definions, and having them in the
> same place as Linux will make maintenance easier.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Checked to be just moves, and it compiles, so:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm64/asm/arch_gicv3.h |  6 ------
>  lib/arm64/asm/processor.h  | 10 ----------
>  lib/arm64/asm/sysreg.h     | 17 +++++++++++++++++
>  arm/cstart64.S             |  2 +-
>  4 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
> index a7994ec2fbbe..fdee4de1f1f6 100644
> --- a/lib/arm64/asm/arch_gicv3.h
> +++ b/lib/arm64/asm/arch_gicv3.h
> @@ -10,12 +10,6 @@
>  
>  #include <asm/sysreg.h>
>  
> -#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> -#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> -#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> -#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> -#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
> -
>  #ifndef __ASSEMBLY__
>  
>  #include <libcflat.h>
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index cdc2463e1981..4a3d826ab560 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -6,16 +6,6 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  
> -/* System Control Register (SCTLR_EL1) bits */
> -#define SCTLR_EL1_EE	(1 << 25)
> -#define SCTLR_EL1_WXN	(1 << 19)
> -#define SCTLR_EL1_I	(1 << 12)
> -#define SCTLR_EL1_SA0	(1 << 4)
> -#define SCTLR_EL1_SA	(1 << 3)
> -#define SCTLR_EL1_C	(1 << 2)
> -#define SCTLR_EL1_A	(1 << 1)
> -#define SCTLR_EL1_M	(1 << 0)
> -
>  #ifndef __ASSEMBLY__
>  #include <asm/ptrace.h>
>  #include <asm/esr.h>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 378bf7ebb3b5..9d6b4fc66936 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -70,4 +70,21 @@ asm(
>  "	.endm\n"
>  );
>  #endif /* __ASSEMBLY__ */
> +
> +#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> +#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> +#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> +#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> +#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
> +
> +/* System Control Register (SCTLR_EL1) bits */
> +#define SCTLR_EL1_EE	(1 << 25)
> +#define SCTLR_EL1_WXN	(1 << 19)
> +#define SCTLR_EL1_I	(1 << 12)
> +#define SCTLR_EL1_SA0	(1 << 4)
> +#define SCTLR_EL1_SA	(1 << 3)
> +#define SCTLR_EL1_C	(1 << 2)
> +#define SCTLR_EL1_A	(1 << 1)
> +#define SCTLR_EL1_M	(1 << 0)
> +
>  #endif /* _ASMARM64_SYSREG_H_ */
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index c1deff842f03..f6c5d2ebccf3 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -10,9 +10,9 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/assembler.h>
>  #include <asm/ptrace.h>
> -#include <asm/processor.h>
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
> +#include <asm/sysreg.h>
>  
>  .section .init
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
