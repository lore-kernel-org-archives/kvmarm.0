From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v3 5/6] Initialize the mapping of KASan shadow memory
Date: Mon, 2 Apr 2018 14:20:15 -0400 (EDT)
Message-ID: <nycvar.YSQ.7.76.1804021418220.28462@knanqh.ubzr>
References: <20180402120440.31900-1-liuwenliang@huawei.com> <20180402120440.31900-6-liuwenliang@huawei.com> <nycvar.YSQ.7.76.1804021402521.28462@knanqh.ubzr> <20180402181536.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180402181536.GJ16141@n2100.armlinux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Abbott Liu <liuwenliang@huawei.com>, kstewart@linuxfoundation.org, tixy@linaro.org, grygorii.strashko@linaro.org, julien.thierry@arm.com, Catalin Marinas <catalin.marinas@arm.com>, linux@rasmusvillemoes.dk, dhowells@redhat.com, linux-mm@kvack.org, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu, f.fainelli@gmail.com, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kasan-dev@googlegroups.com, geert@linux-m68k.org, linux-arm-kernel@lists.infradead.org, zhichao.huang@linaro.org, aryabinin@virtuozzo.com, labbott@redhat.com, vladimir.murzin@arm.com, keescook@chromium.org, Arnd Bergmann <arnd@arndb.de>, marc.zyngier@arm.com, philip@cog.systems, jinb.park7@gmail.com, opendmb@gmail.com, tglx@linutronix.de, dvyukov@google.com, ard.biesheuvel@linaro.org, gregkh@linuxfoundatio
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2 Apr 2018, Russell King - ARM Linux wrote:

> On Mon, Apr 02, 2018 at 02:08:13PM -0400, Nicolas Pitre wrote:
> > On Mon, 2 Apr 2018, Abbott Liu wrote:
> > 
> > > index c79b829..20161e2 100644
> > > --- a/arch/arm/kernel/head-common.S
> > > +++ b/arch/arm/kernel/head-common.S
> > > @@ -115,6 +115,9 @@ __mmap_switched:
> > >  	str	r8, [r2]			@ Save atags pointer
> > >  	cmp	r3, #0
> > >  	strne	r10, [r3]			@ Save control register values
> > > +#ifdef CONFIG_KASAN
> > > +	bl	kasan_early_init
> > > +#endif
> > >  	mov	lr, #0
> > >  	b	start_kernel
> > >  ENDPROC(__mmap_switched)
> > 
> > Would be better if lr was cleared before calling kasan_early_init.
> 
> No.  The code is correct - please remember that "bl" writes to LR.

You're right of course.

/me giving up on patch review and going back to bed


Nicolas
