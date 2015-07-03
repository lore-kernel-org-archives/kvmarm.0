From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 08/17] kvm: arm/arm64: implement kvm_arm_[halt,resume]_guest
Date: Fri, 03 Jul 2015 13:14:15 +0100
Message-ID: <55967C97.5010502@arm.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org> <1435843047-6327-9-git-send-email-eric.auger@linaro.org> <55967848.5050204@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55967848.5050204@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "feng.wu@intel.com" <feng.wu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/07/15 12:55, Eric Auger wrote:
> Christoffer, Marc,
> On 07/02/2015 03:17 PM, Eric Auger wrote:
>> On halt, the guest is forced to exit and prevented from being
>> re-entered. This is synchronous.
>>
>> Those two operations will be needed for IRQ forwarding setting.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> would you agree to handle this ARM functionality separately from the
> forwarding series?
> 
> This includes 2 patch files, that one +
> https://lkml.org/lkml/2015/7/2/288. This functionality is needed for
> forwarding control since when changing the forwarding state we need to
> "freeze" the state of the physical/virtual IRQ to undertake proper
> actions. Stopping the guest makes sure it won't deactivate the virtual
> IRQ while we are doing state change actions.
> 
> The forwarding series is quite heterogeneous (VFIO platform driver,
> vgic, irq bypass manager) and I think it would simplify the review process.
> 
> Please let me know if you agree. If yes, I will post a separate series.

I don't mind, I trust you to do what's best for these series to be
easily reviewed (if that is at all possible).

The only thing is that this patch implements a feature that will
otherwise be unused, so annotating the functions with __maybe_unused
would avoid warnings.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
