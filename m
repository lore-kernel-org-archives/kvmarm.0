From: =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>
Subject: Re: ARM: PCI devices emulation broken with KVM due to
	cache issue
Date: Fri, 17 Apr 2015 15:48:35 +0200
Message-ID: <CAGE1QJo-waQgNyy4XG6Ecqeg3yXH_o4EFuqX+mzj0_66X-ghXQ@mail.gmail.com>
References: <CAGE1QJoXVDP_O0W9dRCsN+FBW3BEYn5gqiCvGh07CfadNp2kHw@mail.gmail.com>
	<552FDD13.4090006@redhat.com> <20150417092910.GI6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20150417092910.GI6186@cbox>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 17, 2015 at 11:29 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Thu, Apr 16, 2015 at 06:02:27PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 16/04/2015 17:54, J=C3=A9r=C3=A9my Fangu=C4=8Dde wrote:
>> > The guest kernel driver of the lsi device fails to enable it correctly
>> > with a cache error:
>> > [...]
>> > sym53c8xx 0000:00:01.0: enabling device (0100 -> 0103)
>> > sym0: <895a> rev 0x0 at pci 0000:00:01.0 irq 54
>> > sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
>> > CACHE TEST FAILED: chip wrote 2, host read 1.
>> > sym0: CACHE INCORRECTLY CONFIGURED.
>> > sym0: giving up ...
>> > [...]
>>
>> Note that this is just a failure in the driver self-test.  It has
>> nothing to do with the processor cache (though there are other problems
>> with PCI and the processor cache in KVM mode).
>>
>> Do not use this QEMU device.  The emulation is incomplete and it's slow.
>>  Use virtio-scsi or megasas instead.  Still, I'm not sure that would
>> work with KVM; as far as I know, most work on the ARM PCI host bridge
>> was done using UEFI firmware.
>>
> I've been running a number of tests lately using virtio-net-pci and
> virtio-blk-pci on XGene at it works like a charm.

It should be noted that all these devices work fine on x86 with KVM
enabled.

Of course, not all PCI devices are affected, e.g. virtio-* devices
work fine for me also. However, should this failure be considered
normal with KVM on ARM, while it works on x86?

For instance, let's take the use case where there is no virtio
alternative: USB devices (passthrough or emulated) attached to a PCI
USB controller, how is this supposed to work with KVM on ARM?
The only way to make usb-ehci working that I am aware, is
with this cache hack.
