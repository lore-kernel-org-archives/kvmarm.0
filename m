From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v4 08/11] libcflat: add IS_ALIGNED() macro,
 and page sizes
Date: Wed, 9 Nov 2016 14:59:44 +0000
Message-ID: <fc87f8e4-7746-734d-49e1-a3294c493920@arm.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
 <1478636499-14339-9-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1478636499-14339-9-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: pbonzini@redhat.com, peter.maydell@linaro.org, alex.bennee@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org, Peter Xu <peterx@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/11/16 20:21, Andrew Jones wrote:
> From: Peter Xu <peterx@redhat.com>
> 
> These macros will be useful to do page alignment checks.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> Signed-off-by: Peter Xu <peterx@redhat.com>
> [drew: also added SZ_64K]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/libcflat.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 82005f5d014f..143fc53061fe 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -33,6 +33,12 @@
>  #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
>  #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
>  #define ALIGN(x, a)		__ALIGN((x), (a))
> +#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
> +
> +#define SZ_4K			(0x1000)
> +#define SZ_64K			(0x10000)
> +#define SZ_2M			(0x200000)
> +#define SZ_1G			(0x40000000)
>  
>  typedef uint8_t		u8;
>  typedef int8_t		s8;
> 
