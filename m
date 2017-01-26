From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] arm/arm64: KVM: Get rid of KVM_MEMSLOT_INCOHERENT
Date: Thu, 26 Jan 2017 14:22:26 +0100
Message-ID: <20170126132226.GZ15850@cbox>
References: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
 <1485358591-12278-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485358591-12278-4-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 03:36:31PM +0000, Marc Zyngier wrote:
> KVM_MEMSLOT_INCOHERENT is not used anymore, as we've killed its
> only use in the arm/arm64 MMU code. Let's remove the last artifacts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
