From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/12] KVM: move iodev.h from virt/kvm/ to include/kvm
Date: Sat, 14 Mar 2015 15:43:29 +0100
Message-ID: <20150314144329.GH10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426263012-22935-3-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, n.nikolaev@virtualopensystems.com, eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 13, 2015 at 04:10:02PM +0000, Andre Przywara wrote:
> iodev.h contains definitions for the kvm_io_bus framework. This is
> needed both by the generic KVM code in virt/kvm as well as by
> architecture specific code under arch/. Putting the header file in
> virt/kvm and using local includes in the architecture part seems at
> least dodgy to me, so let's move the file into include/kvm, so that a
> more natural "#include <kvm/iodev.h>" can be used by all of the code.
> This also solves a problem later when using struct kvm_io_device
> in arm_vgic.h.
> Fixing up the FSF address in the GPL header and a wrong include path
> on the way.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
