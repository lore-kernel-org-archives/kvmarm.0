From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Tue, 3 Jan 2017 15:55:02 +0000
Message-ID: <20170103155502.GA14183@leverpostej>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9610140797
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2017 10:54:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id axqtoZsV9y0g for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2017 10:54:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A2E406A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2017 10:54:29 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161229224335.13531-2-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Thu, Dec 29, 2016 at 05:43:32PM -0500, Christopher Covington wrote:
> +config QCOM_FALKOR_E1003_RESERVED_ASID
> +	int
> +	default 1
> +	depends on QCOM_FALKOR_ERRATUM_1003
> +

I don't think this needs to be configurable, so let's drop this into a
header, e.g. drop:

#define FALKOR_RESERVED_ASID	1

... in <asm/mmu_context.h>, protecting the rest with an ifndef
__ASSEMBLY__ guard.

[...]

> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
> +	mrs     x2, ttbr0_el1                   // get cuurent TTBR0_EL1
> +	mov     x3, #CONFIG_QCOM_FALKOR_ERRATUM_1003	// reserved ASID

Wrong macro? That's not the ASID.

Thanks,
Mark.
