Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF6EC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 16:06:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3996B64FAF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 16:06:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3996B64FAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6A04B284;
	Wed,  3 Feb 2021 11:06:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nnrJSstMSn8I; Wed,  3 Feb 2021 11:06:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9375D4B286;
	Wed,  3 Feb 2021 11:06:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D09624B284
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 11:06:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IH4MAanFOH+F for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 11:06:06 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DA894B282
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 11:06:06 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 101D264F9B;
 Wed,  3 Feb 2021 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612368365;
 bh=GNyZIbhSMsMA+IdaAyNXFV3wbRVRMl0Dn1D0Eg9euXw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FO9H6iajc6NVqYVl4y5je/YxxoDHEFiT2NosmwBHrOBdYZi5oFgx0buRz+Bq1V8UA
 czLa4+xX/opvBFh8yb4fHjTdDyB6M5onZzQ20opl3i4yaX/bOlKYcycLb0rKOWI/NG
 mFjcYWp1jS7FxsSzlU8zLmEL8lQMA7tm+YMyNF2zl9jXsS0TsjcLAWALn3TncBqA3q
 XPYRLOAPkkKjTnSQl2XGVs8tIspIlbLQ8gigJvAEEnLyVBufLTa0X5rASMYZ+Ec1zx
 rUCFiK3OLYBAXt0rCyHniYKy0rm0+SQlUPMGdohf8CfYe4Vu2EX/ip48sGX1DEQoRO
 BgdqTVMBtro+w==
Date: Wed, 3 Feb 2021 16:05:58 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 20/26] KVM: arm64: Set host stage 2 using
 kvm_nvhe_init_params
Message-ID: <20210203160558.GI18974@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-21-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-21-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:18PM +0000, Quentin Perret wrote:
> Move the registers relevant to host stage 2 enablement to
> kvm_nvhe_init_params to prepare the ground for enabling it in later
> patches.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   | 3 +++
>  arch/arm64/kernel/asm-offsets.c    | 3 +++
>  arch/arm64/kvm/arm.c               | 5 +++++
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 9 +++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c   | 5 +----
>  5 files changed, 21 insertions(+), 4 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
