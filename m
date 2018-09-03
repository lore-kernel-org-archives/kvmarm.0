From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 09/13] iommu/smmuv3: Get prepared for nested stage support
Date: Mon, 3 Sep 2018 14:48:58 +0200
Message-ID: <a1c79d41-ad83-1883-dd80-c1153ccfd777@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
 <1535026656-8450-10-git-send-email-eric.auger@redhat.com>
 <538a2b88-dec5-a6fa-d918-486284eb56a9@arm.com>
 <012d4950-7a06-2d59-85a0-44d511ad893b@redhat.com>
 <e6de91f7-2410-b0dd-b118-674c32bae5e8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 054134A1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 08:49:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScK0cHrf5z-A for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 08:49:04 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56B304A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 08:49:04 -0400 (EDT)
In-Reply-To: <e6de91f7-2410-b0dd-b118-674c32bae5e8@arm.com>
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
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, "yi.l.liu\""@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On 09/03/2018 02:29 PM, Jean-Philippe Brucker wrote:
> On 31/08/2018 15:11, Auger Eric wrote:
>> Yep this works with my setup but I was waiting for such kind of comments
>> to turn this prototype into something more "production level" ;-) Did
>> you send anything upstream, related to this branch?
> 
> No I didn't have time to clean it up yet, and don't know when I'll be
> able to send it out. With host SVA and virtio-iommu, I have enough
> patches in flight to keep me busy for a while :) But you can obviously
> pick patches from that branch if they help.

I understand ;-) I will update the uapi according to our last
discussions and I will look at your patches, especially smmu-v3 changes,
adding your Sob when relevant.

Thanks

Eric
> 
> Thanks,
> Jean
> 
