From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 6/8] Makefiles: handle linking of
 scripts into build-tree
Date: Fri, 7 Apr 2017 15:37:25 +0200
Message-ID: <20170407133725.voe3eykrlqvp7wt3@kamzik.brq.redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-7-alex.bennee@linaro.org>
 <a81e981b-1c6e-c8ac-82a6-ced80c045461@redhat.com>
 <87lgrca4fk.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgrca4fk.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, pbonzini@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 07, 2017 at 11:38:07AM +0100, Alex Bennée wrote:
> 
> Thomas Huth <thuth@redhat.com> writes:
> 
> > On 06.04.2017 21:07, Alex Bennée wrote:
> >> When doing an out-of-src-tree build we still want access to the
> >> various bits of common script machinery to run. This is handled by the
> >> scripts-common list which sub-builds can add explicit extra stuff to.
> >>
> >> The final rule is conditional so we don't attempt to link files when
> >> we are doing an in-src-tree build.
> >>
> >> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >> ---
> >>  Makefile            | 13 +++++++++++++
> >>  x86/Makefile.common |  4 ++++
> >>  2 files changed, 17 insertions(+)
> >>
> >> diff --git a/Makefile b/Makefile
> >> index 56598df..c9fea88 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -31,6 +31,10 @@ cflatobjs := \
> >>  	lib/report.o \
> >>  	lib/stack.o
> >>
> >> +# These are scripts we want linked from the source tree
> >> +scripts-common := run_tests.sh \
> >> +	scripts
> >> +
> >>  # libfdt paths
> >>  LIBFDT_objdir = $(SRCDIR)/lib/libfdt
> >>  LIBFDT_srcdir = $(SRCDIR)/lib/libfdt
> >> @@ -86,8 +90,17 @@ $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
> >>  	mkdir -p $(dir $@)
> >>  	$(CC) $(CFLAGS) -c -o $@ $<
> >>
> >> +$(scripts-common): $(SRCDIR)/$@
> >> +	ln -sf $<$@ $@
> >
> > The prerequisite does not seem to work correctly here. I can see that
> > the symlinks are regenerated each time I run make. Even worse, during
> > the second run, there is a
> >
> > ln -sf /home/thuth/devel/kvm-unit-tests/scripts scripts
> >
> > which generates a symlink in the source directory, since the "scripts"
> > symlink already exists!
> >
> > I think you can not use automatic variables like $@ in the prerequisite
> > list, can you?
> >
> > Maybe it would be better to create these symlinks in the configure
> > script already?
> 
> Hmm maybe. The trouble is catching them all. That's why I wanted to have
> something like scripts-common that sub Makefiles could add to.
> 
> We could certainly make the rule a bit more robust against re-linking
> though.

I think I'd prefer configure doing this linking. I don't think we'll
ever have more than

 ln -sf "$srcdir/$testdir/run" $testdir/
 ln -sf "$srcdir/$testdir/unittests.cfg" $testdir/
 ln -sf "$srcdir/run_tests.sh"
 ln -sf "$srcdir/scripts"

(And now I see what we want an absolute path for $srcdir.)

Thanks,
drew
