Return-Path: <SRS0=RBRv=T7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20009C04AB6
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 11:14:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96BD62681C
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 11:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96BD62681C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E29C24A4E1;
	Fri, 31 May 2019 07:14:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kK2bMII0q2G1; Fri, 31 May 2019 07:14:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 730224A4DF;
	Fri, 31 May 2019 07:14:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8156C4A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 07:14:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z4yxjHZV+fXZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 May 2019 07:14:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E53814A369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 07:14:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A8B6341;
 Fri, 31 May 2019 04:14:13 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E6DF3F5AF;
 Fri, 31 May 2019 04:14:10 -0700 (PDT)
Subject: Re: [virtio-dev] Re: [PATCH v8 2/7] dt-bindings: virtio: Add
 virtio-pci-iommu node
To: "Michael S. Tsirkin" <mst@redhat.com>
References: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
 <20190530170929.19366-3-jean-philippe.brucker@arm.com>
 <20190530133523-mutt-send-email-mst@kernel.org>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <c3cd5dba-123d-e808-98b1-731ac2d4b950@arm.com>
Date: Fri, 31 May 2019 12:13:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530133523-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Cc: "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
 "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>,
 "frowand.list@gmail.com" <frowand.list@gmail.com>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "robh+dt@kernel.org" <robh+dt@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 Robin Murphy <Robin.Murphy@arm.com>,
 "jasowang@redhat.com" <jasowang@redhat.com>,
 "bauerman@linux.ibm.com" <bauerman@linux.ibm.com>
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

On 30/05/2019 18:45, Michael S. Tsirkin wrote:
> On Thu, May 30, 2019 at 06:09:24PM +0100, Jean-Philippe Brucker wrote:
>> Some systems implement virtio-iommu as a PCI endpoint. The operating
>> system needs to discover the relationship between IOMMU and masters long
>> before the PCI endpoint gets probed. Add a PCI child node to describe the
>> virtio-iommu device.
>>
>> The virtio-pci-iommu is conceptually split between a PCI programming
>> interface and a translation component on the parent bus. The latter
>> doesn't have a node in the device tree. The virtio-pci-iommu node
>> describes both, by linking the PCI endpoint to "iommus" property of DMA
>> master nodes and to "iommu-map" properties of bus nodes.
>>
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> 
> So this is just an example right?
> We are not defining any new properties or anything like that.

Yes it's just an example. The properties already exist but it's good to
describe how to put them together for this particular case, because
there isn't a precedent describing the topology for an IOMMU that
appears on the PCI bus.

> I think down the road for non dt platforms we want to put this
> info in the config space of the device. I do not think ACPI
> is the best option for this since not all systems have it.
> But that can wait.

There is the probe order problem - PCI needs this info before starting
to probe devices on the bus. Maybe we could store the info in a separate
memory region, that is referenced on the command-line and that the guest
can read early.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
