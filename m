From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 08/28] arm64/sve: Kconfig update and conditional
 compilation support
Date: Wed, 11 Oct 2017 15:29:08 +0100
Message-ID: <20171011142908.gwgxegzy2kyb5i3t@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-9-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A97349D35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:28:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W4xrYUqRRGCO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 10:28:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A3C49C4E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:28:31 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1507660725-7986-9-git-send-email-Dave.Martin@arm.com>
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

On Tue, Oct 10, 2017 at 07:38:25PM +0100, Dave P Martin wrote:
> This patch adds CONFIG_ARM64_SVE to control building of SVE support
> into the kernel, and adds a stub predicate system_supports_sve() to
> control conditional compilation and runtime SVE support.
> =

> system_supports_sve() just returns false for now: it will be
> replaced with a non-trivial implementation in a later patch, once
> SVE support is complete enough to be enabled safely.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
