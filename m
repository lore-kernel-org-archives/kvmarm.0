From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Fri, 15 May 2015 08:12:35 -0700
Message-ID: <20150515151235.GD14144@lvm>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
 <20150506141249.GA6796@cbox>
 <CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
 <20150507112027.GC25885@cbox>
 <CAGE1QJoyaGpuf=6Msa=xpm0pPGRkYWctcXGf=rwnha5o9Gm4bw@mail.gmail.com>
 <CAMJs5B9i9q8gJU93B09-uLMF6w1bTft-40DWPFUP6ky=SketSQ@mail.gmail.com>
 <CAGE1QJoEAg9tAM63MEbpLuqvY_ZwGrHPU1sqo=L_iByKrERUow@mail.gmail.com>
 <554B9A70.6020309@redhat.com>
 <5555DBFD.4080503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5555DBFD.4080503@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Laszlo Ersek <lersek@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?B?Suly6W15IEZhbmd16GRl?= <j.fanguede@virtualopensystems.com>, list@lists.cs.columbia.edu, Overall <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, open@lists.cs.columbia.edu, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 15, 2015 at 01:43:57PM +0200, Laszlo Ersek wrote:
> On 05/07/15 19:01, Paolo Bonzini wrote:
> >=20
> >=20
> > On 07/05/2015 18:56, J=E9r=E9my Fangu=E8de wrote:
> >> USB devices fail with a timeout error, as if the communication bet=
ween
> >> the kernel and the devices fail at a certain point:
> >> usb 1-1: device not accepting address 5, error -110
> >> usb usb1-port1: unable to enumerate USB device
>=20
> This is consistent with what I saw in my earlier testing.
>=20
> >> e1000 fails when the userspace tries to use it, with these type of
> >> kernel messages:
> >> e1000 0000:00:02.0 eth0: Detected Tx Unit Hang
> >>   Tx Queue             <0>
> >>   TDH                  <d>
> >>   TDT                  <d>
> >>   next_to_use          <d>
> >>   next_to_clean        <9>
> >> buffer_info[next_to_clean]
> >>   time_stamp           <ffff9311>
> >>   next_to_watch        <a>
> >>   jiffies              <ffff956a>
> >>   next_to_watch.status <0>
> >=20
> > Can you find out what memory attributes the guest is using for the
> > memory---and if it's uncached, why?
>=20
> For USB, see "drivers/usb/core/hcd-pci.c", function usb_hcd_pci_probe=
():
> it uses ioremap_nocache().
>=20
> On the "why", that ioremap_nocache() call can be tracked to
>=20
> http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?=
id=3Da914dd8b
>=20
> (Feb 2002), which predates the kernel's move to git. I guess
> ioremap_nocache() is used simply because USB host controllers are
> supposed to programmed like that.
>=20
> And, from "arch/arm64/include/asm/io.h":
>=20
> #define ioremap_nocache(addr, size)     __ioremap((addr), (size),
> __pgprot(PROT_DEVICE_nGnRE))
>=20
So this just means that these devices should be mapped as device memory
(like the VGA case before) right?  And therefore should work with Drew'=
s
patches (assuming they are actually correct and you add the right QEMU
annotations to set the memory regions and non-cacheable), correct?

Thanks,
-Christoffer
