From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Thu, 7 May 2015 13:20:27 +0200
Message-ID: <20150507112027.GC25885@cbox>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
 <20150506141249.GA6796@cbox>
 <CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: =?iso-8859-1?B?Suly6W15IEZhbmd16GRl?= <j.fanguede@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, "open list:Overall" <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 07, 2015 at 12:50:50PM +0200, J=E9r=E9my Fangu=E8de wrote:
> On Wed, May 6, 2015 at 4:12 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > Hi J=E9r=E9my,
> >
> > On Tue, May 05, 2015 at 11:13:11AM +0200, J=E9r=E9my Fangu=E8de wro=
te:
> >> To maintain cache coherency on ARM, we may need a mechanism to flu=
sh
> >> the data cache.
> >
> > In addition to generally just making this functionality available (=
see
> > below), do you have an actual use case in mind for this?  To solve =
the
> > VGA issue, for example, we already have a patch series from Drew tr=
ying
> > to address this.  Does that not work for you?
> >
> > There was a long discussion about this here:
> > https://lists.cs.columbia.edu/pipermail/kvmarm/2015-February/013593=
=2Ehtml
> >
> > Drew then created a patch set, here:
> > https://lists.nongnu.org/archive/html/qemu-devel/2015-03/msg01254.h=
tml
> >
> > and replied to himself, here:
> > https://www.marc.info/?l=3Dandroid-virt&m=3D142670523929132&w=3D3
> >
> > Which basically says that he doesn't like having to do flushes all =
over
> > QEMU (IIUC), so he sent this version instead:
> > https://lists.cs.columbia.edu/pipermail/kvmarm/2015-March/014027.ht=
ml
> >
> > Which he now said he'd respin.
>=20
> In fact, I used this ioctl in pairs with this QEMU patch series:
> https://lists.nongnu.org/archive/html/qemu-devel/2015-05/msg00407.htm=
l
> My current work doesn't do anything about vga ram, so vga issue
> probably still persists, but it solves others issues with some
> emulated devices (mainly PCI) which were failing before and now work
> fine with this patch.

Why does Drew's approach not work and your approach works here?  What i=
s
the case that we haven't though about yet?

-Christoffer
