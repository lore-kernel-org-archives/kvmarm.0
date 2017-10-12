From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 18/28] arm64/sve: Preserve SVE registers around EFI
 runtime service calls
Date: Thu, 12 Oct 2017 11:57:05 +0100
Message-ID: <20171012105705.zbs3wokxhky36k4k@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-19-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6014349D3D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cn0hX9zVNALH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:56:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C08C49D38
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:56:26 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1507660725-7986-19-git-send-email-Dave.Martin@arm.com>
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

On Tue, Oct 10, 2017 at 07:38:35PM +0100, Dave P Martin wrote:
> The EFI runtime services ABI allows EFI to make free use of the
> FPSIMD registers during EFI runtime service calls, subject to the
> callee-save requirements of the AArch64 procedure call standard.
> =

> However, the SVE architecture allows upper bits of the SVE vector
> registers to be zeroed as a side-effect of FPSIMD V-register
> writes.  This means that the SVE vector registers must be saved in
> their entirety in order to avoid data loss: non-SVE-aware EFI
> implementations cannot restore them correctly.
> =

> The non-IRQ case is already handled gracefully by
> kernel_neon_begin().  For the IRQ case, this patch allocates a
> suitable per-CPU stash buffer for the full SVE register state and
> uses it to preserve the affected registers around EFI calls.  It is
> currently unclear how the EFI runtime services ABI will be
> clarified with respect to SVE, so it safest to assume that the
> predicate registers and FFR must be saved and restored too.
> =

> No attempt is made to restore the restore the vector length after
> a call, for now.  It is deemed rather insane for EFI to change it,
> and contemporary EFI implementations certainly won't.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
