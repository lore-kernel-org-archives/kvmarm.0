From: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v7 0/7] Add virtio-iommu driver
Date: Thu, 24 Jan 2019 16:03:55 +0000
Message-ID: <a6315ab3-bffb-7470-365d-b26df6524bda@arm.com>
References: <20190115121959.23763-1-jean-philippe.brucker@arm.com>
	<20190123083435.x3svwqp472mdgglw@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190123083435.x3svwqp472mdgglw-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org" <virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org>, "kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org" <tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <Marc.Zyngier-5wv7dgnIgG8@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Robin Murphy <Robin.Murphy-5wv7dgnIgG8@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Joerg,

On 23/01/2019 08:34, Joerg Roedel wrote:
> Hi Jean-Philippe,
> 
> thanks for all your hard work on this!
> 
> On Tue, Jan 15, 2019 at 12:19:52PM +0000, Jean-Philippe Brucker wrote:
>> Implement the virtio-iommu driver, following specification v0.9 [1].
> 
> To make progress on this I think the spec needs to be close to something
> that can be included into the official virtio-specification. Have you
> proposed the specification for inclusion there?

I haven't yet. I did send a few drafts of the spec to the mailing list,
using arbitrary version numbers (0.1 - 0.9), and received excellent
feedback from Eric, Kevin, Ashok and others [2], but I hadn't formally
asked for inclusion yet. Since I haven't made any major change to the
interface in a while, I'll get on that.

> This is because I can't merge a driver that might be incompatible to
> future implementations because the specification needs to be changed on
> its way to an official standard.

Makes sense, though I think other virtio devices have been developed a
little more organically: device and driver code got upstreamed first,
and then the specification describing their interface got merged into
the standard. For example I believe that code for crypto, input and GPU
devices were upstreamed long before the specification was merged. Once
an implementation is upstream, the interface is expected to be
backward-compatible (all subsequent changes are introduced using feature
bits).

So I've been working with this process in mind, also described by Jens
at KVM forum 2017 [3]:
(1) Reserve a device ID, and get that merged into virtio (ID 23 for
virtio-iommu was reserved last year)
(2) Open-source an implementation (this driver and Eric's device)
(3) Formalize and upstream the device specification

But I get that some overlap between (2) and (3) would have been better.
So far the spec document has been reviewed mainly from the IOMMU point
of view, and might require more changes to be in line with the other
virtio devices -- hopefully just wording changes. I'll kick off step
(3), but I think the virtio folks are a bit busy with finalizing the 1.1
spec so I expect it to take a while.

Thanks,
Jean

[2] RFC https://markmail.org/thread/l6b2rpc46nua4egs
    0.4 https://markmail.org/thread/f5k37mab7tnrslin
    0.5 https://markmail.org/thread/tz65oolu5do7hi6n
    0.6 https://markmail.org/thread/dppbg6owzrx2km2n
    0.7 https://markmail.org/thread/dgdy4hicswpakmsq

[3] The future of virtio: riddles, myths and surprises
    https://www.linux-kvm.org/images/0/03/Virtio_fall_2017.pdf
    https://www.youtube.com/watch?v=z9cWwgYH97A


> I had a short discussion with Michael S. Tsirkin about that and from
> what I understood the spec needs to be proposed for inclusion on the
> virtio-comment[1] mailing list and later the TC needs to vote on it.
> Please work with Michael on this to get the specification official (or
> at least pretty close to something that will be part of the official
> virtio standard).
> 
> Regards,
> 
> 	Joerg
> 
> [1] https://www.oasis-open.org/committees/comments/index.php?wg_abbrev=virtio
