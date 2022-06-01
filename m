Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A590C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 16:14:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD574B3D3;
	Wed,  1 Jun 2022 12:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7C8Z9woR0QQe; Wed,  1 Jun 2022 12:14:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 525E74B3D9;
	Wed,  1 Jun 2022 12:14:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2654B3D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 12:14:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JxmHc67utiLV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 12:14:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C28034B3CB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 12:14:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 172E0ED1;
 Wed,  1 Jun 2022 09:14:04 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA55D3F66F;
 Wed,  1 Jun 2022 09:14:02 -0700 (PDT)
Date: Wed, 1 Jun 2022 17:14:00 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 kvmtool 09/13] builtin_run: Allow standard size
 specifiers for memory
Message-ID: <20220601171400.7318cc0b@donnerap.cambridge.arm.com>
In-Reply-To: <Ypd1DtVQwktvXITa@monolith.localdoman>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
 <20220525112345.121321-10-alexandru.elisei@arm.com>
 <20220601143955.55e00cfd@donnerap.cambridge.arm.com>
 <Ypd1DtVQwktvXITa@monolith.localdoman>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: julien@xen.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 1 Jun 2022 15:17:50 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> Hi,
> 
> Thank you for having a look! Replies below.
> 
> On Wed, Jun 01, 2022 at 02:39:55PM +0100, Andre Przywara wrote:
> > On Wed, 25 May 2022 12:23:41 +0100
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> >   
> > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > 
> > > Allow the user to use the standard B (bytes), K (kilobytes), M (megabytes),
> > > G (gigabytes), T (terabytes) and P (petabytes) suffixes for memory size.
> > > When none are specified, the default is megabytes.
> > > 
> > > Also raise an error if the guest specifies 0 as the memory size, instead
> > > of treating it as uninitialized, as kvmtool has done so far.
> > > 
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  builtin-run.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 60 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/builtin-run.c b/builtin-run.c
> > > index 2ef159cdb2a3..a49698d5b2fe 100644
> > > --- a/builtin-run.c
> > > +++ b/builtin-run.c
> > > @@ -49,9 +49,11 @@
> > >  #include <ctype.h>
> > >  #include <stdio.h>
> > >  
> > > -#define MB_SHIFT		(20)
> > >  #define KB_SHIFT		(10)
> > > +#define MB_SHIFT		(20)
> > >  #define GB_SHIFT		(30)
> > > +#define TB_SHIFT		(40)
> > > +#define PB_SHIFT		(50)  
> > 
> > Can we lose the parentheses?  
> 
> Yes.
> 
> >   
> > >  
> > >  __thread struct kvm_cpu *current_kvm_cpu;
> > >  
> > > @@ -87,6 +89,60 @@ void kvm_run_set_wrapper_sandbox(void)
> > >  	kvm_run_wrapper = KVM_RUN_SANDBOX;
> > >  }
> > >  
> > > +static int parse_mem_unit(char **next)
> > > +{
> > > +	int shift = -1;
> > > +
> > > +	switch (**next) {
> > > +	case 'B': case 'b': shift = 0; break;
> > > +	case 'K': case 'k': shift = KB_SHIFT; break;
> > > +	case 'M': case 'm': shift = MB_SHIFT; break;
> > > +	case 'G': case 'g': shift = GB_SHIFT; break;
> > > +	case 'T': case 't': shift = TB_SHIFT; break;
> > > +	case 'P': case 'p': shift = PB_SHIFT; break;
> > > +	}
> > > +
> > > +	if (shift == -1) {
> > > +		/* The default is megabytes. */
> > > +		shift = MB_SHIFT;  
> > 
> > Doesn't that look better inside the switch/case?
> > 	default: return MB_SHIFT;  
> 
> I think that change alone breaks the logic.
> 
> The code needs to advance next if and only if it matches on one of the
> characters. I'll have a go at advancing next in each of the switch arms
> above (with the exception of the default one, which I'll add) to see how it
> ends up looking.

Mmh, but I meant:
{
	switch (**next) {
	case 'B': case 'b': shift = 0; break;
	case 'K': case 'k': shift = KB_SHIFT; break;
	case 'M': case 'm': shift = MB_SHIFT; break;
	case 'G': case 'g': shift = GB_SHIFT; break;
	case 'T': case 't': shift = TB_SHIFT; break;
	case 'P': case 'p': shift = PB_SHIFT; break;
	default: return MB_SHIFT;  
	}

	(*next)++;

	return shift;
}

that should solve it, shouldn't it?

> 
> >   
> > > +	} else {
> > > +		(*next)++;
> > > +	}
> > > +
> > > +	return shift;
> > > +}
> > > +
> > > +static u64 parse_mem_option(const char *nptr, char **next)
> > > +{
> > > +	u64 shift;
> > > +	u64 val;
> > > +
> > > +	val = strtoull(nptr, next, 10);
> > > +	if (errno == ERANGE)
> > > +		die("Memory too large: %s", nptr);  
> > 
> > strtoull does not clear errno if it succeeds, so it retains the
> > previous error value. So we would need to set errno to 0 just before
> > calling strtoull.  
> 
> This was intentional on my part, because I was under the impression that
> kvmtool treats all instances where errno != 0 as a fatal error. I think I
> was wrong about that, I see at least one instance when that isn't the case,
> in kvm_setup_guest_init -> extract_file. So it isn't a rule that a non-zero
> errno is a fatal error.
> 
> I'll change the code to zero errno before calling strtoull.

Thanks!

> 
> >   
> > > +	shift = parse_mem_unit(next);
> > > +
> > > +	if ((val << shift) < val)
> > > +		die("Memory too large: %s", nptr);
> > > +
> > > +	return val << shift;
> > > +}
> > > +
> > > +static int mem_parser(const struct option *opt, const char *arg, int unset)
> > > +{
> > > +	struct kvm *kvm = opt->ptr;
> > > +	char *next;
> > > +
> > > +	kvm->cfg.ram_size = parse_mem_option(arg, &next);
> > > +	if (kvm->cfg.ram_size == 0)
> > > +		die("Invalid RAM size: %s", arg);  
> > 
> > Does 0 hold any significant value (anymore)? I think we die() if we
> > encounter invalid values in parse_mem_option()?  
> 
> strtoull does not consider an error to convert the string "0" to an
> unsigned long long.

I was wondering if we treat 0 as an indicator of a conversion error, or as
a too-low memory size value here. I don't think we should special case the
latter, as even 1MB or 2MB are typically too low values for a "normal"
kvmtool run ("Fatal: kernel image too big to contain in guest memory.").
On the other hand, with --firmware I think we can run a (admittedly very
limited) guest with 0MB of RAM.

So if we care about garbage as an argument, we should do it by the book
(strtoul manpage), and compare the next pointer to the input string
address, plus checking for the returned value being 0, so that
"-m gimme-all" is explicitly denied. But that would need to happen in
parse_mem_option(), I think, not here.

If we cannot be asked, that's probably fine, but I just wanted to
check this.

Cheers,
Andre

> > > +
> > > +	if (*next != '\0')
> > > +		die("Invalid memory specifier: %s", arg);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  #ifndef OPT_ARCH_RUN
> > >  #define OPT_ARCH_RUN(...)
> > >  #endif
> > > @@ -97,8 +153,9 @@ void kvm_run_set_wrapper_sandbox(void)
> > >  	OPT_STRING('\0', "name", &(cfg)->guest_name, "guest name",	\
> > >  			"A name for the guest"),			\
> > >  	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
> > > -	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
> > > -		" size in MB."),					\
> > > +	OPT_CALLBACK('m', "mem", NULL, "size[BKMGTP]",			\
> > > +		     "Virtual machine memory size, by default measured"	\
> > > +		     " in megabytes (M)", mem_parser, kvm),		\
> > >  	OPT_CALLBACK('d', "disk", kvm, "image or rootfs_dir", "Disk "	\
> > >  			" image or rootfs directory", img_name_parser,	\
> > >  			kvm),						\
> > > @@ -522,8 +579,6 @@ static void kvm_run_validate_cfg(struct kvm *kvm)
> > >  		pr_warning("Ignoring initrd file when loading a firmware image");
> > >  
> > >  	if (kvm->cfg.ram_size) {
> > > -		/* User specifies RAM size in megabytes. */
> > > -		kvm->cfg.ram_size <<= MB_SHIFT;
> > >  		available_ram = host_ram_size();
> > >  		if (available_ram && kvm->cfg.ram_size > available_ram) {
> > >  			pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",  
> >   

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
