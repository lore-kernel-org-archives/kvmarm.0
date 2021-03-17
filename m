Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551CDC43381
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:30:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE3D164F26
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:30:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE3D164F26
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2262F4B654;
	Wed, 17 Mar 2021 10:30:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5hpTPnKBuvHa; Wed, 17 Mar 2021 10:30:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0C704B5CA;
	Wed, 17 Mar 2021 10:30:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 807894B65D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:30:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UeHzEx997Rpa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:30:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F9524B5CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:30:25 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3B864E13;
 Wed, 17 Mar 2021 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615991422;
 bh=UlkZsQXs/INZ7pDMa7O0/XSCqYnvaCwSyP15Y4oHfBQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hFx9pj3srcAi0u0CpljilC3snQR+d5s9R7a0k0W8ptjPW0eN4SEjapr+wS33FekVi
 XOzbYuLA/9gGsmJuv0LpFlDQHH89VheWLZb08wc3igTJit0iPaAdI+S7J9XJO0wOg8
 C83NhCElONH+N6hDeMGDyUG6GiI1PGjSOgDNEtoA9Ym7DsI3m5dgTdr7bzTQZhj0Ba
 OhuIV6ZREfoRWGJqEDevzYSLcrG0GbW8R22p1UV+HMmWJdMzr/vo2xP1Q7HFgwMpQ8
 EMX4rA5txr3B/Gg7lhydc6fuGBCia7u7m3tdS1llYXdnxDDl3FPvwh1LA8Ocm6Aehe
 12Xc8fVU1bm6w==
Date: Wed, 17 Mar 2021 14:30:17 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/10] KVM: arm64: Provide KVM's own save/restore SVE
 primitives
Message-ID: <20210317143016.GB5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Tue, Mar 16, 2021 at 10:13:03AM +0000, Marc Zyngier wrote:
> as we are about to change the way KVM deals with SVE, provide
> KVM with its own save/restore SVE primitives.
> 
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h   |  2 ++
>  arch/arm64/include/asm/kvm_hyp.h        |  2 ++
>  arch/arm64/kvm/hyp/fpsimd.S             | 10 ++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 10 +++++-----
>  4 files changed, 19 insertions(+), 5 deletions(-)

With the typo spotted by Quentin fixed:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
