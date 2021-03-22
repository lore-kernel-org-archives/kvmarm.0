Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A8C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 11:26:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F0B76191F
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 11:26:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F0B76191F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE8264B3F5;
	Mon, 22 Mar 2021 07:26:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ibs7ouaNjrZ; Mon, 22 Mar 2021 07:26:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E1E4B41A;
	Mon, 22 Mar 2021 07:26:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B514B411
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:26:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BdQkvvXbgkik for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 07:26:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3EA54B3F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:26:00 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA1E61984;
 Mon, 22 Mar 2021 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616412359;
 bh=PzLkd0Gp9jIBSRQCzJxuUu+Zrn0Xf64IlgL4+coMbzw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=QJQ3wCuUvGBWF4pZF546GIrJMojyVKWgUqpt/xEtubgwefRVr/2s3NPpZKO1k8Ofa
 M1SJmXGhMdM/t7PZ/207GcxroaIx4feVCPUNwXNf6yebFiqnQYHCOLEJtvVheJyXg2
 DSw+i0MCQPS/VsY4YQ0PqF7eIsCw4o4BKaUX9OChAUXj6VFYHNXXG8tL4Kl3uvIgav
 Fj7YKK2fFhskNfN8+Cs/UNVZGqlt0MMBujxt8i4dS9W95bI9OWkoE8mzVvlCYzgz6E
 nQtdgYwRCByxcqczfhmEcevstblWjGUlmU7OJA2XbYaKAFJC6fLlHSdFywvkJAHBaW
 P3BCZSWpUihIQ==
Date: Mon, 22 Mar 2021 11:25:53 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v6 14/38] KVM: arm64: Provide __flush_dcache_area at EL2
Message-ID: <20210322112553.GB10318@willie-the-truck>
References: <20210319100146.1149909-1-qperret@google.com>
 <20210319100146.1149909-15-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319100146.1149909-15-qperret@google.com>
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

On Fri, Mar 19, 2021 at 10:01:22AM +0000, Quentin Perret wrote:
> We will need to do cache maintenance at EL2 soon, so compile a copy of
> __flush_dcache_area at EL2, and provide a copy of arm64_ftr_reg_ctrel0
> as it is needed by the read_ctr macro.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_cpufeature.h |  2 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 ++++++
>  arch/arm64/kvm/sys_regs.c               |  1 +
>  5 files changed, 24 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
