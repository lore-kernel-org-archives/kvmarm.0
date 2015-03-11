From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v9 5/5] KVM: arm/arm64: add irqfd support
Date: Wed, 11 Mar 2015 17:54:52 +0100
Message-ID: <5500735C.4070903@linaro.org>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
 <1425464076-20558-6-git-send-email-eric.auger@linaro.org>
 <54F8359A.4020405@arm.com> <54F83DAE.2060607@redhat.com>
 <20150311142418.GB14799@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8809E487DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 12:50:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id talBZqV7mXIC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 12:50:53 -0400 (EDT)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50773487DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 12:50:52 -0400 (EDT)
Received: by wggx13 with SMTP id x13so10680119wgg.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 09:57:13 -0700 (PDT)
In-Reply-To: <20150311142418.GB14799@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: "eric.auger@st.com" <eric.auger@st.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gleb@kernel.org" <gleb@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/11/2015 03:24 PM, Christoffer Dall wrote:
> On Thu, Mar 05, 2015 at 12:27:42PM +0100, Paolo Bonzini wrote:
>>
>>
>> On 05/03/2015 11:53, Marc Zyngier wrote:
>>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>>> +	case KVM_CAP_IRQFD:
>>>> +		r = vgic_present;
>>>> +		break;
>>>> +#endif
>>>
>>> Nitpick: we have "select HAVE_KVM_IRQFD", so we can lose the #ifdef-ery.
>>
>> Alternatively, I've just posted a patch to move the KVM_CAP_IRQFD case
>> to common code.
>>
>> vgic_present probably should be replaced by
>> IS_ENABLED(CONFIG_KVM_ARM_VGIC).  I've sent a patch for this.
>>
> I have applied all of this together with my kill-the-vgic-config-option
> patch here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git queue
> 
> Take a look please.

Hi Christoffer,

This looks good to me. Thanks for the integration.

- Eric
> 
> Thanks,
> -Christoffer
> 
