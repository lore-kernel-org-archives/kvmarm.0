From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Fix GICC_PMR uaccess on GICv3 and
 clarify ABI
Date: Wed, 22 Mar 2017 09:58:36 +0000
Message-ID: <15b51bbf-aeb9-fe7c-1c64-66a4c40faa91@arm.com>
References: <20170321210522.8362-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C9340AE8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 05:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UF60aUs92aGx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 05:56:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A095A40A6A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 05:56:51 -0400 (EDT)
In-Reply-To: <20170321210522.8362-1-cdall@linaro.org>
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
Cc: Andre Przywara <andre.przywara@arm.com>, Vijaya.Kumar@cavium.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 21:05, Christoffer Dall wrote:
> As an oversight, for GICv2, we accidentally export the GICC_PMR register
> in the format of the GICH_VMCR.VMPriMask field in the lower 5 bits of a
> word, meaning that userspace must always use the lower 5 bits to
> communicate with the KVM device and must shift the value left by 3
> places to obtain the actual priority mask level.
> 
> Since GICv3 supports the full 8 bits of priority masking in the ICH_VMCR,
> we have to fix the value we export when emulating a GICv2 on top of a
> hardware GICv3 and exporting the emulated GICv2 state to userspace.
> 
> Take the chance to clarify this aspect of the ABI.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
