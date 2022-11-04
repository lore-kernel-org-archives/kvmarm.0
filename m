Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF24EC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 11:47:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 978FB41066;
	Fri,  4 Nov 2022 07:47:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KAzmovWdnHB6; Fri,  4 Nov 2022 07:47:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB19849AF7;
	Fri,  4 Nov 2022 07:47:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8634940F59
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 07:30:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NxLDAOEJ9FP2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 07:30:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 292C740E00
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 07:30:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4A3E1FB;
 Fri,  4 Nov 2022 04:30:20 -0700 (PDT)
Received: from [10.57.69.48] (unknown [10.57.69.48])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEB5E3F703;
 Fri,  4 Nov 2022 04:30:10 -0700 (PDT)
Message-ID: <5c410969-2176-49cf-640f-8023c421682e@arm.com>
Date: Fri, 4 Nov 2022 11:30:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 0/7] perf: Arm SPEv1.2 support
Content-Language: en-US
To: Rob Herring <robh@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
From: James Clark <james.clark@arm.com>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
X-Mailman-Approved-At: Fri, 04 Nov 2022 07:47:47 -0400
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>, linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Brown <broonie@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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



On 19/10/2022 20:11, Rob Herring wrote:
> This series adds support for Arm SPEv1.2 which is part of the
> Armv8.7/Armv9.2 architecture. There's 2 new features that affect the 
> kernel: a new event filter bit, branch 'not taken', and an inverted 
> event filter register. 
> 
> Since this support adds new registers and fields, first the SPE register 
> defines are converted to automatic generation.
> 
> Note that the 'config3' addition in sysfs format files causes SPE to 
> break. A stable fix e552b7be12ed ("perf: Skip and warn on unknown format 
> 'configN' attrs") landed in v6.1-rc1.
> 
> The perf tool side changes are available here[1].
> 
> Tested on FVP.
> 
> [1] https://lore.kernel.org/all/20220914-arm-perf-tool-spe1-2-v2-v4-0-83c098e6212e@kernel.org/
> 

LGTM. Tested with [1] applied and on N1SDP (where it isn't supported),
and on the FVP. Enabling all the inverted filters results in no trace
and other combinations work as expected.

James

> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Changes in v2:
> - Convert the SPE register defines to automatic generation
> - Fixed access to SYS_PMSNEVFR_EL1 when not present
> - Rebase on v6.1-rc1
> - Link to v1: https://lore.kernel.org/r/20220825-arm-spe-v8-7-v1-0-c75b8d92e692@kernel.org
> 
> ---
> Rob Herring (7):
>       perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
>       arm64: Drop SYS_ from SPE register defines
>       arm64/sysreg: Convert SPE registers to automatic generation
>       perf: arm_spe: Drop BIT() and use FIELD_GET/PREP accessors
>       perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
>       perf: Add perf_event_attr::config3
>       perf: arm_spe: Add support for SPEv1.2 inverted event filtering
> 
>  arch/arm64/include/asm/el2_setup.h |   6 +-
>  arch/arm64/include/asm/sysreg.h    |  99 +++------------------------
>  arch/arm64/kvm/debug.c             |   2 +-
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c |   2 +-
>  arch/arm64/tools/sysreg            | 116 +++++++++++++++++++++++++++++++
>  drivers/perf/arm_spe_pmu.c         | 136 ++++++++++++++++++++++++-------------
>  include/uapi/linux/perf_event.h    |   3 +
>  7 files changed, 224 insertions(+), 140 deletions(-)
> ---
> base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
> change-id: 20220825-arm-spe-v8-7-fedf04e16f23
> 
> Best regards,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
