From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v5 08/11] libcflat: add IS_ALIGNED() macro, and page sizes
Date: Fri, 11 Nov 2016 15:02:42 +0000
Message-ID: <87shqy6ovh.fsf@linaro.org>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com> <1478798481-25030-9-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1478798481-25030-9-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org, Peter Xu <peterx@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> From: Peter Xu <peterx@redhat.com>
>
> These macros will be useful to do page alignment checks.
>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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

We don't seem to use IS_ALIGNED, or in fact anything apart from SZ_64K
(which is multiplied by 2 anyway) so I'm not sure if this patch is worth
it for this series.

Stylistically I thought (1 << foo) was preferred for setting of
individual bits? Otherwise I'd be tempted to line the values up with
zero padding to make it easier to read the bit position.

>
>  typedef uint8_t		u8;
>  typedef int8_t		s8;


--
Alex Bennée
