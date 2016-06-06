From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 01/10] lib: xstr: allow multiple args
Date: Mon, 06 Jun 2016 11:49:09 +0100
Message-ID: <87d1nuiod6.fsf@linaro.org>
References: <1465064165-14885-2-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1465064165-14885-2-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/libcflat.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 582e3fc60e287..e5e588c742763 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -27,8 +27,8 @@
>
>  #define __unused __attribute__((__unused__))
>
> -#define xstr(s) xxstr(s)
> -#define xxstr(s) #s
> +#define xstr(s...) xxstr(s)
> +#define xxstr(s...) #s

OK my knowledge of stringinfication is still rusty despite having read
the QEMU softmmu code. However:

                printf("Unknown subtest:" xstr(foo,ba) "\n");

Yields:

                Unknown subtestfoo,ba

Is that what you wanted? Or were you aiming for xstr(foo,ba) =3D> fooba

As an aside I couldn't actually see xstr being called with multiple
arguments in the source tree.

>
>  #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
>  #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)


--
Alex Benn=C3=A9e
