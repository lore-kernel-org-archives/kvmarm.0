From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v3 5/7] iommu: Add virtio-iommu driver
Date: Thu, 8 Nov 2018 16:46:19 +0000
Message-ID: <eebdbcd4-e7eb-d5cf-3cc9-6223d9bcfbe0@arm.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
 <20181012145917.6840-6-jean-philippe.brucker@arm.com>
 <20181012120953-mutt-send-email-mst@kernel.org>
 <60605670-0419-3f64-a379-9c4057d90db1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 669384A314
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 11:46:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sM9fl0URAobQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Nov 2018 11:46:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4177A4A34F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 11:46:39 -0500 (EST)
In-Reply-To: <60605670-0419-3f64-a379-9c4057d90db1@redhat.com>
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
To: Auger Eric <eric.auger@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org, robh+dt@kernel.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/11/2018 14:51, Auger Eric wrote:
>>> +/*
>>> + * viommu_replay_mappings - re-send MAP requests
>>> + *
>>> + * When reattaching a domain that was previously detached from all endpoints,
>>> + * mappings were deleted from the device. Re-create the mappings available in
>>> + * the internal tree.
>>> + */
>>> +static int viommu_replay_mappings(struct viommu_domain *vdomain)
>>> +{
>>> +	int ret;
> ret needs to be initialized here. Otherwise this can lead to a crash in
> viommu_add_device.

I actually hit this one while testing the other day :) Fixed in next version

Thanks,
Jean
