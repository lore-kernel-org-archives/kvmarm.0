From: nick <xerofoify@gmail.com>
Subject: Re: [PATCH] kvm:arm:Fix error handling in the function vgic_v3_probe
Date: Thu, 06 Aug 2015 09:16:45 -0400
Message-ID: <55C35E3D.9000708@gmail.com>
References: <1438793303-30228-1-git-send-email-xerofoify@gmail.com>
 <55C240D9.5060900@redhat.com> <55C242C6.6060200@gmail.com>
 <55C31582.4000809@arm.com> <55C34C77.7090303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A934559E20
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 09:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYfBRRnKQJbX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Aug 2015 09:03:57 -0400 (EDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
 [209.85.213.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A586D59B98
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 09:03:57 -0400 (EDT)
Received: by igk11 with SMTP id 11so10952320igk.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Aug 2015 06:16:47 -0700 (PDT)
In-Reply-To: <55C34C77.7090303@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "gleb@kernel.org" <gleb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 2015-08-06 08:00 AM, Paolo Bonzini wrote:
> 
> 
> On 06/08/2015 10:06, Marc Zyngier wrote:
>>> If this structure of function pointers can handle function pointers with a return type of 
>>> void I will be glad to do what you request otherwise this would require a major rewrite
>>> of kvm arm subsystem for a very simple bug fix.
>>
>> Just like Paolo said, the error you report should never happen, and
>> would be caught by a WARN_ON() the first time anyone boots the kernel.
>> Also, failing to register the device ops results in not being able to
>> instantiate a VGIC. No harm done. I really don't understand why you want
>> to rewrite the probe functions.
> 
> I think he just misunderstood my suggestion.  I didn't suggest making
> the probe functions return void.  I suggested that
> kvm_register_device_ops return void.
> 
> Paolo
> 
Unfortunately the other maintainer is right in the s390 kvm subsystem uses the return value of the call to 
kvm_register_device_ops. However we could do something like a WARN_ON if kvm_register_device_ops fails in 
callers that never are required to never use it's return value.
Sorry about the Misunderstanding as I misread your suggestion.
Nick
