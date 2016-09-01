From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 4/5] arm64: KVM: vgic-v2: Add GICV access from HYP
Date: Thu, 1 Sep 2016 15:28:59 +0200
Message-ID: <20160901132859.GG10162@cbox>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471610295-1456-5-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 19, 2016 at 01:38:14PM +0100, Marc Zyngier wrote:
> Now that we have the necessary infrastructure to handle MMIO accesses
> in HYP, perform the GICV access on behalf of the guest. This requires
> checking that the access is strictly 32bit, properly aligned, and
> falls within the expected range.
> 
> When all condition are satisfied, we perform the access and tell
> the rest of the HYP code that the instruction has been correctly
> emulated.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
