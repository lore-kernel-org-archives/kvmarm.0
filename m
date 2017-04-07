From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 2/8] Makefile: ensure build-head works
 out-of-src-tree
Date: Fri, 7 Apr 2017 13:44:08 +0200
Message-ID: <20170407114408.j7j5m36doxhny7fy@kamzik.brq.redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170406190727.5624-3-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 08:07:21PM +0100, Alex Bennée wrote:
> Pass -C $(SRCDIR) to the git command that generates the build-head
> stamp.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 16ce297..eba7b28 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -80,7 +80,7 @@ $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
>  
>  -include */.*.d */*/.*.d
>  
> -all: $(shell git rev-parse --verify --short=8 HEAD >build-head 2>/dev/null)
> +all: $(shell git -C $(SRCDIR) rev-parse --verify --short=8 HEAD >build-head 2>/dev/null)
>  
>  standalone: all
>  	@scripts/mkstandalone.sh
> -- 
> 2.11.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com> 
