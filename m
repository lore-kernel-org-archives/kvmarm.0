From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Sun, 13 Mar 2016 19:16:08 +0100
Message-ID: <20160313181608.GA15988@cbox>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <56E00A7E.4080101@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E00A7E.4080101@semihalf.com>
Sender: kvm-owner@vger.kernel.org
To: Tomasz Nowicki <tn@semihalf.com>
Cc: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 09, 2016 at 12:35:26PM +0100, Tomasz Nowicki wrote:
> Hi Andre,
> 
> Forgive me if anybody already asked this question for previous
> series versions.
> 
> The review is still pending so it is worth to ask. What is your idea
> for saving and restoring vITS state? I notice device, itte and
> collection linked lists which are essential for vITS state. Of
> course it is not feasible to transfer these list to e.g. QEMU using
> KVM_{GET|SET}_DEVICE_ATTR.
> 
If I recall correctly these items are the ones stored in memory on real
hardware, and not in hardware registers.

We had an idea where userspace asks the kernel vgic to flush its
internal cache into the memory allocated by the guest driver for the
vITS data structures and then the state would be transferred across to
the new VM via the memory transfer mechanism.

Only caveat there I think was that we had to decide on a storage format
in those memory regions, to allow QEMU to understand the state and to
ensure back/forwards compatibility between KVM versions.

-Christoffer
