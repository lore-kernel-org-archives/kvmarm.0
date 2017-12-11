From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 13/36] KVM: arm64: Don't deactivate VM on VHE systems
Date: Mon, 11 Dec 2017 09:58:51 +0000
Message-ID: <db6edda5-96ab-04a6-a770-6e50a7ba7dcc@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-14-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-14-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> There is no need to reset the VTTBR to zero when exiting the guest on
> VHE systems.  VHE systems don't use stage 2 translations for the EL2&0
> translation regime used by the host.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
