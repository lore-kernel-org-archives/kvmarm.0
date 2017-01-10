From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v7 04/11] libcflat: add PRI(dux)32 format types
Date: Tue, 10 Jan 2017 15:23:05 +0000
Message-ID: <87r34b2b3a.fsf@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org> <20161124161033.11456-5-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20161124161033.11456-5-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: qemu-devel@nongnu.org, mttcg@listserver.greensocs.com, fred.konrad@greensocs.com, a.rigo@virtualopensystems.com, cota@braap.org, bobby.prani@gmail.com, nikunj@linux.vnet.ibm.com, mark.burton@greensocs.com, pbonzini@redhat.com, jan.kiszka@siemens.com, serge.fdrv@gmail.com, rth@twiddle.net, peter.maydell@linaro.org, claudio.fontana@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu


Alex Bennée <alex.bennee@linaro.org> writes:

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

OK this is bogus, but the failure is because of where we get uint32_t
from (hint using arm32 compiler on a arm64 system) so I got:

  lib/pci.c:71:9: error: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'uint32_t {aka long unsigned int}' [-Werro\
r=format=]

Which makes me think we should be more careful about including system
headers in kvm-unit-tests (done in 75e777a0).

--
Alex Bennée
