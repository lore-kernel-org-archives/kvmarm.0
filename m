From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/36] KVM: arm64: Factor out fault info population and
 gic workarounds
Date: Mon, 11 Dec 2017 09:45:37 +0000
Message-ID: <94f820d4-ec95-1079-ac85-14461bd25a5c@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-11-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-11-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> The current world-switch function has functionality to detect a number
> of cases where we need to fixup some part of the exit condition and
> possibly run the guest again, before having restored the host state.
> 
> This includes populating missing fault info, emulating GICv2 CPU
> interface accesses when mapped at unaligned addresses, and emulating
> the GICv3 CPU interface on systems that need it.
> 
> As we are about to have an alternative switch function for VHE systems,
> but VHE systems still need the same early fixup logic, factor out this
> logic into a separate function that can be shared by both switch
> functions.
> 
> No functional change.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
