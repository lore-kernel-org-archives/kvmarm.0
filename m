From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v6 10/10] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Sat, 23 Apr 2016 22:33:54 -0500
Message-ID: <571C3EA2.1030001@codeaurora.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-11-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7AF49B51
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:31:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kXXIl7213FUn for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2016 23:31:48 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8056249B4C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:31:48 -0400 (EDT)
In-Reply-To: <1460388780-914-11-git-send-email-julien.grall@arm.com>
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
Cc: kvm@vger.kernel.org, al.stone@linaro.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, hanjun.guo@linaro.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/11/2016 10:33 AM, Julien Grall wrote:
> The only call of arch_timer_get_timecounter (in KVM) has been removed.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Tested-by: Shanker Donthineni <shankerd@codeaurora.org>

Using the Qualcomm Technologies QDF2XXX server.

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
