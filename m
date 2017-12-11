From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 16/36] KVM: arm64: Rewrite sysreg alternatives to
 static keys
Date: Mon, 11 Dec 2017 10:15:17 +0000
Message-ID: <75da7003-17d8-7a72-1f0c-4fbf7889c088@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-17-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-17-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> As we are about to move calls around in the sysreg save/restore logic,
> let's first rewrite the alternative function callers, because it is
> going to make the next patches much easier to read.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
