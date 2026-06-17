Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1273B27D8
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692131; cv=pass; b=jgALAgz/f3JP5nMQI3yaCYA22z9CjBTcTCaZLrcFsmu23EweGVD2ea32ckf+ITUGNRH9uW/x2lv6WDcdstDaHlcJUMtjO8jzVNnlRxKLMqRUaSOY7udJDVJV8E6WkKJxa8NlmUYqooIu8PIae/Uy1xeYV1kVv/LMPh5JNjVNPsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692131; c=relaxed/simple;
	bh=UxmcTXw53LpQS53Tvtcs8HYdAlkHQKrn3FBO9PHh61M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KVu1XHyfDrnI7GGM22XUM87UBEKUTeCO9a3zhvWNMw/yGevlIpmIU/M1dwd5DD02YFSQiR8Jt+oRn6L0RYBNQbTxXE7wrlr/AAsnrXwVMJjEiH4kbBmFuO36lmLPf0mjhXXG79GiRjTC7NcpnI/4k+KjtpcP9afhFKfBx3Ii+pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MCJWFcMp; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MCJWFcMp"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5177d1ff061so185791cf.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 03:28:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781692129; cv=none;
        d=google.com; s=arc-20240605;
        b=Pcp/DMyuHxU8MuikvmPFR8xTPJ8IwcbpGFgkEFhgDf/Omo7tpIVfdQ3mFd4o7sSiHV
         n86hAm1z4gfudLaJQMkDczQBrquj+Vjmgfdx/VgHhtZLPymGp2ZGZ2MuNRwhUXj40l+g
         Ir/moZHB1m7OHGUW7OlB1CMN1s+UbWlWRcFRaUZ3FMpnig6imBztSf1Yt04/i6OGMYdx
         XcPTtwoa3R53nqL/Row7OtUj7Q7MBww88tD+CkbicA4JctpoJcM6mBEfq8jzW1Z6hdvH
         llUyGyeC51Bx53YMCT2zAs8CPTp81wZie1zdubeZka6kVrk6AZ8j7LaGqJZA85NZmiMT
         cCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=N2jPlRyhxf5Js0wrvZhbEPMffqjEBHr4VMZy0F6mhfY=;
        fh=IR+OMJqEAbmJVWoaleFXH6dBg0IPHI7TW15vy8Fou6U=;
        b=XPsIQKUo6xZXqfZgHBhnEXUURFspy2h3D2PVRVylYvJq+eZPDCO7NfxAOGcNPpZqdq
         e8ahNVIucY4N+u20MFKMLyW/3iEA2jM+L9sXQ6l8qX0RHjoUuk3NszUBrCO1PbABEgVE
         FtJt3dn43P3HuXft8emuWnp0XmnE6igPOC2p17+hu22J0wk4QmyAwGzinqsml9w2/hcX
         LevmRitSVkNCqx/+0ntTZkxPK+C4L+mDSO35hVDgzaHYkk3KIyAE6uWUl+F7tR24Jlxg
         PAaSdE7J5dBrZbieKUn+ThqcC59kY9/TsXpcZk7S38OzzDKnowcZdzDwJl2XUNobgV5q
         9E8g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781692129; x=1782296929; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N2jPlRyhxf5Js0wrvZhbEPMffqjEBHr4VMZy0F6mhfY=;
        b=MCJWFcMpc2qMWPFr7IoOBXPif6aG7pmKoDyH4/1VkT95aHiJFU0+i04k3oL2JcDPMk
         rcr+F6gwxDG8nj5/bKcWMiE8T0sJVcIwabn7NRzO0BE3yXrFA8GCy/QVkFhfr1KEdMK6
         Me4tWNDHd2dXUR5B0FSEo/TTP+LYC4o8UYfp119LNqF5Z5Vn87o0p9oj50iyYNTEkMxn
         dFQeqqQ4thDnQf+wluGNCF3AwPSpg4m/Cf6eMUFSYwqVgDnUQ+nUX8/0k7IhYKckqw0Q
         qwUfDgxoTsLb4bctmz50EIdkvRuGL1O+wPz9JukhxF0l6O/Sv5o1pfgAJPXgKGFwTJdM
         QVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692129; x=1782296929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2jPlRyhxf5Js0wrvZhbEPMffqjEBHr4VMZy0F6mhfY=;
        b=Sri+jABbpgouO7wcJsgaoxZmn3VfB73XIF1ZjKpvfdJMgFMCkhYu4GoocJftqIwWxs
         30xLG9zh5Z5QKKewG7j5TsvB/8jYVfXsdJ/udeKoy/OuWVZSyR639KyuqqatmoiBbPlh
         Ny3P2pZWLTKRXVPNN3DuEBtKyas2Yg7t3MBIM/W2VjrKNrYOIsMAlQo0cgI/RI/xp5IX
         up2Uhe8ey0k9rX1HRx16ynqg6q+rAI5ScI/HrXzQfcnoqTb9ZneRRi3gr3oUIiQjCzIr
         7g9fl5m33HKN5YoGRHi2TJz+P/Ko/T24cEdt2k9/xu/Q2bOZPLfagGeYxZPOkRo7ZIMh
         3Hrg==
X-Forwarded-Encrypted: i=1; AFNElJ+PE9POc89K+z+5sxr7MISEADNeEwmTOP3+1qJtuDPNR9W+9nn0VsW4JKlzMY9uN0r1tk8XRMU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKsc2WOQzKAnvGMYiff/jI0NpQJx5U1H760ekoV28qnwxzaV/K
	e/DgeQgjp4JllQhPFaF8qvXpwvTegZCNRjQvhZ+tPVDnHi2AT1xZdOGdxd29uuUMQGb8BXoxTlu
	Bz394JRAVtzG6sGRPJ5axFYrElRtonvmcHhH5j/A4
X-Gm-Gg: Acq92OFhPZ9oi7IAhuq66lO/Tdmj2tlOdokYAUaeS9pHVPkkdkiW35PRB8uGXVAY9Qo
	o6Ma5LAQRlIOtbITYW3eWjGI/mZhU4fmYiW6SdDSkrcWv/+KAH6gfmSUxdBE+BzNx35hRXzg8Tf
	k0NYWSrXEMlp/zVcXjfCLBHRHdfq1OwxUee7CYjR+Ea+q5sPKLGJgthxaRiL7dKKS1QRPoj1QZS
	ZzEysWhW4COKZ6ix/VY3yd8hCg+K2TfX1SmYhnv7oVizk08EwtVpnRWX3nZECjTQ7kig6f9ax2e
	SHmqKzOSMefTBr4WpPmmB1RChkV3ww0dB6mjsQ==
X-Received: by 2002:a05:622a:5884:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-519aa962ed6mr8749471cf.10.1781692128086; Wed, 17 Jun 2026
 03:28:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617095238.1530121-1-vdonnefort@google.com>
In-Reply-To: <20260617095238.1530121-1-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 17 Jun 2026 11:28:11 +0100
X-Gm-Features: AVVi8CcmYvjIYllhBFKEFTxWmmEyw5Kb3hq8FaZ92P7SG3S3_sWI4gBOOlTgKqk
Message-ID: <CA+EHjTz2Hc-mCA4Q0ayw0KV6KJ9_-qN5oPahVqMeKKUs93xtZQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Add missing hyp_enter when trapping sysreg
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Jun 2026 at 10:55, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Add a missing hypervisor event call for hyp_enter on sysreg trapping,
> causing an unbalanced hyp_enter/hyp_exit.
>
> The enum hyp_enter_exit_reason is not ABI, so we can keep the ERET
> reasons at the end for clarity.
>
> Fixes: 696dfec22b8e ("KVM: arm64: Add hyp_enter/hyp_exit events to nVHE/pKVM hyp")
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

One thing that caught my eye (as Sashiko would say: pre-existing, not
introduced here), __hyp_enter_exit_reason_str() relies on positional
correspondence between strs[] and enum hyp_enter_exit_reason, with no
compile-time check. Inserting a new value in the middle of the enum
(as you do here) silently shifts all the strings after it if the table
isn't updated in lockstep.

A BUILD_BUG_ON(ARRAY_SIZE(strs)...) would at least catch size
mismatches; catching ordering bugs is harder without per-entry
initialisers like [HYP_REASON_SYS] = "sys".

Something for a future patch, for now:

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> index 743c49bd878f..5f6e6789d121 100644
> --- a/arch/arm64/include/asm/kvm_hypevents.h
> +++ b/arch/arm64/include/asm/kvm_hypevents.h
> @@ -12,6 +12,7 @@
>  enum hyp_enter_exit_reason {
>         HYP_REASON_SMC,
>         HYP_REASON_HVC,
> +       HYP_REASON_SYS,
>         HYP_REASON_PSCI,
>         HYP_REASON_HOST_ABORT,
>         HYP_REASON_GUEST_EXIT,
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 06db299c37a8..45a4abb9619d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -913,6 +913,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
>                 handle_host_mem_abort(host_ctxt);
>                 break;
>         case ESR_ELx_EC_SYS64:
> +               trace_hyp_enter(host_ctxt, HYP_REASON_SYS);
>                 if (handle_host_mte(esr))
>                         break;
>                 fallthrough;
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index c4b3ee552131..c84434e2349a 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -398,6 +398,7 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
>         static const char strs[][12] = {
>                 "smc",
>                 "hvc",
> +               "sys",
>                 "psci",
>                 "host_abort",
>                 "guest_exit",
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> 2.54.0.1136.gdb2ca164c4-goog
>
