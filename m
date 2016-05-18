From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 20/56] KVM: arm/arm64: vgic-new: Add GICv3 world
 switch backend
Date: Wed, 18 May 2016 16:14:38 +0200
Message-ID: <20160518141438.GB6666@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-21-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7FA6412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:10:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6mFrkyySpkhs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 10:10:36 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24482412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:10:36 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id r12so36938260wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 07:13:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463392481-26583-21-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:08AM +0100, Andre Przywara wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> As the GICv3 virtual interface registers differ from their GICv2
> siblings, we need different handlers for processing maintenance
> interrupts and reading/writing to the LRs.
> Implement the respective handler functions and connect them to
> existing code to be called if the host is using a GICv3.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
