Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B78C11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:02:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CAB9613CE
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CAB9613CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B574A7FD;
	Thu,  1 Jul 2021 09:02:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YJPDwCBcOWD1; Thu,  1 Jul 2021 09:02:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE1A4A023;
	Thu,  1 Jul 2021 09:02:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D8649FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:02:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qnsu-KJyIa9g for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 09:01:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F090C4083E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:01:56 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDAD56140B;
 Thu,  1 Jul 2021 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625144515;
 bh=iHSHG/c7nR83GudWbkb74eh2Q3S1tPDocmMIvzxBwxI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=r1fhICH1688wSS5RIgsm/HH8jTIkrAb09EbweFoFHMMOdYK0c1cl2TrqRJMzxJf0A
 34gPvJmmuP40y0tyr80fVb/PVALcQvo14bkIgBkYMFY1BpGBeAwG8ug18OwYmweRB2
 d3kzdYN51EoXMX6dMwKFdnlTiNuO5PvNMTLZYhzqu3j9RsjPZe7DcA1tpv23Utw73V
 o+WUPlFHGaJnsQG9m6kwhxeWBEJbJ/uI1VO+dWt0nRoVkAR1SVm31K+Od3ZsC+JUGZ
 R66XWaCnIdzq82WXf32VT4O3RpYngK1td+OS4I6TijYKgDAnkrxLdUdh7ejBmR490S
 0rqcZdipkInQg==
Date: Thu, 1 Jul 2021 14:01:49 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 03/13] KVM: arm64: Fix names of config register fields
Message-ID: <20210701130149.GC9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-4-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-4-tabba@google.com>
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

On Tue, Jun 15, 2021 at 02:39:40PM +0100, Fuad Tabba wrote:
> Change the names of hcr_el2 register fields to match the Arm
> Architecture Reference Manual. Easier for cross-referencing and
> for grepping.
> 
> Also, change the name of CPTR_EL2_RES1 to CPTR_NVHE_EL2_RES1,
> because res1 bits are different for VHE.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 25d8a61888e4..bee1ba6773fb 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -31,9 +31,9 @@
>  #define HCR_TVM		(UL(1) << 26)
>  #define HCR_TTLB	(UL(1) << 25)
>  #define HCR_TPU		(UL(1) << 24)
> -#define HCR_TPC		(UL(1) << 23)
> +#define HCR_TPCP	(UL(1) << 23)

This one is a bit weird: the field is called TPCP if the CPU supports
FEAT_DPB but is called TPC otherwise! So I don't think renaming it like
this really makes anything better. Perhaps add a comment:

  #define HCR_TPC	(UL(1) << 23)	/* TPCP if FEAT_DPB */

?

Rest of the patch looks good:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
