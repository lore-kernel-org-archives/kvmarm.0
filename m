Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67F4C00A89
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 11:34:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A58A2083B
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 11:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OPmDmHF/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A58A2083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C6134B742;
	Thu,  5 Nov 2020 06:34:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h7XIQBB8+GLD; Thu,  5 Nov 2020 06:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1176C4B772;
	Thu,  5 Nov 2020 06:34:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B284B7D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 05:34:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9gAnKdoZdaXP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 05:34:27 -0500 (EST)
Received: from mail-yb1-f193.google.com (mail-yb1-f193.google.com
 [209.85.219.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5D934B7D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 05:34:27 -0500 (EST)
Received: by mail-yb1-f193.google.com with SMTP id h196so918591ybg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 02:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WARPYNG/pkkFHQsf/U54xpXcQrxxuoK+VKugv+Xo+bc=;
 b=OPmDmHF/W/fl29kiGncEWLY3OqJ/5JdncBDgnHVN6voZdKgHhq8+KeV6SmBwqtMepo
 5PLEu+2Xe0clvNasKD5eEQhfYN3kUvThiBtXksXH+bnIyusPEUnVyMFv4CRolxFxnSZJ
 RC5NB1kczcrKB8D+IetWzfhEVqgMDgUaANwvXMnJC1Ltql7EC2rZ8QYQAK9vtlAYfbaN
 utqfi7e86jk++g4dydxWxgJtP0PiDYYKFeWSzZDajWmOuZGDcoKr4RkVHrGkKOkIL+RJ
 imZ8bOXplk1Egmtw/LWuoByvzlvTzy3hsGeFenagqFZ8KteUruGyT2kNMIMn4fDL2Cnt
 vvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WARPYNG/pkkFHQsf/U54xpXcQrxxuoK+VKugv+Xo+bc=;
 b=Sk4eqcYoHNVRZiVUtegOQ+vZOLTxvYCiXFjTvWyUeMBeVl3z9jiA5sZU6TGNnGVapN
 R0/uUVKn7fOrae9L356y1dN22dZEq/65splLH78eGHCMaEBw1RaoI3jYxOlIRflyZDpP
 ui68urDyX0Sa5Oko1bnIwo8xQm+3fB+VEQopgygmNkXigPPF2y6/sg0o+iJy2o6pljDl
 O769NstxEVzBwery6evgHd7PYx25kTqO33spMD5kuLZtAPWt4+KpzakJubfbrHeghVv5
 P6E7DO4TiOcgq8Gh7VvNaCnT5r/VOzBnI+FV+X4dbjVPgdV7H812Vo3TQ4axDQqXSPEl
 qFvw==
X-Gm-Message-State: AOAM530qkwyZ8vL/zTHjUiKA1QHYHZTu2Qtsy3M1FTdznyRjMeJuO+hD
 QAq+yb+44Zest5YYzjqDd/KQ4hLW+ChvKS4qrZU0UA==
X-Google-Smtp-Source: ABdhPJyhCGP6FUWqnbyKnum71VhBtve+oVrbO+RrKv9weu6UVBx0jI5O7jwdbb95tvqAmy8svnpShUT9GAJ00jVXiaw=
X-Received: by 2002:a25:b2a1:: with SMTP id k33mr2562175ybj.337.1604572466889; 
 Thu, 05 Nov 2020 02:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20201104183630.27513-1-dbrazdil@google.com>
 <20201104183630.27513-24-dbrazdil@google.com>
In-Reply-To: <20201104183630.27513-24-dbrazdil@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Thu, 5 Nov 2020 10:34:15 +0000
Message-ID: <CA+_y_2GgF7W8f=_3Y+-Nyb+JWTCqCvtE7OT=kabAqxnp6vLnOw@mail.gmail.com>
Subject: Re: [RFC PATCH 23/26] kvm: arm64: Intercept host's CPU_SUSPEND PSCI
 SMCs
To: David Brazdil <dbrazdil@google.com>
X-Mailman-Approved-At: Thu, 05 Nov 2020 06:34:17 -0500
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Android Kernel Team <kernel-team@android.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============3905204905882011252=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============3905204905882011252==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f0a1d305b359a334"

--000000000000f0a1d305b359a334
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2020 at 19:37, 'David Brazdil' via kernel-team
<kernel-team@android.com> wrote:
>
> Add a handler of CPU_SUSPEND host PSCI SMCs. When invoked, it determines
> whether the requested power state loses context, ie. whether it is
> indistinguishable from a WHI or whether it is a deeper sleep state that
Do you mean WFI?

> behaves like a CPU_OFF+CPU_ON.
>
> If it's the former, it forwards the call to EL3 and returns to the host
> after waking up.
>
> If it's the latter, it saves r0,pc of the host into and makes the same
> call to EL3 with the hyp CPU entry point. When the core wakes up, EL2
> state is initialized before dropping back to EL1.
>
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/arm.c           |  2 ++
>  arch/arm64/kvm/hyp/nvhe/psci.c | 49 +++++++++++++++++++++++++++++++++-
>  drivers/firmware/psci/psci.c   |  9 -------
>  include/uapi/linux/psci.h      |  7 +++++
>  4 files changed, 57 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 166975999ead..6fbda652200b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1521,9 +1521,11 @@ static void init_psci(void)
>  {
>         extern u32 kvm_nvhe_sym(kvm_host_psci_version);
>         extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
> +       extern u32 kvm_nvhe_sym(kvm_host_psci_cpu_suspend_feature);
>         int cpu;
>
>         kvm_nvhe_sym(kvm_host_psci_version) = psci_driver_version;
> +       kvm_nvhe_sym(kvm_host_psci_cpu_suspend_feature) = psci_cpu_suspend_feature;
>         memcpy(kvm_nvhe_sym(kvm_host_psci_function_id),
>                 psci_function_id, sizeof(psci_function_id));
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
> index 42ee5effa827..4899c8319bb4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci.c
> @@ -21,6 +21,7 @@
>  /* Config options set by the host. */
>  u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
>  u32 kvm_host_psci_function_id[PSCI_FN_MAX];
> +u32 kvm_host_psci_cpu_suspend_feature;
>  s64 hyp_physvirt_offset;
>
>  #define __hyp_pa(x) ((phys_addr_t)(x) + hyp_physvirt_offset)
> @@ -83,6 +84,20 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
>         hyp_panic(); /* unreachable */
>  }
>
> +static bool psci_has_ext_power_state(void)
> +{
> +       return kvm_host_psci_cpu_suspend_feature & PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK;
> +}
> +
> +static bool psci_power_state_loses_context(u32 state)
> +{
> +       const u32 mask = psci_has_ext_power_state() ?
> +                                       PSCI_1_0_EXT_POWER_STATE_TYPE_MASK :
> +                                       PSCI_0_2_POWER_STATE_TYPE_MASK;
> +
> +       return state & mask;
> +}
> +
>  static unsigned int find_cpu_id(u64 mpidr)
>  {
>         int i;
> @@ -106,6 +121,34 @@ static phys_addr_t cpu_entry_pa(void)
>         return kern_va - kimage_voffset;
>  }
>
> +static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
> +{
> +       u64 power_state = host_ctxt->regs.regs[1];
> +       unsigned long pc = host_ctxt->regs.regs[2];
> +       unsigned long r0 = host_ctxt->regs.regs[3];
> +       hyp_spinlock_t *cpu_lock;
> +       struct vcpu_reset_state *cpu_reset;
> +       struct kvm_nvhe_init_params *cpu_params;
> +
> +       if (!psci_power_state_loses_context(power_state)) {
> +               /* This power state has the same semantics as WFI. */
> +               return psci_call(PSCI_0_2_FN64_CPU_SUSPEND, 0, 0, 0);
> +       }
> +
> +       cpu_lock = this_cpu_ptr(&psci_cpu_lock);
> +       cpu_reset = this_cpu_ptr(&psci_cpu_reset);
> +       cpu_params = this_cpu_ptr(&kvm_init_params);
> +
> +       /* Resuming from this state has the same semantics as CPU_ON. */
> +       hyp_spin_lock(cpu_lock);
> +       *cpu_reset = (struct vcpu_reset_state){
> +               .pc = pc,
> +               .r0 = r0,
> +       };
> +       hyp_spin_unlock(cpu_lock);
> +       return psci_call(func_id, power_state, cpu_entry_pa(), __hyp_pa(cpu_params));
> +}
> +
>  static int psci_cpu_off(u64 func_id, struct kvm_cpu_context *host_ctxt)
>  {
>         hyp_spinlock_t *cpu_lock = this_cpu_ptr(&psci_cpu_lock);
> @@ -193,7 +236,9 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
>
>  static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
>  {
> -       if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
> +       if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_SUSPEND])
> +               return psci_cpu_suspend(func_id, host_ctxt);
> +       else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
>                 return psci_cpu_off(func_id, host_ctxt);
>         else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
>                 return psci_cpu_on(func_id, host_ctxt);
> @@ -216,6 +261,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
>         case PSCI_0_2_FN_SYSTEM_RESET:
>                 psci_forward_noreturn(host_ctxt);
>                 unreachable();
> +       case PSCI_0_2_FN64_CPU_SUSPEND:
> +               return psci_cpu_suspend(func_id, host_ctxt);
>         case PSCI_0_2_FN_CPU_OFF:
>                 return psci_cpu_off(func_id, host_ctxt);
>         case PSCI_0_2_FN64_CPU_ON:
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index b6ad237b1518..387e24409da7 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -62,15 +62,6 @@ static psci_fn *invoke_psci_fn;
>
>  u32 psci_function_id[PSCI_FN_MAX];
>
> -#define PSCI_0_2_POWER_STATE_MASK              \
> -                               (PSCI_0_2_POWER_STATE_ID_MASK | \
> -                               PSCI_0_2_POWER_STATE_TYPE_MASK | \
> -                               PSCI_0_2_POWER_STATE_AFFL_MASK)
> -
> -#define PSCI_1_0_EXT_POWER_STATE_MASK          \
> -                               (PSCI_1_0_EXT_POWER_STATE_ID_MASK | \
> -                               PSCI_1_0_EXT_POWER_STATE_TYPE_MASK)
> -
>  u32 psci_cpu_suspend_feature;
>  static bool psci_system_reset2_supported;
>
> diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
> index 0d52b8dbe8c2..df3d85ce86f7 100644
> --- a/include/uapi/linux/psci.h
> +++ b/include/uapi/linux/psci.h
> @@ -65,6 +65,10 @@
>  #define PSCI_0_2_POWER_STATE_AFFL_SHIFT                24
>  #define PSCI_0_2_POWER_STATE_AFFL_MASK         \
>                                 (0x3 << PSCI_0_2_POWER_STATE_AFFL_SHIFT)
> +#define PSCI_0_2_POWER_STATE_MASK                                      \
> +                               (PSCI_0_2_POWER_STATE_ID_MASK |         \
> +                                PSCI_0_2_POWER_STATE_TYPE_MASK |       \
> +                                PSCI_0_2_POWER_STATE_AFFL_MASK)
>
>  /* PSCI extended power state encoding for CPU_SUSPEND function */
>  #define PSCI_1_0_EXT_POWER_STATE_ID_MASK       0xfffffff
> @@ -72,6 +76,9 @@
>  #define PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT    30
>  #define PSCI_1_0_EXT_POWER_STATE_TYPE_MASK     \
>                                 (0x1 << PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT)
> +#define PSCI_1_0_EXT_POWER_STATE_MASK                                  \
> +                               (PSCI_1_0_EXT_POWER_STATE_ID_MASK |     \
> +                                PSCI_1_0_EXT_POWER_STATE_TYPE_MASK)
>
>  /* PSCI v0.2 affinity level state returned by AFFINITY_INFO */
>  #define PSCI_0_2_AFFINITY_LEVEL_ON             0
> --
> 2.29.1.341.ge80a0c044ae-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

--000000000000f0a1d305b359a334
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmgYJKoZIhvcNAQcCoIIPizCCD4cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz0MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
3bJTL+f1Qu2ISHRBOjBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMIGaBggrBgEFBQcB
AQSBjTCBijA+BggrBgEFBQcwAYYyaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vY2EvZ3NhdGxh
c3Izc21pbWVjYTIwMjAwSAYIKwYBBQUHMAKGPGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20v
Y2FjZXJ0L2dzYXRsYXNyM3NtaW1lY2EyMDIwLmNydDAfBgNVHSMEGDAWgBR8zApo16LrHixyG9HN
XZVvjfvyYzBGBgNVHR8EPzA9MDugOaA3hjVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dz
YXRsYXNyM3NtaW1lY2EyMDIwLmNybDANBgkqhkiG9w0BAQsFAAOCAQEAPSX0dCv/pNBePB6gzapR
2K3Td14q4WSFa3qzZW2NDRqi6BwzBnY56oEw5nzqoCfO862RWMaJooafzfFN8Tqi+a1srDUtfEl6
HqHJnOHV1ffVlKteZo7+a8MKoEEZkNY3FDqLCGW0MI3sK12SRylih9n9EiaZmNCdbiVEiQp8b6ZS
71dZypMV11MFvto+wAK5IpWrAGZceJvedthg4MbgRkwFl5mO4SpAE2+SiEJHfwSCXO9pANWr9tUo
HcT/LtA3yN6iu37SYRAEwVTCMOQz8ZId/aYKzWtUVhCe/w0ktX3JmQcD27GSKtGZLC2S1oudgZi1
EWpM28ahuCAqKwzu8jGCAmowggJmAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
bFNpZ24gbnYtc2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01JTUUgQ0EgMjAyMAIQ
ARpkhHbCOwIIXzj5ux8owjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgJr9F174l
u3BuuC8IxXtBIzEgS0RR2xHouNsxSRnaPUIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMTA1MTAzNDI3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAA+EukltcxS3H/A+ImauT6Lq0nZk
lzcMvzUoZ4sQ+kacj9jA9OUjpRB3d4DU8vsZ5nxa2BuydNkj0CLMcdrz7RdiqI9w/lH50qrTS9Ks
FDPWd6eY4SAVd+hTn2ouVoStmbKtOzW2dZOWGs9uHIe8HgC573ws+s48uQ0PIevpJ6zXdBbtsoiz
BQBcq1me23H2MNtcgaxh54+ixaxc/bc2t1oYHZMsiK6j8IySqcSfJ2RkxHC7H6+CdOUeNGPM7z+O
TOodpHMbhMaEsk7vkg16eGCRzcHMs9LTJIdYA3aNW/9XyftZjz2dpaaPbIIYFZ1FIIZhy+WWeDKn
3SizYSPUuYo=
--000000000000f0a1d305b359a334--

--===============3905204905882011252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3905204905882011252==--
