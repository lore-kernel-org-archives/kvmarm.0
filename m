From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Fri, 12 Jan 2018 10:21:48 +0000
Message-ID: <CAFEAcA9KMWkTOd4w-QD8fsFs4UQJaNC4PMwPtHVS54ZLhHT72A@mail.gmail.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-2-suzuki.poulose@arm.com>
 <20180110012429-mutt-send-email-mst@kernel.org>
 <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
 <20180110130230-mutt-send-email-mst@kernel.org>
 <CAFEAcA9VJ41vPBOwYSVHmBGtjdA4jL2b2mHAUZ09aym_JynMzw@mail.gmail.com>
 <2aacb81b-0efb-87b9-f70c-a61e66dd0331@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCDD49DB2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 05:17:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dKDPqGcnN4Fv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 05:17:18 -0500 (EST)
Received: from mail-ot0-f176.google.com (mail-ot0-f176.google.com
 [74.125.82.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B529949D62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 05:17:18 -0500 (EST)
Received: by mail-ot0-f176.google.com with SMTP id s3so4651576otc.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 02:22:09 -0800 (PST)
In-Reply-To: <2aacb81b-0efb-87b9-f70c-a61e66dd0331@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Will Deacon <Will.Deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Kristina Martsenko <Kristina.Martsenko@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10 January 2018 at 11:25, Jean-Philippe Brucker
<jean-philippe.brucker@arm.com> wrote:
> Hi Peter,
>
> On 10/01/18 11:19, Peter Maydell wrote:
>> Are there uses that make it worthwhile to get virtio-1
>> support added to virtio-mmio, rather than just getting
>> people to move over to virtio-pci instead ?
>
> virtio-iommu uses virtio-mmio transport. It makes little sense to have an
> IOMMU presented as a PCI endpoint.

Having an entire transport just for the IOMMU doesn't make
a great deal of sense either though :-) If we didn't already
have virtio-mmio kicking around would we really have designed
it that way?

thanks
-- PMM
