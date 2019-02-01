From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 2/6] arm: fdt: add stdout-path to /chosen node
Date: Fri, 1 Feb 2019 11:03:33 +0000
Message-ID: <20190201110333.3660a1a7@donnerap.cambridge.arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
 <20190125180801.209910-3-andre.przywara@arm.com>
 <20190130182019.GF18558@fuggles.cambridge.arm.com>
 <20190131145711.6e6a4bcb@donnerap.cambridge.arm.com>
 <20190201062654.GA4308@brain-police>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C36FA4A3BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:03:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wCpQyPQNYXuV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 06:03:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C0CA4A39B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:03:38 -0500 (EST)
In-Reply-To: <20190201062654.GA4308@brain-police>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 1 Feb 2019 06:26:58 +0000
Will Deacon <will.deacon@arm.com> wrote:

Hi,

> On Thu, Jan 31, 2019 at 02:57:11PM +0000, Andre Przywara wrote:
> > On Wed, 30 Jan 2019 18:20:19 +0000
> > Will Deacon <will.deacon@arm.com> wrote:  
> > > On Fri, Jan 25, 2019 at 06:07:57PM +0000, Andre Przywara wrote:  
> > > > The DT spec describes the stdout-path property in the /chosen
> > > > node to contain the DT path for a default device usable for
> > > > outputting characters. The Linux kernel uses this for earlycon
> > > > (without further parameters), other DT users might rely on this
> > > > as well.
> > > > 
> > > > Add a property containing the path to our emulated 8250 serial
> > > > device.
> > > > 
> > > > Even when we use the virtio console, the serial console is still
> > > > there and works, so we can expose this unconditionally. Putting
> > > > the virtio console path in there will not work anyway.
> > > > 
> > > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > > ---
> > > >  arm/fdt.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/arm/fdt.c b/arm/fdt.c
> > > > index 28ba1c2c..8cda3ded 100644
> > > > --- a/arm/fdt.c
> > > > +++ b/arm/fdt.c
> > > > @@ -143,6 +143,7 @@ static int setup_fdt(struct kvm *kvm)
> > > >  	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only",
> > > > 1)); _FDT(fdt_property_string(fdt, "bootargs",
> > > > kvm->cfg.real_cmdline)); _FDT(fdt_property_u64(fdt,
> > > > "kaslr-seed", kvm->cfg.arch.kaslr_seed));
> > > > +	_FDT(fdt_property_string(fdt, "stdout-path",
> > > > "/U6_16550A@3f8"));    
> > > 
> > > Since the last string here has to match the one in hw/serial.c, I
> > > think we should be retrieving it from there rather than
> > > hardcoding it here.  
> > 
> > Are you thinking about something like setting a "char
> > *primary_console_path" in
> > hw/serial.c:serial8250_generate_fdt_node(), then using this here in
> > arm/fdt.c? Or shall the generate function directly set the
> > stdout-path?  
> 
> It's probably a bit dodgy doing it from the generate function,
> because I think we'd then be relying on the the /chosen node being
> created before the serial node (which is true, but I wouldn't like to
> rely on it).

Agreed.

> So I think either have a way to register the primary console device,
> or a way to squirrel the string away somewhere. Is there a variant of
> stdout-path which uses a phandle instead of a string?  That might end
> up being cleaner to implement.

stdout-path must be a string, so a phandle will not work. However that
string can be an alias, so I now let stdout-path always be "serial0",
then add an aliases node at the end of the FDT generation, assigning
serial0 to the path of the first instantiated serial device.

I will post a v2 with that.

Cheers,
Andre.
