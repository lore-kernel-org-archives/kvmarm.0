From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 19/28] arm64/sve: ptrace and ELF coredump support
Date: Fri, 8 Sep 2017 14:11:40 +0100
Message-ID: <20170908131136.GG6321@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-20-git-send-email-Dave.Martin@arm.com>
 <5FA513F682BE7F4EAAB8EE035D5B08E44109DFE8@G01JPEXMBKW02>
 <20170906181634.GF6321@e103592.cambridge.arm.com>
 <5FA513F682BE7F4EAAB8EE035D5B08E44109EBDF@G01JPEXMBKW02>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5FA513F682BE7F4EAAB8EE035D5B08E44109EBDF@G01JPEXMBKW02>
Sender: linux-arch-owner@vger.kernel.org
To: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, "gdb@sourceware.org" <gdb@sourceware.org>, Yao Qi <Yao.Qi@arm.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alan Hayward <alan.hayward@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 07, 2017 at 05:11:45AM +0000, Okamoto, Takayuki wrote:
> Hi Dave,
> 
> Thank you for your reply.
> 
> > Your fix looks correct and seems to work.  For stylistic reasons, I may
> > write it like this instead, but the effect should be the same:
> > 
> > 	header->max_vl = sve_max_vl;
> > 	if (WARN_ON(!sve_vl_valid(sve_max_vl))
> > 		header->max_vl = header->vl;
> 
> It is better than my fix.
> Please, apply it at next version.

I've rebased to v4.13 and pushed a branch to track fixes against v2,
here:

 * http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve/v2%2Bfixes

 * git://linux-arm.org/linux-dm.git sve/v2+fixes

Cheers
---Dave
