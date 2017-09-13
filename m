From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 09/28] arm64/sve: Signal frame and context structure
 definition
Date: Wed, 13 Sep 2017 06:36:18 -0700
Message-ID: <20170913133618.lclorawve7364xxi@localhost>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-10-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504198860-12951-10-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, gdb@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 31, 2017 at 06:00:41PM +0100, Dave P Martin wrote:
> +/*
> + * The SVE architecture leaves space for future expansion of the
> + * vector length beyond its initial architectural limit of 2048 bits
> + * (16 quadwords).
> + */
> +#define SVE_VQ_BYTES		0x10	/* number of bytes per quadword */
> +
> +#define SVE_VQ_MIN		1
> +#define SVE_VQ_MAX		0x200

Just a nitpick (up to you): could you use 16 and 512 here instead of
hex? I usually associate hex numbers with some bit fields.

-- 
Catalin
