Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE6DC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 11:32:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFABA4B105;
	Wed,  8 Dec 2021 06:32:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gVaeQfNst39H; Wed,  8 Dec 2021 06:32:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA824B0DD;
	Wed,  8 Dec 2021 06:32:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C864B092
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 21:44:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W2jKxI9c6zxN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 21:44:33 -0500 (EST)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B07A4B08E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 21:44:33 -0500 (EST)
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="224612928"
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; d="scan'208";a="224612928"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 07 Dec 2021 18:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; d="scan'208";a="515586056"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118])
 ([10.239.159.118])
 by orsmga008.jf.intel.com with ESMTP; 07 Dec 2021 18:44:23 -0800
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To: eric.auger@redhat.com, Joerg Roedel <joro@8bytes.org>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
From: Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
Date: Wed, 8 Dec 2021 10:44:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Wed, 08 Dec 2021 06:32:05 -0500
Cc: kevin.tian@intel.com, lushenming@huawei.com, ashok.raj@intel.com,
 kvm@vger.kernel.org, jean-philippe@linaro.org, maz@kernel.org,
 robin.murphy@arm.com, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, vsethi@nvidia.com, vivek.gautam@arm.com,
 alex.williamson@redhat.com, Jason Gunthorpe <jgg@nvidia.com>,
 wangxingang5@huawei.com, zhangfei.gao@linaro.org, baolu.lu@linux.intel.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 12/7/21 6:22 PM, Eric Auger wrote:
> On 12/6/21 11:48 AM, Joerg Roedel wrote:
>> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
>>> Signed-off-by: Jean-Philippe Brucker<jean-philippe.brucker@arm.com>
>>> Signed-off-by: Liu, Yi L<yi.l.liu@linux.intel.com>
>>> Signed-off-by: Ashok Raj<ashok.raj@intel.com>
>>> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
>>> Signed-off-by: Eric Auger<eric.auger@redhat.com>
>> This Signed-of-by chain looks dubious, you are the author but the last
>> one in the chain?
> The 1st RFC in Aug 2018
> (https://lists.cs.columbia.edu/pipermail/kvmarm/2018-August/032478.html)
> said this was a generalization of Jacob's patch
> 
> 
>    [PATCH v5 01/23] iommu: introduce bind_pasid_table API function
> 
> 
>    https://lists.linuxfoundation.org/pipermail/iommu/2018-May/027647.html
> 
> So indeed Jacob should be the author. I guess the multiple rebases got
> this eventually replaced at some point, which is not an excuse. Please
> forgive me for that.
> Now the original patch already had this list of SoB so I don't know if I
> shall simplify it.

As we have decided to move the nested mode (dual stages) implementation
onto the developing iommufd framework, what's the value of adding this
into iommu core?

Best regards,
baolu
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
