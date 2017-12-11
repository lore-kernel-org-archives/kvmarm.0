From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 19/36] KVM: arm64: Unify non-VHE host/guest sysreg save
 and restore functions
Date: Mon, 11 Dec 2017 10:40:50 +0000
Message-ID: <2799bd84-8882-3404-7122-09fc1a0d8937@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-20-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-20-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> There is no need to have multiple identical functions with different
> names for saving host and guest state.  When saving and restoring state
> for the host and guest, the state is the same for both contexts, and
> that's why we have the kvm_cpu_context structure.  Delete one
> version and rename the other into simply save/restore.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
