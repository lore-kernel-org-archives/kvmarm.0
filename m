From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 25/55] KVM: arm/arm64: vgic-new: Add PENDING registers
 handlers
Date: Tue, 10 May 2016 11:49:57 +0100
Message-ID: <5731BCD5.4040806@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-26-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D77F49B9C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 06:47:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8TOQj8ksnh5W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2016 06:47:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3B249BA4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 06:47:06 -0400 (EDT)
In-Reply-To: <1462531568-9799-26-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> The pending register handlers are shared between the v2 and v3
> emulation, so their implementation goes into vgic-mmio.c, to be easily
> referenced from the v3 emulation as well later.
> For level triggered interrupts the real line level is unaffected by
> this write, so we keep this state separate and combine it with the
> device's level to get the actual pending state.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
