From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/6] irqchip: GICv2/v3: Add support for irq_vcpu_affinity
Date: Wed, 12 Aug 2015 15:21:40 +0100
Message-ID: <55CB5674.2080209@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <55C9C939.2020408@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C4C5AC51
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 10:08:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5U51unwnwTho for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 10:08:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B255AC4A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 10:08:36 -0400 (EDT)
In-Reply-To: <55C9C939.2020408@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/08/15 11:06, Eric Auger wrote:
> Hi Marc,
> 
> The series works fine with KVM platform device passthrough use case
> (Calxeda Midway, GICv2, SPI assignment with VFIO). My integration branch
> can be found at
> https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc6-irq-forward-v3
> if useful.
> 
> Tested-by: Eric Auger <eric.auger@linaro.org>

Many thanks for trying it (and for the review). I'll post an updated
version soon.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
