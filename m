From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 07/11] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Tue, 4 Aug 2015 16:33:52 +0200
Message-ID: <20150804143352.GF29335@cbox>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
 <1437753309-17989-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 201DF59FB1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2015 10:20:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tCnfX9wkPGZW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2015 10:20:24 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55F3459FB0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2015 10:20:24 -0400 (EDT)
Received: by labow3 with SMTP id ow3so8665491lab.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2015 07:33:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1437753309-17989-8-git-send-email-marc.zyngier@arm.com>
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

On Fri, Jul 24, 2015 at 04:55:05PM +0100, Marc Zyngier wrote:
> To allow a HW interrupt to be injected into a guest, we lookup the
> guest virtual interrupt in the irq_phys_map list, and if we have
> a match, encode both interrupts in the LR.
> 
> We also mark the interrupt as "active" at the host distributor level.
> 
> On guest EOI on the virtual interrupt, the host interrupt will be
> deactivated.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
