From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Fri, 10 Jul 2015 12:22:31 +0100
Message-ID: <CAFEAcA8a+RDxPwKsjKSzSZq6khqZjKEZXCokp3rQEuaNBj0B1Q@mail.gmail.com>
References: <1436526053-4516-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F75584F3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 07:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XA93hH1CQOp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 07:11:13 -0400 (EDT)
Received: from mail-vn0-f52.google.com (mail-vn0-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 185A0584EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 07:11:12 -0400 (EDT)
Received: by vnbf1 with SMTP id f1so26473605vnb.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 04:22:50 -0700 (PDT)
In-Reply-To: <1436526053-4516-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10 July 2015 at 12:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Some registers like the CNTVCT register should only be written to the
> kernel as part of machine initialization or on vmload operations, but
> never during runtime, as this can potentially make time go backwards or
> create inconsistent time observations between VCPUs.
>
> Introduce a list of registers that should not be written back at runtime
> and check this list on syncing the register state to the KVM state.

Thanks for picking this one up...

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  target-arm/kvm.c     | 34 +++++++++++++++++++++++++++++++++-
>  target-arm/kvm32.c   |  2 +-
>  target-arm/kvm64.c   |  2 +-
>  target-arm/kvm_arm.h |  3 ++-
>  target-arm/machine.c |  2 +-
>  5 files changed, 38 insertions(+), 5 deletions(-)
>
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index 548bfd7..2e92699 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -409,7 +409,35 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
>      return ok;
>  }
>
> -bool write_list_to_kvmstate(ARMCPU *cpu)
> +typedef struct cpreg_state_level {
> +    uint64_t kvm_idx;
> +    int level;
> +} cpreg_state_level;

(QEMU's coding style prefers CPRegStateLevel for struct types.)

> +
> +/* All system registers not listed in the following table are assumed to be
> + * of the level KVM_PUT_RUNTIME_STATE, a register should be written less
> + * often, you must add it to this table with a state of either
> + * KVM_PUT_RESET_STATE or KVM_PUT_FULL_STATE.
> + */
> +cpreg_state_level non_runtime_cpregs[] = {
> +    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },

This should be KVM_PUT_RESET_STATE, right?

> +};

The other option here would be to keep the level information
in the cpreg structs (which is where we put everything else
we know about cpregs); we'd probably need to then initialise
some other data structure if we wanted to avoid the hash
table lookup for every register in write_list_to_kvmstate.

I guess if we expect this list to remain a fairly small
set of exceptional cases then this is OK (and vaguely
comparable to the existing kvm_arm_reg_syncs_via-cpreg_list
handling).

Don't we need separate 32-bit and 64-bit versions of
this list?

thanks
-- PMM
