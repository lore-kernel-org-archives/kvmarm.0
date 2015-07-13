From: Eric Auger <eric.auger@linaro.org>
Subject: Re: Extensions for KVM MSI related ioctls
Date: Mon, 13 Jul 2015 16:24:23 +0200
Message-ID: <55A3CA17.1010500@linaro.org>
References: <55A39231.4050904@arm.com> <55A3B090.6090002@redhat.com> <03b901d0bd70$6c2f4b50$448de1f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <03b901d0bd70$6c2f4b50$448de1f0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, 'Andre Przywara' <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, 'Gleb Natapov' <gleb@kernel.org>, 'Jan Kiszka' <jan.kiszka@siemens.com>, 'Marcelo Tosatti' <mtosatti@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/13/2015 03:32 PM, Pavel Fedin wrote:
>  Hello!
> 
>> I think I prefer the flag.  Offhand it sounds easier to add support for
>> it to non-ARM architectures, compared to KVM_IRQ_ROUTING_EXTENDED_MSI.
> 
>  Actually i also voted for flag, because it is already introduced in (2), and i'm not a fan of
> adding new definitions where we can reuse existing ones. IMHO using flag would make an API more
> consistent.

OK I will respin with user space flag.

Andre, what about the kernel routing entry struct. You wanted me to get
rid of  KVM_IRQ_ROUTING_EXTENDED_MSI there too. Will you be able to
manage a usespace wrong setting if the type is not set?

Best Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 

