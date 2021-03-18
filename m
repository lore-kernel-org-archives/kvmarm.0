Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F81C43381
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 13:34:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E05560238
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 13:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E05560238
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDF74B747;
	Thu, 18 Mar 2021 09:34:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fxH1chIRqJUo; Thu, 18 Mar 2021 09:34:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF1EC4B745;
	Thu, 18 Mar 2021 09:34:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44DF84B743
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 09:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v+d79diJsPRt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 09:34:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22D614B731
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 09:34:33 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A72864E27;
 Thu, 18 Mar 2021 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616074470;
 bh=d+aUNfWPxN/xxjxc8yYGr+7tZ50qw5UZwCakX/qmEk0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AMKitB5VW/7PXIefSVUCNlKk3uz9eZlkxq3nB8HKwt24c/rwDd6rUUQU+6lNyau9X
 NMgBtb3f7NZsoJO9zV63kPQdB7x2LVb+96uwHd40xQhQh7zAEJ8wAJIZRoIIQ1+sbE
 96R8JHHuIp5xr4pxwJtqHMJrF4WjB1kLDC/uIq6vxxjb4Avc04NiEF2VLR0wqix0i3
 EZKOs6l3XRfLLGuYcsafB3MFGzwm9qwRQBk236hbyE4SlgfqhnPPXCfj0ni8oR8PdP
 Tf6aOHl7UnVgKSahhp0sBFHtFXgDLFXSziVTZIQuRfESWZqRaJUc6xvn+aP4G8Sc3w
 t+WQ6ajjAzMQQ==
Date: Thu, 18 Mar 2021 13:34:25 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 06/11] KVM: arm64: Rework SVE host-save/guest-restore
Message-ID: <20210318133424.GC7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-7-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-7-maz@kernel.org>
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

On Thu, Mar 18, 2021 at 12:25:27PM +0000, Marc Zyngier wrote:
> In order to keep the code readable, move the host-save/guest-restore
> sequences in their own functions, with the following changes:
> - the hypervisor ZCR is now set from C code
> - ZCR_EL2 is always used as the EL2 accessor
> 
> This results in some minor assembler macro rework.
> No functional change intended.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h   |  8 +++--
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/fpsimd.S             |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 40 +++++++++++++++----------
>  4 files changed, 32 insertions(+), 20 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
