From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Wed, 10 Jan 2018 11:25:42 +0000
Message-ID: <2aacb81b-0efb-87b9-f70c-a61e66dd0331@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-2-suzuki.poulose@arm.com>
 <20180110012429-mutt-send-email-mst@kernel.org>
 <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
 <20180110130230-mutt-send-email-mst@kernel.org>
 <CAFEAcA9VJ41vPBOwYSVHmBGtjdA4jL2b2mHAUZ09aym_JynMzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9VJ41vPBOwYSVHmBGtjdA4jL2b2mHAUZ09aym_JynMzw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Suzuki Poulose <Suzuki.Poulose@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Kristina Martsenko <Kristina.Martsenko@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <Will.Deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <Mark.Rutland@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Jason Wang <jasowang@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On 10/01/18 11:19, Peter Maydell wrote:
> On 10 January 2018 at 11:06, Michael S. Tsirkin <mst@redhat.com> wrote:
>> For virtio-mmio? I don't seem to see that code in
>> hw/virtio/virtio-mmio.c
>> For example I still see handling for VIRTIO_MMIO_QUEUE_PFN
>> there, and no handling for VIRTIO_MMIO_QUEUE_DESC_LOW
>> and such.
> 
> Are there uses that make it worthwhile to get virtio-1
> support added to virtio-mmio, rather than just getting
> people to move over to virtio-pci instead ?

virtio-iommu uses virtio-mmio transport. It makes little sense to have an
IOMMU presented as a PCI endpoint.

Thanks,
Jean
