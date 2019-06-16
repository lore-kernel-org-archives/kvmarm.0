Return-Path: <SRS0=zS8b=UP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4444EC31E50
	for <kvmarm@archiver.kernel.org>; Sun, 16 Jun 2019 20:05:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA79620657
	for <kvmarm@archiver.kernel.org>; Sun, 16 Jun 2019 20:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA79620657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D40D4A4CA;
	Sun, 16 Jun 2019 16:05:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UFX2Oggc+M7P; Sun, 16 Jun 2019 16:04:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C6D4A518;
	Sun, 16 Jun 2019 16:04:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E7C4A4CA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Jun 2019 16:04:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3-kK8JAlyEPM for <kvmarm@lists.cs.columbia.edu>;
 Sun, 16 Jun 2019 16:04:54 -0400 (EDT)
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com
 [209.85.222.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ED664A4A9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Jun 2019 16:04:54 -0400 (EDT)
Received: by mail-qk1-f195.google.com with SMTP id l128so4999915qke.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Jun 2019 13:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MSqaCoMGco6P2zrSK37/hWJH9CXgQkBw2hzb1U1jzNw=;
 b=ayCVU5JHE6iIt84v4LFiBKOV5R0/ZLgBWzUEePSB41r2Am9k76Qua5YvU/9wIG9nIQ
 Ys7WcHa6hWYVctgMjWruDfc7FLjlVTA+huKiRw3t+inyU1Q25X3tm04U9d/fdDIcypc2
 0uDg9Rm4oq0BfYE7L5r4BEdq9eEvQdcm9kBCsUrain5zEqw0Y1Dp0AgW9JsbwcB598Sn
 LYcXeZUcqArB/cYcVVpNTqQ18OQhb5LXPodkZkKDp8TvWxT7ByTadiigubJFCH9YlOE1
 dCnqXOtANO91y+Q8Y8CR0b4SP7ES1PfeVHzHhBmWe/iC1+5nbqSbqABi+WtMJzPJKxwi
 RJ4w==
X-Gm-Message-State: APjAAAUNrnngL47rn6p34sSMPJkXfpvXOcDqpdbfvh7THFZPNyQGQvsP
 cKHyOsDxl7BFoIisgd5/+Gl0Bw==
X-Google-Smtp-Source: APXvYqzk8vjSAyBVM9AEC2sCcZJe/bhI9soeo5hRV28lwc5eEPs3dYN+S5Bd7YkUw5B0eEUJ+IVZrA==
X-Received: by 2002:ae9:c21a:: with SMTP id j26mr65498831qkg.310.1560715494165; 
 Sun, 16 Jun 2019 13:04:54 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net.
 [100.0.197.103])
 by smtp.gmail.com with ESMTPSA id w51sm4943466qth.18.2019.06.16.13.04.51
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Sun, 16 Jun 2019 13:04:53 -0700 (PDT)
Date: Sun, 16 Jun 2019 16:04:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [virtio-dev] Re: [PATCH v8 2/7] dt-bindings: virtio: Add
 virtio-pci-iommu node
Message-ID: <20190616154841-mutt-send-email-mst@kernel.org>
References: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
 <20190530170929.19366-3-jean-philippe.brucker@arm.com>
 <20190530133523-mutt-send-email-mst@kernel.org>
 <c3cd5dba-123d-e808-98b1-731ac2d4b950@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c3cd5dba-123d-e808-98b1-731ac2d4b950@arm.com>
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

On Fri, May 31, 2019 at 12:13:47PM +0100, Jean-Philippe Brucker wrote:
> On 30/05/2019 18:45, Michael S. Tsirkin wrote:
> > On Thu, May 30, 2019 at 06:09:24PM +0100, Jean-Philippe Brucker wrote:
> >> Some systems implement virtio-iommu as a PCI endpoint. The operating
> >> system needs to discover the relationship between IOMMU and masters long
> >> before the PCI endpoint gets probed. Add a PCI child node to describe the
> >> virtio-iommu device.
> >>
> >> The virtio-pci-iommu is conceptually split between a PCI programming
> >> interface and a translation component on the parent bus. The latter
> >> doesn't have a node in the device tree. The virtio-pci-iommu node
> >> describes both, by linking the PCI endpoint to "iommus" property of DMA
> >> master nodes and to "iommu-map" properties of bus nodes.
> >>
> >> Reviewed-by: Rob Herring <robh@kernel.org>
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > 
> > So this is just an example right?
> > We are not defining any new properties or anything like that.
> 
> Yes it's just an example. The properties already exist but it's good to
> describe how to put them together for this particular case, because
> there isn't a precedent describing the topology for an IOMMU that
> appears on the PCI bus.
> 
> > I think down the road for non dt platforms we want to put this
> > info in the config space of the device. I do not think ACPI
> > is the best option for this since not all systems have it.
> > But that can wait.
> 
> There is the probe order problem - PCI needs this info before starting
> to probe devices on the bus.


This isn't all that special - it's pretty common for
IOMMUs to be pci devices. The solution is to have the device on
bus 0. For example, add it with

DECLARE_PCI_FIXUP_EARLY
or
DECLARE_PCI_FIXUP_CLASS_EARLY

in e.g.
arch/x86/kernel/quirks.c
or
drivers/pci/quirks.c

You can also use the configuration access capability
if there's need to access the device before its memory is
enabled.

> Maybe we could store the info in a separate
> memory region, that is referenced on the command-line and that the guest
> can read early.
> 
> Thanks,
> Jean

The point is to avoid command line hacks. Devices should be
self describing.

-- 
MST
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
