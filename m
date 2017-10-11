From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 09/28] arm64/sve: Signal frame and context structure
 definition
Date: Wed, 11 Oct 2017 15:29:51 +0100
Message-ID: <20171011142950.zdhpaenvz4u5oyc3@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-10-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77B9B49D35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:29:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5HQxqcQjbvr7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 10:29:14 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BA5C49C4E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:29:14 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1507660725-7986-10-git-send-email-Dave.Martin@arm.com>
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

On Tue, Oct 10, 2017 at 07:38:26PM +0100, Dave P Martin wrote:
> This patch defines the representation that will be used for the SVE
> register state in the signal frame, and implements support for
> saving and restoring the SVE registers around signals.
> =

> The same layout will also be used for the in-kernel task state.
> =

> Due to the variability of the SVE vector length, it is not possible
> to define a fixed C struct to describe all the registers.  Instead,
> Macros are defined in sigcontext.h to facilitate access to the
> parts of the structure.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Benn=E9e <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
