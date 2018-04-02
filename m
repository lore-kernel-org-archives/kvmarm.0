From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v3 5/6] Initialize the mapping of KASan shadow memory
Date: Mon, 2 Apr 2018 14:08:13 -0400 (EDT)
Message-ID: <nycvar.YSQ.7.76.1804021402521.28462@knanqh.ubzr>
References: <20180402120440.31900-1-liuwenliang@huawei.com> <20180402120440.31900-6-liuwenliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180402120440.31900-6-liuwenliang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abbott Liu <liuwenliang@huawei.com>
Cc: aryabinin@virtuozzo.com, dvyukov@google.com, Jonathan Corbet <corbet@lwn.net>, Russell King - ARM Linux <linux@armlinux.org.uk>, christoffer.dall@linaro.org, marc.zyngier@arm.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, f.fainelli@gmail.com, Andrew Morton <akpm@linux-foundation.org>, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, pombredanne@nexb.com, ard.biesheuvel@linaro.org, vladimir.murzin@arm.com, alexander.levin@verizon.com, tglx@linutronix.de, thgarnie@google.com, dhowells@redhat.com, keescook@chromium.org, Arnd Bergmann <arnd@arndb.de>, geert@linux-m68k.org, tixy@linaro.org, julien.thierry@arm.com, mark.rutland@arm.com, james.morse@arm.com, zhichao.huang@linaro.org, jinb.park7@gmail.com, labbott@redhat.com, philip@cog.systems, grygorii.strashko@
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2 Apr 2018, Abbott Liu wrote:

> index c79b829..20161e2 100644
> --- a/arch/arm/kernel/head-common.S
> +++ b/arch/arm/kernel/head-common.S
> @@ -115,6 +115,9 @@ __mmap_switched:
>  	str	r8, [r2]			@ Save atags pointer
>  	cmp	r3, #0
>  	strne	r10, [r3]			@ Save control register values
> +#ifdef CONFIG_KASAN
> +	bl	kasan_early_init
> +#endif
>  	mov	lr, #0
>  	b	start_kernel
>  ENDPROC(__mmap_switched)

Would be better if lr was cleared before calling kasan_early_init.


Nicolas
