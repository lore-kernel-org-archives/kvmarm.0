Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F37C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 16:57:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C0F04D775;
	Mon, 18 Jul 2022 12:57:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2-Lr2FvmB4qe; Mon, 18 Jul 2022 12:57:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C23C4D780;
	Mon, 18 Jul 2022 12:57:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 206F24D746
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:57:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4fYbFF835JaA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 12:57:31 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFD3B4D6A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:57:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 66CA1B8167E;
 Mon, 18 Jul 2022 16:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113E5C341C0;
 Mon, 18 Jul 2022 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658163448;
 bh=AnJdj+qPEyjwaxmU5ymhWx17b9DtWL91rx0lNbaEJnI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=JPyT0RynILtx2EUQmdMhPkGtYND7f66t4sOqBJzNqUnh932Y3l7aKdSRg8BSsRirV
 nLRrxRu4tZDl0flU0dmGh6/UhxNZUDmjVokIfXd+i77V1d6PEIaTEXtPfFmUInIYdO
 dC8wS4PXMqXygxngpliHXhhxIYEtQpLRkk3afxVmt70C4+Cx1+KW6NaYIe1gOr7FOV
 ifDY8Ge37q2QM/Y6/hToXlMykwUdZqimI5LDnQTpXgRfhH8VHEtfYFFYF5jl9b+XAp
 0OibGdOE+30id4Th0KL0jbwwoQCvYfxFoUxZk0h+HAy5MwwtW9jhmT5AND3VdWszsO
 a9O2fTIZS1LKQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oDU3h-008GnX-MJ;
 Mon, 18 Jul 2022 17:57:25 +0100
MIME-Version: 1.0
Date: Mon, 18 Jul 2022 17:57:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v4 11/18] KVM: arm64: Stub implementation of non-protected
 nVHE HYP stack unwinder
In-Reply-To: <CAC_TJvewAfGACxwZ57W+fDsXOYBNnjxaKUt3Es9Ou0vDO3H_0w@mail.gmail.com>
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-12-kaleshsingh@google.com>
 <877d4a513o.wl-maz@kernel.org>
 <CAC_TJvewAfGACxwZ57W+fDsXOYBNnjxaKUt3Es9Ou0vDO3H_0w@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <54b1c642097af7d290174072bd6e856c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: kaleshsingh@google.com, mark.rutland@arm.com,
 broonie@kernel.org, madvenka@linux.microsoft.com, will@kernel.org,
 qperret@google.com, tabba@google.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 andreyknvl@gmail.com, russell.king@oracle.com, vincenzo.frascino@arm.com,
 mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
 elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org,
 oupton@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 andreyknvl@gmail.com, "Cc:
 Android Kernel" <kernel-team@android.com>, Marco Elver <elver@google.com>,
 Mark Brown <broonie@kernel.org>, "moderated list:ARM64
 PORT \(AARCH64 ARCHITECTURE\)" <linux-arm-kernel@lists.infradead.org>,
 russell.king@oracle.com, LKML <linux-kernel@vger.kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-07-18 17:51, Kalesh Singh wrote:
> On Mon, Jul 18, 2022 at 12:31 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On Fri, 15 Jul 2022 07:10:20 +0100,
>> Kalesh Singh <kaleshsingh@google.com> wrote:
>> >
>> > Add stub implementations of non-protected nVHE stack unwinder, for
>> > building. These are implemented later in this series.
>> >
>> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
>> > ---
>> >  arch/arm64/include/asm/stacktrace/nvhe.h | 22 ++++++++++++++++++++++
>> >  1 file changed, 22 insertions(+)
>> >
>> > diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
>> > index 1eac4e57f2ae..36cf7858ddd8 100644
>> > --- a/arch/arm64/include/asm/stacktrace/nvhe.h
>> > +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
>> > @@ -8,6 +8,12 @@
>> >   *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
>> >   *      buffer where the host can read and print the stacktrace.
>> >   *
>> > + *   2) Non-protected nVHE mode - the host can directly access the
>> > + *      HYP stack pages and unwind the HYP stack in EL1. This saves having
>> > + *      to allocate shared buffers for the host to read the unwinded
>> > + *      stacktrace.
>> > + *
>> > + *
>> >   * Copyright (C) 2022 Google LLC
>> >   */
>> >  #ifndef __ASM_STACKTRACE_NVHE_H
>> > @@ -53,5 +59,21 @@ static int notrace unwind_next(struct unwind_state *state)
>> >  NOKPROBE_SYMBOL(unwind_next);
>> >  #endif       /* CONFIG_PROTECTED_NVHE_STACKTRACE */
>> >
>> > +/*
>> > + * Non-protected nVHE HYP stack unwinder
>> > + */
>> > +#else        /* !__KVM_NVHE_HYPERVISOR__ */
>> 
>> I don't get this path. This either represents the VHE hypervisor or
>> the kernel proper. Which one is it?
> 
> Hi Marc. This is run from kernel proper context. And it's the
> unwinding for conventional nVHE (non-protected). The unwinding is done
> from the host kernel in EL1.

This really deserves a comment here, as the one you currently
have is a bit misleading (and you probably want to move it
below the #else).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
