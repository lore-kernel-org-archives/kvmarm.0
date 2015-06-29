From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] kvmtool: don't use PCI config space IRQ line field
Date: Mon, 29 Jun 2015 11:10:05 +0100
Message-ID: <20150629101004.GB17474@arm.com>
References: <1433431245-23227-1-git-send-email-andre.przywara@arm.com>
 <20150605164158.GL7420@arm.com>
 <557EACD2.1030500@arm.com>
 <20150616170657.GO30522@arm.com>
 <5582FDB9.3020700@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5582FDB9.3020700@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Thu, Jun 18, 2015 at 06:19:53PM +0100, Andre Przywara wrote:
> I am tempted to remove shmem, since it's broken:
> a) there is no upstream driver, only some out-of-tree uio driver module
> in some Github repo

Right, but that's the same for qemu and we've already made the jump of
merging the driver, so I don't think that's a good argument for throwing
it out of the tree.

> b) the PCI device BARs do not match what QEMU implements and what the
> uio driver expects (IO BAR vs. MMIO BAR)

In what way? A quick look suggests that kvmtool is at least aligned with
said github repo.

> c) there is (at least one) bug in kvmtool (easily fixed, though)

Care to elaborate?

Will
