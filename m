From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH] arm64: KVM: fix perf cycle counter support for VHE
Date: Tue, 30 Apr 2019 10:58:10 +0100
Message-ID: <20190430095810.GG22493@e119886-lin.cambridge.arm.com>
References: <20190429191305.21000-1-andrew.murray@arm.com>
 <8022b69e-f4aa-cc06-0d5a-5ef980cf0d4a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 706A84A4C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Apr 2019 05:58:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PCoBAcpkP+k8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Apr 2019 05:58:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E814A4A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Apr 2019 05:58:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <8022b69e-f4aa-cc06-0d5a-5ef980cf0d4a@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 30, 2019 at 10:14:58AM +0100, Marc Zyngier wrote:
> [+ Christoffer, James, Julien]
> 
> Hi Andrew,
> 
> On 29/04/2019 20:13, Andrew Murray wrote:
> > The kvm_vcpu_pmu_{read,write}_evtype_direct functions do not handle
> > the cycle counter use-case, this leads to inaccurate counts and a
> > WARN message when using perf with the cycle counter (-e cycle).
> > 
> > Let's fix this by adding a use case for pmccfiltr_el0.
> > 
> > Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> 
> Queued, with
> Fixes: 39e3406a090a ("arm64: KVM: Avoid isb's by using direct pmxevtyper
> sysreg")
> 
> In the future, please cc all the KVM/arm maintainers/reviewers so that
> we do not risk overseeing an important patch.

OK I will do.

Thanks,

Andrew Murray

> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
