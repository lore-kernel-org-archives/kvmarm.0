From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v6 06/10] irqchip/gic-v3: Gather all ACPI specific data in
 a single structure
Date: Sat, 23 Apr 2016 22:02:35 -0500
Message-ID: <571C374B.503@codeaurora.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-7-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 385A849B70
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:00:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+aLfYttPfp6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2016 23:00:31 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D76149B4C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:00:31 -0400 (EDT)
In-Reply-To: <1460388780-914-7-git-send-email-julien.grall@arm.com>
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
> The ACPI code requires to use global variables in order to collect
> information from the tables.
>
> To make clear those variables are ACPI specific, gather all of them in a
> single structure.
>
> Furthermore, even if some of the variables are not marked with
> __initdata, they are all only used during the initialization. Therefore,
> the new variable, which hold the structure, can be marked with
> __initdata.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
>
Tested-by: Shanker Donthineni <shankerd@codeaurora.org>

Using the Qualcomm Technologies QDF2XXX server platform.

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
