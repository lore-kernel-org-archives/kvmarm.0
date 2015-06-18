From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 13/13] KVM: arm64: enable ITS emulation as a virtual MSI
 controller
Date: Thu, 18 Jun 2015 20:20:31 +0100
Message-ID: <558319FF.4090809@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-14-git-send-email-andre.przywara@arm.com>
 <558284B4.104@linaro.org> <5582D410.60708@arm.com>
 <01a401d0a9d7$e87997d0$b96cc770$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8DC55CE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 15:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ykGqpazfBhc8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 15:09:33 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 134E355CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 15:09:32 -0400 (EDT)
In-Reply-To: <01a401d0a9d7$e87997d0$b96cc770$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Eric Auger' <eric.auger@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/18/2015 04:03 PM, Pavel Fedin wrote:
>  Hello!
> 
>> But that fails compilation on ARM (which uses this file as well),
>> because we have a dummy fail function in the header if
>> CONFIG_HAVE_KVM_MSI is not defined.
> 
>  May be then remove that fail function too? Too many #ifdef's are not good...

Yes, that seems to work - now. I think I had more code in there before
that prevented exposure without #ifdef guarding.

Cheers,
Andre.

> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
