From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC 09/13] iommu/smmuv3: Get prepared for nested stage support
Date: Fri, 31 Aug 2018 14:20:34 +0100
Message-ID: <538a2b88-dec5-a6fa-d918-486284eb56a9@arm.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-10-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535026656-8450-10-git-send-email-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, "\"eric.auger.pro"@gmail.comeric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jean-philippe.brucker@arm.com, jacob.jun.pan@linux.intel.com, "yi.l.liu\""@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 23/08/18 13:17, Eric Auger wrote:
>  	if (ste->s1_cfg) {
> -		BUG_ON(ste_live);

Scary! :) The current code assumes that it can make modifications to the
STE in any order and enable translation after a sync. So far I haven't
been able to find anything that violates this rule in the spec: "If
software modifies the structure while it is valid, it must not allow the
structure to enter an invalid intermediate state." So maybe it's fine,
though to be safe I would have started with disabling the STE
(http://www.linux-arm.org/git?p=linux-jpb.git;a=commitdiff;h=936e49f923e101c061269eadd5fa43fef819d2e9)

Thanks,
Jean
