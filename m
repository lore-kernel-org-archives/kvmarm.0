From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 02/10] KVM: arm/arm64: vgic: Avoid flushing vgic state
 when there's no pending IRQ
Date: Mon, 27 Mar 2017 11:52:23 +0100
Message-ID: <bd56c2b3-bd4e-dd42-61bf-2ec1f81dba38@arm.com>
References: <20170321211059.8719-1-cdall@linaro.org>
 <20170321211059.8719-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6446F40AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 06:50:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bBA3161yluEP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 06:50:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975A640A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 06:50:29 -0400 (EDT)
In-Reply-To: <20170321211059.8719-3-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 21:10, Christoffer Dall wrote:
> From: Shih-Wei Li <shihwei@cs.columbia.edu>
> 
> We do not need to flush vgic states in each world switch unless
> there is pending IRQ queued to the vgic's ap list. We can thus reduce
> the overhead by not grabbing the spinlock and not making the extra
> function call to vgic_flush_lr_state.
> 
> Note: list_empty is a single atomic read (uses READ_ONCE) and can
> therefore check if a list is empty or not without the need to take the
> spinlock protecting the list.
> 
> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
