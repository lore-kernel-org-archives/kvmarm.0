From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v7 10/17] KVM: arm64: introduce new KVM ITS device
Date: Mon, 4 Jul 2016 15:32:37 +0100
Message-ID: <CAFEAcA96DGzW=bShwz188O0BaDy34ccEG3921AxQCf3aAFgurg@mail.gmail.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-11-andre.przywara@arm.com> <2525bd7b-5df1-54bc-1999-25c8c7fe88a3@redhat.com>
 <173c3704-180e-0385-623c-5dbcced2d762@arm.com> <da2ac9c4-e29b-e74f-a11e-b2736526bf8f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <da2ac9c4-e29b-e74f-a11e-b2736526bf8f@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 July 2016 at 15:27, Auger Eric <eric.auger@redhat.com> wrote:
> Andre,
>
> On 04/07/2016 16:05, Andre Przywara wrote:
>> Hi,
>>
>> On 04/07/16 10:00, Auger Eric wrote:
>>> From a QEMU integration point of view this means the init sequence used
>>> for KVM GIC interrupt controllers cannot be reused for ITS and more
>>> importantly this is not straightforward to have the proper sequence
>>> ordering (hence the previously reported case).
>>
>> I am confused, can you please elaborate what the problem is?
>> Or alternatively sketch what you ideally would the ITS init sequence to
>> look like? I am totally open to any changes, just need to know what
>> you/QEMU needs.
>
> in QEMU the address setting is done on a so-called qemu
> "machine_init_done_notifier", ie. a callback that is registered at ITS
> device init, to be called once the virt machine code has executed. This
> callback calls  kvm_device_ioctl(kd->dev_fd, KVM_SET_DEVICE_ATTR, attr);
>
> In case the userspace needs to explicitly "init" the ITS (actually ~
> map_resources) this must happen after the KVM_SET_DEVICE_ATTR. So you
> also must register a callback in the same way. However there is a
> framework existing to register kvm device addresses but this does not
> exist to set other attributes than device addresses.
>
> This is feasible I think but this does not fit qemu nicely. So can't the
> map_resources happen implicitly on the first VCPU run?

I'm not clear what you think the problem here for QEMU is.
We definitely want the API for the kernel to be:
 create device
 set attributes
 explicitly complete init of the device
 [attribute setting after this is illegal]
 run CPUs

so I'm not sure why QEMU would care if the kernel does things at
"final init" rather than "run CPUs".

This is how the GICv3 init works and how the ITS should work too;
we don't want to extend the GICv2 mistake of "no explicit complete
init" to anything else, because then you end up with ad-hoc
"do this when we first run the vCPU; oh, but also do it if
userspace tries to write a register content; and also if...".

thanks
-- PMM
