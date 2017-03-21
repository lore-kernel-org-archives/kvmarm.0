From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 8/9] KVM: arm/arm64: vgic: Don't check vgic_initialized in
 flush_hwstate
Date: Tue, 21 Mar 2017 12:08:15 +0000
Message-ID: <96b0efe2-d764-7b52-8335-0383a9357a1f@arm.com>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-9-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCA7F40BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 08:06:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SoddextYreas for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 08:06:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ACD540969
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 08:06:31 -0400 (EDT)
In-Reply-To: <20170320105818.20481-9-cdall@linaro.org>
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
> Now when we do an early init of the static parts of the VGIC data
> structures, we can do things like checking if the AP lists are empty
> directly without having to explicitly check if the vgic is initialized
> and reduce a bit of work in our criticial path.

                                  critical

> Note: list_empty is a single atomic read (uses READ_ONCE) and can
> therefore check if a list is empty or not without the need to take the
> spinlock protecting the list.

This note might be better placed in patch #2.

> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
