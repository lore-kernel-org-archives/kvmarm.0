Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B39C38A29
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 10:32:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3183F21556
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 10:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3183F21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77E74B261;
	Wed, 15 Apr 2020 06:32:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HqU1GozLgTEP; Wed, 15 Apr 2020 06:32:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B11F4B1FB;
	Wed, 15 Apr 2020 06:32:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05DCE4B1FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 06:32:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1-QQU1hW8b+m for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 06:32:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC944B18D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 06:32:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D90B1063;
 Wed, 15 Apr 2020 03:32:00 -0700 (PDT)
Received: from [10.37.12.1] (unknown [10.37.12.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A70563F68F;
 Wed, 15 Apr 2020 03:31:58 -0700 (PDT)
Subject: Re: [PATCH 5/8] arm64: cpufeature: Factor out checking of AArch32
 features
To: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20200414213114.2378-1-will@kernel.org>
 <20200414213114.2378-6-will@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <95817087-122e-0392-9474-c17ad1f926d2@arm.com>
Date: Wed, 15 Apr 2020 11:36:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200414213114.2378-6-will@kernel.org>
Content-Language: en-US
Cc: saiprakash.ranjan@codeaurora.org, anshuman.khandual@arm.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, dianders@chromium.org, catalin.marinas@arm.com,
 kernel-team@android.com
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

On 04/14/2020 10:31 PM, Will Deacon wrote:
> update_cpu_features() is pretty large, so split out the checking of the
> AArch32 features into a separate function and call it after checking the
> AArch64 features.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kernel/cpufeature.c | 108 +++++++++++++++++++--------------
>   1 file changed, 61 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 7dfcdd9e75c1..32828a77acc3 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -715,6 +715,65 @@ static int check_update_ftr_reg(u32 sys_id, int cpu, u64 val, u64 boot)
>   	return 1;
>   }
>   
> +static int update_32bit_cpu_features(int cpu, struct cpuinfo_arm64 *info,
> +				     struct cpuinfo_arm64 *boot)
> +{

...

> -
>   	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
>   		taint |= check_update_ftr_reg(SYS_ZCR_EL1, cpu,
>   					info->reg_zcr, boot->reg_zcr);
> @@ -845,6 +857,8 @@ void update_cpu_features(int cpu,
>   			sve_update_vq_map();
>   	}
>   
> +	taint |= update_32bit_cpu_features(cpu, info, boot);
> +

This relies on the assumption that the id_aa64pfr0 has been sanitised. 
It may be worth adding a comment to make sure people (hacking the
kernel) don't move this around and break that dependency.

Either ways:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
