From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Wed, 24 Jun 2015 15:03:10 +0200
Message-ID: <558AAA8E.2010403@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org>
 <558920F7.9090301@arm.com> <558956E4.2050700@linaro.org>
 <01b901d0ae78$2bed39a0$83c7ace0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A146156D10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 08:52:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3SAODK7mOlK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 08:52:35 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E07A456D0F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 08:52:34 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so45873246wic.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 06:03:30 -0700 (PDT)
In-Reply-To: <01b901d0ae78$2bed39a0$83c7ace0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 06/24/2015 02:20 PM, Pavel Fedin wrote:
>  Hello!
> 
>> What I can simply do is preventing any non identity mapping for irqchip
>> routing entries, ie. gsi != irqchip.pin. This fixes the problem of
>> KVM_IRQ_LINE. This check can happen in arm kvm_set_routing_entry() and
>> that's it.
> 
>  You cannot fix problem of KVM_IRQ_LINE because anyway with this ioctl on ARM you should OR your
> value with (1 << 24), so this is actually not plain GSI any more.
>  KVM_IRQ_LINE is never used for triggering MSIs, so i think the easiest thing to do is to just leave
> it doing what it does.

Yes I agree with you. in my next version I simply aknowledge the fact
GSI_ROUTING does not apply to KVM_IRQ_LINE on arm/arm64 but only applies
to KVM_IRQFD.
> 
>  As to irqchip routing of irqfd's, why not? By default all GSIs would be SPIs, then this can be
> changed by userspace, or reverted back... Who cares? When using direct mapping qemu never calls
> routing functions, so it's OK.

Indeed either we leave fully open irqchip routing saying that
irqchip.pin corresponds to an SPI ID. But personally I would prefer we
check irqchip routing entries have flat mapping, ie gsi = irqchip.pin
since in any case we don't want/expect the userspace to play with that.

Best Regards

Eric
> 
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
