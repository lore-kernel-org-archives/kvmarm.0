From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC 02/13] iommu: Introduce tlb_invalidate API
Date: Mon, 3 Sep 2018 14:41:35 +0100
Message-ID: <fe514d3f-ef43-5fc3-8fe1-1d5dadd2b0b6@arm.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-3-git-send-email-eric.auger@redhat.com>
 <11279859-08f8-6d9d-7aa7-7a5de4cfd3fb@arm.com>
 <95e423a6-3f67-d101-a391-369a1493dff9@redhat.com>
 <8a3b8fcd-48c4-7d9e-7672-e73431bcde5b@arm.com>
 <8c06530b-afad-1c13-4c42-f97b650f8e5b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c06530b-afad-1c13-4c42-f97b650f8e5b@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, "yi.l.liu\""@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 03/09/2018 13:41, Auger Eric wrote:
> Also what about CMD_CFI_CD(_ALL) propagation. Is it an
> IOMMU_INV_TYPE_PASID invalidation?

Yes, INV_TYPE_PASID corresponds to the config invalidation. CMD_CFGI_CD
is granule INV_GRANU_PASID_SEL and CMD_CFGI_CD_ALL is granule
INV_GRANU_ALL_PASID

Thanks,
Jean
