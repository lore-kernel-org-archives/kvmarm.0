From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Wed, 10 Jan 2018 13:30:52 +0200
Message-ID: <20180110132930-mutt-send-email-mst@kernel.org>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-2-suzuki.poulose@arm.com>
 <20180110012429-mutt-send-email-mst@kernel.org>
 <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
 <20180110130230-mutt-send-email-mst@kernel.org>
 <CAFEAcA9VJ41vPBOwYSVHmBGtjdA4jL2b2mHAUZ09aym_JynMzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA9VJ41vPBOwYSVHmBGtjdA4jL2b2mHAUZ09aym_JynMzw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kristina.martsenko@arm.com, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Jason Wang <jasowang@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 10, 2018 at 11:19:34AM +0000, Peter Maydell wrote:
> On 10 January 2018 at 11:06, Michael S. Tsirkin <mst@redhat.com> wrote:
> > For virtio-mmio? I don't seem to see that code in
> > hw/virtio/virtio-mmio.c
> > For example I still see handling for VIRTIO_MMIO_QUEUE_PFN
> > there, and no handling for VIRTIO_MMIO_QUEUE_DESC_LOW
> > and such.
> 
> Are there uses that make it worthwhile to get virtio-1
> support added to virtio-mmio, rather than just getting
> people to move over to virtio-pci instead ?
> 
> thanks
> -- PMM

I keep getting these patches (like the one that started this thread) so
I think yes. If nothing else the guest support will bit-rot without
an open-source implementation.

-- 
MST
