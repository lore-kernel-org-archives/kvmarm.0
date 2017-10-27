From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 02/20] arm64: Implement arch_counter_get_cntpct to
 read the physical counter
Date: Fri, 27 Oct 2017 11:53:24 +0100
Message-ID: <20171027105323.hvbewckytr5gbpph@armageddon.cambridge.arm.com>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
 <1509093281-15225-3-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A26349D19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:52:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t2bpX1vJUtyf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:52:04 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3534040638
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:52:04 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1509093281-15225-3-git-send-email-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 10:34:23AM +0200, Christoffer Dall wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> As we are about to use the physical counter on arm64 systems that have
> KVM support, implement arch_counter_get_cntpct() and the associated
> errata workaround functionality for stable timer reads.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Just in case you need an ack for the arch/arm64/ hunks:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
