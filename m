From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 09/28] arm64/sve: Signal frame and context structure
 definition
Date: Wed, 13 Sep 2017 22:33:08 +0100
Message-ID: <20170913213307.GF23415@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-10-git-send-email-Dave.Martin@arm.com>
 <20170913133618.lclorawve7364xxi@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170913133618.lclorawve7364xxi@localhost>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, gdb@sourceware.org, Yao Qi <Yao.Qi@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alan Hayward <alan.hayward@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 13, 2017 at 06:36:18AM -0700, Catalin Marinas wrote:
> On Thu, Aug 31, 2017 at 06:00:41PM +0100, Dave P Martin wrote:
> > +/*
> > + * The SVE architecture leaves space for future expansion of the
> > + * vector length beyond its initial architectural limit of 2048 bits
> > + * (16 quadwords).
> > + */
> > +#define SVE_VQ_BYTES		0x10	/* number of bytes per quadword */
> > +
> > +#define SVE_VQ_MIN		1
> > +#define SVE_VQ_MAX		0x200
> 
> Just a nitpick (up to you): could you use 16 and 512 here instead of
> hex? I usually associate hex numbers with some bit fields.

I have no strong opinion other than a desire to make these constants
typo-proof.

There's no particular reason why these shouldn't be in decimal, so I can
change them if you like, provided you promise to notice if I misspell
512 as 521...

(git grep 131027)

Cheers
---Dave
