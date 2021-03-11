Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842A1C43381
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 16:21:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF1E16146B
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 16:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF1E16146B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366D94B548;
	Thu, 11 Mar 2021 11:21:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MTaiJzA3DUp2; Thu, 11 Mar 2021 11:21:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398A44B6D8;
	Thu, 11 Mar 2021 11:21:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3664B5EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 11:21:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hoiwOnujqMjC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 11:21:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A5C94B548
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 11:21:22 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 753FC6146B;
 Thu, 11 Mar 2021 16:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615479681;
 bh=T+Bt7gZGUjrxDrEQ2211vo0Svgs66BNqHKZT8ttELhs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=msyy8vEG3L5NnRfp90UsA3PFVsDk+faHyWPzudfFi2aM/2Lvau5b/GnFNFcjIXYZ4
 /FPfplr6+dJ+Ygyxek9GF75aVSIKUAhjFY2DwV7sWVm97x5FwS8KoEB8jv0f+eOe5r
 D+CB5H+c+4unbcsz4kmfZUKT6e4dOQsekhttSnJwJ+Gu+i2j6CiZKKViTJq3oSyeGj
 9AHJddEqOypI8jb3iT3JG8m/gWS/Dj0XdFiyEnFY3k24jWWUF64Kk2DzTpcsNKGuQO
 DVxwDWaJDzz/tETwYwz9YuW6E9q1MifTBV3A3QBKQr83A1938NCDySQy65h8ppgjBl
 2vXAIC0pBrEsg==
Date: Thu, 11 Mar 2021 16:21:13 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 16/34] KVM: arm64: Prepare the creation of s1 mappings
 at EL2
Message-ID: <20210311162112.GD31206@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-17-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-17-qperret@google.com>
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

On Wed, Mar 10, 2021 at 05:57:33PM +0000, Quentin Perret wrote:
> When memory protection is enabled, the EL2 code needs the ability to
> create and manage its own page-table. To do so, introduce a new set of
> hypercalls to bootstrap a memory management system at EL2.
> 
> This leads to the following boot flow in nVHE Protected mode:
> 
>  1. the host allocates memory for the hypervisor very early on, using
>     the memblock API;
> 
>  2. the host creates a set of stage 1 page-table for EL2, installs the
>     EL2 vectors, and issues the __pkvm_init hypercall;
> 
>  3. during __pkvm_init, the hypervisor re-creates its stage 1 page-table
>     and stores it in the memory pool provided by the host;
> 
>  4. the hypervisor then extends its stage 1 mappings to include a
>     vmemmap in the EL2 VA space, hence allowing to use the buddy
>     allocator introduced in a previous patch;
> 
>  5. the hypervisor jumps back in the idmap page, switches from the
>     host-provided page-table to the new one, and wraps up its
>     initialization by enabling the new allocator, before returning to
>     the host.
> 
>  6. the host can free the now unused page-table created for EL2, and
>     will now need to issue hypercalls to make changes to the EL2 stage 1
>     mappings instead of modifying them directly.
> 
> Note that for the sake of simplifying the review, this patch focuses on
> the hypervisor side of things. In other words, this only implements the
> new hypercalls, but does not make use of them from the host yet. The
> host-side changes will follow in a subsequent patch.
> 
> Credits to Will for __pkvm_init_switch_pgd.
> 
> Co-authored-by: Will Deacon <will@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h     |   4 +
>  arch/arm64/include/asm/kvm_host.h    |   7 +
>  arch/arm64/include/asm/kvm_hyp.h     |   8 ++
>  arch/arm64/include/asm/kvm_pgtable.h |   2 +
>  arch/arm64/kernel/image-vars.h       |  16 +++
>  arch/arm64/kvm/hyp/Makefile          |   2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mm.h |  71 ++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile     |   4 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  27 ++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  49 +++++++
>  arch/arm64/kvm/hyp/nvhe/mm.c         | 173 +++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c      | 197 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         |   2 -
>  arch/arm64/kvm/hyp/reserved_mem.c    |  92 +++++++++++++
>  arch/arm64/mm/init.c                 |   3 +
>  15 files changed, 652 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mm.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/mm.c
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/setup.c
>  create mode 100644 arch/arm64/kvm/hyp/reserved_mem.c

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
