From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for
 a platform device
Date: Mon, 5 Oct 2015 11:48:11 +0100
Message-ID: <20151005104811.GD19064@leverpostej>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
 <1443814099.26107.124.camel@redhat.com>
 <20151002202844.GD32011@cbox>
 <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
 <20151005093739.GF9011@cbox>
 <CAFEAcA_ZGaS__7LPFR_JJEs0=KpDNjYQB_ib2pNDLLp2S0zSMA@mail.gmail.com>
 <20151005103200.GB11536@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D10F1412FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 06:46:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UT8o0kOjQl4w for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 06:46:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6907F41291
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 06:46:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20151005103200.GB11536@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: iommu@lists.linux-foundation.org, Alex Williamson <alex.williamson@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 05, 2015 at 12:32:00PM +0200, Christoffer Dall wrote:
> [cc'ing Mark R. and Shannon for their input on FDT and ACPI].
> 
> On Mon, Oct 05, 2015 at 11:07:35AM +0100, Peter Maydell wrote:
> > On 5 October 2015 at 10:37, Christoffer Dall
> > <christoffer.dall@linaro.org> wrote:
> > > On Fri, Oct 02, 2015 at 11:53:07PM +0100, Peter Maydell wrote:
> > >>  * I don't really want to build in a lot of infrastructure into
> > >>    QEMU to either build the DTC compiler into it or else introduce
> > >>    a runtime dependency on the dtc binary
> > >
> > > what level of complexity are we really talking about here?  Doesn't QEMU
> > > already link against libfdt and doesn't it support exactly what we're
> > > trying to do here?
> > 
> > We link against libfdt, but libfdt is for manipulating and creating
> > dt binary blobs. As I understand it what sysfs exposes to userspace
> > is not a dt binary blob (or fragment thereof) but a bit of dt source.
> > libfdt doesn't do parsing of source into blobs; that is done by the
> > dtc compiler, which QEMU doesn't currently build and which is set
> > up to build only a separate command line binary anyway, not to be
> > a utility library for compiling dt sources.
> > 
> > Do correct me if I'm wrong about the sysfs interface -- if it is
> > just exposing dt blobs that would be easier to deal with.
> > 
> 
> I thought there was also /sys/firmware/fdt being the unflattened one
> accessible by libfdt, but dtc -I dtb seems to be unhappy parsin this on
> my Mustang.
> 
> Mark, can you refresh my memory about this?

/sys/firmware/fdt is the original, unadulterated DTB passed to the
kernel, while /sys/firmware/device-tree is the unflattened form which
may have had overlays (or perhaps other fixups) applied.

For runtime stuff I'd generally expect /sys/firmware/device-tree to be
preferable (e.g. if we want to expose some device added by an overlay).
We added /sys/firmware/fdt for kexec, as memory reservations are in the
DTB header, which doesn't show up in the unflattened tree.

> > > I also don't think this is the job of VFIO, assuming there is some
> > > better place to do this.  I initially thought exposing device properties
> > > in some canonical format from sysfs independently from whether the
> > > system was booted with ACPI or DT was the right thing to do, but the
> > > counter argument to this was essentially that the guest kernel needs the
> > > same description as the host kernel and therefore we really have to find
> > > a way to pass the HW description bits on to the guest.
> > 
> > So we end up with even more code to pass through ACPI table
> > fragments as well :-(
> > 
> 
> Probaby, yes.  But I think it's even worse, because there's no guarantee
> you can get at the original firmware data, because it's all from the
> DSDT so invoking the initial 'probe' method of the device entry could
> theoretically overwrite itself...  (If I remember the details
> correctly).

I don't think you can realistically expose host AML to the guest. Even
if it doesn't overwrite itself, it could perform oneshot configuration
that breaks if executed repeatedly, try to access otehr bits of ACPI
which may or may not be present, call to secure firmware, etc.

Mark.
