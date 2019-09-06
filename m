Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD81C43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 06:30:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 598452082C
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 06:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 598452082C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B0C24A551;
	Fri,  6 Sep 2019 02:30:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xs0ZHWYwi5HV; Fri,  6 Sep 2019 02:30:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E5A4A55F;
	Fri,  6 Sep 2019 02:30:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3EB4A55F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 02:30:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SPnP9exazRbU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 02:30:07 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A4284A551
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 02:30:07 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 6BADE87521E;
 Fri,  6 Sep 2019 06:30:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 297944106;
 Fri,  6 Sep 2019 06:30:05 +0000 (UTC)
Date: Fri, 6 Sep 2019 08:30:02 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvm-unit-tests] arm: prevent compiler from using
 unaligned accesses
Message-ID: <20190906063002.xiterzugydfycrlu@kamzik.brq.redhat.com>
References: <20190905171502.215183-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190905171502.215183-1-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.68]); Fri, 06 Sep 2019 06:30:06 +0000 (UTC)
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Thu, Sep 05, 2019 at 06:15:02PM +0100, Andre Przywara wrote:
> The ARM architecture requires all accesses to device memory to be
> naturally aligned[1][2]. Normal memory does not have this strict
> requirement, and in fact many systems do ignore unaligned accesses
> (by the means of clearing the A bit in SCTLR and accessing normal
> memory). So the default behaviour of GCC assumes that unaligned accesses
> are fine, at least if happening on the stack.
> 
> Now kvm-unit-tests runs some C code with the MMU off, which degrades the
> whole system memory to device memory. Now every unaligned access will
> fault, regardless of the A bit.
> In fact there is at least one place in lib/printf.c where GCC merges
> two consecutive char* accesses into one "strh" instruction, writing to
> a potentially unaligned address.
> This can be reproduced by configuring kvm-unit-tests for kvmtool, but
> running it on QEMU, which triggers an early printf that exercises this
> particular code path.
> 
> Add the -mstrict-align compiler option to the arm64 CFLAGS to fix this
> problem. Also add the respective -mno-unaligned-access flag for arm.
> 
> Thanks to Alexandru for helping debugging this.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> [1] ARMv8 ARM DDI 0487E.a, B2.5.2
> [2] ARMv7 ARM DDI 0406C.d, A3.2.1
> ---
>  arm/Makefile.arm   | 1 +
>  arm/Makefile.arm64 | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index a625267..43b4be1 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -12,6 +12,7 @@ KEEP_FRAME_POINTER := y
>  
>  CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
> +CFLAGS += -mno-unaligned-access
>  
>  arch_LDFLAGS = -Ttext=40010000
>  
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 02c24e8..35de5ea 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -7,6 +7,7 @@ bits = 64
>  ldarch = elf64-littleaarch64
>  
>  arch_LDFLAGS = -pie -n
> +CFLAGS += -mstrict-align
>  
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
