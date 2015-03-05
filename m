From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 5/5] KVM: arm/arm64: add irqfd support
Date: Thu, 05 Mar 2015 11:33:07 +0000
Message-ID: <54F83EF3.4070903@arm.com>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org> <1425464076-20558-6-git-send-email-eric.auger@linaro.org> <54F8359A.4020405@arm.com> <54F83DAE.2060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F83DAE.2060607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "gleb@kernel.org" <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/03/15 11:27, Paolo Bonzini wrote:
> 
> 
> On 05/03/2015 11:53, Marc Zyngier wrote:
>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>> +	case KVM_CAP_IRQFD:
>>> +		r = vgic_present;
>>> +		break;
>>> +#endif
>>
>> Nitpick: we have "select HAVE_KVM_IRQFD", so we can lose the #ifdef-ery.
> 
> Alternatively, I've just posted a patch to move the KVM_CAP_IRQFD case
> to common code.
> 
> vgic_present probably should be replaced by
> IS_ENABLED(CONFIG_KVM_ARM_VGIC).  I've sent a patch for this.

Right. We can probably take this at the same time as Eric's series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
