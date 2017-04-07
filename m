From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 3/8] Makefile: set VPATH based on
 SRCDIR
Date: Fri, 7 Apr 2017 13:56:38 +0200
Message-ID: <20170407115638.yh4yri35jvxpsljz@kamzik.brq.redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-4-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170406190727.5624-4-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 08:07:22PM +0100, Alex Bennée wrote:
> Setting the VPATH prompts make to search VPATH for source files. There
> are still some fix-ups needed for linking and including other Makefile
> fragments for each architecture.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index eba7b28..80bc57e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -7,6 +7,9 @@ endif
>  
>  include config.mak
>  
> +# Set search path for all sources
> +VPATH=$(SRCDIR)

nit: prefer spaces around the =

> +
>  libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
>  ARCH_LIBDIRS := $(call libdirs-get,$(ARCH)) $(call libdirs-get,$(TEST_DIR))
>  
> -- 
> 2.11.0
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>
