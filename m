From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 03/33] irqchip/gic-v3-its: Refactor command
 encoding
Date: Mon, 13 Feb 2017 10:54:34 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131039340.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B3D40BC4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 04:53:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IF+V-HXpAmhk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 04:53:57 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6CE040A63
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 04:53:57 -0500 (EST)
In-Reply-To: <1484648454-21216-4-git-send-email-marc.zyngier@arm.com>
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
> +static void its_mask_encode(u64 *raw_cmd, u64 val, int h, int l)

I'd rather name h/l in a way which makes it clear that they are describing
a bit range. msb/lsb perhaps.

> +{
> +	u64 mask = GENMASK_ULL(h, l);

New line missing here.

> +	*raw_cmd &= ~mask;
> +	*raw_cmd |= (val << l) & mask;
> +}
> +
>  static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
>  {
> -	cmd->raw_cmd[0] &= ~0xffULL;
> -	cmd->raw_cmd[0] |= cmd_nr;
> +	its_mask_encode(&cmd->raw_cmd[0], cmd_nr, 7, 0);

I assume that the manual provides a name for these bit ranges. Wouldn't it
be helpful to use them in these functions?

Looks good otherwise.

Thanks,

	tglx
