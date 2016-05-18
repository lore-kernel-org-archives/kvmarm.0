From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 48/56] KVM: arm/arm64: vgic-new: Add userland GIC CPU
 interface access
Date: Wed, 18 May 2016 16:02:24 +0200
Message-ID: <20160518140224.GQ3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-49-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C06E40FA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 09:58:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NFSJEhpmM43Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 09:58:22 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1385040C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 09:58:21 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id r12so36357875wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 07:01:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463392481-26583-49-git-send-email-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:36AM +0100, Andre Przywara wrote:
> Using the VMCR accessors we provide access to GIC CPU interface state
> to userland by wiring it up to the existing userland interface.
> [Marc: move and make VMCR accessors static, streamline MMIO handlers]
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
