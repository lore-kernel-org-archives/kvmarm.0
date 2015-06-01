From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm: vgic: Drop useless Group0 warning
Date: Mon, 1 Jun 2015 12:05:46 +0200
Message-ID: <20150601100546.GA28473@cbox>
References: <1432917015-31439-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0689752758
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 05:55:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3yZSTUe+JeDT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jun 2015 05:55:15 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B12205274D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 05:55:15 -0400 (EDT)
Received: by labko7 with SMTP id ko7so93749003lab.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Jun 2015 03:05:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1432917015-31439-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 29, 2015 at 05:30:15PM +0100, Marc Zyngier wrote:
> If a GICv3-enabled guest tries to configure Group0, we print a
> warning on the console (because we don't support Group0 interrupts).
> 
> This is fairly pointless, and would allow a guest to spam the
> console. Let's just drop the warning.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
