From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 0/4] support exception state migration and set
 VSESR_EL2 by user space
Date: Fri, 20 Jul 2018 11:13:12 +0100
Message-ID: <c79facd4-0048-1733-1c8a-00fb2cd061b1@arm.com>
References: <20180719152425.6696-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9756F49FA8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 06:00:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KgbiUBpKQl3o for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jul 2018 06:00:08 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 950AC40192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 06:00:08 -0400 (EDT)
In-Reply-To: <20180719152425.6696-1-james.morse@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvm-devel <kvm@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, gengdongjiu <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 19/07/18 16:24, James Morse wrote:
> Hi guys,
> 
> Changes since v8: expanded the documentation based on feedback.
> 
> This series adds the get/set events API to KVM for arm/arm64 so that
> user-space can migrate pending SError, (which KVM may have made pending
> as part of its device emulation), and for RAS make a new SError with a
> specific ESR value pending. (Only systems with the v8.2 RAS Extensions
> can specify an ESR, KVM advertises this capability with a new cap:
> KVM_CAP_ARM_INJECT_SERROR_ESR)
> 
> User-space can use this for emulation of the v8.2 CPU RAS features
> (using error nodes backed by mmio) or as part of NOTIFY_SEI which
> extends a v8.2 RAS SError to also have firmware-first CPER records.

Applied to kvmarm/next.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
