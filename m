From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 09/13] iommu/smmuv3: Get prepared for nested stage support
Date: Fri, 31 Aug 2018 16:11:37 +0200
Message-ID: <012d4950-7a06-2d59-85a0-44d511ad893b@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-10-git-send-email-eric.auger@redhat.com>
 <538a2b88-dec5-a6fa-d918-486284eb56a9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <538a2b88-dec5-a6fa-d918-486284eb56a9@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, "\"eric.auger.pro"@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, "yi.l.liu\""@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On 08/31/2018 03:20 PM, Jean-Philippe Brucker wrote:
> On 23/08/18 13:17, Eric Auger wrote:
>>  	if (ste->s1_cfg) {
>> -		BUG_ON(ste_live);
> 
> Scary! :) The current code assumes that it can make modifications to the
> STE in any order and enable translation after a sync. So far I haven't
> been able to find anything that violates this rule in the spec: "If
> software modifies the structure while it is valid, it must not allow the
> structure to enter an invalid intermediate state." So maybe it's fine,
> though to be safe I would have started with disabling the STE
> (http://www.linux-arm.org/git?p=linux-jpb.git;a=commitdiff;h=936e49f923e101c061269eadd5fa43fef819d2e9)

Yep this works with my setup but I was waiting for such kind of comments
to turn this prototype into something more "production level" ;-) Did
you send anything upstream, related to this branch?

Thanks

Eric
> 
> Thanks,
> Jean
> 
