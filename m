From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Let vcpu thread modify its own active
 state
Date: Mon, 06 Mar 2017 14:38:14 +0000
Message-ID: <874lz631yh.fsf@on-the-bus.cambridge.arm.com>
References: <1488807757-86131-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBCDE40A69
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:37:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7nUNyyu9FwgR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:36:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF1940A66
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:36:59 -0500 (EST)
In-Reply-To: <1488807757-86131-1-git-send-email-christoffer.dall@linaro.org>
 (Christoffer Dall's message of "Mon, 6 Mar 2017 05:42:37 -0800")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 06 2017 at  1:42:37 pm GMT, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Jintack Lim <jintack@cs.columbia.edu>
>
> Currently, if a vcpu thread tries to change the active state of an
> interrupt which is already on the same vcpu's AP list, Since the VGIC
> mmio handler is called after a vcpu has already synced back the LR state
> to the struct vgic_irq, we can just let it proceed safely.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
