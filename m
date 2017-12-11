From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 09/36] KVM: arm64: Improve debug register save/restore
 flow
Date: Mon, 11 Dec 2017 09:40:27 +0000
Message-ID: <5c7e6b56-1cb7-cfd7-c1c7-b23d37e99054@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-10-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-10-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> Instead of having multiple calls from the world switch path to the debug
> logic, each figuring out if the dirty bit is set and if we should
> save/restore the debug registers, let's just provide two hooks to the
> debug save/restore functionality, one for switching to the guest
> context, and one for switching to the host context, and we get the
> benefit of only having to evaluate the dirty flag once on each path,
> plus we give the compiler some more room to inline some of this
> functionality.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
