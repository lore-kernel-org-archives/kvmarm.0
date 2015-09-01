From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
	a platform device
Date: Tue, 1 Sep 2015 17:52:05 +0200
Message-ID: <20150901155205.GA19385@cbox>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
	<55DF07F0.3070405@linaro.org>
	<1440691887.20355.27.camel@redhat.com>
	<55DF45D0.5040704@linaro.org> <20150830140638.GB24113@cbox>
	<55E48897.4090907@linaro.org> <20150831173359.GA10991@cbox>
	<55E5546C.7040504@linaro.org> <20150901092813.GE10991@cbox>
	<CAN9JPjGfuv_YOBEdZA_AD13oHej7wMCR50=zQTZmgzHx-jBj_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAN9JPjGfuv_YOBEdZA_AD13oHej7wMCR50=zQTZmgzHx-jBj_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Cc: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 01, 2015 at 05:32:21PM +0200, Baptiste Reynal wrote:
> Hi everyone,
> 
> The usefullness of this patch has already been discussed during the
> first releases (http://lists.linuxfoundation.org/pipermail/iommu/2014-August/009586.html).
> I underline the fact that it avoids implementing the logic on the
> userspace program, as VFIO can be used for many usage (userspace
> drivers and device assignment).
> 
> If you're interested in the implementation on the userspace side, an
> RFC has been suggested for QEMU:
> http://lists.gnu.org/archive/html/qemu-devel/2015-01/msg01211.html

This one-year-old discussion is hardly exhaustive.

I think you missed the gist of the question for Eric a bit as well.

One important question for me is whether seeing the host DT is always
sufficient or if the kernel and physical device driver can have more
information about the device and its configuration which userspace may
need, which cannot be directly read in the DT (for example because the
driver has initialized the device in a specific way).  My point is, it's
really not about DT-specific things (what if you used ACPI?), but it's
about retrieving properties of a device and its configuration from
userspace.

Have we thought about the possible ways to achieve this and weight one
option against the other?

-Christoffer

> 
> On Tue, Sep 1, 2015 at 11:28 AM, Christoffer Dall
> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > Hi Eric,
> >
> > On Tue, Sep 01, 2015 at 09:31:56AM +0200, Eric Auger wrote:
> >
> > [...]
> >
> >> >>> Can you reiterate why QEMU and VFIO don't already have the information
> >> >>> necessary to setup resources and present a DT to the guest that the
> >> >>> guest can use?
> >> >> A vfio-platform driver was bound to the passthrough'ed device. QEMU
> >> >> current knows the compat string of the device and the node's name and
> >> >> that's it.
> >> >>
> >> >> The VFIO platform driver currently does not allow to return device
> >> >> specific information. It just returns generic info such as resource
> >> >> info. The driver is HW agnostic.
> >> >>
> >> >>
> >> >> The QEMU VFIO device should be able to check some characteristics of the
> >> >> host device tree. Typically if the host node does not comply with some
> >> >> constraints it may not be possible to assign the device.
> >> >>
> >> >> We do not want the QEMU end-user to have in-depth knowledge of the HW so
> >> >> passing the info in the QEMU command line does not sound to be the good
> >> >> solution.
> >> >>
> >> >>
> >> >> As you mentioned /proc/device-tree depends on kernel option. I am able
> >> >> to find the properties in sysfs too but can we systematically rely on
> >> >> sysfs (CONFIG_SYSFS)? Also I would have expected the values to be human
> >> >> readable but they are not. Currently investigating open/read from qemu
> >> >> but is better than an ioctl API? ...
> >> >>
> >> > Yeah it does, but I thought we originally planned that the driver for a
> >> > specific platform device in QEMU should know these details,
> >> Yes that's the objective to put this intelligence in the QEMU VFIO
> >> device or more precisely in the associated function that builds its
> >> guest dt node.
> >>
> >> Let's take an example. Assuming an xgmac supports different speeds, you
> >> need to set those on guest. Either you put arbitrary values or you reuse
> >> the values that were set on host. Typically some values may not be
> >> supported by the HW.
> >>
> >
> > I see.  I'm no expert here, but I could imagine that drivers could
> > overwrite some things in the DT or do some advanced probing of the
> > hardware which is then only exported in the sysfs and not the DT, so I
> > would go the sysfs approach myself.
> >
> >> Idea of genericity was ruled out indeed meaning each device needs to
> >> have a specialized QEMU VFIO device and an associated dt node creation
> >> function. Now this does not prevent from exploiting host dt information.
> >> Does that make sense?
> >>
> > Yes, thanks for the explanation.
> >
> > -Christoffer
