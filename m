From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Thu, 23 Jul 2015 17:48:44 +0100
Message-ID: <55B11AEC.4050804@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com> <55A93488.9060408@arm.com> <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com> <55ACAC73.9090500@arm.com> <03d901d0c44e$beadaa90$3c08ffb0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <03d901d0c44e$beadaa90$3c08ffb0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/07/15 08:19, Pavel Fedin wrote:

>> I don't care much for such an API, mostly because it will obviously
>> bitrot very quickly (your "broken VGIC" platform is hopefully a one off
>> that won't be repeated again, and the RPi is out of scope anyway).
>>
>> It would have to be extremely non-intrusive and completely safe for this
>> to be taken in...
> 
>  Ok, let's leave this API alone then for now...
>  Will then be a concensus if i tweak the thing a little bit and we just enable KVM without both vGIC
> and vTimer ? It will be an emulator's problem how to handle them then.

Well, let's see the patches first, and how invasive they are.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
