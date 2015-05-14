From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 13:38:11 +0100
Message-ID: <CAFEAcA_OXHH2NmU6c=KB+DgRQS=+YYX4es+otjE_k0qzn+6+0Q@mail.gmail.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
 <20150514112910.GR32765@cbox> <55548777.9000702@redhat.com>
 <20150514113634.GS32765@cbox> <5554893E.4030105@redhat.com>
 <20150514120039.GU32765@cbox> <55549051.1090007@redhat.com>
 <20150514122413.GV32765@cbox> <55549501.2010000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 230E3514C4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:29:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KnbDdzdBDWHC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 08:29:24 -0400 (EDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
 [209.85.223.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CECC514BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:29:23 -0400 (EDT)
Received: by iebpz10 with SMTP id pz10so59079830ieb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 05:38:32 -0700 (PDT)
In-Reply-To: <55549501.2010000@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "Michael S. Tsirkin" <mst@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 14 May 2015 at 13:28, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Well, PCI BARs are generally MMIO resources, and hence should not be cached.
>
> As an optimization, OS drivers can mark them as cacheable or
> write-combining or something like that, but in general it's a safe
> default to leave them uncached---one would think.

Isn't this handled by the OS mapping them in the 'prefetchable'
MMIO window rather than the 'non-prefetchable' one? (QEMU's
generic-PCIe device doesn't yet support the prefetchable window.)

-- PMM
