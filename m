From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 00/13] KVM: arm64: GICv3 ITS emulation
Date: Wed, 8 Jun 2016 18:03:43 +0100
Message-ID: <57584FEF.7040005@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Andre,

On 03/06/16 15:02, Andre Przywara wrote:
> Hi,
> 
> please welcome a reworked version of the ITS emulation support.
> It allows those KVM guests that use an emulated GICv3 to use LPIs as well,
> though in the moment this is limited to emulated PCI devices.
> This is based on v4.7-rc1 and only works with the new VGIC implementation.
> There have been some modifications due to changes in the underlying
> VGIC code (changed MMIO handlers, etc.).
> Some other changes relate to the fact that any redistributor related
> variables are now held in the vgic_cpu structure, so they are naturally
> per VCPU.
> Also this series supports multiple ITSes and makes them independent from
> the distributor. There is a new KVM device, which can be created multiple
> times.
> 
> You can find all of this code (and the prerequisites) in the
> its-emul/v5 branch of my repository [1].
> This has been briefly tested on the model and on GICv3 hardware.
> Since there are quite some fundamental changes in this version, I expect
> some issues in the code, so if you have GICv3 capable hardware, please
> test it on your setup.
> Also of course any review comments are very welcome!

I've stopped reviewing after patch 12, as there is way too many design
issues. What I really want to see in the next drop:

1) Locking. The current implementation is too complicated, has holes,
and this leads to interesting bugs.
2) Split between vgic_irq and ITEs. They are not the same, and your
design explodes in the face of multiple ITSs.
3) Handling of collections is extremely creative, and doesn't remotely
match my reading of the architecture.

There is also all kind of buglets all over the shop, which can be
swiftly addressed, but the above three points are real blockers for me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
