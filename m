From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Wed, 10 Jan 2018 11:19:34 +0000
Message-ID: <CAFEAcA9VJ41vPBOwYSVHmBGtjdA4jL2b2mHAUZ09aym_JynMzw@mail.gmail.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-2-suzuki.poulose@arm.com>
 <20180110012429-mutt-send-email-mst@kernel.org>
 <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
 <20180110130230-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5912549DAC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 06:15:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A1kkCBVS8jV8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jan 2018 06:15:10 -0500 (EST)
Received: from mail-oi0-f52.google.com (mail-oi0-f52.google.com
 [209.85.218.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 968ED49D40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 06:15:10 -0500 (EST)
Received: by mail-oi0-f52.google.com with SMTP id 184so12592837oii.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 03:19:55 -0800 (PST)
In-Reply-To: <20180110130230-mutt-send-email-mst@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Jason Wang <jasowang@redhat.com>, Will Deacon <will.deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kristina.martsenko@arm.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10 January 2018 at 11:06, Michael S. Tsirkin <mst@redhat.com> wrote:
> For virtio-mmio? I don't seem to see that code in
> hw/virtio/virtio-mmio.c
> For example I still see handling for VIRTIO_MMIO_QUEUE_PFN
> there, and no handling for VIRTIO_MMIO_QUEUE_DESC_LOW
> and such.

Are there uses that make it worthwhile to get virtio-1
support added to virtio-mmio, rather than just getting
people to move over to virtio-pci instead ?

thanks
-- PMM
