From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Mon, 27 Jun 2016 09:17:45 +0100
Message-ID: <5770E129.10101@arm.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160624145748.e2uwqrdv2fik46wc@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 684A4411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 04:12:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W2Ef1nuAqRNC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 04:12:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45917410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 04:12:42 -0400 (EDT)
In-Reply-To: <20160624145748.e2uwqrdv2fik46wc@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/06/16 15:57, Andrew Jones wrote:
> 
> Hi Ard,
> 
> Thanks for bringing this back up again (I think :-)
> 
> On Fri, Jun 24, 2016 at 04:04:45PM +0200, Ard Biesheuvel wrote:
>> Hi all,
>>
>> This old subject came up again in a discussion related to PCIe support
>> for QEMU/KVM under Tianocore. The fact that we need to map PCI MMIO
>> regions as cacheable is preventing us from reusing a significant slice
>> of the PCIe support infrastructure, and so I'd like to bring this up
>> again, perhaps just to reiterate why we're simply out of luck.
>>
>> To refresh your memories, the issue is that on ARM, PCI MMIO regions
>> for emulated devices may be backed by memory that is mapped cacheable
>> by the host. Note that this has nothing to do with the device being
>> DMA coherent or not: in this case, we are dealing with regions that
>> are not memory from the POV of the guest, and it is reasonable for the
>> guest to assume that accesses to such a region are not visible to the
>> device before they hit the actual PCI MMIO window and are translated
>> into cycles on the PCI bus. That means that mapping such a region
>> cacheable is a strange thing to do, in fact, and it is unlikely that
>> patches implementing this against the generic PCI stack in Tianocore
>> will be accepted by the maintainers.
>>
>> Note that this issue not only affects framebuffers on PCI cards, it
>> also affects emulated USB host controllers (perhaps Alex can remind us
>> which one exactly?) and likely other emulated generic PCI devices as
>> well.
>>
>> Since the issue exists only for emulated PCI devices whose MMIO
>> regions are backed by host memory, is there any way we can already
>> distinguish such memslots from ordinary ones? If we can, is there
> 
> When I was looking at this I didn't see any way to identify these
> memslots. I wrote some patches to add a new flag, KVM_MEM_NONCACHEABLE,
> allowing userspace to point them out. That was the easy part (although
> I didn't like that userspace developers would have to go around finding
> all memory regions that needed to be flagged, and new devices would
> likely not be flagged when developed on non-arm architectures, so we'd
> always be chasing it...) However what really slowed/stopped me was
> trying to figure out what to do with those identified memslots.
> 
> My last idea, which had implementation issues (probably because I was
> getting in over my head), was
> 
>  1) introduce PAGE_S2_NORMAL_NC and use it when mapping the guest's pages
>  2) flush the userspace pages and update all PTEs to be NC
> 
> The reasoning was that, while we can't force a guest to use cacheable
> memory, we can take advantage of the noncacheable precedence of the
> architecture, forcing the memory accesses to be noncached by way of
> S2 attributes. And of course userspace mappings also need to become NC
> to finally have coherency.

I think this is a sensible course of action, as long as you can identify
a specific memblock on which to apply this. You may even not have to
"repaint" the PTEs, but instead obtain a non-cacheable mapping from the
kernel (at a different address).

I'm more worried if we end-up having both cacheable and non-cacheable
pages inside the same VMA (and Alex seems to point at USB having weird
requirements around this).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
