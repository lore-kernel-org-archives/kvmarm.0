Return-Path: <SRS0=Zv6D=ZG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91354C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 10:27:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DB8720723
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 10:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DB8720723
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3E34AEBE;
	Thu, 14 Nov 2019 05:27:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tzVp+9254D7x; Thu, 14 Nov 2019 05:27:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59FBA4AF07;
	Thu, 14 Nov 2019 05:27:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69B414ACD3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 05:27:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Vq-ge9OggQn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 05:27:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53DD94ACB3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 05:27:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00FB031B;
 Thu, 14 Nov 2019 02:27:34 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D69653F6C4;
 Thu, 14 Nov 2019 02:27:32 -0800 (PST)
Subject: Re: [PATCH v3 3/3] arm64: Workaround for Cortex-A55 erratum 1530923
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
References: <20191113172252.12610-1-steven.price@arm.com>
 <20191113172252.12610-4-steven.price@arm.com>
From: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <0b017ec9-5be1-90b9-be30-09462dec9e9d@arm.com>
Date: Thu, 14 Nov 2019 10:27:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191113172252.12610-4-steven.price@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 13/11/2019 17:22, Steven Price wrote:
> Cortex-A55 erratum 1530923 allows TLB entries to be allocated as a
> result of a speculative AT instruction. This may happen in the middle of
> a guest world switch while the relevant VMSA configuration is in an
> inconsistent state, leading to erroneous content being allocated into
> TLBs.
> 
> The same workaround as is used for Cortex-A76 erratum 1165522
> (WORKAROUND_SPECULATIVE_AT_NVE) can be used here. Note that this
> mandates the use of VHE on affected parts.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   Documentation/arm64/silicon-errata.rst |  2 ++
>   arch/arm64/Kconfig                     | 13 +++++++++++++
>   arch/arm64/include/asm/kvm_hyp.h       |  4 ++--
>   arch/arm64/kernel/cpu_errata.c         |  6 +++++-
>   arch/arm64/kvm/hyp/switch.c            |  4 ++--
>   arch/arm64/kvm/hyp/tlb.c               |  4 ++--
>   6 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
> index 899a72570282..b40cb3e0634e 100644
> --- a/Documentation/arm64/silicon-errata.rst
> +++ b/Documentation/arm64/silicon-errata.rst
> @@ -88,6 +88,8 @@ stable kernels.
>   +----------------+-----------------+-----------------+-----------------------------+
>   | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
>   +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A55      | #1530923        | ARM64_ERRATUM_1530923       |
> ++----------------+-----------------+-----------------+-----------------------------+
>   | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
>   +----------------+-----------------+-----------------+-----------------------------+
>   | ARM            | Neoverse-N1     | #1349291        | N/A                         |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index defb68e45387..d2dd72c19560 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -532,6 +532,19 @@ config ARM64_ERRATUM_1165522
>   
>   	  If unsure, say Y.
>   
> +config ARM64_ERRATUM_1530923
> +	bool "Cortex-A55: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
> +	default y
> +	select ARM64_WORKAROUND_SPECULATIVE_AT

ARM64_WORKAROUND_SPECULATIVE_AT_VHE ?

Otherwise looks good to me.

Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
