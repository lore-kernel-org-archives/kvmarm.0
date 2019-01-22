From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Tue, 22 Jan 2019 10:17:00 +0000
Message-ID: <20190122101657.GE3578@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3934A3C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 05:17:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3RuK4wbo5Hk1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 05:17:04 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 883D74A39F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 05:17:04 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190107120537.184252-1-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 07, 2019 at 12:05:35PM +0000, Andre Przywara wrote:
> Workarounds for Spectre variant 2 or 4 vulnerabilities require some help
> from the firmware, so KVM implements an interface to provide that for
> guests. When such a guest is migrated, we want to make sure we don't
> loose the protection the guest relies on.
> 
> This introduces two new firmware registers in KVM's GET/SET_ONE_REG
> interface, so userland can save the level of protection implemented by
> the hypervisor and used by the guest. Upon restoring these registers,
> we make sure we don't downgrade and reject any values that would mean
> weaker protection.

Just trolling here, but could we treat these as immutable, like the ID
registers?  

We don't support migration between nodes that are "too different" in any
case, so I wonder if adding complex logic to compare vulnerabilities and
workarounds is liable to create more problems than it solves...

Do we know of anyone who explicitly needs this flexibility yet?

[...]

Cheers
---Dave
