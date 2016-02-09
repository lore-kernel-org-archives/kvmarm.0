From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 03/28] ARM: KVM: Move VFP registers to a CPU context
 structure
Date: Tue, 9 Feb 2016 19:42:07 +0100
Message-ID: <20160209184207.GH5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-4-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:20AM +0000, Marc Zyngier wrote:
> In order to turn the WS code into something that looks a bit
> more like the arm64 version, move the VFP registers into a
> CPU context container for both the host and the guest.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
