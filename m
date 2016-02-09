From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 15/28] ARM: KVM: Add VFP lazy save/restore handler
Date: Tue, 9 Feb 2016 19:44:49 +0100
Message-ID: <20160209184449.GS5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-16-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-16-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:32AM +0000, Marc Zyngier wrote:
> Similar to the arm64 version, add the code that deals with VFP traps,
> re-enabling VFP, save/restoring the registers and resuming the guest.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
