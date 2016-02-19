From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4.1] arm64: perf: Count EL2 events if the kernel is
 running in HYP
Date: Fri, 19 Feb 2016 14:30:31 +0000
Message-ID: <20160219143031.GI27062@arm.com>
References: <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
 <1455731859-26690-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8A9497BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 09:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GUEgauFciD8t for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2016 09:24:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4327049794
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 09:24:01 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1455731859-26690-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 05:57:39PM +0000, Marc Zyngier wrote:
> When the kernel is running in HYP (with VHE), it is necessary to
> include EL2 events if the user requests counting kernel or
> hypervisor events.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/perf_event.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Will
