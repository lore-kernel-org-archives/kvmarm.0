Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E59C3F2CD
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 16:51:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 946A724697
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 16:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 946A724697
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D18B4AF63;
	Fri, 28 Feb 2020 11:51:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bviBm6aUJRpe; Fri, 28 Feb 2020 11:51:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67644AFEC;
	Fri, 28 Feb 2020 11:51:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CE514AFD5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 11:51:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MvB4BNGLJd4j for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 11:51:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D0E4AF63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 11:51:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3BD731B;
 Fri, 28 Feb 2020 08:51:25 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3CE83F73B;
 Fri, 28 Feb 2020 08:51:24 -0800 (PST)
Date: Fri, 28 Feb 2020 16:51:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v5 2/3] KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
Message-ID: <20200228165122.GL36089@lakrids.cambridge.arm.com>
References: <1580125469-23887-1-git-send-email-andrew.murray@arm.com>
 <1580125469-23887-3-git-send-email-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1580125469-23887-3-git-send-email-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jan 27, 2020 at 11:44:28AM +0000, Andrew Murray wrote:
> We currently expose the PMU version of the host to the guest via
> emulation of the DFR0_EL1 and AA64DFR0_EL1 debug feature registers.
> However many of the features offered beyond PMUv3 for 8.1 are not
> supported in KVM. Examples of this include support for the PMMIR
> registers (added in PMUv3 for ARMv8.4) and 64-bit event counters
> added in (PMUv3 for ARMv8.5).
> 
> Let's trap the Debug Feature Registers in order to limit
> PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.1
> to avoid unexpected behaviour.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  5 +++++
>  arch/arm64/kvm/sys_regs.c       | 11 +++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6e919fa..1009878 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -672,6 +672,11 @@
>  #define ID_AA64DFR0_TRACEVER_SHIFT	4
>  #define ID_AA64DFR0_DEBUGVER_SHIFT	0
>  
> +#define ID_DFR0_PERFMON_SHIFT		24
> +
> +#define ID_DFR0_EL1_PMUVER_8_1		4
> +#define ID_AA64DFR0_EL1_PMUVER_8_1	4
> +
>  #define ID_ISAR5_RDM_SHIFT		24
>  #define ID_ISAR5_CRC32_SHIFT		16
>  #define ID_ISAR5_SHA2_SHIFT		12
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9f21659..3f0f3cc 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1085,6 +1085,17 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>  			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
>  			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> +	} else if (id == SYS_ID_AA64DFR0_EL1) {
> +		/* Limit guests to PMUv3 for ARMv8.1 */
> +		val = cpuid_feature_cap_signed_field_width(val,
> +						ID_AA64DFR0_PMUVER_SHIFT,
> +						4, ID_AA64DFR0_EL1_PMUVER_8_1);
> +	} else if (id == SYS_ID_DFR0_EL1) {
> +		/* Limit guests to PMUv3 for ARMv8.1 */
> +		val = cpuid_feature_cap_signed_field_width(val,
> +						ID_DFR0_PERFMON_SHIFT,
> +						4, ID_DFR0_EL1_PMUVER_8_1);
> +

Unfortunately, ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon don't
follow the usual ID scheme, and cannot be treated as signed fields.

Per ARM DDI 0487E.a, page D13-2825, they follow an alternative scheme
that is treated as unsigned, with 0xF additionally being treated as an
architected PMU version not being implemented. For KVM we'll want to
convert 0xF to 0x0.

I'll respin these patches accordingly.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
