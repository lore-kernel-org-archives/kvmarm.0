From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v7 10/17] KVM: arm64: introduce new KVM ITS device
Date: Tue, 5 Jul 2016 10:55:56 +0100
Message-ID: <CAFEAcA8LQPLBtB_H9oN8S8K5ZFZXt3s4trSwowgr-FD9U6DYKQ@mail.gmail.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-11-andre.przywara@arm.com> <2525bd7b-5df1-54bc-1999-25c8c7fe88a3@redhat.com>
 <173c3704-180e-0385-623c-5dbcced2d762@arm.com> <da2ac9c4-e29b-e74f-a11e-b2736526bf8f@redhat.com>
 <CAFEAcA96DGzW=bShwz188O0BaDy34ccEG3921AxQCf3aAFgurg@mail.gmail.com>
 <2b712bbe-1534-0206-34e7-8df433ace7c2@redhat.com> <fc201178-cfa4-221d-b36e-f5d959f89f74@arm.com>
 <081321b4-5bf2-29f7-018e-6d50ee74b95c@redhat.com> <95a09591-8915-9ebf-1edd-675e83a1a09b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <95a09591-8915-9ebf-1edd-675e83a1a09b@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 5 July 2016 at 09:59, Andre Przywara <andre.przywara@arm.com> wrote:
> Ah, OK, so you _do_ the address setup _after_ the INIT.
> My understanding of the KVM API was that this isn't allowed, as with the
> INIT _everything_ should have been setup. kvmtool works this way.
>
> So we obviously can't change this for GICv3, but I wonder if we should
> make this explicit with the ITS:
> 1) Create the device
> 2) setup _all_ parameters (address, number of ...)
> 3) call INIT, any setup calls from here on are denied
>
> That sounds like the proper setup sequence to me.

So we shouldn't necessarily let QEMU drive the kernel API
design here, but:

(1) consistency with GICv2-with-explicit-init and GICv3
seems worth preserving
(2) there is a coherent model here which maps onto QEMU's
device model:

 (i) create device
 (ii) configure device
 (iii) explicitly finish init of device (in QEMU's
   object model this is called "realize")
 (iv) wire completed device into the system, by
   plugging in its IRQs, mapping its memory regions
   into the address space, etc
 (v) at this point it is ok to either read/write registers
   or to start vcpus

Which I think is why "set register base addresses"
looks like an odd-one-out from the kernel's point of view.

So I think for the ITS we should continue to do the same
thing we do for GICv2 and v3 (but not the GICv2
"explicit completion of init is optional" part).

I'd forgotten exactly how this worked; sorry for any
confusion in my earlier email.

thanks
-- PMM
