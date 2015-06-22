From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Mon, 22 Jun 2015 10:31:16 +0200
Message-ID: <5587C7D4.2010408@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <011e01d0aa5a$6b14fae0$413ef0a0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF94655DA1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 04:20:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f8Ym1P+bc7K9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2015 04:20:48 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7736455C7F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 04:20:48 -0400 (EDT)
Received: by wgck11 with SMTP id k11so7345227wgc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 01:31:38 -0700 (PDT)
In-Reply-To: <011e01d0aa5a$6b14fae0$413ef0a0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 06/19/2015 08:37 AM, Pavel Fedin wrote:
>  Hello!
> 
>> The series therefore allows and mandates the usage of KVM_SET_GSI_ROUTING
>> ioctl along with KVM_IRQFD. If the userspace does not define any routing
>> table, no irqfd injection can happen. The user-space can use
>> KVM_CAP_IRQ_ROUTING to detect whether a routing table is needed.
> 
>  Yesterday, half-sleeping in the train back home, i've got a simple idea how to resolve
> conflicts with existing static GSI->SPI routing without bringing in any more
> inconsistencies.
>  So far, in current implementation GSI is an SPI index (let alone KVM_IRQ_LINE, because
> it's already another story on ARM). In order to maintain this convention we could simply
> implement default routing which sets all GSIs to corresponding SPI pins. So, if the
> userland never cares about KVM_SET_GSI_ROUTING, everything works as before. But it will be
> possible to re-route GSIs to MSI. It will perfectly work because SPI signaling is used
> with GICv2m, and MSI with GICv3(+), which cannot be used at the same time.
I agree with you and I suggested the same approach in my cover letter.
Since applying GSI routing to KVM_IRQ_LINE is quite problematic, I would
be also in favour to forbid userspace GSI routing setting and implement
it kernel-side. Userspace would only be allowed to define MSI routing
entries.

I will respin accordingly and validate it further with qemu.

Best Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
