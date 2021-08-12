Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965D5C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0145B61058
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0145B61058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9663E4A198;
	Thu, 12 Aug 2021 04:59:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dBzcvucbqaO7; Thu, 12 Aug 2021 04:59:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F2524A19E;
	Thu, 12 Aug 2021 04:59:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F32E249E93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0kSVoE6eB6i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 04:59:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F84A40839
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:26 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0776160C3F;
 Thu, 12 Aug 2021 08:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628758765;
 bh=sjxnnAcFFQeU/Bm517XhrtWUqgRGPZPYbSW/yVHWY5s=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZQj4RBz6e9t5QGtKRgT4K70zwQlVrLhg48IywHQcySOSt6rJBWxiPe3UmtVIY9fat
 NH6mS5vhBqHsLmQ6tKD5IqSs51Onmw2/6dpdutEG8H/+l2ze6O/epbNnQERnjeGXI9
 x4t/2R52K3AH0iszsA1xjxDa3mPF28Dd9ZskGnTnCP0L7L6kcScsp8DsxeJ8SZ1RsM
 dlnFyiFf6Ya4QsEQXaNIgr/CCPxGaO1DhmeJFqi6dlc5c4/03lj+FSrAPV7mRpCDxe
 aFBNoK42mSG49sj9MSQRNKSjdN1qxzMtyUwVW6UH+i4eS82mClXtG54n8dyYNiAaHz
 7mqlx7Y6mygDg==
Date: Thu, 12 Aug 2021 09:59:20 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h, c for nVHE reuse
Message-ID: <20210812085919.GD5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-6-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-6-tabba@google.com>
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

On Mon, Jul 19, 2021 at 05:03:36PM +0100, Fuad Tabba wrote:
> Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> common code. It will be used in nVHE in a later patch.
> 
> Note that the refactored code uses __inline_bsearch for find_reg
> instead of bsearch to avoid copying the bsearch code for nVHE.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  3 +++
>  arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
>  arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 29 deletions(-)

With the naming change suggested by Drew:

Acked-by: Will Deacon <will@kernel.org.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
