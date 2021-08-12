Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69FDC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60D8461058
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60D8461058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0106C407F4;
	Thu, 12 Aug 2021 04:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id etYL8DVJo-kN; Thu, 12 Aug 2021 04:59:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF78D49DE7;
	Thu, 12 Aug 2021 04:59:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEFE2407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hu8xxFdFTuk5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 04:59:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 020D84075E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:16 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D543A60C3F;
 Thu, 12 Aug 2021 08:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628758755;
 bh=q4t3vjuGK+tg/Wy9fWMngwcMUzb/VrxOSr5Xbkqf90I=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=VtzrVV2aF9VFqkuM1pzh5cVjlv4J4jrsalzZfW086fCJzEgKaIfEScPtVlsr2DWdy
 8racU7H4uRyOoEzYWpyLZngiBLf2knMRE6R5je/wcMfoZpTMNikwmjhhogsFBrB8Fj
 zBV1zXMUxF1s3YyRrvIdHjDcQVFIeGI6hzCghwDlaB0+Jm/fh8KvNw8Jnb3fs0g1kD
 DMQkp6Xg2Pg+Y4nZIQiqf8kbWOG4nNvqRLTDP6jnKPNebSxtG4PRjrBTDPn3UY0O0M
 y8lA/WZx/bicXZ60X+NZlqbURiMLL0D6FLgP+Ch/nD234s/pKaw5Ym4CHws8W8WVkr
 m1FXGuYEY/4eg==
Date: Thu, 12 Aug 2021 09:59:09 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 02/15] KVM: arm64: Remove trailing whitespace in comment
Message-ID: <20210812085908.GC5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-3-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-3-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jul 19, 2021 at 05:03:33PM +0100, Fuad Tabba wrote:
> Remove trailing whitespace from comment in trap_dbgauthstatus_el1().
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f6f126eb6ac1..80a6e41cadad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -318,14 +318,14 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
>  /*
>   * We want to avoid world-switching all the DBG registers all the
>   * time:
> - * 
> + *
>   * - If we've touched any debug register, it is likely that we're
>   *   going to touch more of them. It then makes sense to disable the
>   *   traps and start doing the save/restore dance
>   * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
>   *   then mandatory to save/restore the registers, as the guest
>   *   depends on them.
> - * 
> + *
>   * For this, we use a DIRTY bit, indicating the guest has modified the
>   * debug registers, used as follow:
>   *

I'd usually be against these sorts of changes but given you're in the
area...

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
