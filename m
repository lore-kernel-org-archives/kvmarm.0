From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Thu, 02 Jul 2015 16:50:47 +0200
Message-ID: <55954FC7.3070604@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
 <018f01d0b4a2$d74e29f0$85ea7dd0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0269B5779A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 10:39:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id saybTKtV93zo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 10:39:49 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E75885778B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 10:39:48 -0400 (EDT)
Received: by wguu7 with SMTP id u7so65459532wgu.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 07:51:05 -0700 (PDT)
In-Reply-To: <018f01d0b4a2$d74e29f0$85ea7dd0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/02/2015 10:41 AM, Pavel Fedin wrote:
>  Hello!
> =

>> What if we use KVM_MSI_VALID_DEVID flag instead of new KVM_IRQ_ROUTING_E=
XTENDED_MSI
>> definition? I
>> believe this would make an API more consistent and introduce less new de=
finitions.
> =

>  I have just found one more flaw in your implementation. If you take a lo=
ok at irqfd_wakeup()...
> --- cut ---
> 		/* An event has been signaled, inject an interrupt */
> 		if (irq.type =3D=3D KVM_IRQ_ROUTING_MSI)
> 			kvm_set_msi(&irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1,
> 					false);
> 		else
> 			schedule_work(&irqfd->inject);
> --- cut ---
>  You apparently missed KVM_IRQ_ROUTING_EXTENDED_MSI here, as well as in i=
rqfd_update(). But, if you
> accept my API proposal, this becomes irrelevant.

Hi Pavel,

thanks for spotting this bug. Whatever the user-api API choice I will
respin shortly fixing this  plus the one reported by Andr=E9.

Thanks for the review.

Best Regards

Eric


> =

> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> =

> =
