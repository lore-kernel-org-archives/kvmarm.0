From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: drop resource size check for GICV window
Date: Sat, 9 Jun 2018 20:58:16 +0200
Message-ID: <20180609185816.GM5097@C02W217FHV2R.local>
References: <20180601150628.10111-1-ard.biesheuvel@linaro.org>
 <20180609100657.GI5097@C02W217FHV2R.local>
 <86602s9n5v.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0FA44048A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jun 2018 14:47:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SD1ZqqaSJW4d for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jun 2018 14:46:55 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D270440192
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jun 2018 14:46:55 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <86602s9n5v.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jun 09, 2018 at 01:09:32PM +0100, Marc Zyngier wrote:
> On Sat, 09 Jun 2018 11:06:57 +0100,
> Christoffer Dall wrote:
> > 
> > On Fri, Jun 01, 2018 at 05:06:28PM +0200, Ard Biesheuvel wrote:
> > > When booting a 64 KB pages kernel on a ACPI GICv3 system that
> > > implements support for v2 emulation, the following warning is
> > > produced
> > > 
> > >   GICV size 0x2000 not a multiple of page size 0x10000
> > > 
> > > and support for v2 emulation is disabled, preventing GICv2 VMs
> > > from being able to run on such hosts.
> > > 
> > > The reason is that vgic_v3_probe() performs a sanity check on the
> > > size of the window (it should be a multiple of the page size),
> > > while the ACPI MADT parsing code hardcodes the size of the window
> > > to 8 KB. This makes sense, considering that ACPI does not bother
> > > to describe the size in the first place, under the assumption that
> > > platforms implementing ACPI will follow the architecture and not
> > > put anything else in the same 64 KB window.
> > 
> > Does the architecture actually say that anywhere?
> 
> It implies it in section 8.14 of the GICv3 spec:
> 
> <quote>
> To enable use of 64KB pages, the GICV_* memory map must ensure that:
> 
> * The base address of the GICV_* registers is 64KB aligned.
> 
> * An alias of the GICV_* registers is provided starting at offset
>   0xF000 from the start of the page such that a second copy of
>   GICV_DIR exists at the start of the next 64KB page.  This provides
>   support for both 4KB and 64KB pages.
> </quote>
> 
> > > So let's just drop the sanity check altogether, and assume that
> > > the window is at least 64 KB in size.
> > 
> > This could obviously be dangerous if broken systems actually exist.
> > Marc may know more about that than me.  An alternative would be to
> > modify the ACPI code to assume max(8 KB, page size) instead, and/or a
> > command line parameter to override this check.
> 
> While the above is in effect very similar to the corresponding GICv2
> requirements with the ARMv8 architecture (described in SBSA, which
> everybody and their dog are unfortunately making a point in ignoring),
> this is implemented in the CPU, meaning that integrators do not have
> the opportunity to fsck it up. Hooray!
> 
> And as far as I know, this is only implemented on A35, A53, A57, A72
> and A73 (all the other ARMv8 CPUs are purely GICv3, and no other
> architectural licensee ever shipped a system with the compat
> interface).
> 
> > That said, I'm not directly opposed to this patch, but I'll let Marc
> > have a look as well.
> 
> My take on this is that we should play it as per the architecture, and
> only add more checks if we're presented with a non-compliant
> implementation.
> 

I had some faint memory that we had actually seen that, but I'm clearly
mixing things up.

Thanks for the extended explanation.
-Christoffer
