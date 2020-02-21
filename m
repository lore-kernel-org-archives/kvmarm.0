Return-Path: <SRS0=c+b0=4J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9B1C35647
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 13:13:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68C8124672
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 13:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZ6R6LUl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68C8124672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A194AEB2;
	Fri, 21 Feb 2020 08:13:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zuv4swWHO6ej; Fri, 21 Feb 2020 08:13:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC0C34AEBF;
	Fri, 21 Feb 2020 08:13:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F2C4AEA0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 08:13:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z5hGd3zG6Bri for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Feb 2020 08:13:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 929F54AC84
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 08:13:34 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EEB072073A;
 Fri, 21 Feb 2020 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582290813;
 bh=p18h0RDqSU6qOTnFj4Oou+CzjsOmxDYN0xBSDCxnk1M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=rZ6R6LUl6Qpm2kc/4MO9SuodxF8HEB0Nxy8xWEzC146gAqyTZ5NfXhOkcgXYJ95Mm
 CDjGggZKJx0I2OTo5hiX8lHE976Jib7xfD3xDCp7Th0Mqf7mOmDTG6zlkrhv/pQ9IN
 UqYzCSmI1utPF5AOtKI9F+5JSI4SjLNxog8X2fh8=
Date: Fri, 21 Feb 2020 13:13:28 +0000
From: Will Deacon <will@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 3/3] arm64: Ask the compiler to __always_inline functions
 used by KVM at HYP
Message-ID: <20200221131328.GA13460@willie-the-truck>
References: <20200220165839.256881-1-james.morse@arm.com>
 <20200220165839.256881-4-james.morse@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200220165839.256881-4-james.morse@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Feb 20, 2020 at 04:58:39PM +0000, James Morse wrote:
> KVM uses some of the static-inline helpers like icache_is_vipt() from
> its HYP code. This assumes the function is inlined so that the code is
> mapped to EL2. The compiler may decide not to inline these, and the
> out-of-line version may not be in the __hyp_text section.
> 
> Add the additional __always_ hint to these static-inlines that are used
> by KVM.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/include/asm/cache.h      | 2 +-
>  arch/arm64/include/asm/cacheflush.h | 2 +-
>  arch/arm64/include/asm/cpufeature.h | 8 ++++----
>  arch/arm64/include/asm/io.h         | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

It's the right thing to do, but if this stuff keeps trickling in then
we should make CONFIG_OPTIMIZE_INLINING depend on !ARM64 because seeing
"__always_inline" tells you nothing about /why/ it needs to be there and
it's hard to know if/when you can remove those annotations in future.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
