From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [RFC PATCH 11/33] irqchip/gic-v3-its: Split out pending table
 allocation
Date: Mon, 13 Feb 2017 16:31:18 -0600
Message-ID: <659c374d-c437-4474-2c2f-4f1fd5e173dc@codeaurora.org>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-12-git-send-email-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BD7640A69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 17:30:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jEZOZyEMcwJp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 17:30:38 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27FC240A54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 17:30:37 -0500 (EST)
In-Reply-To: <1484648454-21216-12-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,


On 01/17/2017 04:20 AM, Marc Zyngier wrote:
> Just as for the property table, let's move the pending table
> allocation to a separate function.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 29 ++++++++++++++++++++---------
>   1 file changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c
> b/drivers/irqchip/irq-gic-v3-its.c
> index 14305db1..dce8f8c 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1188,6 +1188,24 @@ static int its_alloc_collections(struct its_node
> *its)
>   	return 0;
>   }
>   
> +static struct page *its_allocate_pending_table(gfp_t gfp_flags)
> +{
PEND and PROP table sizes are defined as compile time macros, but as per 
ITS spec implementation 24bit LPI space is also possible. It would be 
nicer to parametrize
both the tables sizes so that it would easier to enable 24bit LPI later.

Actually Qualcomm server chips support 24bit IDBITS.

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
