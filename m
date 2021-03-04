Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940C4C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 14:09:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0469864F43
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 14:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0469864F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97DD44B3D6;
	Thu,  4 Mar 2021 09:09:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YsNbmr-6osfh; Thu,  4 Mar 2021 09:09:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 164174B372;
	Thu,  4 Mar 2021 09:09:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD544B2FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 09:09:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rYpS78-qYaVO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 09:09:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 284CB4B2EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 09:09:43 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EC5F64EDF;
 Thu,  4 Mar 2021 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614866982;
 bh=6EzIY8mKBs6byT+yHKkgcBlOIVV0b78KDf87tIOxB00=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UrLovbK0Yz6BuDjF+iBIgvC9apQ074oZiquUsRoxNP57gxQyf9vO1V7aqG39ne+DE
 lkGnQAkCi6sUhrxkNYWD3ADJEMIpD/BFXFX8cjv4F7wW66vLoLYqbOwqQ3nt36Pz5W
 n7o34V0bjYFFuma7ZsasQa21f3v2oxb0pC768CNiwtN8cKp3quhy6YOMrbPrL08Qjf
 +ATR9QY5jJSBoRKvFRwX9X8JeEjse7Ds20/btLeZ/dwbCA10Jc0qEG3FHmLJ+TUwU3
 fKD0cE07a1LfyCT8184I4jX0lCy4g9thQJoKyNngaMrF9K71BYbQYVDLyvWoivjN0L
 HoCTbDrMG6cFA==
Date: Thu, 4 Mar 2021 14:09:36 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 07/32] KVM: arm64: Introduce a BSS section for use at
 Hyp
Message-ID: <20210304140935.GD21229@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-8-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-8-qperret@google.com>
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

On Tue, Mar 02, 2021 at 02:59:37PM +0000, Quentin Perret wrote:
> Currently, the hyp code cannot make full use of a bss, as the kernel
> section is mapped read-only.
> 
> While this mapping could simply be changed to read-write, it would
> intermingle even more the hyp and kernel state than they currently are.
> Instead, introduce a __hyp_bss section, that uses reserved pages, and
> create the appropriate RW hyp mappings during KVM init.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/sections.h |  1 +
>  arch/arm64/kernel/vmlinux.lds.S   | 52 ++++++++++++++++++++-----------
>  arch/arm64/kvm/arm.c              | 14 ++++++++-
>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  1 +
>  4 files changed, 49 insertions(+), 19 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
