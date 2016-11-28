From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 04/11] libcflat: add PRI(dux)32 format
 types
Date: Mon, 28 Nov 2016 10:18:17 +0100
Message-ID: <20161128091817.wnfjxqjzpidmgkcc@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-5-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-5-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, mttcg@greensocs.com, nikunj@linux.vnet.ibm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, qemu-devel@nongnu.org, cota@braap.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:26PM +0000, Alex Bennée wrote:
> So we can have portable formatting of uint32_t types.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  lib/libcflat.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index bdcc561..6dab5be 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -55,12 +55,17 @@ typedef _Bool		bool;
>  #define true  1
>  
>  #if __SIZEOF_LONG__ == 8
> +#  define __PRI32_PREFIX
>  #  define __PRI64_PREFIX	"l"
>  #  define __PRIPTR_PREFIX	"l"
>  #else
> +#  define __PRI32_PREFIX        "l"

But a 32-bit value is an 'int' and an 'int' shouldn't ever
require an 'l'. Why was this necessary?

>  #  define __PRI64_PREFIX	"ll"
>  #  define __PRIPTR_PREFIX
>  #endif
> +#define PRId32  __PRI32_PREFIX	"d"
> +#define PRIu32  __PRI32_PREFIX	"u"
> +#define PRIx32  __PRI32_PREFIX	"x"
>  #define PRId64  __PRI64_PREFIX	"d"
>  #define PRIu64  __PRI64_PREFIX	"u"
>  #define PRIx64  __PRI64_PREFIX	"x"
> -- 
> 2.10.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
