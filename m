Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C406AC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 14:38:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 069C164F5B
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 14:38:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 069C164F5B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0D74B168;
	Thu,  4 Mar 2021 09:38:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HgKxRHDQ4bxj; Thu,  4 Mar 2021 09:38:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 760614B192;
	Thu,  4 Mar 2021 09:38:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06F9E4B168
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 09:38:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1plbgq2WkhMI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 09:38:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D4A54B0C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 09:38:33 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E75764F53;
 Thu,  4 Mar 2021 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614868712;
 bh=8HCRgaAXUQKJEYk45KGjzpayiZSJL7Z75jrU+D65Qeo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=X5yEwJIaq0J3G+LX6gOVqkHLOFA7A1fzuRqCO9TA3yz2kYuwqLKdBrGz76rPD96U2
 cKxMcAvYWFIn0mO4mwEXY8GDmT7CujlI2LMHCeYDKCxCFT+MS7YUtSLUZgseGev/xB
 nGDRIQhE3SgnpSPCaLFPVNGxI9ZIEar6b0EurD8f6+x6FTn+2mosIODf05n8Fhps7T
 6QAmQ2r7uAqH2YL1JnUMvggdafAHFhTeRJA6Ahi2Z9kxafeSU3qpbvvwMD8QMRRMdf
 M7fZC0WyDhSD4F/RBO4PNluP+ce8uxYNzwoR2gYlXfFBH1z7UPaIWt7zo1b4j71CLe
 LtYItYCXzSl+w==
Date: Thu, 4 Mar 2021 14:38:25 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 10/32] KVM: arm64: Introduce an early Hyp page allocator
Message-ID: <20210304143825.GA21410@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-11-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-11-qperret@google.com>
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

On Tue, Mar 02, 2021 at 02:59:40PM +0000, Quentin Perret wrote:
> With nVHE, the host currently creates all stage 1 hypervisor mappings at
> EL1 during boot, installs them at EL2, and extends them as required
> (e.g. when creating a new VM). But in a world where the host is no
> longer trusted, it cannot have full control over the code mapped in the
> hypervisor.
> 
> In preparation for enabling the hypervisor to create its own stage 1
> mappings during boot, introduce an early page allocator, with minimal
> functionality. This allocator is designed to be used only during early
> bootstrap of the hyp code when memory protection is enabled, which will
> then switch to using a full-fledged page allocator after init.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/early_alloc.h | 14 +++++
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      | 24 +++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile              |  2 +-
>  arch/arm64/kvm/hyp/nvhe/early_alloc.c         | 54 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c          |  4 +-
>  5 files changed, 94 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/memory.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/early_alloc.c

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
