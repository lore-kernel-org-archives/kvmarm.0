From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 5/8] Makefile: add explicit mkdir for
 .o targets
Date: Fri, 7 Apr 2017 16:42:34 +0200
Message-ID: <20170407144234.kmq2ofvh5e6vyssq@kamzik.brq.redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-6-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 045B240BE3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 10:40:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GNabDrTdbyd0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 10:40:23 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06A6D40B5B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 10:40:22 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170406190727.5624-6-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 08:07:24PM +0100, Alex Benn=E9e wrote:
> This is fairly direct way of ensuring the target build directories are
> created before we build a binary blob. mkdir -p fails gracefully if
> the directory is already there.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> =

> diff --git a/Makefile b/Makefile
> index 781186e..56598df 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -79,8 +79,13 @@ $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIB=
FDT_OBJS))
>  	$(AR) rcs $@ $^
>  =

>  %.o: %.S
> +	mkdir -p $(dir $@)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>  =

> +%.o: %.c
> +	mkdir -p $(dir $@)
> +	$(CC) $(CFLAGS) -c -o $@ $<

This rule will override any arch makefile %.o rule.  I don't think we want
to do that.  And I guess that means we should move the '%.o: %.S' rule up
above the include $(TEST_DIR)/Makefile so we don't override those either.

> +
>  -include */.*.d */*/.*.d
>  =

>  all: $(shell git -C $(SRCDIR) rev-parse --verify --short=3D8 HEAD >build=
-head 2>/dev/null)
> -- =

> 2.11.0
>

I'd prefer we just have a couple places where we do mkdir:  one in the
common Makefile for common dirs (BUILD_DIRS) and one in the arch makefile
for arch dirs (ARCH_BUILD_DIRS).

The example linked below looks like something we might be able to apply.

https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html#=
Prerequisite-Types

Thanks,
drew
