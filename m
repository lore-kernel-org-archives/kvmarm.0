From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 6/6] KVM: arm/arm64: vgic: Allow configuration of
 interrupt groups
Date: Mon, 9 Jul 2018 09:52:57 +0100
Message-ID: <CAFEAcA9HxPcZp3_EChj7_9B7M1u40Jp4kzpmZ4c2__ZA1owOiw@mail.gmail.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
 <1530697100-22419-7-git-send-email-christoffer.dall@arm.com>
 <7f875ead-d3cb-1fec-bc84-56e64526e6a7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7C449EA2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 04:40:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5s37ZBqlEdX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jul 2018 04:40:37 -0400 (EDT)
Received: from mail-oi0-f65.google.com (mail-oi0-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3DDE4086E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 04:40:37 -0400 (EDT)
Received: by mail-oi0-f65.google.com with SMTP id b15-v6so34401197oib.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jul 2018 01:53:18 -0700 (PDT)
In-Reply-To: <7f875ead-d3cb-1fec-bc84-56e64526e6a7@arm.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 July 2018 at 09:42, Marc Zyngier <marc.zyngier@arm.com> wrote:
> I don't really get why QEMU doesn't try to restore GICD_IIDR, while it
> is definitely trying to restore RO sysregs (and that's how we detect
> incompatibilities).

Accident of design, mostly. From QEMU's point of view, GICD_IIDR
is part of the GIC device, which we save and restore as a separate
thing from the CPU. The GIC device was written in what for QEMU
is a more 'traditional' style, where QEMU assumes it knows all the
registers that might have state and saves and restores them all
(and doesn't bother to do anything with constant registers).
The CPU sysregs are done in a completely different style[*], where
we let the kernel be the source of truth for what sysregs exist;
as a side effect of that we end up trying to save and restore
constant sysregs, since QEMU doesn't know they're constant.

[*] there's an argument that in retrospect this was a mistake;
still, it is what we have and trying to upend it now would be
a huge pain.

thanks
-- PMM
