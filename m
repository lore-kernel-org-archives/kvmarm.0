Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BFDC433E6
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 19:09:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9FA4664EF2
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 19:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FA4664EF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA844B6BD;
	Thu, 11 Mar 2021 14:09:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9PUyfdVa2fB1; Thu, 11 Mar 2021 14:09:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 211C54B668;
	Thu, 11 Mar 2021 14:09:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04DEF4B668
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 14:09:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z9EtbKg7-Ley for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 14:09:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 033184B667
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 14:09:28 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93B0E64E60;
 Thu, 11 Mar 2021 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615489766;
 bh=tjRqrEnr46TNCZjccx2NGAuGGxIXCeGJ/0pAUdHa0PI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TEL/EMvYZ0+zWrD5EIuzTfjrSYY7hC23Y2j+Z8/RVD2RPw5nW9nlL9OVPhdujco5H
 IxG1S4eYeByD+3RC4CtWTm2v9bPW3Wp6RTwwEhrAiNVg9ByP/3LKt8qv9TQ5TVf6Rn
 168ARlFFeWq63rb7WsPBEmDpUngQIhcuvG3mb/Z3ZznNYhYt5+gDPEnWHMJqgnNnU6
 DbcYWMOsemicENDMIBBoIaq6WYPEw+CKiBbYO2yOeJZ7nzkg3ohIzcM+MwF6wA2NPY
 Cwys5Ma+XGmLRC4S6IjWhKdvD0b1cOPkjRYIdkkA/ct10QYWQmLHVz/w6VMUFp/FOf
 87T98ajA+CTHg==
Date: Thu, 11 Mar 2021 19:09:20 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 31/34] KVM: arm64: Wrap the host with a stage 2
Message-ID: <20210311190919.GC31586@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-32-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-32-qperret@google.com>
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

On Wed, Mar 10, 2021 at 05:57:48PM +0000, Quentin Perret wrote:
> When KVM runs in protected nVHE mode, make use of a stage 2 page-table
> to give the hypervisor some control over the host memory accesses. The
> host stage 2 is created lazily using large block mappings if possible,
> and will default to page mappings in absence of a better solution.
> 
> From this point on, memory accesses from the host to protected memory
> regions (e.g. marked PROT_NONE) are fatal and lead to hyp_panic().
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_cpufeature.h       |   2 +
>  arch/arm64/kernel/image-vars.h                |   3 +
>  arch/arm64/kvm/arm.c                          |  10 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  34 +++
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 246 ++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |   5 +
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
>  12 files changed, 319 insertions(+), 7 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c

I like this a lot more now, thanks:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
