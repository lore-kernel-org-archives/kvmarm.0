Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6DFC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 11:40:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69DF74B11E;
	Wed, 15 Dec 2021 06:40:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Kts21cTs9vh; Wed, 15 Dec 2021 06:40:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FFBF4B121;
	Wed, 15 Dec 2021 06:40:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 459A44B11F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 06:40:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SSE+EQ8Pv7p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 06:40:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5ED4B11E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 06:40:02 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1807BD6E;
 Wed, 15 Dec 2021 03:40:02 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 038E83F774;
 Wed, 15 Dec 2021 03:40:00 -0800 (PST)
Date: Wed, 15 Dec 2021 11:39:58 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1
 as undefined
Message-ID: <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-2-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211214172812.2894560-2-oupton@google.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On Tue, Dec 14, 2021 at 05:28:07PM +0000, Oliver Upton wrote:
> Any valid implementation of the architecture should generate an
> undefined exception for writes to a read-only register, such as
> OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> behavior.
> 
> Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> write ever traps to EL2, inject an undef into the guest and print a
> warning.

I think this can still be read amibguously, since we don't explicitly state
that writes to OSLSR_EL1 should never trap (and the implications of being
UNDEFINED are subtle). How about:

| Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to EL2, but
| the KVM trap handler for OSLSR_EL1 handlees writes via ignore_write(). This
| is confusing to readers of the code, but shouldn't have any functional impact.
|
| For clarity, use write_to_read_only() rather than ignore_write(). If a trap
| is unexpectedly taken to EL2 in violation of the architecture, this will
| WARN_ONCE() and inject an undef into the guest.

With that:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..11b4212c2036 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  			   const struct sys_reg_desc *r)
>  {
>  	if (p->is_write) {
> -		return ignore_write(vcpu, p);
> +		return write_to_read_only(vcpu, p, r);
>  	} else {
>  		p->regval = (1 << 3);
>  		return true;
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
