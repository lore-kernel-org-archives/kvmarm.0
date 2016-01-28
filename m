From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Thu, 28 Jan 2016 10:50:00 +0100
Message-ID: <56A9E448.6010308@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
 <000001d1585e$8097d7e0$81c787a0$@samsung.com> <56A8854F.3030209@linaro.org>
 <00aa01d1599b$5fd3bd10$1f7b3730$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00aa01d1599b$5fd3bd10$1f7b3730$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, eric.auger@st.com, alex.williamson@redhat.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, suravee.suthikulpanit@amd.com, linux-kernel@vger.kernel.org, patches@linaro.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 01/28/2016 08:13 AM, Pavel Fedin wrote:
>  Hello!
> 
>> x86 isn't problem-free in this space.  An x86 VM is going to know that
>> the 0xfee00000 address range is special, it won't be backed by RAM and
>> won't be a DMA target, thus we'll never attempt to map it for an iova
>> address.  However, if we run a non-x86 VM or a userspace driver, it
>> doesn't necessarily know that there's anything special about that range
>> of iovas.  I intend to resolve this with an extension to the iommu info
>> ioctl that describes the available iova space for the iommu.  The
>> interrupt region would simply be excluded.
> 
>  I see now, but i still don't understand how it would work. How can we tell the guest OS that we cannot do DMA to this particular
> area? Just exclude it from RAM at all? But this means we would have to modify machine's model...
>  I know that this is a bit different story from what we are implementing now. Just curious.

Well in QEMU mach-virt we have a static guest PA memory map. Maybe in
some other virt machines this is different and it is possible to take
into account the fact an IOVA range cannot be used?

Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Senior Engineer
> Samsung Electronics Research center Russia
> 
> 

