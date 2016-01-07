From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 02/20] KVM: ARM64: Define PMU data structure for each
 vcpu
Date: Thu, 07 Jan 2016 10:21:45 +0000
Message-ID: <568E3C39.2020909@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-3-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37D3F412A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 05:18:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKvM6ubB5F2n for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 05:18:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 171E1412A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 05:18:07 -0500 (EST)
In-Reply-To: <1450771695-11948-3-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:07, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Here we plan to support virtual PMU for guest by full software
> emulation, so define some basic structs and functions preparing for
> futher steps. Define struct kvm_pmc for performance monitor counter and
> struct kvm_pmu for performance monitor unit for each vcpu. According to
> ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.
> 
> Since this only supports ARM64 (or PMUv3), add a separate config symbol
> for it.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
