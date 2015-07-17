From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 08/10] KVM: arm/arm64: vgic: Add
 vgic_{get,set}_phys_irq_active
Date: Sat, 18 Jul 2015 00:15:47 +0200
Message-ID: <20150717221547.GL14024@cbox>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
 <1436378202-20224-9-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD70E58DF4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E1P4VSGQPaL4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 18:03:32 -0400 (EDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
 [209.85.217.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAE3558DE0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:31 -0400 (EDT)
Received: by lbbzr7 with SMTP id zr7so68300009lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 15:15:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436378202-20224-9-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 06:56:40PM +0100, Marc Zyngier wrote:
> In order to control the active state of an interrupt, introduce
> a pair of accessors allowing the state to be set/queried.
> 
> This only affects the logical state, and the HW state will only be
> applied at world-switch time.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
