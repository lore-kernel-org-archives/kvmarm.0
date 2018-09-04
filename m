From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Tue, 4 Sep 2018 10:53:11 +0100
Message-ID: <c05ac969-2921-3166-e715-af3595291666@arm.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-2-git-send-email-eric.auger@redhat.com>
 <22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
 <b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
 <4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D1912EFB76@SHSMSX101.ccr.corp.intel.com>
 <220e4c2a-d31c-d8fb-2d77-d902d2f13bb2@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D1912EFCD8@SHSMSX101.ccr.corp.intel.com>
 <8da25040-42fe-5ce8-2647-ee6b8d795bc9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8da25040-42fe-5ce8-2647-ee6b8d795bc9@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, "Tian, Kevin" <kevin.tian@intel.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, Christoffer Dall <Christoffer.Dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/09/2018 09:41, Auger Eric wrote:
> I think the confusion comes from the different terminology used in VTD
> and ARM SMMU spec.
> 
> Your PASID table ~ ARM SMMU Context Descriptor (CD) table
> Your Root Entry/Context Entry ~ ARM SMMU Stream Table Entry (STE)

In past discussions we used "PASID table (entry)" and "device context"
respectively. For clarity we should probably stick to those names unless
we discuss arch-specific patches

Thanks,
Jean
