From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Sat, 18 Jul 2015 20:39:25 +0200
Message-ID: <55AA9D5D.7010607@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
 <01d401d0c062$086c2ee0$19448ca0$@samsung.com> <55A8D44A.3030105@redhat.com>
 <029401d0c07a$55a3ddd0$00eb9970$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 282F858E2D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jul 2015 14:27:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lwux+CJPkH-4 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 18 Jul 2015 14:27:58 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C9BF58E2C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jul 2015 14:27:58 -0400 (EDT)
Received: by wicmv11 with SMTP id mv11so65792373wic.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jul 2015 11:39:57 -0700 (PDT)
In-Reply-To: <029401d0c07a$55a3ddd0$00eb9970$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/17/2015 12:21 PM, Pavel Fedin wrote:
>  Hello!
> 
>>>>> +	} else if (!msi->flags)
>>>>> +		return -EINVAL;
>>>  Did you mean "if (msg->flags)" here (inverted condition)?
Yes thanks for spotting this.

Thanks

Eric
>>
>> Indeed, and also you need { } around the return for the QEMU coding
>> standard.
> 
>  It's kernel and not qemu :)
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
