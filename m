From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 01/10] KVM: arm/arm64: vgic: Defer touching GICH_VMCR
 to vcpu_load/put
Date: Mon, 27 Mar 2017 11:49:39 +0100
Message-ID: <5cdcadc0-c6c4-bb11-5a70-83f3a00a6532@arm.com>
References: <20170321211059.8719-1-cdall@linaro.org>
 <20170321211059.8719-2-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9363140AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 06:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N+evBnwoQ0fk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 06:47:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB7640A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 06:47:45 -0400 (EDT)
In-Reply-To: <20170321211059.8719-2-cdall@linaro.org>
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
Cc: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 21:10, Christoffer Dall wrote:
> From: Christoffer Dall <cdall@cs.columbia.edu>
> 
> We don't have to save/restore the VMCR on every entry to/from the guest,
> since on GICv2 we can access the control interface from EL1 and on VHE
> systems with GICv3 we can access the control interface from KVM running
> in EL2.
> 
> GICv3 systems without VHE become the rare case, which have to
> save/restore the register in the put/load functions by doing an extra
> jump to EL2 to access the EL2-only register state.
> 
> Note that userspace accesses may see out-of-date values if the VCPU is
> running while accessing the VGIC state via the KVM device API, but this
> is already the case and it is up to userspace to quiesce the CPUs before
> reading the CPU registers from the GIC for an up-to-date view.
> 
> Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
