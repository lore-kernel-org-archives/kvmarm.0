From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 5/7] arm64: KVM: vgic-v2: Add the GICV emulation
 infrastructure
Date: Tue, 6 Sep 2016 12:53:37 +0200
Message-ID: <20160906105337.GK30513@cbox>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
 <1473150527-4729-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473150527-4729-6-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 06, 2016 at 09:28:45AM +0100, Marc Zyngier wrote:
> In order to efficiently perform the GICV access on behalf of the
> guest, we need to be able to avoid going back all the way to
> the host kernel.
> 
> For this, we introduce a new hook in the world switch code,
> conveniently placed just after populating the fault info.
> At that point, we only have saved/restored the GP registers,
> and we can quickly perform all the required checks (data abort,
> translation fault, valid faulting syndrome, not an external
> abort, not a PTW).
> 
> Coming back from the emulation code, we need to skip the emulated
> instruction. This involves an additional bit of save/restore in
> order to be able to access the guest's PC (and possibly CPSR if
> this is a 32bit guest).
> 
> At this stage, no emulation code is provided.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
