From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/52] genirq: Let irq_set_vcpu_affinity() iterate
 over hierarchy
Date: Tue, 4 Jul 2017 23:15:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1707042315370.2131@nanos>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
 <20170628150411.15846-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2BD40D2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 17:15:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XDaxB7WcCcwk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jul 2017 17:15:35 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1517C40D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 17:15:34 -0400 (EDT)
In-Reply-To: <20170628150411.15846-2-marc.zyngier@arm.com>
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



On Wed, 28 Jun 2017, Marc Zyngier wrote:

> When assigning an interrupt to a vcpu, it is not unlikely that
> the level of the hierarchy implementing irq_set_vcpu_affinity
> is not the top level (think a generic MSI domain on top of a
> virtualization aware interrupt controller).
> 
> In such a case, let's iterate over the hierarchy until we find
> an irqchip implementing it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
