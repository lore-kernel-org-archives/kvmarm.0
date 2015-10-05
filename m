From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for
	a platform device
Date: Mon, 5 Oct 2015 12:32:00 +0200
Message-ID: <20151005103200.GB11536@cbox>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
	<1443814099.26107.124.camel@redhat.com>
	<20151002202844.GD32011@cbox>
	<CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
	<20151005093739.GF9011@cbox>
	<CAFEAcA_ZGaS__7LPFR_JJEs0=KpDNjYQB_ib2pNDLLp2S0zSMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA_ZGaS__7LPFR_JJEs0=KpDNjYQB_ib2pNDLLp2S0zSMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org" <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

[cc'ing Mark R. and Shannon for their input on FDT and ACPI].

On Mon, Oct 05, 2015 at 11:07:35AM +0100, Peter Maydell wrote:
> On 5 October 2015 at 10:37, Christoffer Dall
> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On Fri, Oct 02, 2015 at 11:53:07PM +0100, Peter Maydell wrote:
> >>  * I don't really want to build in a lot of infrastructure into
> >>    QEMU to either build the DTC compiler into it or else introduce
> >>    a runtime dependency on the dtc binary
> >
> > what level of complexity are we really talking about here?  Doesn't QEMU
> > already link against libfdt and doesn't it support exactly what we're
> > trying to do here?
> 
> We link against libfdt, but libfdt is for manipulating and creating
> dt binary blobs. As I understand it what sysfs exposes to userspace
> is not a dt binary blob (or fragment thereof) but a bit of dt source.
> libfdt doesn't do parsing of source into blobs; that is done by the
> dtc compiler, which QEMU doesn't currently build and which is set
> up to build only a separate command line binary anyway, not to be
> a utility library for compiling dt sources.
> 
> Do correct me if I'm wrong about the sysfs interface -- if it is
> just exposing dt blobs that would be easier to deal with.
> 

I thought there was also /sys/firmware/fdt being the unflattened one
accessible by libfdt, but dtc -I dtb seems to be unhappy parsin this on
my Mustang.

Mark, can you refresh my memory about this?

> > I also don't think this is the job of VFIO, assuming there is some
> > better place to do this.  I initially thought exposing device properties
> > in some canonical format from sysfs independently from whether the
> > system was booted with ACPI or DT was the right thing to do, but the
> > counter argument to this was essentially that the guest kernel needs the
> > same description as the host kernel and therefore we really have to find
> > a way to pass the HW description bits on to the guest.
> 
> So we end up with even more code to pass through ACPI table
> fragments as well :-(
> 

Probaby, yes.  But I think it's even worse, because there's no guarantee
you can get at the original firmware data, because it's all from the
DSDT so invoking the initial 'probe' method of the device entry could
theoretically overwrite itself...  (If I remember the details
correctly).

At least saying ACPI guest on ACPI, and DT guest on DT host, would be a
reasonable limitation for anything like this.

But perhaps this really is a place where you need the transparency of DT
vs. ACPI to do this.

This is all outside my area of expertise, so take whatever I said above
with that disclaim.er

> >> (except "don't do device passthrough for platform devices, insist
> >> on a real bus like PCI"...)
> >>
> > While I appreciate the simplicity of this solution from our
> > (maintainers') point of view, I still see the latter point as relatively
> > moot.  We have hardware with 10G platform ethernet devices that people
> > want to do device assignment on already, and I think we should try to
> > find a reasonable set of boundaries for setups that we can support
> > upstream instead of this becoming a black hole of derivative code bases
> > to do this sort of thing.
> 
> Yeah, speaking more seriously I agree we do need to do something
> here. It's just all irritatingly awkward...
> 

Agreed.

-Christoffer
