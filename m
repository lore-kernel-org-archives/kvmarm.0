Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCBEC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:04:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C74F9613A7
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C74F9613A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A7214B0ED;
	Thu, 30 Sep 2021 09:04:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iDkWZU5IwDmQ; Thu, 30 Sep 2021 09:04:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BBDF4B0D6;
	Thu, 30 Sep 2021 09:04:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E79A34B0CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KEQMOooWjDMX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 09:04:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D25C949DE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:04:45 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980FF61528;
 Thu, 30 Sep 2021 13:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633007084;
 bh=+s6LJxFuBmlJp9/9dcn48u7vnNbcZ8iPNN4iyAdSDPI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lAOSz70qSb1/bv1kHlkZDOvTg6wttP2zJv3px1/YqJm0Nkout2msVt9Z7nDY73GAo
 IOXXwUdhK3TOZmhdrG/nZwueGWjuzn643i9AYHDZlUA0YElj0iGWcNIWN8u9PLJ+k6
 Ja2+FCVgU9FMvV0SnGhUngXQAZryBYCwibjq0iYqhH4HIyuj8njLPx98MhcScnjTbZ
 ewyKZGdTTN2cuiES30Azq3cB48JBVsTvj9EA6zyu41+eWw88Q8nTLYkNPLwuDVuhjk
 C+Yx4N6m86OLcA6uH0W9bXGAPlpcJg475/K/ePPzUDVwJaSJpYOJlAUCucyi38qcKC
 oBFc0p1Hjsejw==
Date: Thu, 30 Sep 2021 14:04:38 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v6 01/12] KVM: arm64: Move __get_fault_info() and co into
 their own include file
Message-ID: <20210930130437.GA23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-2-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210922124704.600087-2-tabba@google.com>
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

On Wed, Sep 22, 2021 at 01:46:53PM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> In order to avoid including the whole of the switching helpers
> in unrelated files, move the __get_fault_info() and related helpers
> into their own include file.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/fault.h  | 75 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 61 +-------------------
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
>  3 files changed, 77 insertions(+), 61 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
> new file mode 100644
> index 000000000000..1b8a2dcd712f
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2015 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>

May as well fix the broken email address? ^^

> + */
> +
> +#ifndef __ARM64_KVM_HYP_FAULT_H__
> +#define __ARM64_KVM_HYP_FAULT_H__
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>

Strictly speaking, I think you're probably missing a bunch of includes here
(e.g. asm/sysreg.h, asm/kvm_arm.h, asm/cpufeature.h, ...)

Nits aside:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
