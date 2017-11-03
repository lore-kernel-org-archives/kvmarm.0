From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH kvmtool 2/2] Add GICv2m support
Date: Fri, 3 Nov 2017 15:03:08 +0000
Message-ID: <6620c78d-f61e-57ee-37e4-ddb158f7ac2f@arm.com>
References: <20171103113841.3066-1-jean-philippe.brucker@arm.com>
 <20171103113841.3066-3-jean-philippe.brucker@arm.com>
 <fa935a6d-2692-f4d9-7527-b434452ff334@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <fa935a6d-2692-f4d9-7527-b434452ff334@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>, Punit Agrawal <Punit.Agrawal@arm.com>, Will Deacon <Will.Deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/11/17 14:27, Andre Przywara wrote:
> Hi,
> 
> good stuff, thanks for doing this!
> 
> On 03/11/17 11:38, Jean-Philippe Brucker wrote:
>> GICv2m is a small extension to the GICv2 architecture, specified in the
>> Server Base System Architecture (SBSA). It adds a set of register to
>> converts MSIs into SPIs, effectively enabling MSI support for pre-GICv3
>> platforms.
> 
> I was wondering if it would be worth to split this up, and introduce the
> msi_routing_ops in a separate patch first, possibly even the changes to
> pci.c.
> 
>> Implement a GICv2m emulation entirely in userspace. Add a thin translation
>> layer in irq.c to catch the MSI->SPI routing setup of the guest, and then
>> transform irqfd injection of MSI into the associated SPI. There shouldn't
>> be any significant runtime overhead compared to gicv3-its.
> 
> As others have pointed out already, these patches seem to rely on some
> other patches.
> However by ignoring the two hunks in non-yet-existing functions in irq.c

Right, this was based on the VFIO series and a bit rushed, sorry about
that. A little more work is needed to support irqfd ("irq: add irqfd
helpers") and the combination GICv2m+force-pci+vhost, but it should be
ready soon enough.

Thanks,
Jean
