From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 07/33] irqchip/gic-v3-its: Macro-ize
 its_send_single_command
Date: Mon, 13 Feb 2017 11:24:46 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131122070.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A7840AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:24:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K858lykS2bCI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 05:24:09 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E924240AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:24:08 -0500 (EST)
In-Reply-To: <1484648454-21216-8-git-send-email-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:
> +
> +static __its_send_single_cmd(its_send_single_command, its_cmd_builder_t,
> +			     struct its_collection, its_build_sync_cmd)

I'm fine with that macro magic, but the above is very unintuitive as it
looks like a normal function.

The way this is done in other places is to have:

#define BUILD_CMD_FUNC(name,....) \
....

and then have

BUILD_CMD_FUNC(its_send_single_command, ....);

That makes it entirely obvious that this is macro magic.

Thanks,

	tglx
