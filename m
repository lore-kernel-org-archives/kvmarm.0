From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 07/28] arm64/sve: Low-level SVE architectural state
 manipulation functions
Date: Wed, 11 Oct 2017 15:28:19 +0100
Message-ID: <20171011142819.jheh4jwb347demj6@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-8-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03EC449D35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:27:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vRBa+bNuAleH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 10:27:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DEB49C4E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:27:42 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1507660725-7986-8-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:24PM +0100, Dave P Martin wrote:
> Manipulating the SVE architectural state, including the vector and
> predicate registers, first-fault register and the vector length,
> requires the use of dedicated instructions added by SVE.
> =

> This patch adds suitable assembly functions for saving and
> restoring the SVE registers and querying the vector length.
> Setting of the vector length is done as part of register restore.
> =

> Since people building kernels may not all get an SVE-enabled
> toolchain for a while, this patch uses macros that generate
> explicit opcodes in place of assembler mnemonics.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

(not adding reviewed-by as I haven't checked the instruction encodings,
I just trust you to be correct ;))
