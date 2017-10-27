From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 19/28] arm64/sve: ptrace and ELF coredump support
Date: Fri, 27 Oct 2017 14:04:11 +0100
Message-ID: <20171027130411.qc2ee2z5ywocnvnw@armageddon.cambridge.arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
 <1509101470-7881-20-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A64AB49D14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 09:02:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5h0f6nRvqDYI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 09:02:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 317DD406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 09:02:52 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1509101470-7881-20-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Alan Hayward <alan.hayward@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 11:51:01AM +0100, Dave P Martin wrote:
> This patch defines and implements a new regset NT_ARM_SVE, which
> describes a thread's SVE register state.  This allows a debugger to
> manipulate the SVE state, as well as being included in ELF
> coredumps for post-mortem debugging.
> =

> Because the regset size and layout are dependent on the thread's
> current vector length, it is not possible to define a C struct to
> describe the regset contents as is done for existing regsets.
> Instead, and for the same reasons, NT_ARM_SVE is based on the
> freeform variable-layout approach used for the SVE signal frame.
> =

> Additionally, to reduce debug overhead when debugging threads that
> might or might not have live SVE register state, NT_ARM_SVE may be
> presented in one of two different formats: the old struct
> user_fpsimd_state format is embedded for describing the state of a
> thread with no live SVE state, whereas a new variable-layout
> structure is embedded for describing live SVE state.  This avoids a
> debugger needing to poll NT_PRFPREG in addition to NT_ARM_SVE, and
> allows existing userspace code to handle the non-SVE case without
> too much modification.
> =

> For this to work, NT_ARM_SVE is defined with a fixed-format header
> of type struct user_sve_header, which the recipient can use to
> figure out the content, size and layout of the reset of the regset.
> Accessor macros are defined to allow the vector-length-dependent
> parts of the regset to be manipulated.
> =

> Signed-off-by: Alan Hayward <alan.hayward@arm.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Benn=E9e <alex.bennee@linaro.org>
> Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
