From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/9] KVM: arm/arm64: vgic: Get rid of unnecessary
 save_maint_int_state
Date: Tue, 21 Mar 2017 11:44:37 +0000
Message-ID: <99019ceb-d811-dad1-c46e-77a9d2d05664@arm.com>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF39540BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:42:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xlG5pbByLmQ8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:42:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A038940BD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:42:53 -0400 (EDT)
In-Reply-To: <20170320105818.20481-6-cdall@linaro.org>
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

On 20/03/17 10:58, Christoffer Dall wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Now when we don't look at the MISR and EISR values anymore, we can get
> rid of the logic to save them in the GIC save/restore code.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
