From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v6 03/10] irqchip/gic-v2: Gather ACPI specific data in a
 single structure
Date: Sat, 23 Apr 2016 21:58:37 -0500
Message-ID: <571C365D.80605@codeaurora.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-4-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4545D49B70
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 22:56:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UlZIfTr5L8NN for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2016 22:56:31 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C11149B6F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 22:56:31 -0400 (EDT)
In-Reply-To: <1460388780-914-4-git-send-email-julien.grall@arm.com>
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
> For now, a single global variable is used, but more will be added in a
> subsequent patch. To make clear they are ACPI specific, gather all the
> information in a single structure.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Acked-by: Christofer Dall <christoffer.dall@linaro.org>
> Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
>
Tested-by: Shanker Donthineni <shankerd@codeaurora.org>

Using the Qualcomm Technologies QDF2XXX server platform.

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
