Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86C5C4320E
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C64C06103A
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C64C06103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4404A523;
	Thu, 12 Aug 2021 04:59:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vEbyE1rJFsHa; Thu, 12 Aug 2021 04:59:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B10349E93;
	Thu, 12 Aug 2021 04:59:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD78040839
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mqE5c90C3XIF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 04:59:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C18034A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 04:59:45 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD9160C3F;
 Thu, 12 Aug 2021 08:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628758784;
 bh=srKEXFb7B5Re+3iiWpHXQAcqGzm51k++58eDNACsfIU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=iCW5MwZkpLmx7akle39s9ZWQqz9phsrE8gL8DMrSjyYtmlkEzgfFbv2QE0G7KFEWI
 HEMFqcJhUy8HiXsDHb8G+MiEHwAnS4kBpkRxi+WbL6PFIl4V4qfrJbYudoeeSASvE9
 gW+BqHIlUl3/+oJ6jWOeuAQg/0+Ww8EjnEWr+uQFp7MXIwZfbzbcks4O8ADmxN3ny3
 DIZLEyXAPnyuJGSXJprvCuh8mDFkFDj/wSQhcTC1yw4SPMk8wmHd1Bavm6TI2z0A02
 efS8zw2r4MEp3lRYwMIaRz7k5rufqLygdKrafkG+sf9GMeSyXwrkkni2kF3GGJVcGT
 6nn8dL051zK6g==
Date: Thu, 12 Aug 2021 09:59:39 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 08/15] KVM: arm64: Add feature register flag definitions
Message-ID: <20210812085939.GF5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-9-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-9-tabba@google.com>
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

On Mon, Jul 19, 2021 at 05:03:39PM +0100, Fuad Tabba wrote:
> Add feature register flag definitions to clarify which features
> might be supported.
> 
> Consolidate the various ID_AA64PFR0_ELx flags for all ELs.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  4 ++--
>  arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
>  arch/arm64/kernel/cpufeature.c      |  8 ++++----
>  3 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 9bb9d11750d7..b7d9bb17908d 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -602,14 +602,14 @@ static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
>  {
>  	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
>  
> -	return val == ID_AA64PFR0_EL1_32BIT_64BIT;
> +	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
>  }
>  
>  static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
>  {
>  	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
>  
> -	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
> +	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
>  }
>  
>  static inline bool id_aa64pfr0_sve(u64 pfr0)
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 326f49e7bd42..0b773037251c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -784,14 +784,13 @@
>  #define ID_AA64PFR0_AMU			0x1
>  #define ID_AA64PFR0_SVE			0x1
>  #define ID_AA64PFR0_RAS_V1		0x1
> +#define ID_AA64PFR0_RAS_ANY		0xf

This doesn't correspond to an architectural definition afaict: the manual
says that any values other than 0, 1 or 2 are "reserved" so we should avoid
defining our own definitions here.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
