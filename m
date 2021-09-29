Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BBEC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 15:53:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAC5E61465
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 15:53:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CAC5E61465
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D73B4B13A;
	Wed, 29 Sep 2021 11:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QeKtDQ0ycxba; Wed, 29 Sep 2021 11:53:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 543394B0C2;
	Wed, 29 Sep 2021 11:53:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3CAC4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 11:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pfZr8P-xHAFc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 11:53:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09FDA4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 11:53:35 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F63160FA0;
 Wed, 29 Sep 2021 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632930814;
 bh=uEB7waoBI1fsFWcFkbUd52mOvV43dk+iz1OQQ6eGAs4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FhfK1xg/+azJIJECGx2MEBGxaCxIQlJVIfzX6+ALentONlFVSuD/mDBT3jQCRjPzM
 zXAazTZ+QTASPy3yqTnF8Ign8olbao4VgwsShjtc3VxzZV78KkFUru8tSgGhThuZ7H
 p2NNnjDuXhE+ElpLLdZNsY/FT9Wn1UcUt+Zig9M1ltgzRuvK+SBC8mVyU0F5RwLmRW
 inV8EdFSu1fXT12TRtLow8BRMQRw9NilDRDlWuNlVhKp5puuyWDfJ9JmZd4tcMphEZ
 hKKkiB6Lw6maRopT+mcDqx0YUsEZ9kxnWM1jfrDPzk64UNNwN8Twcgaxd8IOZVAd4Q
 YWHgJmaTEh2bg==
Date: Wed, 29 Sep 2021 16:53:29 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Depend on HAVE_KVM => OF instead of
 directly on OF
Message-ID: <20210929155328.GD22029@willie-the-truck>
References: <20210921222231.518092-1-seanjc@google.com>
 <20210921222231.518092-3-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210921222231.518092-3-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Sep 21, 2021 at 03:22:31PM -0700, Sean Christopherson wrote:
> Select HAVE_KVM if the KVM dependency is met (OF / Open Firmware), and
> make KVM depend on HAVE_KVM instead of directly on OF.  This fixes the
> oddity where arm64 configs can end up with KVM=y and HAVE_KVM=n, and will
> hopefully prevent breakage if there are future users of HAVE_KVM.
> 
> Note, arm64 unconditionally selects OF, and has always done so (see
> commit 8c2c3df31e3b ("arm64: Build infrastructure").  Keep the somewhat
> pointless HAVE_KVM dependency on OF to document that KVM requires Open
> Firmware support.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/Kconfig     | 1 +
>  arch/arm64/kvm/Kconfig | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b5b13a932561..38c0f36a5ed4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -187,6 +187,7 @@ config ARM64
>  	select HAVE_GCC_PLUGINS
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
>  	select HAVE_IRQ_TIME_ACCOUNTING
> +	select HAVE_KVM if OF

Honestly, I'd just drop the 'if OF' here. We select it unconditionally a
few lines below and so I think it's more confusing to have the check.

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
