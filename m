From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4/4] pre_init: add ARM implementations
Date: Thu, 3 Mar 2016 21:08:18 +0000
Message-ID: <20160303210818.GC650@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
 <1456327988-31568-5-git-send-email-andre.przywara@arm.com>
 <20160302030009.GB7637@arm.com>
 <56D7797A.5040008@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D7797A.5040008@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 02, 2016 at 11:38:34PM +0000, Andr=E9 Przywara wrote:
> On 02/03/16 03:00, Will Deacon wrote:
> > On Wed, Feb 24, 2016 at 03:33:08PM +0000, Andre Przywara wrote:
> >> The pre_init stub consists of two syscalls mouting the host's FS
> >> via 9pfs and then calling the actual init binary, which can now
> >> use normal dynamic linking.
> >> Based on the x86 code provide an ARM and ARM64 implementation of
> >> that. Beside removing the need for static linkage it reduces the
> >> size of the kvmtool binary by quite a lot (numbers for aarch64):
> >>
> >> -rwxr-xr-x 1 root root     9952 Nov 16 14:37 guest/init
> >> -rwxr-xr-x 1 root root      512 Nov 16 14:37 guest/pre_init
> >> -rwxr-xr-x 2 root root  1284704 Nov 16 14:37 lkvm
> >> vs. the old version:
> >> -rwxr-xr-x 1 root root   776024 Nov 16 14:38 guest/init
> >> -rwxr-xr-x 2 root root  2050112 Nov 16 14:38 lkvm
> >>
> >> Tested on Midway and Juno.
> >=20
> > Hmm, I'm not super keen on switching behaviour like this on arm, wh=
ere
> > it's not uncommon to build a static lkvm and transfer it to a remot=
e
> > target and expect init to work.
>=20
> So are you concerned about a fully static root file system on the hos=
t,
> which does not provide libc.so and/or ld-linux.so at all? Is that rea=
lly
> a use case? I had the impression that people use a statically linked
> kvmtool to avoid dependencies like to libfdt.so.

Right. There are certainly environments where kvmtool is used that don'=
t
have a dynanmic linker, and I'd really like lkvm-static to work there.

> > Perhaps we could only do this when building a dynamic executable?
>=20
> This is of course an option as well.

I think it's the right thing to do.

Will
