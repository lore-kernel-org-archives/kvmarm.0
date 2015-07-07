From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Tue, 07 Jul 2015 09:43:37 +0200
Message-ID: <559B8329.9070105@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
 <024301d0b7f0$2b13b410$813b1c30$@samsung.com> <559A9854.2090607@linaro.org>
 <559AA449.80705@arm.com> <014d01d0b885$d3228380$79678a80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89D1557D8B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 03:32:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gKne4XDgPvtg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 03:32:29 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 677CA57D4F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 03:32:29 -0400 (EDT)
Received: by wibdq8 with SMTP id dq8so174119859wib.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jul 2015 00:43:58 -0700 (PDT)
In-Reply-To: <014d01d0b885$d3228380$79678a80$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 07/07/2015 09:23 AM, Pavel Fedin wrote:
>  Hi!
> 
>> I guess not. But I prefer the new type anyway, as it also has a known
>> error path for older kernels.
> 
>  flags != 0 has known error path too, and it's absolutely the same.
>  Sorry, read this after writing my previous reply, so this is a short addendum.
> 
>  I see lots of people agreed on a new type. If my argument about reusing existing definitions is not
> enough, you can ignore it. Three people beat one definitely. :)
OK. let's move forward and use this new type. I will repost soon so
everyone can re-check the fit at kvmtool/qemu.

Thanks

Eric
>  And yes, since we are talking about it, actually KVM_MSI_VALID_DEVID flag is not yet a part of
> mainline, so it's not set in stone. Then, perhaps you could throw it away completely and invent
> KVM_SIGNAL_EXT_MSI ioctl for sending MSIs with device ID. This would also be consistent IMO.
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
