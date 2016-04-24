From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v6 07/10] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Sat, 23 Apr 2016 22:05:30 -0500
Message-ID: <571C37FA.2020802@codeaurora.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-8-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0306149B70
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:03:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bStIzVo1ajA3 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2016 23:03:25 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63B8249B4C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:03:24 -0400 (EDT)
In-Reply-To: <1460388780-914-8-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, al.stone@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, hanjun.guo@linaro.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu



On 04/11/2016 10:32 AM, Julien Grall wrote:
> Fill up the recently introduced gic_kvm_info with the hardware
> information used for virtualization.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
>
Tested-by: Shanker Donthineni <shankerd@codeaurora.org>

Using the Qualcomm Technologies QDF2XXX server platform.

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
