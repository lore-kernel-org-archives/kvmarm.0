From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 38/55] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM
 device ops registration
Date: Fri, 13 May 2016 12:11:47 +0200
Message-ID: <20160513101147.GA16274@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-39-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AEFC49B3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 06:08:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J6Gv1yNAi--k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2016 06:08:07 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15CC449B37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 06:08:06 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id g17so21744004wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 03:11:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462531568-9799-39-git-send-email-andre.przywara@arm.com>
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

On Fri, May 06, 2016 at 11:45:51AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> This patch introduces the skeleton for the KVM device operations
> associated to KVM_DEV_TYPE_ARM_VGIC_V2 and KVM_DEV_TYPE_ARM_VGIC_V3.
> 
> At that stage kvm_vgic_create is stubbed.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
