From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 01/28] regset: Add support for dynamically sized regsets
Date: Wed, 11 Oct 2017 15:45:43 +0100
Message-ID: <20171011144543.GE19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-2-git-send-email-Dave.Martin@arm.com>
 <20171011141410.tu53u2ugvs6n7uem@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC3049D3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:45:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sOA5rLFk3E1s for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 10:45:06 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE2549D14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 10:45:06 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171011141410.tu53u2ugvs6n7uem@armageddon.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 11, 2017 at 03:14:10PM +0100, Catalin Marinas wrote:
> On Tue, Oct 10, 2017 at 07:38:18PM +0100, Dave P Martin wrote:
> > Currently the regset API doesn't allow for the possibility that
> > regsets (or at least, the amount of meaningful data in a regset)
> > may change in size.
> > =

> > In particular, this results in useless padding being added to
> > coredumps in a regset's current size is smaller than its
> > theoretical maximum size.
> > =

> > This patch adds a get_size() function to struct user_regset.
> > Individual regset implementations can implement this function to
> > return the current size of the regset data.  A regset_size()
> > function is added to provide callers with an abstract interface for
> > determining the size of a regset without needing to know whether
> > the regset is dynamically sized or not.
> > =

> > The only affected user of this interface is the ELF coredump code:
> > This patch ports ELF coredump to dump regsets with their actual
> > size in the coredump.  This has no effect except for new regsets
> > that are dynamically sized and provide a get_size() implementation.
> > =

> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > ---
> >  fs/binfmt_elf.c        |  6 ++---
> >  include/linux/regset.h | 67 ++++++++++++++++++++++++++++++++++++++++++=
++------
> >  2 files changed, 63 insertions(+), 10 deletions(-)
> =

> The patch looks fine to me:
> =

> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> =

> However, you'd probably need an ack from the filesystem maintainers
> (cc'ed; patch below for reference).

Apologies for that -- I manually added Ccs to this patch in previous
postings, and predictably lost them in the respin.

I'll add Cc lines in the commit message, since there will be a
further re-spin of the series to apply the Documentation changes
requested by Szabolcs that I missed.

I don't currently have any pending fixes to _this_ patch, so it's still
worth reviewing.

Cheers
---Dave

[...]
