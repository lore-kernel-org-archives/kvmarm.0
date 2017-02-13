From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 08/33] irqchip/gic-v3-its: Implement
 irq_set_irqchip_state for pending state
Date: Mon, 13 Feb 2017 11:28:00 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131127450.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-9-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36CE240966
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:27:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dcrSXV1zjWTH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 05:27:22 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7540440962
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:27:22 -0500 (EST)
In-Reply-To: <1484648454-21216-9-git-send-email-marc.zyngier@arm.com>
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

> Allow the pending state of an LPI to be set or cleared via
> irq_set_irqchip_state.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
