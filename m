From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm/arm64: trivial header path sanitization
Date: Fri, 25 Jan 2019 13:06:16 +0100
Message-ID: <20190125120616.GB18654@e113682-lin.lund.arm.com>
References: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 25, 2019 at 04:57:27PM +0900, Masahiro Yamada wrote:
> My main motivation is to get rid of crappy header search path manipulation
> from Kbuild core.
> 
> Before that, I want to finish as many cleanup works as possible.
> 
> If you are interested in the big picture of this work,
> the full patch set is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test

Changes appear fine to me:

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
