Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99144C31E46
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 18:50:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24ED020896
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 18:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24ED020896
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A614A4E8;
	Wed, 12 Jun 2019 14:50:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QE8GotWd-lA2; Wed, 12 Jun 2019 14:50:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8A74A50B;
	Wed, 12 Jun 2019 14:50:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9654A508
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 14:50:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dZtF5gpLLW2D for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 14:50:51 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24A694A4E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 14:50:51 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 12 Jun 2019 11:50:49 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
 by orsmga004.jf.intel.com with ESMTP; 12 Jun 2019 11:50:49 -0700
Date: Wed, 12 Jun 2019 11:53:58 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190612115358.0d90b322@jacob-builder>
In-Reply-To: <905f130b-02dc-6971-8d5b-ce87d9bc96a4@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <20190603163139.70fe8839@x1.home>
 <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
 <20190605154553.0d00ad8d@jacob-builder>
 <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
 <20190606132903.064f7ac4@jacob-builder>
 <dc051424-67d7-02ff-9b8e-0d7a8a4e59eb@arm.com>
 <20190607104301.6b1bbd74@jacob-builder>
 <e02b024f-6ebc-e8fa-c30c-5bf3f4b164d6@arm.com>
 <20190610143134.7bff96e9@jacob-builder>
 <905f130b-02dc-6971-8d5b-ce87d9bc96a4@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 Vincent Stehle <Vincent.Stehle@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Marc Zyngier <Marc.Zyngier@arm.com>, jacob.jun.pan@linux.intel.com,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "Liu,
 Yi L" <yi.l.liu@intel.com>, Robin Murphy <Robin.Murphy@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
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

On Tue, 11 Jun 2019 14:14:33 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 10/06/2019 22:31, Jacob Pan wrote:
> > On Mon, 10 Jun 2019 13:45:02 +0100
> > Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:
> >   
> >> On 07/06/2019 18:43, Jacob Pan wrote:  
> >>>>> So it seems we agree on the following:
> >>>>> - iommu_unregister_device_fault_handler() will never fail
> >>>>> - iommu driver cleans up all pending faults when handler is
> >>>>> unregistered
> >>>>> - assume device driver or guest not sending more page response
> >>>>> _after_ handler is unregistered.
> >>>>> - system will tolerate rare spurious response
> >>>>>
> >>>>> Sounds right?      
> >>>>
> >>>> Yes, I'll add that to the fault series    
> >>> Hold on a second please, I think we need more clarifications.
> >>> Ashok pointed out to me that the spurious response can be harmful
> >>> to other devices when it comes to mdev, where PRQ group id is not
> >>> per PASID, device may reuse the group number and receiving
> >>> spurious page response can confuse the entire PF.     
> >>
> >> I don't understand how mdev differs from the non-mdev situation
> >> (but I also still don't fully get how mdev+PASID will be
> >> implemented). Is the following the case you're worried about?
> >>
> >>   M#: mdev #
> >>
> >> # Dev         Host        mdev drv       VFIO/QEMU        Guest
> >> ====================================================================
> >> 1                     <- reg(handler)
> >> 2 PR1 G1 P1    ->         M1 PR1 G1        inject ->     M1 PR1 G1
> >> 3                     <- unreg(handler)
> >> 4       <- PS1 G1 P1 (F)      |
> >> 5                        unreg(handler)
> >> 6                     <- reg(handler)
> >> 7 PR2 G1 P1    ->         M2 PR2 G1        inject ->     M2 PR2 G1
> >> 8                                                     <- M1 PS1 G1
> >> 9         accept ??    <- PS1 G1 P1
> >> 10                                                    <- M2 PS2 G1
> >> 11        accept       <- PS2 G1 P1
> >>  
> > Not really. I am not worried about PASID reuse or unbind. Just
> > within the same PASID bind lifetime of a single mdev, back to back
> > register/unregister fault handler.
> > After Step 4, device will think G1 is done. Device could reuse G1
> > for the next PR, if we accept PS1 in step 9, device will terminate
> > G1 before the real G1 PS arrives in Step 11. The real G1 PS might
> > have a different response code. Then we just drop the PS in Step
> > 11?  
> 
> Yes, I think we do. Two possibilities:
> 
> * G1 is reused at step 7 for the same PASID context, which means that
> it is for the same mdev. The problem is then identical to the non-mdev
> case, new page faults and old page response may cross:
> 
> # Dev         Host        mdev drv       VFIO/QEMU        Guest
> ====================================================================
> 7 PR2 G1 P1  --.
> 8               \                         .------------- M1 PS1 G1
> 9                '----->  PR2 G1 P1  ->  /   inject  --> M1 PR2 G1
> 10           accept <---  PS1 G1 P1  <--'
> 11           reject <---  PS2 G1 P1  <------------------ M1 PS2 G1
> 
> And the incorrect page response is returned to the guest. However it
> affects a single mdev/guest context, it doesn't affect other mdevs.
> 
> * Or G1 is reused at step 7 for a different PASID. At step 10 the
> fault handler rejects the page response because the PASID is
> different, and step 11 is accepted.
> 
> 
> >>> Having spurious page response is also not
> >>> abiding the PCIe spec. exactly.    
> >>
> >> We are following the PCI spec though, in that we don't send page
> >> responses for PRGIs that aren't in flight.
> >>  
> > You are right, the worst case of the spurious PS is to terminate the
> > group prematurely. Need to know the scope of the HW damage in case
> > of mdev where group IDs can be shared among mdevs belong to the
> > same PF.  
> 
> But from the IOMMU fault API point of view, the full page request is
> identified by both PRGI and PASID. Given that each mdev has its own
> set of PASIDs, it should be easy to isolate page responses per mdev.
> 
On Intel platform, devices sending page request with private data must
receive page response with matching private data. If we solely depend
on PRGI and PASID, we may send stale private data to the device in
those incorrect page response. Since private data may represent PF
device wide contexts, the consequence of sending page response with
wrong private data may affect other mdev/PASID.

One solution we are thinking to do is to inject the sequence #(e.g.
ktime raw mono clock) as vIOMMU private data into to the guest. Guest
would return this fake private data in page response, then host will
send page response back to the device that matches PRG1 and PASID and
private_data.

This solution does not expose HW context related private data to the
guest but need to extend page response in iommu uapi.

/**
 * struct iommu_page_response - Generic page response information
 * @version: API version of this structure
 * @flags: encodes whether the corresponding fields are valid
 *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
 * @pasid: Process Address Space ID
 * @grpid: Page Request Group Index
 * @code: response code from &enum iommu_page_response_code
 * @private_data: private data for the matching page request
 */
struct iommu_page_response {
#define IOMMU_PAGE_RESP_VERSION_1	1
	__u32	version;
#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
#define IOMMU_PAGE_RESP_PRIVATE_DATA	(1 << 1)
	__u32	flags;
	__u32	pasid;
	__u32	grpid;
	__u32	code;
	__u32	padding;
	__u64	private_data[2];
};

There is also the change needed for separating storage for the real and
fake private data.

Sorry for the last minute change, did not realize the HW implications.

I see this as a future extension due to limited testing, perhaps for
now, can you add paddings similar to page request? Make it 64B as well.

struct iommu_page_response {
#define IOMMU_PAGE_RESP_VERSION_1	1
	__u32	version;
#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
	__u32	flags;
	__u32	pasid;
	__u32	grpid;
	__u32	code;
	__u8	padding[44];
};

Thanks!

Jacob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
