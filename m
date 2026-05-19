Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD9B4B8DD4
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191987; cv=pass; b=biIGe9LBe4DQjg3bqrjbG3UBdgOFk/40zJHGWFnrlQGM4P+4lbx7iZQIgC8UBACuEIiMjSZoh28u6HdPgXShg6HY+VvZJnB3zDQcxiOynkJxLpyp7+hi6/I5ZtsuHHn2hhEerbGgaMTGMopqUpVzAvPJsfi7l02CI59KG+6WqTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191987; c=relaxed/simple;
	bh=S6b+ES1AQ4BlRnqoPf1CsvY7t9GR4aa6SRDlJGUhEJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D421xPnL787EPNvW3SwyygMJc6KxQl7BdzFBECApwYI0jNoprGh8jYYpApcaG2XqxAuaXWmSyWCdYh2G36frdkDA8aYmBFvQSyfTLoJ/s7eKsta57S01wSAVaZMhGgR8qhFeLLG451sJ2XbgPnizicjD9j9nZALX6S/D7waCRQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oiGhlg+x; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oiGhlg+x"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-515548f390fso10311cf.0
        for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 04:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779191984; cv=none;
        d=google.com; s=arc-20240605;
        b=fVyxU+gk8U0lgtRHtJwU1ehLcZ0D+DZrG2UnpoP+7jCafd9kbPfuaf8zxyO9p9u2ew
         /CYQ9Ec3pZIOthNwbOglKFssYvslvRvAHnaZiLGKyW5vDeGSQqx6G8MQGAyn9ZTWUz2p
         vsngns5ZPADRu5Inj3yda5bPQ42ezO930EVcSIggUD+Vhm7B8won72Hy64FhZ5a8fpNE
         q7g5XQh+HwvT/j+NwZ/Z8a8yG2eL3g+i5uj6yiHgLPqr6ZQ9KCo9O2ADIiUmdT0GZiSl
         677BHIZBZyEhrNobg4EHE7kjZmGykbYMDgxb6KXy7TFYf5CGTV4ojdi28DSeZCUozT6l
         Pu9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5EHisNFyKc4RDoQIbb7dFN77BBMtRwURYpatGZmAWVM=;
        fh=cAKpwdess4r27gdRgZOfivbcS/NnCSafqX6ZJ/AKmaw=;
        b=AGa4q6X3XL58lSCmTRHSthMWRVKtzTbHtmBHooviRSBYBtKZF4aGASLn1Hu5aNkP+5
         71YEbTIAKuVwkfmdasB8bO/iN7Hja7I69q6sIe6HB0ZwFHJx4ycarGldzQyGKXVFfgw9
         6RUKU1lWST+Qnb1zp2v1jeg4j3cEbYN5q0gKm2HroiPBYBt4Cye0YqpgDx9rzeZH7b60
         dBLNw8J9zN9rmdhIqji6J3YoaaRr9FDxW9N3A2rRAMQpr9ujx09eOInKjHBi8gwB0ac+
         kDMi+UrLTYF4VJaAHCDxB2m6Zd3R2oZKQ1B/qRBR8Tco8+t9gIAlvTJZdP5d7l+5LY20
         Mb7g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779191984; x=1779796784; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5EHisNFyKc4RDoQIbb7dFN77BBMtRwURYpatGZmAWVM=;
        b=oiGhlg+xYhP7JOUSmhmomIGXIKFxkfy3I92ggVArO+DeCaT49LfZiZfRLFxoNUj9iM
         24PUFztP1PsOLbd4pXdY5bQoEJEGRGTfqde4cBqaZbmjb4Ps9v1Ye7aCloIxOi+4bF1Y
         gP2XKyEzqCVRP/V8t9BShVgD+GCos2qKQSyIlx6YYHwriUkhFSusiMvdreICeGrR9Pee
         IOeCPDgPhQXbbVE6n99oQp9XCCVkbpt3M7vOcYKUmYAVdmiUa6n/LfNV/lHMP37AXqZD
         5vOtTxD3umWA69X9dt1ZgEOSOfTRtGoX4SzQearXPIfqPNXWg5SF9umZLdxcuHFlUtib
         /I8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191984; x=1779796784;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EHisNFyKc4RDoQIbb7dFN77BBMtRwURYpatGZmAWVM=;
        b=HpVAU1zKvIKPI6tcDh3xelSpWF2yU5gMxV6P7BowGuCvZG8KMEkatJDUTPKIBZjqkI
         VTP39PEjjEB0fnfUKFdF/nOT1MvfPNZxMM6Wz9L1EmbUaWwR4Wi57U4Ii/5km/dPB6qp
         iw+9K9y7A0sOD7Xdp5r+dUMDHyqPWAEJ8szQ3RBQsqbn2iCrNZjVufxzsdvGm85xmOu5
         i5+Lc4N5JJRJmGI1toeGKaYAjD6HmQyAugptLFoPaHgQygztHoZKKtFiDKNiQRxKH6Oj
         +S5BXTJQQiMKPZVUP48WfyAG7UlmLDaBpl6DRUN/WzJGNu7MN6nFBBiJffuPICHFx6qA
         iKRQ==
X-Forwarded-Encrypted: i=1; AFNElJ9RNRJSaHs95EJvZatWvXgRE0VLHw9xfgKVTRJ3Fp5yWCgTXmnHPHMXtdUpD8YjD7POaP7u5b0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+iIPYxAQImo9R9y1SGuV7sFfHT9/xwrbFUb9ZHxTNMLDZb5f0
	l27EvsIJRl0dxhTwA4V9Ij5qYHz+A3JY/K75GIwu4fv+uDWFyP9nUX/dv8axVIKb6iuXXwMrT+R
	RB6GnpDLWU8fQmXqqy//xnxLXrZZvDQdTBUo/cjzM
X-Gm-Gg: Acq92OH56RI+WTS47oKDVE3VIEadNs/+TBElphfhl3fTN823xi06hs/qYMn9KKJl89A
	b2k7E9UlTAwbLysYkydbfFBI/odpS8n7jMVapfUJrCZNC8vsM8z1wZNaZGkQSYpgo4BkxzO3aeF
	SfTXHhD3pC2urMZ+XuiU7n59bDUUzZq8zrclDHYHXL2idliSolSVvnwodY+I5FbT0nwBiaIsZI2
	W4v8d3HvIqvN23NNDanuxgfzbOe1W+Emd9o/FvlIe6Ez388rjG+0gXaSvOmg0VvdYt6AT7c0xU8
	/t7/WWixm4ACH29PcOel7dpk8Ry6mYQUnVUtkQPzto7Hjxnc
X-Received: by 2002:a05:622a:1f0c:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-5167937eeeamr27627991cf.8.1779191983904; Tue, 19 May 2026
 04:59:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260501-host-direct-messages-v6-0-3f4af727ed85@google.com> <20260501-host-direct-messages-v6-2-3f4af727ed85@google.com>
In-Reply-To: <20260501-host-direct-messages-v6-2-3f4af727ed85@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 19 May 2026 12:59:06 +0100
X-Gm-Features: AVHnY4Ig1N0dpqVbGvtdmXRoPPpkiLAJ97bxEVMStEvo9zlm0QSTSGFeCOzGZhg
Message-ID: <CA+EHjTyXHG05nGy5-7629vSmnctvMw0GDvjqYCMr_DisLaJewA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Armelle Laine <armellel@google.com>, 
	Sebastien Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Per,

On Fri, 1 May 2026 at 06:34, Per Larsen via B4 Relay
<devnull+perlarsen.google.com@kernel.org> wrote:
>
> From: Per Larsen <perlarsen@google.com>
>
> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions and can use the
> existing handler function. Add support for FFA_MSG_SEND_DIRECT_REQ2 in
> the host ffa handler.
>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 3a58e01d255f..e5718c0f1c31 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -684,11 +684,12 @@ static bool ffa_call_supported(u64 func_id)
>         case FFA_NOTIFICATION_GET:
>         case FFA_NOTIFICATION_INFO_GET:
>         /* Optional interfaces added in FF-A 1.2 */
> -       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
>         case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
>         case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not in Table 13.1 */
>         case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual instances per 13.1 */
>                 return false;
> +       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
> +               return hyp_ffa_version >= FFA_VERSION_1_2;
>         }
>
>         return true;
> @@ -865,6 +866,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
>                               struct kvm_cpu_context *ctxt)
>  {
> +       DECLARE_REG(u64, func_id, ctxt, 0);
>         DECLARE_REG(u32, endp, ctxt, 1);
>         DECLARE_REG(u32, flags, ctxt, 2);
>
> @@ -875,8 +877,12 @@ static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
>                 return;
>         }
>
> -       /* filter out framework messages and validate SBZ/MBZ bits */
> -       if (flags) {
> +       /*
> +        * filter out framework messages and validate SBZ/MBZ flag bits.
> +        * FFA_MSG_SEND_DIRECT_REQ2 implies flag-less partition message.
> +        */
> +       if ((func_id == FFA_MSG_SEND_DIRECT_REQ ||
> +            func_id == FFA_FN64_MSG_SEND_DIRECT_REQ) && flags) {

I don't have much experience with FFA, however, Sashiko flagged this
[1], and I think it found a real issue.

handle_host_smc() in hyp-main.c clears ARM_SMCCC_CALL_HINTS from its
local func_id and rejects calls with non-zero x0[63:32] before
dispatching here, so the upper bits (u64) aren't the issue. The issue is
that the hint-bit clear in handle_host_smc() only touches the local variable.
host_ctxt->regs.regs[0] still carries whatever the host wrote.

The DECLARE_REG() you added re-reads the raw X0 from ctxt, so the
SVE_HINT bit (0x10000) reappears. With the host setting that bit,
func_id becomes 0x8401006F and the equality test against
FFA_MSG_SEND_DIRECT_REQ (0x8400006F) falls through, skipping the
flags check. Note this isn't u64-specific -- u32 would capture the
same bit.

I think it's safest to pass the canonicalised func_id from
kvm_host_ffa_handler() rather than re-deriving here, matching the
__do_ffa_mem_xfer() style.

Cheers,
/fuad

https://sashiko.dev/#/patchset/20260501-host-direct-messages-v6-0-3f4af727ed85%40google.com



>                 ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
>                 return;
>         }
> @@ -942,6 +948,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>         case FFA_PARTITION_INFO_GET:
>                 do_ffa_part_get(&res, host_ctxt);
>                 goto out_handled;
> +       case FFA_MSG_SEND_DIRECT_REQ2:
> +               if (!ffa_call_supported(func_id))
> +                       goto out_not_supported;
> +               fallthrough;
>         case FFA_MSG_SEND_DIRECT_REQ:
>         case FFA_FN64_MSG_SEND_DIRECT_REQ:
>                 do_ffa_direct_msg(&res, host_ctxt);
> @@ -951,6 +961,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>         if (ffa_call_supported(func_id))
>                 return false; /* Pass through */
>
> +out_not_supported:
>         ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
>  out_handled:
>         ffa_set_retval(host_ctxt, &res);
>
> --
> 2.54.0.545.g6539524ca2-goog
>
>
>
