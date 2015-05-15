From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement
	KVM_FLUSH_DCACHE_GPA ioctl
Date: Fri, 15 May 2015 13:43:57 +0200
Message-ID: <5555DBFD.4080503@redhat.com>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
	<20150506141249.GA6796@cbox>
	<CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
	<20150507112027.GC25885@cbox>
	<CAGE1QJoyaGpuf=6Msa=xpm0pPGRkYWctcXGf=rwnha5o9Gm4bw@mail.gmail.com>
	<CAMJs5B9i9q8gJU93B09-uLMF6w1bTft-40DWPFUP6ky=SketSQ@mail.gmail.com>
	<CAGE1QJoEAg9tAM63MEbpLuqvY_ZwGrHPU1sqo=L_iByKrERUow@mail.gmail.com>
	<554B9A70.6020309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <554B9A70.6020309@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGQ=?= =?UTF-8?B?ZQ==?= <j.fanguede@virtualopensystems.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: list@lists.cs.columbia.edu, Overall <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, open@lists.cs.columbia.edu, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/07/15 19:01, Paolo Bonzini wrote:
>=20
>=20
> On 07/05/2015 18:56, J=C3=A9r=C3=A9my Fangu=C3=A8de wrote:
>> USB devices fail with a timeout error, as if the communication between
>> the kernel and the devices fail at a certain point:
>> usb 1-1: device not accepting address 5, error -110
>> usb usb1-port1: unable to enumerate USB device

This is consistent with what I saw in my earlier testing.

>> e1000 fails when the userspace tries to use it, with these type of
>> kernel messages:
>> e1000 0000:00:02.0 eth0: Detected Tx Unit Hang
>>   Tx Queue             <0>
>>   TDH                  <d>
>>   TDT                  <d>
>>   next_to_use          <d>
>>   next_to_clean        <9>
>> buffer_info[next_to_clean]
>>   time_stamp           <ffff9311>
>>   next_to_watch        <a>
>>   jiffies              <ffff956a>
>>   next_to_watch.status <0>
>=20
> Can you find out what memory attributes the guest is using for the
> memory---and if it's uncached, why?

For USB, see "drivers/usb/core/hcd-pci.c", function usb_hcd_pci_probe():
it uses ioremap_nocache().

On the "why", that ioremap_nocache() call can be tracked to

http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?id=3D=
a914dd8b

(Feb 2002), which predates the kernel's move to git. I guess
ioremap_nocache() is used simply because USB host controllers are
supposed to programmed like that.

And, from "arch/arm64/include/asm/io.h":

#define ioremap_nocache(addr, size)     __ioremap((addr), (size),
__pgprot(PROT_DEVICE_nGnRE))

Thanks
Laszlo
