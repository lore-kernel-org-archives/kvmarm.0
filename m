From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 4/7] arm/arm64: vgic-new: Define required GICv3 reg
 definitions
Date: Tue, 20 Sep 2016 10:50:46 +0100
Message-ID: <57E10676.9080509@arm.com>
References: <1474351965-11586-1-git-send-email-vijay.kilari@gmail.com>
 <1474351965-11586-5-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E52413E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2016 05:41:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F52m4UkfLmZI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2016 05:41:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF59412ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2016 05:41:47 -0400 (EDT)
In-Reply-To: <1474351965-11586-5-git-send-email-vijay.kilari@gmail.com>
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

On 20/09/16 07:12, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Define register definitions for ICH_VMCR_EL2, ICC_CTLR_EL1 and
> ICH_VTR_EL2, ICC_BPR0_EL1, ICC_BPR1_EL1 registers.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

$SUBJECT should report "irqchip/gic-v3: Add missing system register
definitions", or something similar.

Also, please drop this "vgic-new", as there is no vgic-old anymore.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
