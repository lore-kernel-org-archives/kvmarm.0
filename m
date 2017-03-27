From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/10] KVM: arm/arm64: vgic: Get rid of unnecessary
 process_maintenance operation
Date: Mon, 27 Mar 2017 12:03:03 +0100
Message-ID: <b94b9e68-ee7f-a3d7-2c1f-7df9ebbcadc6@arm.com>
References: <20170321211059.8719-1-cdall@linaro.org>
 <20170321211059.8719-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBE640AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 07:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e1K7HH48vXvI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 07:01:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F17E140A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 07:01:08 -0400 (EDT)
In-Reply-To: <20170321211059.8719-6-cdall@linaro.org>
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
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Since we always read back the LRs that we wrote to the guest and the
> MISR and EISR registers simply provide a summary of the configuration of
> the bits in the LRs, there is really no need to read back those status
> registers and process them.  We can might as well just signal the
                                  ^^^
Typo.

> notifyfd when folding the LR state and save some cycles in the process.
> 
> We now clear the underflow bit in the fold_lr_state functions as we only
> need to clear this bit if we had used all the LRs, so this is as good a
> place as any to do that work.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
