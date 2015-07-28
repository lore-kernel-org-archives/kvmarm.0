From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 0/2] VFIO: Add virtual MSI doorbell support.
Date: Tue, 28 Jul 2015 17:55:04 +0100
Message-ID: <55B7B3E8.9020000@arm.com>
References: <1437728590-23126-1-git-send-email-pranavkumar@linaro.org> <1438100507.5211.170.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438100507.5211.170.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Will Deacon <Will.Deacon@arm.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "arnd@arndb.de" <arnd@arndb.de>, "rob.herring@linaro.org" <rob.herring@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "patches@apm.com" <patches@apm.com>, Bharat Bhushan <Bharat.Bhushan@freescale.com>, Stuart Yoder <stuart.yoder@freescale.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 28/07/15 17:21, Alex Williamson wrote:
> On Fri, 2015-07-24 at 14:33 +0530, Pranavkumar Sawargaonkar wrote:
>> In current VFIO MSI/MSI-X implementation, linux host kernel
>> allocates MSI/MSI-X vectors when userspace requests through vfio ioctls.
>> Vfio creates irqfd mappings to notify MSI/MSI-X interrupts
>> to the userspace when raised.
>> Guest OS will see emulated MSI/MSI-X controller and receives an interrupt
>> when kernel notifies the same via irqfd.
>>
>> Host kernel allocates MSI/MSI-X using standard linux routines
>> like pci_enable_msix_range() and pci_enable_msi_range(). 
>> These routines along with requset_irq() in host kernel sets up 
>> MSI/MSI-X vectors with Physical MSI/MSI-X addresses provided by
>> interrupt controller driver in host kernel.
>>
>> This means when a device is assigned with the guest OS, MSI/MSI-X addresses
>> present in PCIe EP are the PAs programmed by the host linux kernel.
>>
>> In x86 MSI/MSI-X physical address range is reserved and iommu is aware
>> about these addreses and transalation is bypassed for these address range.
>>
>> Unlike x86, ARM/ARM64 does not reserve MSI/MSI-X Physical address range and
>> all the transactions including MSI go through iommu/smmu without bypass.
>> This requires extending current vfio MSI layer with additional functionality
>> for ARM/ARM64 by
>> 1. Programing IOVA (referred as a MSI virtual doorbell address)
>>    in device's MSI vector as a MSI address.
>>    This IOVA will be provided by the userspace based on the
>>    MSI/MSI-X addresses reserved for the guest.
>> 2. Create an IOMMU mapping between this IOVA and
>>    Physical address (PA) assigned to the MSI vector.
>>
>> This RFC is proposing a solution for MSI/MSI-X passthrough for ARM/ARM64.
> 
> 
> Hi Pranavkumar,
> 
> Freescale has the same, or very similar, need, so any solution in this
> space will need to work for both ARM and powerpc.  I'm not a big fan of
> this approach as it seems to require the user to configure MSI/X via
> ioctl and then call a separate ioctl mapping the doorbells.  That's more
> code for the user, more code to get wrong and potentially a gap between
> configuring MSI/X and enabling mappings where we could see IOMMU faults.
> 
> If we know that doorbell mappings are required, why can't we set aside a
> bank of IOVA space and have them mapped automatically as MSI/X is being
> configured?  Then the user's need for special knowledge and handling of
> this case is limited to setup.  The IOVA space will be mapped and used
> as needed, we only need the user to specify the IOVA space reserved for
> this.  Thanks,

I guess my immediate worry is that it seems to impose a fixed mapping
for all the guests, which would restrict the "shape" of the mappings we
give to a guest. Or did you intend for that IOVA mapping to be defined
on a "per userspace instance" basis?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
