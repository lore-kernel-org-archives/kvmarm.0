From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Fri, 03 Jul 2015 17:42:08 +0200
Message-ID: <5596AD50.70103@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <55954F6E.5030008@linaro.org>
 <55955542.6000809@arm.com> <55955728.3080506@linaro.org>
 <02eb01d0b4dd$50b25160$f216f420$@samsung.com> <55955B98.1000504@linaro.org>
 <018401d0b5a5$10576a60$31063f20$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8629557952
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 11:31:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AnDt5lnBFpyV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 11:31:08 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59AA1578D4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 11:31:08 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so103526832wic.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 08:42:26 -0700 (PDT)
In-Reply-To: <018401d0b5a5$10576a60$31063f20$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/03/2015 05:29 PM, Pavel Fedin wrote:
>  Hi!
> 
>> OK so both of you say the same thing. Will respin accordingly
> 
>  You may also want to add this:
> Tested-by: Pavel Fedin <p.fedin@samsung.com>

Thanks Pavel for the intent. However since I am going to change the uapi
and correct the bug you spotted out, this will need to be tested again.
T-b is applied when the code is stable and bug-free I think ;-)

Best Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
