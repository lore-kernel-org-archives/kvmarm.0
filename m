From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 01/13] arm/arm64: Add new is_kernel_in_hyp_mode predicate
Date: Thu, 9 Jul 2015 10:42:30 +0100
Message-ID: <20150709094230.GA20105@leverpostej>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75E3D582B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 05:31:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 93hYiZ1LwbP3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 05:31:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F424582A4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 05:31:22 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1436372356-30410-2-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

> +static inline bool is_kernel_in_hyp_mode(void)
> +{
> +	u64 el;
> +
> +	asm("mrs %0, CurrentEL" : "=r" (el));
> +	return el == CurrentEL_EL2;
> +}

If you can include cputype.h, I think this can be:

static inline bool is_kernel_in_hyp_mode(void)
{
	return read_cpuid(CurrentEL) == CurrentEL_EL2;
}

Mark.
