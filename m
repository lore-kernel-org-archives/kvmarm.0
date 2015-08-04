From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 04/11] KVM: arm/arm64: vgic: Allow HW irq to be
 encoded in LR
Date: Tue, 4 Aug 2015 16:33:46 +0200
Message-ID: <20150804143346.GE29335@cbox>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
 <1437753309-17989-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC2E59F2B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2015 10:20:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pusz1scd4yFg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2015 10:20:19 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7097959F21
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2015 10:20:19 -0400 (EDT)
Received: by lbbpo9 with SMTP id po9so7205602lbb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2015 07:33:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1437753309-17989-5-git-send-email-marc.zyngier@arm.com>
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

On Fri, Jul 24, 2015 at 04:55:02PM +0100, Marc Zyngier wrote:
> Now that struct vgic_lr supports the LR_HW bit and carries a hwirq
> field, we can encode that information into the list registers.
> 
> This patch provides implementations for both GICv2 and GICv3.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
