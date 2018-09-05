From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Wed, 5 Sep 2018 00:36:23 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D1912F0BC2@SHSMSX101.ccr.corp.intel.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-2-git-send-email-eric.auger@redhat.com>
 <22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
 <b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
 <4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D1912EFB76@SHSMSX101.ccr.corp.intel.com>
 <220e4c2a-d31c-d8fb-2d77-d902d2f13bb2@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D1912EFCD8@SHSMSX101.ccr.corp.intel.com>
 <8da25040-42fe-5ce8-2647-ee6b8d795bc9@redhat.com>
 <c05ac969-2921-3166-e715-af3595291666@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC9C4A1FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 20:36:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7RJM2CP3bBDl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Sep 2018 20:36:38 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 353354A1D2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 20:36:38 -0400 (EDT)
In-Reply-To: <c05ac969-2921-3166-e715-af3595291666@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Auger Eric <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

> From: Jean-Philippe Brucker [mailto:jean-philippe.brucker@arm.com]
> Sent: Tuesday, September 4, 2018 5:53 PM
> 
> On 04/09/2018 09:41, Auger Eric wrote:
> > I think the confusion comes from the different terminology used in VTD
> > and ARM SMMU spec.
> >
> > Your PASID table ~ ARM SMMU Context Descriptor (CD) table
> > Your Root Entry/Context Entry ~ ARM SMMU Stream Table Entry (STE)
> 
> In past discussions we used "PASID table (entry)" and "device context"
> respectively. For clarity we should probably stick to those names unless
> we discuss arch-specific patches
> 

yes, that is a good abstraction. let's try to use them in related discussions
and patch series.

Thanks
Kevin
