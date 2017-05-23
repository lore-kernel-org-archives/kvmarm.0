From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 3/9] KVM: arm/arm64: Move irq_is_ppi() to header file
Date: Tue, 23 May 2017 18:10:23 +0100
Message-ID: <89561287-b656-ec0d-2e00-95cdd3c0c2cd@arm.com>
References: <20170516184556.26785-1-cdall@linaro.org>
 <20170516184556.26785-4-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516184556.26785-4-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 19:45, Christoffer Dall wrote:
> We are about to need this define in the arch timer code as well so move
> it to a common location.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
