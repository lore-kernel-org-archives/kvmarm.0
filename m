From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 12/28] arm64/sve: Support vector length resetting for
 new processes
Date: Wed, 11 Oct 2017 17:16:39 +0100
Message-ID: <20171011161638.wdj6mka3pm24lebg@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EACA49D56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 12:16:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZIrKLHSK2Djp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 12:16:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03FB449D3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 12:16:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1507660725-7986-13-git-send-email-Dave.Martin@arm.com>
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

On Tue, Oct 10, 2017 at 07:38:29PM +0100, Dave P Martin wrote:
> It's desirable to be able to reset the vector length to some sane
> default for new processes, since the new binary and its libraries
> processes may or may not be SVE-aware.
> =

> This patch tracks the desired post-exec vector length (if any) in a
> new thread member sve_vl_onexec, and adds a new thread flag
> TIF_SVE_VL_INHERIT to control whether to inherit or reset the
> vector length.  Currently these are inactive.  Subsequent patches
> will provide the capability to configure them.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
