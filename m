From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/3] KVM: arm/arm64: Separate guest and uaccess writes
 to dist {sc}active
Date: Mon, 22 May 2017 16:24:51 +0100
Message-ID: <eca50759-8682-d897-9ee1-22b285be8a54@arm.com>
References: <20170516100431.4101-1-cdall@linaro.org>
 <20170516100431.4101-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516100431.4101-3-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 11:04, Christoffer Dall wrote:
> Factor out the core register modifier functionality from the entry
> points from the register description table, and only call the
> prepare/finish functions from the guest path, not the uaccess path.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
