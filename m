From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 06/11]
 arm/Makefile.common: force -fno-pic
Date: Mon, 28 Nov 2016 10:33:04 +0100
Message-ID: <20161128093304.74rfi7dk5qhuvo4g@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-7-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-7-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, mttcg@greensocs.com, peter.maydell@linaro.org, claudio.fontana@huawei.com, nikunj@linux.vnet.ibm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, a.rigo@virtualopensystems.com, qemu-devel@nongnu.org, cota@braap.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net, fred.konrad@greensocs.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:28PM +0000, Alex Bennée wrote:
> As distro compilers move towards defaults for build hardening for things
> like ASLR we need to force -fno-pic. Failure to do can lead to weird
> relocation problems when we build our "lat" binaries.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arm/Makefile.common | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 52f7440..cca0d9c 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -21,6 +21,7 @@ phys_base = $(LOADADDR)
>  
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
> +CFLAGS += -fno-pic
>  CFLAGS += -Wextra
>  CFLAGS += -O2
>  CFLAGS += -I lib -I lib/libfdt
> -- 
> 2.10.1
> 
>

Applied to arm/next

https://github.com/rhdrjones/kvm-unit-tests/commits/arm/next

Thanks,
drew
