Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CED5C76191
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 03:31:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1BF62171F
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 03:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOmSYmFw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1BF62171F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B9564A53E;
	Mon, 15 Jul 2019 23:31:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZhEyBpQPSYzG; Mon, 15 Jul 2019 23:31:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B8F4A4E6;
	Mon, 15 Jul 2019 23:31:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D362B4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 23:31:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mqB8I3XalBSp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jul 2019 23:31:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E9C24A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 23:31:42 -0400 (EDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1AA532171F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 03:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1563247901;
 bh=nkLC7Do/0/ASx+htK3W0deCY/L7u52YvatK3PThzs1o=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=bOmSYmFwgJoFlxLXY0jcxork4cP46Hw0+GSfRe0St3ZR0NPWSU7OH04NHQzXB8AVq
 xC5enZlHYqatS/fVlSf/0vI5R8YiIYDxKt7mnew6O4KX/QKodKFpVFFPEwBC7jUGlV
 iUvYO2H5sEaclssF++r91+dLjJklm/J0ax/BT9Ms=
Received: by mail-wm1-f46.google.com with SMTP id a15so17071893wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 20:31:41 -0700 (PDT)
X-Gm-Message-State: APjAAAW8MJTW5++lPdFm2RBIFTBIxnNbzu3qOlFwHI+g/1jB9xmyJOh+
 wp6gbR8TAmogm8BroAy5KniNyR+7xpt6zYNqU38=
X-Google-Smtp-Source: APXvYqyPa5rP95ycs6b3WYMG+EzG85EsRWTZkZHjobdrhwBuzs6W/qfB+TTyLjN39USlTZAaWUOIcPqk90kThcB1O2E=
X-Received: by 2002:a7b:c212:: with SMTP id x18mr26821859wmi.77.1563247899662; 
 Mon, 15 Jul 2019 20:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
 <20190621141606.GF18954@arrakis.emea.arm.com>
 <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
 <20190624153820.GH29120@arrakis.emea.arm.com>
 <CAJF2gTRUzHUNV+nzECUp5n2L1akdy=Aovb6tSd+PNVnpasBrqw@mail.gmail.com>
 <20190701091711.GA21774@arrakis.emea.arm.com>
In-Reply-To: <20190701091711.GA21774@arrakis.emea.arm.com>
From: Guo Ren <guoren@kernel.org>
Date: Tue, 16 Jul 2019 11:31:27 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTEbhA-pZCPGuUNqXT9F-vk8fSTyNJyEOpn=QE=toAN3g@mail.gmail.com>
Message-ID: <CAJF2gTTEbhA-pZCPGuUNqXT9F-vk8fSTyNJyEOpn=QE=toAN3g@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: aou@eecs.berkeley.edu, Marc Zyngier <marc.zyngier@arm.com>,
 Anup Patel <anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-csky@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish Patra <Atish.Patra@wdc.com>, Julien Grall <julien.grall@arm.com>,
 Palmer Dabbelt <palmer@sifive.com>, gary@garyguo.net, paul.walmsley@sifive.com,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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

Hello Catalin,

Thanks for sharing about CnP assid experience. See my comment below.

On Mon, Jul 1, 2019 at 5:17 PM Catalin Marinas
> From the ASID reservation/allocation perspective, the mechanism is the
> same between multi-threaded with a shared TLB and multi-core. On arm64,
> a local_flush_tlb_all() on a thread invalidates the TLB for the other
> threads of the same core.
>
> The actual problem with multi-threaded CPUs is a lot more subtle.
> Digging some internal email from 1.5 years ago and pasting it below
> (where "current ASID algorithm" refers to the one prior to the fix and
> CnP - Common Not Private - means shared TLBs on a multi-threaded CPU):
>
>
> The current ASID roll-over algorithm allows for a small window where
> active_asids for a CPU (P1) is different from the actual ASID in TTBR0.
> This can lead to a roll-over on a different CPU (P2) allocating an ASID
> (for a different task) which is still hardware-active on P1.
>
> A TLBI on a CPU (or a peer CPU with CnP) does not guarantee that all the
> entries corresponding to a valid TTBRx are removed as they can still be
> speculatively loaded immediately after TLBI.
>
> While having two different page tables with the same ASID on different
> CPUs should be fine without CnP, it becomes problematic when CnP is
> enabled:
>
> P1                                      P2
> --                                      --
> TTBR0.BADDR = T1
> TTBR0.ASID = A1
> check_and_switch_context(T2,A2)
>   asid_maps[P1] = A2
>   goto fastpath
>                                         check_and_switch_context(T3,A0)
>                                           new_context
>                                             ASID roll-over allocates A1
>                                               since it is not active
>                                           TLBI ALL
> speculate TTBR0.ASID = A1 entry
>                                           TTBR0.BADDR = T3
>                                           TTBR0.ASID = A1
>   TTBR0.BADDR = T2
>   TTBR0.ASID = A2
>
> After this, the common TLB on P1 and P2 (CnP) contains entries
> corresponding to the old T1 and A1. Task T3 using the same ASID A1 can
> hit such entries. (T1,A1) will eventually be removed from the TLB on the
> next context switch on P1 since tlb_flush_pending was set but this is
> not guaranteed to happen.
>
>
> The fix on arm64 (as part of 5ffdfaedfa0a - "arm64: mm: Support Common
> Not Private translations") was to set the reserved TTBR0 in
> check_and_switch_context(), preventing speculative loads into the TLB
> being tagged with the wrong ASID. So this is specific to the ARM CPUs
> behaviour w.r.t. speculative TLB loads, it may not be the case (yet) for
> your architecture.

The most important thing is that TLBI ALL occurs between
"asid_maps[P1] = A2" and "TTBR0.BADDR = T2", then speculative
execution after TLBI which access to user space code/data will result
in a valid asid entry which re-filled into the TLB by PTW.

A similar problem should exist if C-SKY ISA supports SMT. Although the
C-SKY kernel prohibits the kernel from speculating on user space code
directly, ld/st can access user space memory in csky kernel mode.
Therefore, a similar problem occurs when it speculatively executes
copy_from / to_user codes in that window.

RISC-V ISA has a SUM setting bit that prevents the kernel from
speculating access to user space. So this problem has been bypassed
from the design.

I saw arm64 to prevent speculation by temporarily setting TTBR0.el1 to
a zero page table. Is that used to prevent speculative execution user
space code or just prevent ld/st in copy_use_* ?

-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
