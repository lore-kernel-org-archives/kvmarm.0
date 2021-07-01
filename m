Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F1FC11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:22:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7481661413
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7481661413
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A0849D50;
	Thu,  1 Jul 2021 09:22:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RlLe62Lw+o7F; Thu,  1 Jul 2021 09:22:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C4F4A98B;
	Thu,  1 Jul 2021 09:22:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F1BB4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:22:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LJAdG4+VYxDS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 09:22:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 869BC49D50
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:22:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA2961413;
 Thu,  1 Jul 2021 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625145770;
 bh=M+yZhv6g5otK9MkfzDlcaPl/c3UMH4E1t9qb2YpBQQE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=mAFaojGOxwSR3+mK09AWgCOlfbEIM4pXDdsJ3gUPTuNNOAMnTtzGkjtUM72UC2w5s
 saxDVUj7iTr8VkMZbBFi/LKeA/qxhDmERgPapUWo5cw6QcxiBBRlpnDy667inwDABQ
 CNwctMGRK4dvJP0WRUNu/zyn0GEKMdJ8SBnPfFw8FDcVj2ITWELMp2KXTl1O82e4Sx
 T4bsCjbmJTW8Zlu9JI0wuRdx3JLiSgV0ZtDZp9pBRai1nFV4FlatrDHjP/bZ2rRVKr
 lLHTwPEdgHGS+cz/zRplGTYHiBZD3e7IeJOmMOFw6fiUMd+TWtBmGh71/uRI4pWdtk
 cvNYb02DcOCAQ==
Date: Thu, 1 Jul 2021 14:22:44 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add feature register flag definitions
Message-ID: <20210701132244.GF9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-7-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-7-tabba@google.com>
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

On Tue, Jun 15, 2021 at 02:39:43PM +0100, Fuad Tabba wrote:
> Add feature register flag definitions to clarify which features
> might be supported.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 65d15700a168..42bcc5102d10 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -789,6 +789,10 @@
>  #define ID_AA64PFR0_FP_SUPPORTED	0x0
>  #define ID_AA64PFR0_ASIMD_NI		0xf
>  #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
> +#define ID_AA64PFR0_EL3_64BIT_ONLY	0x1
> +#define ID_AA64PFR0_EL3_32BIT_64BIT	0x2
> +#define ID_AA64PFR0_EL2_64BIT_ONLY	0x1
> +#define ID_AA64PFR0_EL2_32BIT_64BIT	0x2
>  #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
>  #define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
>  #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1

Maybe just consolidate all of these into two definitions:

  #define ID_AA64PFR0_ELx_64BIT_ONLY   0x1
  #define ID_AA64PFR0_ELx_32BIT_64BIT  0x2

?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
