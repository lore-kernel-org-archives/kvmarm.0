From: Thomas Huth <thuth@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 6/8] Makefiles: handle linking of
 scripts into build-tree
Date: Fri, 7 Apr 2017 11:22:56 +0200
Message-ID: <a81e981b-1c6e-c8ac-82a6-ced80c045461@redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-7-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406190727.5624-7-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 06.04.2017 21:07, Alex Bennée wrote:
> When doing an out-of-src-tree build we still want access to the
> various bits of common script machinery to run. This is handled by the
> scripts-common list which sub-builds can add explicit extra stuff to.
> 
> The final rule is conditional so we don't attempt to link files when
> we are doing an in-src-tree build.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  Makefile            | 13 +++++++++++++
>  x86/Makefile.common |  4 ++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 56598df..c9fea88 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -31,6 +31,10 @@ cflatobjs := \
>  	lib/report.o \
>  	lib/stack.o
>  
> +# These are scripts we want linked from the source tree
> +scripts-common := run_tests.sh \
> +	scripts
> +
>  # libfdt paths
>  LIBFDT_objdir = $(SRCDIR)/lib/libfdt
>  LIBFDT_srcdir = $(SRCDIR)/lib/libfdt
> @@ -86,8 +90,17 @@ $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
>  	mkdir -p $(dir $@)
>  	$(CC) $(CFLAGS) -c -o $@ $<
>  
> +$(scripts-common): $(SRCDIR)/$@
> +	ln -sf $<$@ $@

The prerequisite does not seem to work correctly here. I can see that
the symlinks are regenerated each time I run make. Even worse, during
the second run, there is a

ln -sf /home/thuth/devel/kvm-unit-tests/scripts scripts

which generates a symlink in the source directory, since the "scripts"
symlink already exists!

I think you can not use automatic variables like $@ in the prerequisite
list, can you?

Maybe it would be better to create these symlinks in the configure
script already?

>  -include */.*.d */*/.*.d
>  
> +
> +# We only need to link common scripts for out-of-src-tree builds
> +ifneq ($(CURDIR), $(SRCDIR))
> +all: $(scripts-common)
> +endif
> +
>  all: $(shell git -C $(SRCDIR) rev-parse --verify --short=8 HEAD >build-head 2>/dev/null)
>  
>  standalone: all
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index fbab82c..ef6e543 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -54,8 +54,12 @@ tests-common += api/dirty-log
>  tests-common += api/dirty-log-perf
>  endif
>  
> +scripts-common += $(TEST_DIR)/run
> +scripts-common += $(TEST_DIR)/unittests.cfg
> +
>  test_cases: $(tests-common) $(tests)
>  
> +

Cosmetic nit: Superfluous white space change.

>  $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I lib -I lib/x86
>  
>  $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
> 

 Thomas
