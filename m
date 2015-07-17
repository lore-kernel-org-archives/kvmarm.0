From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 09/10] KVM: arm/arm64: timer: Allow the timer to
 control the active state
Date: Sat, 18 Jul 2015 00:15:52 +0200
Message-ID: <20150717221552.GM14024@cbox>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
 <1436378202-20224-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E65958DE0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRpo2LokVdga for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 18:03:37 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DB4658E02
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:36 -0400 (EDT)
Received: by lahe2 with SMTP id e2so5883158lah.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 15:15:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436378202-20224-10-git-send-email-marc.zyngier@arm.com>
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

On Wed, Jul 08, 2015 at 06:56:41PM +0100, Marc Zyngier wrote:
> In order to remove the crude hack where we sneak the masked bit
> into the timer's control register, make use of the phys_irq_map
> API control the active state of the interrupt.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
