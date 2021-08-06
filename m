Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A6BC4338F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:59:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D50F61163
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D50F61163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B25244A1FA;
	Fri,  6 Aug 2021 07:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IVzPIsKt9rjO; Fri,  6 Aug 2021 07:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B3C4B0D2;
	Fri,  6 Aug 2021 07:59:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A024A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:59:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I1T7fataPWym for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 07:59:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DD2D49E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:59:33 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E754610FF;
 Fri,  6 Aug 2021 11:59:30 +0000 (UTC)
Date: Fri, 6 Aug 2021 12:59:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/4] arm64: mm: Fix TLBI vs ASID rollover
Message-ID: <20210806115927.GJ6719@arm.com>
References: <20210806113109.2475-1-will@kernel.org>
 <20210806113109.2475-2-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210806113109.2475-2-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arch@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 stable@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jade Alglave <jade.alglave@arm.com>
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

On Fri, Aug 06, 2021 at 12:31:04PM +0100, Will Deacon wrote:
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index 75beffe2ee8a..e9c30859f80c 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -27,11 +27,32 @@ typedef struct {
>  } mm_context_t;
>  
>  /*
> - * This macro is only used by the TLBI and low-level switch_mm() code,
> - * neither of which can race with an ASID change. We therefore don't
> - * need to reload the counter using atomic64_read().
> + * We use atomic64_read() here because the ASID for an 'mm_struct' can
> + * be reallocated when scheduling one of its threads following a
> + * rollover event (see new_context() and flush_context()). In this case,
> + * a concurrent TLBI (e.g. via try_to_unmap_one() and ptep_clear_flush())
> + * may use a stale ASID. This is fine in principle as the new ASID is
> + * guaranteed to be clean in the TLB, but the TLBI routines have to take
> + * care to handle the following race:
> + *
> + *    CPU 0                    CPU 1                          CPU 2
> + *
> + *    // ptep_clear_flush(mm)
> + *    xchg_relaxed(pte, 0)
> + *    DSB ISHST
> + *    old = ASID(mm)

We'd need specs clarified (ARM ARM, cat model) that the DSB ISHST is
sufficient to order the pte write with the subsequent ASID read.
Otherwise the patch looks fine to me:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
