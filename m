From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
	a platform device
Date: Mon, 31 Aug 2015 19:33:59 +0200
Message-ID: <20150831173359.GA10991@cbox>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
	<55DF07F0.3070405@linaro.org>
	<1440691887.20355.27.camel@redhat.com>
	<55DF45D0.5040704@linaro.org> <20150830140638.GB24113@cbox>
	<55E48897.4090907@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55E48897.4090907-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 31, 2015 at 07:02:15PM +0200, Eric Auger wrote:
> Hi Christoffer,
> On 08/30/2015 04:06 PM, Christoffer Dall wrote:
> > Hi Eric,
> > 
> > On Thu, Aug 27, 2015 at 07:16:00PM +0200, Eric Auger wrote:
> >> Hi Alex,
> >> On 08/27/2015 06:11 PM, Alex Williamson wrote:
> >>> On Thu, 2015-08-27 at 14:52 +0200, Eric Auger wrote:
> >>>> Hi Baptiste, Antonios,
> >>>>
> >>>> What are the plans wrt this series? I am currently integrating another
> >>>> QEMU VFIO platform devices where this series could be useful I think
> >>>> (Feb 2015). Do you intend to follow up and bring it upstream?
> >>>>
> >>>> Alex, do you see some show-stoppers in this series or do you advise to
> >>>> simply follow-up?
> >>>
> >>> I'm at a bit of a disadvantage not really knowing what types of
> >>> properties a user will be able to retrieve here.  The interface itself
> >>> seems sort of like a game of Go Fish.  Should the properties we're
> >>> looking for be generally available via sysfs?  The ioctl proposed needs
> >>> some work to fit within the argsz/flags model that vfio typically uses.
> >>> It's unclear what argsz vs length represents and defining the flags
> >>> field as 'type' limits the future extensions of the ioctl.  Thanks,
> >>
> >> The properties that I need can be found in /proc/device-tree too. They
> >> are of different types, with void cell value, with string cell
> >> values(single & multiple), with integer cell value(s), array ...
> >>
> >> The aim is to be able to assign a highly configurable platform device to
> >> a guest, read some property values on host and write the same values in
> >> guest dt node.
> >>
> > Can you reiterate why QEMU and VFIO don't already have the information
> > necessary to setup resources and present a DT to the guest that the
> > guest can use?
> A vfio-platform driver was bound to the passthrough'ed device. QEMU
> current knows the compat string of the device and the node's name and
> that's it.
> 
> The VFIO platform driver currently does not allow to return device
> specific information. It just returns generic info such as resource
> info. The driver is HW agnostic.
> 
> 
> The QEMU VFIO device should be able to check some characteristics of the
> host device tree. Typically if the host node does not comply with some
> constraints it may not be possible to assign the device.
> 
> We do not want the QEMU end-user to have in-depth knowledge of the HW so
> passing the info in the QEMU command line does not sound to be the good
> solution.
> 
> 
> As you mentioned /proc/device-tree depends on kernel option. I am able
> to find the properties in sysfs too but can we systematically rely on
> sysfs (CONFIG_SYSFS)? Also I would have expected the values to be human
> readable but they are not. Currently investigating open/read from qemu
> but is better than an ioctl API? ...
> 
Yeah it does, but I thought we originally planned that the driver for a
specific platform device in QEMU should know these details, and that you
simply have to add code for each supported device, instead of trying to
solve this generically.  (It was never the user who should supply it on
the command line).  But perhaps we moved on from our original idea?

I think relying on sysfs is probably reasonable, but I'm really not an
expert in the right ways here.

Thanks,
-Christoffer
