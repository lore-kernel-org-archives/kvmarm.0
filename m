Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424D2C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 18:32:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89FAB64EA3
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 18:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89FAB64EA3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 159404B107;
	Mon,  1 Feb 2021 13:32:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fsnHDHigvpHo; Mon,  1 Feb 2021 13:32:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E30A4B0FE;
	Mon,  1 Feb 2021 13:32:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57C074B107
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 13:32:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YbuhecCBlCQi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 13:32:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42F504B0F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 13:32:28 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297C364E3C;
 Mon,  1 Feb 2021 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612204346;
 bh=aw6UMl/5KezkQ6ePwIA2OgzehTIqm/PvcGa5HLSc7RM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UIYtjuYrMYJnisaYscglrtJrY5NnTqDs4gd/oAXQhAwGqdVVV26wgJj57oXG8Dp6C
 E7BBZQJVTuulgZC0xOaP/aGc151+92nph9fqGju8zxChrvdLJSRYLz/FbDBq/tbNYk
 ycRiEGAZsFA61DaRGOJxrYN7+TGOD/gMK/0yJRFk5BXcXD/PGmlUAgk1LdFEwXHuwP
 Sy0YJFcO1gupIQAB7EUaZVMolH5k+MP425Kzb4z7PQ/IzBjtMgGSL1YQIKCAs5zOME
 buU2T2Zr9S/i91ru96Ue6PPvU1gBCqpY7PjX/BQNrUfYqkC3xLK4K6ev0EcIC1v+6K
 Nwaujfwy+ep7A==
Date: Mon, 1 Feb 2021 18:32:20 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 07/26] KVM: arm64: Introduce a BSS section for use
 at Hyp
Message-ID: <20210201183220.GE15632@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-8-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-8-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:05PM +0000, Quentin Perret wrote:
> Currently, the hyp code cannot make full use of a bss, as the kernel
> section is mapped read-only.
> 
> While this mapping could simply be changed to read-write, it would
> intermingle even more the hyp and kernel state than they currently are.
> Instead, introduce a __hyp_bss section, that uses reserved pages, and
> create the appropriate RW hyp mappings during KVM init.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/sections.h |  1 +
>  arch/arm64/kernel/vmlinux.lds.S   |  7 +++++++
>  arch/arm64/kvm/arm.c              | 11 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  1 +
>  4 files changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
> index 8ff579361731..f58cf493de16 100644
> --- a/arch/arm64/include/asm/sections.h
> +++ b/arch/arm64/include/asm/sections.h
> @@ -12,6 +12,7 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
>  extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
>  extern char __hyp_text_start[], __hyp_text_end[];
>  extern char __hyp_data_ro_after_init_start[], __hyp_data_ro_after_init_end[];
> +extern char __hyp_bss_start[], __hyp_bss_end[];
>  extern char __idmap_text_start[], __idmap_text_end[];
>  extern char __initdata_begin[], __initdata_end[];
>  extern char __inittext_begin[], __inittext_end[];
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 43af13968dfd..3eca35d5a7cf 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -8,6 +8,13 @@
>  #define RO_EXCEPTION_TABLE_ALIGN	8
>  #define RUNTIME_DISCARD_EXIT
>  
> +#define BSS_FIRST_SECTIONS				\
> +	. = ALIGN(PAGE_SIZE);				\
> +	__hyp_bss_start = .;				\
> +	*(.hyp.bss)					\

Use HYP_SECTION_NAME() here?

> +	. = ALIGN(PAGE_SIZE);				\
> +	__hyp_bss_end = .;

Should this be gated on CONFIG_KVM like the other hyp sections are? In fact,
it might be nice to define all of those together. Yeah, it means moving
things higher up in the file, but I think it will be easier to read.

>  #include <asm-generic/vmlinux.lds.h>
>  #include <asm/cache.h>
>  #include <asm/hyp_image.h>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3ac0f3425833..51b53ca36dc5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1770,7 +1770,18 @@ static int init_hyp_mode(void)
>  		goto out_err;
>  	}
>  
> +	/*
> +	 * .hyp.bss is placed at the beginning of the .bss section, so map that
> +	 * part RW, and the rest RO as the hyp shouldn't be touching it.
> +	 */
>  	err = create_hyp_mappings(kvm_ksym_ref(__bss_start),

I think it would be clearer to refer to __hyp_bss_start here ^^.
You could always add an ASSERT in the linker script if you want to catch
anybody adding something before the hyp bss in future.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
