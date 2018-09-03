From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Mon, 3 Sep 2018 13:19:31 +0100
Message-ID: <58418b7b-44f4-9659-98df-b5f24bed3e15@arm.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-2-git-send-email-eric.auger@redhat.com>
 <22c01a4d-c74a-7279-d4ae-39e29a3bc942@redhat.com>
 <b7909f1b-57ce-f4db-d916-140a63283232@arm.com>
 <4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4309832b-27ed-597a-b5a1-f439fbea9843@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 31/08/2018 14:52, Auger Eric wrote:
> Do we agree here we can get rid of the struct device * parameter?

That's fine by me, in my opinion the bind operation should only be on
the domain, like map/unmap. For the invalidation however, I think we
need to keep the device as an optional parameter, because the guest may
want to invalidate the ATC (DTLB) of a single device.

Thanks,
Jean
