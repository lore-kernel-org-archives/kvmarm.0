From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Tue, 4 Sep 2018 07:57:50 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D1912EFB76@SHSMSX101.ccr.corp.intel.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
	<1535026656-8450-2-git-send-email-eric.auger@redhat.com>
	<22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
	<b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
	<4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <4309832b-27ed-597a-b5a1-f439fbea9843-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>, "eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org" <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>, "robin.murphy-5wv7dgnIgG8@public.gmane.org" <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Cc: "marc.zyngier-5wv7dgnIgG8@public.gmane.org" <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "christoffer.dall-5wv7dgnIgG8@public.gmane.org" <christoffer.dall-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

> From: Auger Eric
> Sent: Friday, August 31, 2018 9:52 PM
> 
> Hi Jean-Philippe,
> 
> On 08/31/2018 03:11 PM, Jean-Philippe Brucker wrote:
> > Hi Eric,
> >
> > On 23/08/18 16:25, Auger Eric wrote:
> >>> +int iommu_bind_guest_stage(struct iommu_domain *domain, struct
> device *dev,
> >>> +			   struct iommu_guest_stage_config *cfg)
> >
> > About the name change from iommu_bind_pasid_table: is the intent to
> > reuse this API for SMMUv2, which supports nested but not PASID? Seems
> > like a good idea but "iommu_bind_table" may be better since "stage" is
> > only used by Arm.
> 
> At the moment I don't target SMUv2 but just SMMUv3. My focus was on
> nested stage enablement without enabling the multi-CD feature (PASID),
> whish is not supported by the QEMU vSMMUv3. Afterwards I realized that
> basically we are pointing to a CD or PASID table and that's about the
> same. I don't have a strong opinion on the name, iommu_bind_guest_table
> or iommu_bind_pasid_table would be fine with me. Indeed "stage" is ARM
> vocable (level for Intel?)

Intel uses first level/second level. 

iommu_bind_table is a bit confusing. what should people take table as?
there is PASID table. there is also page table linked in each stage/level. and
maybe other tables in vendor-specific definition.

to me iommu_bind_pasid_table is still clearer. anyway in other places
we've used pasid explicitly in vfio/iommu APIs, then it should be general
enough to represent various implementations.

Thanks
Kevin
