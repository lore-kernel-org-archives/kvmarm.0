From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] Makefile: allow overriding CFLAGS on the command line
Date: Wed, 4 Nov 2015 10:49:58 +0000
Message-ID: <20151104104957.GD5405@arm.com>
References: <1446225650-19710-1-git-send-email-andre.przywara@arm.com>
 <1446225650-19710-2-git-send-email-andre.przywara@arm.com>
 <CAAqcGHk=TMzmtAqAvy5q2XEkY0uf=49N-NX11BnSUv6zHfMwCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAqcGHk=TMzmtAqAvy5q2XEkY0uf=49N-NX11BnSUv6zHfMwCw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Riku Voipio <riku.voipio@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 04, 2015 at 12:02:23PM +0200, Riku Voipio wrote:
> On 30 October 2015 at 19:20, Andre Przywara <andre.przywara@arm.com> wrote:
> > When a Makefile variable is set on the make command line, all
> > Makefile-internal assignments to that very variable are _ignored_.
> > Since we add quite some essential values to CFLAGS internally,
> > specifying some CFLAGS on the command line will usually break the
> > build (and not fix any include file problems you hoped to overcome
> > with that).
> > Somewhat against intuition GNU make provides the "override" directive
> > to change this behavior; with that assignments in the Makefile get
> > _appended_ to the value given on the command line. [1]
> >
> > Change any internal assignments to use that directive, so that a user
> > can use:
> > $ make CFLAGS=/path/to/my/include/dir
> > to teach kvmtool about non-standard header file locations (helpful
> > for cross-compilation) or to tweak other compiler options.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >
> > [1] https://www.gnu.org/software/make/manual/html_node/Override-Directive.html
> > ---
> >  Makefile | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index f8f7cc4..77a7c9f 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -15,9 +15,7 @@ include config/utilities.mak
> >  include config/feature-tests.mak
> >
> >  CC     := $(CROSS_COMPILE)gcc
> > -CFLAGS :=
> >  LD     := $(CROSS_COMPILE)ld
> > -LDFLAGS        :=
> 
> This breaks builds of debian packages as dpkg-buildpackage sets LDFLAGS
> to something unsuitable for guest init.

Thanks for the report, Riku. I'll revert this patch while we rethink how
to support user-supplied toolchain flags.

Will
