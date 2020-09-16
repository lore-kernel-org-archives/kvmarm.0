Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D805BC433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 12:39:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38E1E2224E
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 12:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="clfcM+a6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38E1E2224E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 831F94B3B1;
	Wed, 16 Sep 2020 08:39:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dtk5XXv+GP8w; Wed, 16 Sep 2020 08:39:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55BCB4B36E;
	Wed, 16 Sep 2020 08:39:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BD914B2E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 08:39:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vj9JI5Bap9L8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 08:39:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50F604B23A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 08:39:23 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C66EC22225;
 Wed, 16 Sep 2020 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600259962;
 bh=SG4MuQp/zwduxe3VaSSRDORy0X7NqWtWqo77LpwkLVw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=clfcM+a6rpyIvjE9f/xKkFEArCvnhlB83pHLnB4FRf9h/LWBgsDNWuLET6KuYTnlg
 ipu1/I8F0W3MU7Xv6S7hEF6BswSLvz2VZlaBcO+rZHonVu7dRFYKA54uWJ7VdXESG3
 ryxftx2FjhHc+UTLAyC8ogG/hxgTSlN2VjehXuzo=
Date: Wed, 16 Sep 2020 13:39:14 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 00/10] Independent per-CPU data section for nVHE
Message-ID: <20200916123913.GA28056@willie-the-truck>
References: <20200903091712.46456-1-dbrazdil@google.com>
 <20200914174008.GA25238@willie-the-truck>
 <20200916115404.rhv4dkyjz35e4x25@google.com>
 <20200916122412.elxfxbdygvmdgrj5@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916122412.elxfxbdygvmdgrj5@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Sep 16, 2020 at 01:24:12PM +0100, David Brazdil wrote:
> > I was also wondering about another approach - using the PERCPU_SECTION macro
> > unchanged in the hyp linker script. It would lay out a single .data..percpu and
> > we would then prefix it with .hyp and the symbols with __kvm_nvhe_ as with
> > everything else. WDYT? Haven't tried that yet, could be a naive idea. 
> 
> Seems to work. Can't use PERCPU_SECTION directly because then we couldn't
> rename it in the same linker script, but if we just unwrap that one layer
> we can use PERCPU_INPUT. No global macro changes needed.
> 
> Let me know what you think.
> 
> ------8<------
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 5904a4de9f40..9e6bf21268f1 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -195,11 +195,9 @@ SECTIONS
>         PERCPU_SECTION(L1_CACHE_BYTES)
> 
>         /* KVM nVHE per-cpu section */
> -       #undef PERCPU_SECTION_NAME
> -       #undef PERCPU_SYMBOL_NAME
> -       #define PERCPU_SECTION_NAME(suffix)     CONCAT3(.hyp, PERCPU_SECTION_BASE_NAME, suffix)
> -       #define PERCPU_SYMBOL_NAME(name)        __kvm_nvhe_ ## name
> -       PERCPU_SECTION(L1_CACHE_BYTES)
> +       . = ALIGN(PAGE_SIZE);
> +       .hyp.data..percpu : { *(.hyp.data..percpu) }
> +       . = ALIGN(PAGE_SIZE);
> 
>         .rela.dyn : ALIGN(8) {
>                 *(.rela .rela*)
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> index 7d8c3fa004f4..1d8e4f7edc29 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> @@ -4,6 +4,10 @@
>   * Written by David Brazdil <dbrazdil@google.com>
>   */
> 
> +#include <asm-generic/vmlinux.lds.h>
> +#include <asm/cache.h>
> +#include <asm/memory.h>
> +
>  /*
>   * Defines an ELF hyp section from input section @NAME and its subsections.
>   */
> @@ -11,9 +15,9 @@
> 
>  SECTIONS {
>         HYP_SECTION(.text)
> -       HYP_SECTION(.data..percpu)
> -       HYP_SECTION(.data..percpu..first)
> -       HYP_SECTION(.data..percpu..page_aligned)
> -       HYP_SECTION(.data..percpu..read_mostly)
> -       HYP_SECTION(.data..percpu..shared_aligned)
> +
> +       .hyp..data..percpu : {

Too many '.'s here?

> +               __per_cpu_load = .;

I don't think we need this symbol.

Otherwise, idea looks good to me. Can you respin like this, but also
incorporating some of the cleanup in the diff I posted, please?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
