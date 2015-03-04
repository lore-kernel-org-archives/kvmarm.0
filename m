From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Wed, 04 Mar 2015 10:45:04 -0700
Message-ID: <1425491104.5200.268.camel@redhat.com>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425485274-5709-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
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
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-03-04 at 17:07 +0100, Baptiste Reynal wrote:
> This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM, so it
> may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC flag
> supported by SMMUs adhering to the ARM SMMU specification so the VFIO user can
> specify whether the target memory can be executed by the device behind the
> SMMU.

Ok, so the differences between IOMMU_CACHE and IOMMU_NOEXEC are twofold.
First is that when the IOMMU is IOMMU_CAP_CACHE_COHERENCY we always use
IOMMU_CACHE for all mappings within the domain.  This is not a user
provided mapping flag.  Second, if a device is added behind an IOMMU
that is not IOMMU_CAP_CACHE_COHERENCY capable, this simply means that it
needs to be managed as a separate domain within the same container.
vfio_domains_have_iommu_cache() reports true only if all domains within
the container support, and are therefore using, IOMMU_CACHE.

On the other hand, IOMMU_NOEXEC is a feature, but not a global mapping
flag for a domain.  There are potentially some mappings with it within a
domain and some without, just like the IOMMU_READ/IOMMU_WRITE.  It's
therefore a per-DMA mapping flag as you've implemented in patch 4.
Second, as a user specified flag, support for it is mandatory.  If a
device is added behind an IOMMU that does not support NOEXEC and NOEXEC
mappings are in use, the device must be rejected from addition to the
container.

Hopefully that's correct, because I think that's what the code does.
The problem I have with the code is that I don't think it's acceptable
to call iommu_ops.capable() directly.  This is breaking an abstraction
of the IOMMU API.  The obvious problem with that is:

bool iommu_capable(struct bus_type *bus, enum iommu_cap cap)

I assume you're calling the op directly because of bus_type, but that's
no excuse to misuse the API.  Our choice is either to try to extend the
API, maybe create:

bool iommu_domain_capable(struct iommu_domain *domain, enum iommu_cap cap)

Or to use the available function by either caching the value when we do
have a bus_type available to us, or storing or discovering bus_type.  It
doesn't seem that terrible to cache it on the domain.  Be careful though
that if a device imposing lack of NOEXEC on a domain is removed, the
ability to do NOEXEC mappings should be reinstated.  That would be easy
if we use separate vfio_domains to manage NOEXEC capable vs NOEXEC
in-capable devices (like we do CACHE vs no-CACHE), but there's some
additional overhead to do that since it implies a separate iommu_domain.
Thanks,

Alex
