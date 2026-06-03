Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366044A718
	for <kvmarm@lists.linux.dev>; Wed,  3 Jun 2026 11:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780485771; cv=pass; b=pNvBD5CPzxWk1Z6ffAn4HE9Lrx9oE8kTlVde4pjlXK8PH9DLXJkoH9YLMwDz0JnIn33CxnJjqTlLbEvvPtdYs2DGMrNOuierjmcsg8pkM8CMg1jW11kuR5REOB7L3DYcEEltPoEOBPAmTTcggoFER69nJJFNFeZiz5c/Oxf3QA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780485771; c=relaxed/simple;
	bh=6i9ll1CJ8XVSAX7aMTO4bnOtHG3uInw9l6OWATwgeIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IHhyaCaUqU43b9jRocvqNjg1gQrtm3ZO1yganMc3fMAaHOJaqEgMjRKoDMth51CxLwY4KxAnVYte92IHqKz0JjVj7UKOvcqQjUKN0fWkVa4BpvH1IwYt073uCH7c3eqkEkOcu7fmeXp0+t7aAiiJWy5jUFs3+MDb4YIySE/1nFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IODcqFOX; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IODcqFOX"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177d1ff061so290351cf.1
        for <kvmarm@lists.linux.dev>; Wed, 03 Jun 2026 04:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780485769; cv=none;
        d=google.com; s=arc-20240605;
        b=d381QzfFoZdYDjVtHqJOPcMnF5yixhK3k2HxB/5dTPSY/2gXyETqqPX3LKX9oqByi1
         WwKOKGkvBSrS6LU4Z1CZmjx4t+O274LCOS/QdBsAb9/3cZNNUze/4/7m7m4oCGTsz2AP
         o5/+cQjspp/tkjNUvdxOODXvzszx0CmMwIScAWbUTgePSPQBOo2WTi16kcjqa0VGq3o7
         zWkBFA0VQdu0iNwimULiJZXWqbBAHzSurfNX4nQPccyywiRMsNwh/uKJGVZ+eQCOngNv
         KVN42L+xabODuc1K4U0MC5GI7Naq7T5kUTh8tT5hZmpwvjM4+ufcgc9wYynI/TZav66W
         TL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6OeStcwvul6xuBmfHmqioB3II/ujcPrLl80+h0LOYME=;
        fh=9349ZnJZWd8bGGTwf/FDmHN0lCJzZkRIzzPlxw/NmRI=;
        b=UvU9MIwEPAueL5OomnTJXOXzljON9OUWftpv/q1hPqvb1Sg4GbB4y9tYy+LkBMHfdm
         o1fL3cvjwoF2wt72ycTLsA7VdHByAn5DhRKiJY6Yeg0AQVTgJp2IP4h7BBqjpro0dhMK
         V4bEmuSZwCvWbz5dJJHwElp6Q5kZg2DzmC6gGETvbkdLwmM4Uq36xPTuKVMePiprPsiK
         Ehj8wMzZ9KewlGN7HgVwrom5TApbd527sXuVL7O5Hkchm0b6TkFRVp6LOIgzwBT7KW+n
         plnlaywqHx/2r1QvtgKTLhpBHpVpl02Qo1aWX0TM9W6Dq3oLT7IjUybLQJma+iq9Rynh
         X8lQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780485769; x=1781090569; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6OeStcwvul6xuBmfHmqioB3II/ujcPrLl80+h0LOYME=;
        b=IODcqFOX6oWzHTM9EQjFpJVAZbblxnoLaZHI91qZjHqy8dRPPDcLMn84M52l0fcUer
         O05jtWaZMlQjLfWbtePlFPbqestX6TquxDwsUziJ5NGoRSpBVXDQcjOxKAdhU3T6rOLf
         v2wNHWZFDi3ryfwQX2PqNBkXQp+vfEwZhmZmWSwiDBh3BOGpfz8iH2BbKs5TIf3p/Kfu
         NQcBzFZIPLRN0nNG9dCoUcbmIbz5YuDpqEC/uSJJVsc4DO2BynXJ9wfjqlGV9eqj6aOJ
         FZ6BexnIh9dNU3tj9VTiMNwvBdSdlOAWfEn9D/5dIn5t1l6mWM+STaY7YtJxwvSMmraJ
         7GoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780485769; x=1781090569;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OeStcwvul6xuBmfHmqioB3II/ujcPrLl80+h0LOYME=;
        b=T4LE25NpDOd/meMfaMnxO0wAKBs2i5X/Obxhcs/fHeoRfQH8kYIkJQQNIuGbkpIxA1
         Y9uF1OXTB8OSpYLjGUcORjX/tfCUFitP8Hy/0R5p4BlgXFbhk72CY0C/Z1qtVv0D6Wul
         Bnfevsu7u9iJcOqMGTV5Q1JEeLWs0bM06xg0+WWBp+HwTsIg0Svd1aWW6toqAEqSBGu/
         1KAj8NGsUzki0acATHJ7R+O0t/wW8RPU08jZN92UMtizrAYzdAX7YCLGt6XHEO6ReGP0
         xXsxtnsDOq2aUyADbkcK7+mIaVNvJ6OxsovLWB1LaEthgWwUKYZtLlaeDH9HArPKBYUI
         9EUg==
X-Forwarded-Encrypted: i=1; AFNElJ9S7zKBDHftZbYNCIoCnpXSvIWxDpTVavgVNgdTJRRrhg+Re3aRP3mmkKtuyqEWj50R3pj37Ps=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSRLReeyZttqlkzxrcFJT2zB/PxxoNGT9h1d3Yn7JTu+YKK5UO
	PyGsD+5PQUbgFQFsGbvkTN2kp+Nu4BGSGZatWZ47k24EdYrL8PStnb/gwYCOUqiwL8wlCD6K+/k
	hdGulOPvkY6d3TkihMOCoV1IC/GLhD0pVlIT3gyo3
X-Gm-Gg: Acq92OGM6JV4BexkNSqQuQ6g+0Et4d1KisxB+t0kWXyJogZhpP0hZf1ZalzTo6lQ0yQ
	5ujt/4NQMZ9bc8PllXayjeuWarwj2KrWJ8zRXgFOW+wHk6fWLz+uv9o7Dw4Z6nYhTg8UYf3tzFX
	8jnO+VchKKbpb3t/gzOtgaSXbMKGdWbqroUjmxB0ZEoY5bJ7NSX8YhVEv6qIDWd618ADBZAeCAG
	CYKBU2WyLVd9IdbAaZeaTXbhyga4C5k8nKMXtc3M4tkLrx95725a1A2RxSTDV7J/t4tBoiVsPU1
	9obfRWBrl1cPeYnjHiMuVaiCgtqFpxrTtpnkuhsk6E6LotNY7AnhVSXRAA==
X-Received: by 2002:ac8:580e:0:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-5177bacf8bemr7041881cf.12.1780485768086; Wed, 03 Jun 2026
 04:22:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260603110312.2909844-1-vdonnefort@google.com>
In-Reply-To: <20260603110312.2909844-1-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 3 Jun 2026 12:22:11 +0100
X-Gm-Features: AVHnY4KI9ky2nK9uhZkT2wqO6-ArzdUSiw-eQWvqiODT58oZSiJAb0P_fIrw1BA
Message-ID: <CA+EHjTwFZGNi=WqE_=mD4nifowHidxyNVuho1XiuU7msMe8MFg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Set a linux errno on SMCCC error in kvm_call_hyp_nvhe()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Wed, 3 Jun 2026 at 12:03, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> If the HVC called in kvm_call_hyp_nvhe() fails with an SMCCC error code,
> we WARN. However, the returned value isn't initialized and the caller
> might get garbage or 0 which is likely to be interpreted as success.
>
> Set a default -EPERM error value, ensuring all callers get the message
> when SMCCC calls fail.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> ---
>
> I have encountered this issue while working on a follow-up contribution to the
> hypervisor tracing. In that case it completely crashed the kernel because
> IS_ERR() failed on that res.a1 value.
>
> Now, if it makes that function more robust, I do not believe it is fixing any
> existing bug which is why I haven't added a "Fixes:" tag.
>
> In case we want to stick one, here it is:
>
> Fixes: 054698316d87 ("KVM: arm64: nVHE: Migrate hyp interface to SMCCC")

You are fixing a real bug, even if it's latent; I think you should include it.

>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a49042bfa801..6b8fd494792c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1273,13 +1273,14 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  #define vcpu_has_run_once(vcpu)        (!!READ_ONCE((vcpu)->pid))
>
>  #ifndef __KVM_NVHE_HYPERVISOR__
> -#define kvm_call_hyp_nvhe(f, ...)                                              \
> +#define kvm_call_hyp_nvhe(f, ...)                                      \

nit: This realignment would muddle a git blame on this. Prefer you drop it.

Otherwise,

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>         ({                                                              \
>                 struct arm_smccc_res res;                               \
>                                                                         \
>                 arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),               \
>                                   ##__VA_ARGS__, &res);                 \
> -               WARN_ON(res.a0 != SMCCC_RET_SUCCESS);                   \
> +               if (WARN_ON(res.a0 != SMCCC_RET_SUCCESS))               \
> +                       res.a1 = -EPERM;                                \
>                                                                         \
>                 res.a1;                                                 \
>         })
>
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
> --
> 2.54.0.1032.g2f8565e1d1-goog
>
