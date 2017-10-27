From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 16/28] arm64/sve: Probe SVE capabilities and usable
 vector lengths
Date: Fri, 27 Oct 2017 13:56:22 +0100
Message-ID: <20171027125622.75rqvb2kyr4wqhr4@armageddon.cambridge.arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
 <1509101470-7881-17-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1DA949D1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 08:55:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2kgzwJAcVQpP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 08:55:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA4740638
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 08:55:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1509101470-7881-17-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 11:50:58AM +0100, Dave P Martin wrote:
> This patch uses the cpufeatures framework to determine common SVE
> capabilities and vector lengths, and configures the runtime SVE
> support code appropriately.
> =

> ZCR_ELx is not really a feature register, but it is convenient to
> use it as a template for recording the maximum vector length
> supported by a CPU, using the LEN field.  This field is similar to
> a feature field in that it is a contiguous bitfield for which we
> want to determine the minimum system-wide value.  This patch adds
> ZCR as a pseudo-register in cpuinfo/cpufeatures, with appropriate
> custom code to populate it.  Finding the minimum supported value of
> the LEN field is left to the cpufeatures framework in the usual
> way.
> =

> The meaning of ID_AA64ZFR0_EL1 is not architecturally defined yet,
> so for now we just require it to be zero.
> =

> Note that much of this code is dormant and SVE still won't be used
> yet, since system_supports_sve() remains hardwired to false.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Alex Benn=E9e <alex.bennee@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
