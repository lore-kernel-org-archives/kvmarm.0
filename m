From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/10] KVM: arm/arm64: vgic: Improve sync_hwstate
 performance
Date: Mon, 27 Mar 2017 12:04:26 +0100
Message-ID: <98d4f104-6c5e-9e2c-13ff-d4c8fbe23fd4@arm.com>
References: <20170321211059.8719-1-cdall@linaro.org>
 <20170321211059.8719-11-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6597340BDE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 07:02:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZVOjVF6vindz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 07:02:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9920D40BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 07:02:31 -0400 (EDT)
In-Reply-To: <20170321211059.8719-11-cdall@linaro.org>
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
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 21:10, Christoffer Dall wrote:
> There is no need to call any functions to fold LRs when we don't use any
> LRs and we don't need to mess with overflow flags, take spinlocks, or
> prune the AP list if the AP list is empty.
> 
> Note: list_empty is a single atomic read (uses READ_ONCE) and can
> therefore check if a list is empty or not without the need to take the
> spinlock protecting the list.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
