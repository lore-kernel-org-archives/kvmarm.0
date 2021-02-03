Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F9FC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:25:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B639464F8C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B639464F8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 300344B287;
	Wed,  3 Feb 2021 10:25:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4d1NMB7Y38Cs; Wed,  3 Feb 2021 10:25:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A091B4B277;
	Wed,  3 Feb 2021 10:25:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD554B277
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:25:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s-bR-sLklg9U for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 10:25:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 266704B260
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:25:00 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E86064E50;
 Wed,  3 Feb 2021 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612365898;
 bh=b6GRiq4QWZI2rziuLd7GuwpX6MNv51A8gcYBBvehiio=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=b6Y16Cv346MxftHyKt9CjWlbJT3BUlf8fpmSRvBh9qH1up5WGKfAVm2q0gqQ7fxmW
 0cPpkWQQtzxsDzT3G422p0zCLvepCyf5ghZd6xCuYNtvNdyrkiDjzYoENxjPUGctAJ
 l7X6Al+Yjvo0osO70Mn4QGsRq0QlPCyIjo4f/HboaU19+bgKIgKp8bkSsIuS/ysEiM
 3aTgKiAQu9g7W7hmgzoge1tRFBuzCHajRrhVWfI7+YZZ6LoGiZFMojJEe+UnFvhUsL
 q/v4Vw2fDx/qmRFmVVpq2GLD4+Qa1PHc3o+YF9LYzaT9TUJks7u33wS6x+CMp6HR2z
 RhfG/FIp5RF1A==
Date: Wed, 3 Feb 2021 15:24:52 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 1/2] asm-generic: export: Stub EXPORT_SYMBOL with
 __DISABLE_EXPORTS
Message-ID: <20210203152452.GA18974@willie-the-truck>
References: <20210203141931.615898-1-qperret@google.com>
 <20210203141931.615898-2-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203141931.615898-2-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 kernel-team@android.com, ardb@kernel.org
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

On Wed, Feb 03, 2021 at 02:19:30PM +0000, Quentin Perret wrote:
> It is currently possible to stub EXPORT_SYMBOL() macros in C code using
> __DISABLE_EXPORTS, which is necessary to run in constrained environments
> such as the EFI stub or the decompressor. But this currently doesn't
> apply to exports from assembly, which can lead to somewhat confusing
> situations.
> 
> Consolidate the __DISABLE_EXPORTS infrastructure by checking it from
> asm-generic/export.h as well.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  include/asm-generic/export.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
