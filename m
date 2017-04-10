From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 08/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Mon, 10 Apr 2017 16:07:03 +0100
Message-ID: <CAFEAcA-dG-UuODon2c877m8oPdjSFfb9ZwHxUqDwSSiSXFMS8A@mail.gmail.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
 <864lxzch9o.fsf@arm.com>
 <5f1423fd-8f73-364a-9cf7-b4310957e2fd@redhat.com>
 <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D239840C2E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 11:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GsNHoIVuTjAw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Apr 2017 11:05:02 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C678A40C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 11:05:02 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id c55so77431908wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 08:07:25 -0700 (PDT)
In-Reply-To: <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10 April 2017 at 15:57, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 10/04/17 15:32, Auger Eric wrote:
>> Well this is partly documented in
>> Documentation/virtual/kvm/devices/arm-vgic-its.txt. No plan to
>> deprecate. migration from KVM supporting v1 to KVM supporting V2 would
>> be possible but not the contrary.
>>
>> Does it make sense?
>
> Sort of. Say you have three systems: A and C, which only supports v1; B,
> which supports v1 and v2. Let's say you migrate from A to B, and from B
> to C. Is B mandated to be able to export the tables as v1 and v2? Or can
> it restrict what it can export?

Generally for QEMU we only require forwards-compatibility (so
in this case old-kernel to new-kernel has to work but new-kernel
to old-kernel need not). Export-as-old-format if the in-kernel
data can be represented in the old format would be a nice to have
property only (and depending what the unanticipated future need
is, might not be possible at all).

The idea here is not that we expect to need this, but to give
ourselves an escape hatch for future use if we do find we need
to add something which won't fit in the currently defined format.

thanks
-- PMM
