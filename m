From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 27/36] KVM: arm64: Move common VHE/non-VHE trap config
 in separate functions
Date: Mon, 11 Dec 2017 13:53:00 +0000
Message-ID: <838f808d-c367-be79-80ec-2fce2b6d55db@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-28-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-28-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> As we are about to be more lazy with some of the trap configuration
> register read/writes for VHE systems, move the logic that is currently
> shared between VHE and non-VHE into a separate function which can be
> called from either the world-switch path or from vcpu_load/vcpu_put.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
