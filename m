Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE7CC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 18:00:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D52B264F2A
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 18:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D52B264F2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 647464B68A;
	Wed, 17 Mar 2021 14:00:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rFUi3vUya+RA; Wed, 17 Mar 2021 14:00:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C364B64D;
	Wed, 17 Mar 2021 14:00:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89094B5B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 14:00:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dJ+DXm+dQXMr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 14:00:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 136A34B4E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 14:00:24 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD5264F21;
 Wed, 17 Mar 2021 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616004023;
 bh=19/EHa8tqrBvjr5N+17FlDNPaZq4lw493X2jfLFSXMU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qmtsr6jfQGZvpiPtqAKOYAJGAFJD/3AieD2zGweFccZ92UmjEDsr47puog4UPWImD
 jL423PnqghvSY69wUYdL60Zq3mOq3jAh3t4deDklE6s7quCvhuz6CcBAwOzGyHqq+3
 5AsJZo9WM7OkYmHZHutAgu3lCGyF/2AJchbrEb8zrWfchIzb6SujeKEbYjmMjl2yPi
 L11n1lRaoZlIgP+KHv/yt2TZeVBJekNsyNQYghmVeONuOr9Lpcl290whyZaoQAR2wZ
 9SGFNkG1qdacKrB/ceUun0OuG0dSEinmoliDwo1IlsZBvyJnSgNWTQitAYeD1TNUhB
 q+8m8ZGZASQMg==
Date: Wed, 17 Mar 2021 18:00:17 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 10/10] KVM: arm64: Enable SVE support for nVHE
Message-ID: <20210317180017.GB5713@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-11-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-11-maz@kernel.org>
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

On Tue, Mar 16, 2021 at 10:13:12AM +0000, Marc Zyngier wrote:
> From: Daniel Kiss <daniel.kiss@arm.com>
> 
> Now that KVM is equipped to deal with SVE on nVHE, remove the code
> preventing it from being used as well as the bits of documentation
> that were mentioning the incompatibility.
> 
> Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/Kconfig                |  7 -------
>  arch/arm64/include/asm/kvm_host.h | 13 -------------
>  arch/arm64/kvm/arm.c              |  5 -----
>  arch/arm64/kvm/reset.c            |  4 ----
>  4 files changed, 29 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

I thought we might need to update the documentation too, but I couldn't
actually find anywhere that needed it when I looked.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
