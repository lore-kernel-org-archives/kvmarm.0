Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296294EC649
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452772; cv=none; b=Z105WTIB+FQSGljaFPCK8KiKjled79bEuHZ7NtpQhBI7cF9/xnyzsQnK0KljKG6Or+jT5Yq41adSuyyEPn4xxrtEh9FTMq4lM81sGMnT5ZIN95yFj01Twx4rg9adD64zvtQKWJ33a7gzCwW6XgPIjxTpfYfi7516aZVRBABd138=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452772; c=relaxed/simple;
	bh=+qcsrQvO4vozfnHvfqhK0Bur5FCJBcSl782PHIa4noY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rpU3TrEY/khHLDqBQ6pKFjDSqFEJWg6y7dI8uUBbIpFIAqRSKteGCxKylOo/jjaY75XB34lfutWDWarX+jflXlZDulbE4FVFhlGMIcyLajEFZ0WGBun86aCq3rn5XlOwAJhjjKEJTo2je5janR6LYRx6946ecsww7TFQKRA2irA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=agk0pFTR; arc=none smtp.client-ip=91.218.175.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="agk0pFTR"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+qcsrQvO4vozfnHvfqhK0Bur5FCJBcSl782PHIa4noY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788452769; v=1; x=1789057569;
 b=agk0pFTRfRtVt8yXGyeTVVhbsPtsQcVQaBYECmU2D2nWSdjwFYPsjKh11Ps4HwMPOjjW1gia
 FTg6kDwniDrUROtSBOalm7dd3v+VqiIRxwLAyY67IbHjgTQbD5Bdlx3jgJ+dGy5yqurPbKHZPpq
 Zbs10Ww74sYruxUfol9v9960=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 707f8484f41cdc3f;
	Thu, 03 Sep 2026 16:26:09 +0000
X-Mizu-Trace-ID: 707f8484f41cdc3f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so6614e87.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:26:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx3tW8dnQR6ZGmw7u1TwLbETXxt6PJJj3oG6maYbCb42HgNhUYaL99njIG8AlWuDfDow0CXuK8=@lists.linux.dev
X-Gm-Message-State: AFuF++lUpTrBDxdARBqM6yBD9B/4NgTvvRjkrFQ3uSkATCN9QYQ9YCCw
	ekF2yufOb0yoFaTD9IZ6qoKXVWj9FxmXkDuotY0mTsNCwdWAOP8czfFWMqiHQyb/z4EnDiS3C0B
	+vogH4CCb943RGGgy85NYCZQYXuBu7hhJAG0oxq4O
X-Received: by 2002:a05:6512:3da3:b0:5b4:9dba:4ecd with SMTP id
 2adb3069b0e04-5b60f995745mr170343e87.11.1788452765001; Thu, 03 Sep 2026
 09:26:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-9-fuad.tabba@linux.dev>
 <apmOd-KTA3dSp30S@e143914.arm.com>
In-Reply-To: <apmOd-KTA3dSp30S@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 3 Sep 2026 17:25:28 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwvO728q5RJgqdBw+ocVnj69Aofadxfx610-sH2s-yNzA@mail.gmail.com>
X-Gm-Features: AcwNN1Wh4qoftVNA-tYS-W9OgIM1mUYNik80e15tl98nB-9zZtgvToD4NDruw5E
Message-ID: <CA+EHjTwvO728q5RJgqdBw+ocVnj69Aofadxfx610-sH2s-yNzA@mail.gmail.com>
Subject: Re: [PATCH 08/17] KVM: arm64: Implement HVC handling for protected
 guests at EL2
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Sept 2026 at 16:13, Joey Gouly <joey.gouly@arm.com> wrote:
>
> On Mon, Aug 31, 2026 at 05:34:12PM +0100, Fuad Tabba wrote:
> > Extend kvm_handle_pvm_hvc64() to handle SMCCC_VERSION,
> > SMCCC_ARCH_FEATURES and the vendor hypervisor call UID at EL2, so
> > these queries do not reach the host. ARCH_FEATURES is mandatory from
> > SMCCC 1.1, the version EL2 reports: it returns SUCCESS for itself and
> > for SMCCC_VERSION, and NOT_SUPPORTED for anything else.
> >
> > Add handle_pvm_entry_hvc64() and handle_pvm_exit_hvc64(), which
> > forward a protected guest's HVCs to the host and return the reply; a
> > later patch wires them into the per-EC dispatch tables.
>
> These two functions are unused in this commit, and are modified in the
> next commit, while still being unused. Then handle_pvm_entry_hvc64()
> becomes a wrapper for handle_pvm_entry_psci() (which was the whole body
> of handle_pvm_entry_hvc64). It's quite hard to follow. If these
> functions are really unused and then modified, maybe it's just better to
> remove them from this commit?

Both move to the patch that first calls them, so each appears once, in
its final form, beside its caller.

The wrapper should go with it: handle_pvm_entry_hvc64() only calls
handle_pvm_entry_psci(), and PSCI calls are the only HVCs forwarded to
the host, so the split has no non-PSCI case to handle.

Thanks for the reviews!
/fuad

>
> Thanks,
> Joey
>
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 28 ++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c     | 29 +++++++++++++++++++++++++++++
> >  2 files changed, 57 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index d4b0f69ff130c..62864db1e099a 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -4,6 +4,8 @@
> >   * Author: Andrew Scull <ascull@google.com>
> >   */
> >
> > +#include <kvm/arm_hypercalls.h>
> > +
> >  #include <hyp/adjust_pc.h>
> >  #include <hyp/switch.h>
> >
> > @@ -33,6 +35,32 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
> >
> >  typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
> >
> > +static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < 4; i++) {
> > +             u64 ret =
> > +                     READ_ONCE(hyp_vcpu->host_vcpu->arch.ctxt.regs.regs[i]);
> > +             vcpu_set_reg(&hyp_vcpu->vcpu, i, ret);
> > +     }
> > +}
> > +
> > +static void __maybe_unused handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > +     int i;
> > +
> > +     WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
> > +                hyp_vcpu->vcpu.arch.fault.esr_el2);
> > +
> > +     /* Pass the HVC function id (r0) and its arguments. */
> > +     for (i = 0; i < 8; i++) {
> > +             WRITE_ONCE(host_vcpu->arch.ctxt.regs.regs[i],
> > +                        vcpu_get_reg(&hyp_vcpu->vcpu, i));
> > +     }
> > +}
> > +
> >  static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >       vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index af334318d0a03..0fe11f95e2e26 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -1144,8 +1144,37 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  {
> >       u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
> >       bool handled = true;
> > +     u32 feature;
> > +     uuid_t uuid;
> >
> >       switch (smccc_get_function(vcpu)) {
> > +     case ARM_SMCCC_VERSION_FUNC_ID:
> > +             /* Nothing to be handled by the host. Go back to the guest. */
> > +             val[0] = ARM_SMCCC_VERSION_1_1;
> > +             val[1] = 0;
> > +             val[2] = 0;
> > +             val[3] = 0;
> > +             break;
> > +     case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +             /* SUCCESS only for the architecture calls EL2 implements. */
> > +             feature = smccc_get_arg1(vcpu);
> > +             switch (feature) {
> > +             case ARM_SMCCC_VERSION_FUNC_ID:
> > +             case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +                     val[0] = SMCCC_RET_SUCCESS;
> > +                     break;
> > +             default:
> > +                     val[0] = SMCCC_RET_NOT_SUPPORTED;
> > +                     break;
> > +             }
> > +             break;
> > +     case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > +             uuid = ARM_SMCCC_VENDOR_HYP_UID_KVM;
> > +             val[0] = smccc_uuid_to_reg(&uuid, 0);
> > +             val[1] = smccc_uuid_to_reg(&uuid, 1);
> > +             val[2] = smccc_uuid_to_reg(&uuid, 2);
> > +             val[3] = smccc_uuid_to_reg(&uuid, 3);
> > +             break;
> >       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >               val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >               val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
> > --
> > 2.39.5
> >
