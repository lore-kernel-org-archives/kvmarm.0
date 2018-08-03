From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v2 4/4] arm/arm64: GICv2: add
 GICD_ITARGETSR testing
Date: Fri, 3 Aug 2018 15:13:05 +0200
Message-ID: <20180803131305.rshrvokhexqpwu5y@kamzik.brq.redhat.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
 <20180720153942.26821-5-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA52C4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Aug 2018 09:13:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AUzFCntVZ91U for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Aug 2018 09:13:09 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16CA049FA8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Aug 2018 09:13:09 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180720153942.26821-5-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 20, 2018 at 04:39:42PM +0100, Andre Przywara wrote:
> Some tests for the ITARGETS registers.
> Bits corresponding to non-existent CPUs must be RAZ/WI.
> These registers must be byte-accessible, also check that accesses beyond
> the implemented IRQ limit are actually read-as-zero/write-ignore.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c         | 43 +++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/gic.h |  1 +
>  2 files changed, 44 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
