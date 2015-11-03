From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32
 virtual platforms
Date: Tue, 3 Nov 2015 17:55:23 +0000
Message-ID: <20151103175522.GA24856@arm.com>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
 <5638E1CD.8090006@codeaurora.org>
 <5638F294.4060409@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5638F294.4060409@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Christopher Covington <cov@codeaurora.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux@arm.linux.org.uk, andre.przywara@arm.com, grant.likely@secretlab.ca, robherring2@gmail.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 03, 2015 at 09:44:52AM -0800, Mario Smarduch wrote:
> On 11/3/2015 8:33 AM, Christopher Covington wrote:
> > On 11/02/2015 06:51 PM, Mario Smarduch wrote:
> >>    this is a re-post from couple weeks ago, please take time to review this 
> >> simple patch which simplifies DEBUG_LL and prevents kernel crash on virtual 
> >> platforms.
> >>
> >> Before this patch DEBUG_LL for 'dummy virtual machine':
> >>
> >> ( ) Kernel low-level debugging via EmbeddedICE DCC channel
> >> ( ) Kernel low-level debug output via semihosting I/O
> >> ( ) Kernel low-level debugging via 8250 UART
> >> ( ) Kernel low-level debugging via ARM Ltd PL01x Primecell
> >>
> >> In summary if debug uart is not emulated kernel crashes.
> >> And once you pass that hurdle, uart physical/virtual addresses are unknown.
> >> DEBUG_LL comes in handy on many occasions and should be somewhat 
> >> intuitive to use like it is for physical platforms. For virtual platforms
> >> user may start daubting the host and get into a bigger mess.
> >>
> >> After this patch is applied user gets:
> >>
> >> (X) Kernel low-level debugging on QEMU Virtual Platform
> >> ( ) Kernel low-level debugging on Kvmtool Virtual Platform
> >> 	..... above repeated ....
> >>
> >> The virtual addresses selected follow arm reference models, high in vmalloc 
> >> section with high mem enabled and guest running with >= 1GB of memory. The 
> >> offset is leftover from arm reference models.
> > 
> > Which model? It doesn't appear to match the vexpress AEM/RTSM/FVP/whatever
> > which used 0x1c090000 for UART0.
> 
> I recall QEMU virt model had it's own physical address map, for sure I saw the
> virtio-mmio regions assigned in some ARM document. Peter would you know?
> 
> As far as kvmtool I'm not sure, currently PC1 COM1 port is used? Andre will that
> stay fixed?

We make absolutely no guarantees about the memory map provided by kvmtool.

Will
