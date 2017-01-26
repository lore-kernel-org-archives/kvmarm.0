From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm/arm64: KVM: Stop propagating cacheability status
 of a faulted page
Date: Thu, 26 Jan 2017 14:22:18 +0100
Message-ID: <20170126132218.GY15850@cbox>
References: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
 <1485358591-12278-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485358591-12278-3-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 03:36:30PM +0000, Marc Zyngier wrote:
> Now that we unconditionally flush newly mapped pages to the PoC,
> there is no need to care about the "uncached" status of individual
> pages - they must all be visible all the way down.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
