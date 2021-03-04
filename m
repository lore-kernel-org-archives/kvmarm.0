Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E5AC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:51:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A539B64F60
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A539B64F60
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B0E4B67D;
	Thu,  4 Mar 2021 14:51:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sS4Zxjb9g818; Thu,  4 Mar 2021 14:51:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 510BB4B660;
	Thu,  4 Mar 2021 14:51:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5393E4B664
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:51:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fntLOs3d0GAK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 14:51:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D72D4B660
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:51:38 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB9164F36;
 Thu,  4 Mar 2021 19:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614887497;
 bh=ppev95IRq0ko0CFGee8LBgrN4g0vaWYUMRdDU803TPo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Kss5eJZbCOMAhR49LUrOU62oxFhl6HZfRQt1aJrNyfWTPUoHuXX1EUXLCdTGgrfHh
 Ab2sNWyll1YeBA4fCCVlDzvgH13S+eB8f4BTd3QS1dZKZIl7/zpUT1cY/eWRkNHj2x
 Uqa3f3rhwC9L8EUyN9sHVV80SHr3sJTJEevY+1fNSnb0XuYNa1xSj7NiCizLL6Cm00
 i07ORjh0/fra1zDhCSxw59N5jZgQwF53m3o7Jfy8a7+ygzQ83WFvXAObocL/22nNyV
 CfcWezrT0SY4ZwhTSgVsHloW0KQd9Th6OaMlYLfYpPSAqiabzDG2+272k9olN/KPkX
 7fyIWZUX3kFUA==
Date: Thu, 4 Mar 2021 19:51:31 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 25/32] KVM: arm64: Sort the hypervisor memblocks
Message-ID: <20210304195131.GE21950@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-26-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-26-qperret@google.com>
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

On Tue, Mar 02, 2021 at 02:59:55PM +0000, Quentin Perret wrote:
> We will soon need to check if a Physical Address belongs to a memblock
> at EL2, so make sure to sort them so this can be done efficiently.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/reserved_mem.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
