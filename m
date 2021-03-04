Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4100C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:35:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3901864F6D
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3901864F6D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3EEC4B439;
	Thu,  4 Mar 2021 14:35:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9KS+S0sGr-L5; Thu,  4 Mar 2021 14:35:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 257944B43D;
	Thu,  4 Mar 2021 14:35:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E504B349
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:35:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4mKyzYnOTz0M for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 14:35:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 071C74B33E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:35:06 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320AE64F60;
 Thu,  4 Mar 2021 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614886506;
 bh=yYKWZ6QndHwWfsOdgKSOMpZxTE7UTXV1JxyvIovkYDE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZpNz8lFeg3deiGdXUSucIiLylskK5XGCqj1AwyqBAb+2N8gZ5XpzwPPTSSHvhQoEx
 ehvWad8VPCVuHb/IPoGG9lnq9HMJstraBLRB+ntMWb/3Qss8JcVGqLtoic7SHvG5Bb
 AjFJ5CIAWumqND6y6Ys73womqixyps7o6Zpy7QWU8YYAOcq+Dkm5GLmEutN9D8ykRh
 w/qrsBjcwcX1jkDf6avPi3fDaVD/G91LUCi/8R70jepn057vy7WEET763yakPLpuDp
 AsfovY+zS9jTC+Zzw7V3u7ZCgoc3mOPGNr8R3A4lEjlvuoMuvNeezxn9Qp5qFy4p/t
 7KNucS/DhjuLQ==
Date: Thu, 4 Mar 2021 19:35:00 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 20/32] KVM: arm64: Refactor kvm_arm_setup_stage2()
Message-ID: <20210304193459.GA21950@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-21-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-21-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:50PM +0000, Quentin Perret wrote:
> In order to re-use some of the stage 2 setup code at EL2, factor parts
> of kvm_arm_setup_stage2() out into separate functions.
> 
> No functional change intended.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 32 +++++++++++++++++++++
>  arch/arm64/kvm/reset.c               | 42 +++-------------------------
>  3 files changed, 62 insertions(+), 38 deletions(-)

Looks much better than the big header in v2, thanks!

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
