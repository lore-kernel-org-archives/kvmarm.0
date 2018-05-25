From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 00/15] ARM Spectre variant 2 fixes
Date: Fri, 25 May 2018 09:25:34 -0700
Message-ID: <20180525162534.GE98604@atomide.com>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 473BF49F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 12:15:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dxt4KR06SzUn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 12:14:52 -0400 (EDT)
Received: from muru.com (muru.com [72.249.23.125])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6658849F8B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 12:14:52 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180525135938.GE17671@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

* Russell King - ARM Linux <linux@armlinux.org.uk> [180525 07:02]:
> Third version:
> - Remove "PSCI" from the SMC version of the workaround as well.
> - Avoid reporting active workaround if the IBE bit is not set.
> - Only probe for workaround_1 on Cortex A57 and A72, or non-ARM CPUs.
> - Require features probe for workaround_1 to return zero.
> - Validation that all CPUs in the system have the same workaround status.
> - Avoid corrupting r12 in workaround_1 KVM hypervisor implementation.

Looks good to me and things still work for me. I don't really
want to count that as Tested-by though :) But feel free to add:

Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
