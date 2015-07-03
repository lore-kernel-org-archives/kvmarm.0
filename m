From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 05/10] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for
 edge IRQs
Date: Fri, 3 Jul 2015 10:57:59 +0100
Message-ID: <CAFEAcA_TrNQvR-fooGXSg=04CNAULEpNr54iwXjqA=qvqYuLZw@mail.gmail.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-6-git-send-email-marc.zyngier@arm.com>
 <20150630201933.GA11332@cbox>
 <5593B040.6050208@arm.com> <20150701115820.GC17890@cbox>
 <55942F00.6000306@arm.com>
 <20150702162359.GJ11332@cbox> <55965AFF.30509@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8EB9578EE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 05:47:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P+2foVYYLVnQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 05:46:59 -0400 (EDT)
Received: from mail-vn0-f49.google.com (mail-vn0-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7016578EB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 05:46:59 -0400 (EDT)
Received: by vnbg190 with SMTP id g190so14769545vnb.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 02:58:18 -0700 (PDT)
In-Reply-To: <55965AFF.30509@arm.com>
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
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Andre Przywara <Andre.Przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 3 July 2015 at 10:50, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 02/07/15 17:23, Christoffer Dall wrote:
>> If we had a different *shared* device than the timer which is
>> edge-triggered, don't we then also need to capture the physical
>> distributor's pending state along with the state of the device unless we
>> assume that upon restoring the state for the device count on the device
>> to have another rising/falling edge to trigger the interrupt again? (I
>> assume the line would always go high for a level-triggered interrupt in
>> this case).
>
> I'd definitely assume that restoring the state of the device would make
> it generate an interrupt. This has to be a property of the device,
> otherwise it is not really shareable between vcpus.

FWIW, QEMU's modelling approach to this is to say that devices
do *not* generate interrupts on restore. If the device had
previously generated an interrupt then this should be captured
by the state of the interrupt controller (or whatever else
it is connected to) and dealt with when the GIC state is restored.

If you say that restoring the device state is supposed to
generate an interrupt, you introduce an ordering requirement
that the state of the interrupt controller is restored
first and the device second (otherwise the incoming GIC
state will overwrite the interrupt that the device just
generated), which isn't ideal (especially since QEMU
makes no guarantees about restore order between devices).

thanks
-- PMM
