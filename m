From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 08/13] arm64: Add vmap_stack header file
Date: Fri, 13 Oct 2017 16:42:26 +0100
Message-ID: <20171013154226.xswo4y2viht22wvk@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-9-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170922182614.27885-9-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 22, 2017 at 07:26:09PM +0100, James Morse wrote:
> diff --git a/arch/arm64/include/asm/vmap_stack.h b/arch/arm64/include/asm/vmap_stack.h
> new file mode 100644
> index 000000000000..f41d043cac31
> --- /dev/null
> +++ b/arch/arm64/include/asm/vmap_stack.h
> @@ -0,0 +1,41 @@
> +/*
> + * Copyright (C) 2017 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_VMAP_STACK_H
> +#define __ASM_VMAP_STACK_H
> +
> +#include <linux/vmalloc.h>
> +#include <asm/memory.h>
> +#include <asm/pgtable.h>
> +#include <asm/thread_info.h>
> +
> +#ifdef CONFIG_VMAP_STACK
> +/*
> + * To ensure that VMAP'd stack overflow detection works correctly, all VMAP'd
> + * stacks need to have the same alignment.
> + */
> +static inline unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node)
> +{
> +	return __vmalloc_node_range(stack_size, THREAD_ALIGN,
> +				    VMALLOC_START, VMALLOC_END,
> +				    THREADINFO_GFP, PAGE_KERNEL, 0, node,
> +				    __builtin_return_address(0));
> +}
> +
> +#else
> +unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node); // link error

Do you actually need this here? The calling site (at least in this
patch), is surrounded by CONFIG_VMAP_STACK. Removing the dummy
declaration should be fine (I haven't read the rest of the patches yet,
maybe it's needed later; would a BUILD_BUG do?).

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
