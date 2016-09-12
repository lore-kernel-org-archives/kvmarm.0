From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 0/5] arm/arm64: vgic-new: Implement API for vGICv3 live
 migration
Date: Mon, 12 Sep 2016 14:15:47 +0100
Message-ID: <57D6AA83.6060208@arm.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F2F410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 09:07:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5yWh3ZWOw6zp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 09:07:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49BB640F90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 09:07:10 -0400 (EDT)
In-Reply-To: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/09/16 13:22, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> This patchset adds API for saving and restoring
> of VGICv3 registers to support live migration with new vgic feature.
> This API definition is as per version of VGICv3 specification
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> 
> Compatible live migration QEMU patches will be sent later.

Could you please point to the QEMU patches as well? I need to be able to
test the this infrastructure.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
