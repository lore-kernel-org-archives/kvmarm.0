From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 13/20] arm64: cpufeature: Enable IESB on exception
 entry/return for firmware-first
Date: Wed, 18 Oct 2017 17:43:10 +0100
Message-ID: <20171018164309.ecwsk7qjmkyevos4@armageddon.cambridge.arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
 <20171005191812.5678-14-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2DE049D09
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 12:42:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZO0FNjizC7F for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 12:42:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7D640A74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 12:42:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171005191812.5678-14-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 05, 2017 at 08:18:05PM +0100, James Morse wrote:
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b68f5e93baac..29df2a93688c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -989,6 +989,21 @@ config ARM64_RAS_EXTN
>  	  and access the new registers if the system supports the extension.
>  	  Platform RAS features may additionally depend on firmware support.
>  
> +config ARM64_IESB
> +	bool "Enable Implicit Error Synchronization Barrier (IESB)"
> +	default y
> +	depends on ARM64_RAS_EXTN
> +	help
> +	  ARM v8.2 adds a feature to add implicit error synchronization
> +	  barriers whenever the CPU enters or exits a particular exception
> +	  level.
> +
> +	  On CPUs with this feature and the 'RAS Extensions' feature, we can
> +	  use this to contain detected (but not yet reported) errors to the
> +	  relevant exception level.
> +
> +	  The feature is detected at runtime, selecting this option will
> +	  enable these implicit barriers if the CPU supports the feature.
>  endmenu

What's the use-case for not having this option always enabled?

-- 
Catalin
