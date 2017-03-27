From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 04/10] KVM: arm/arm64: vgic: Only set underflow when
 actually out of LRs
Date: Mon, 27 Mar 2017 11:59:12 +0100
Message-ID: <4205a35a-d183-8c7b-3b3f-534a52e8ccab@arm.com>
References: <20170321211059.8719-1-cdall@linaro.org>
 <20170321211059.8719-5-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3B840AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 06:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VQecZRg+dCFf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 06:57:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37FB140A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 06:57:18 -0400 (EDT)
In-Reply-To: <20170321211059.8719-5-cdall@linaro.org>
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
> We currently assume that all the interrupts in our AP list will be
> queued to LRs, but that's not necessarily the case, because some of them
> could have been migrated away to different VCPUs and only the VCPU
> thread itself can remove interrupts from its AP list.
> 
> Therefore, slightly change the logic to only setting the underflow
> interrupt when we actually run out of LRs.
> 
> As it turns out, this allows us to further simplify the handling in
> vgic_sync_hwstate in later patches.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
