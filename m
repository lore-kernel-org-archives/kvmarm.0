From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 20/55] KVM: arm/arm64: vgic-new: Implement
 kvm_vgic_vcpu_pending_irq
Date: Tue, 10 May 2016 16:18:31 +0200
Message-ID: <20160510141831.GH27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-21-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9445449BA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 10:15:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iQGbVKK0YdFi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2016 10:15:02 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C3C349B9B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 10:15:01 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id a17so30729889wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 07:17:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462531568-9799-21-git-send-email-andre.przywara@arm.com>
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

On Fri, May 06, 2016 at 11:45:33AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> Tell KVM whether a particular VCPU has an IRQ that needs handling
> in the guest. This is used to decide whether a VCPU is runnable.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
