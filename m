From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Thu, 7 May 2015 17:34:53 +0200
Message-ID: <CAMJs5B9i9q8gJU93B09-uLMF6w1bTft-40DWPFUP6ky=SketSQ@mail.gmail.com>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
	<20150506141249.GA6796@cbox>
	<CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
	<20150507112027.GC25885@cbox>
	<CAGE1QJoyaGpuf=6Msa=xpm0pPGRkYWctcXGf=rwnha5o9Gm4bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAGE1QJoyaGpuf=6Msa=xpm0pPGRkYWctcXGf=rwnha5o9Gm4bw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "open list:Overall" <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 7, 2015 at 4:50 PM, J=C3=A9r=C3=A9my Fangu=C3=A8de
<j.fanguede@virtualopensystems.com> wrote:
> On Thu, May 7, 2015 at 1:20 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
>> On Thu, May 07, 2015 at 12:50:50PM +0200, J=C3=A9r=C3=A9my Fangu=C3=A8=
de wrote:
>>> On Wed, May 6, 2015 at 4:12 PM, Christoffer Dall
>>> <christoffer.dall@linaro.org> wrote:
>>> > Hi J=C3=A9r=C3=A9my,
>>> >
>>> > On Tue, May 05, 2015 at 11:13:11AM +0200, J=C3=A9r=C3=A9my Fangu=C3=
=A8de wrote:
>>> >> To maintain cache coherency on ARM, we may need a mechanism to f=
lush
>>> >> the data cache.
>>> >
>>> > In addition to generally just making this functionality available=
 (see
>>> > below), do you have an actual use case in mind for this?  To solv=
e the
>>> > VGA issue, for example, we already have a patch series from Drew =
trying
>>> > to address this.  Does that not work for you?
>>> >
>>> > There was a long discussion about this here:
>>> > https://lists.cs.columbia.edu/pipermail/kvmarm/2015-February/0135=
93.html
>>> >
>>> > Drew then created a patch set, here:
>>> > https://lists.nongnu.org/archive/html/qemu-devel/2015-03/msg01254=
=2Ehtml
>>> >
>>> > and replied to himself, here:
>>> > https://www.marc.info/?l=3Dandroid-virt&m=3D142670523929132&w=3D3
>>> >
>>> > Which basically says that he doesn't like having to do flushes al=
l over
>>> > QEMU (IIUC), so he sent this version instead:
>>> > https://lists.cs.columbia.edu/pipermail/kvmarm/2015-March/014027.=
html
>>> >
>>> > Which he now said he'd respin.
>>>
>>> In fact, I used this ioctl in pairs with this QEMU patch series:
>>> https://lists.nongnu.org/archive/html/qemu-devel/2015-05/msg00407.h=
tml
>>> My current work doesn't do anything about vga ram, so vga issue
>>> probably still persists, but it solves others issues with some
>>> emulated devices (mainly PCI) which were failing before and now wor=
k
>>> fine with this patch.
>>
>> Why does Drew's approach not work and your approach works here?  Wha=
t is
>> the case that we haven't though about yet?
>
> The first patch from Andrew, (which is for arm64 only) doesn't permit
> me to make some emulated PCI devices working with virt, probably
> because some flushes/cleans are missing.
> As for the second patch, it focuses, for now, only on VGA ram. I
> quickly tried to extend the KVM_MEM_UNCACHED flag to the whole guest
> memory, but then the guest fails to boot; but even if it was working,
> does it make sense to map as uncached all the ram of the guest? Since
> we can not guess which region of the guest memory will be accessed.
>
> Simple PCI devices like e1000 or usb-ehci (with usb-kbd for instance)
> are not usable, with or without these patches, but if I flush a
> precise memory range, on reads and writes performed by emulated
> devices on guest ram, (It's exactly what the QEMU patch series that I
> sent does, with this ioctl), emulated PCI devices are now working.

I understand all this.  What I'd like for us to find out is why we are
having coherency issues.  We knew that for the VGA adapter, the guest
maps the memory as uncached (because that's how the real hardware
works), and QEMU maps the memory as cached (because it's just normal
memory), and unsurprisingly the two views of that memory is not
coherent.

What are the cases you are seeing with e1000 or usb-ehci?

Hint: We can make a lot of things work by just sticking cache flushes
all over, but it's not a good engineering approach.

Thanks,
-Christoffer
