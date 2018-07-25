From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 12/16] KVM: arm64/sve: Context switch the SVE registers
Date: Wed, 25 Jul 2018 15:57:33 +0200
Message-ID: <20180725135733.wx4eqrp7cyghcigq@kamzik.brq.redhat.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-13-git-send-email-Dave.Martin@arm.com>
 <20180719131338.jsgezassnjhdbotd@kamzik.brq.redhat.com>
 <20180725115045.GJ4240@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1F9740672
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 09:57:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iAlbNN4sEx5i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 09:57:37 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3260D404D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 09:57:37 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180725115045.GJ4240@e103592.cambridge.arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 25, 2018 at 12:50:45PM +0100, Dave Martin wrote:
> > > +	if (system_supports_sve() && guest_has_sve)
> 
> As elsewhere, the system_supports_sve() check uses a static key and
> should be very cheap (or free in a CONFIG_ARM64_SVE=n kernel).
>

Yup, I'm clear on that now. Thanks again for explaining. It might
be nice for a small helper function in this case in order to avoid
the 'system_supports_sve() &&' everywhere and the chance that the
order of the checks gets swapped during some code refactoring someday.

Thanks,
drew
