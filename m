Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1D427FB3E
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765806205; cv=pass; b=UdTPJyoETi78xDPZDbbiVadgfmh7BAIAZA5mb5/EEsrk/i+VM/oVrLFOhNbNhmefWPjPj7/KkP1bdQPaIeyrfIgyF5mTkSLPpKFxLpRhD6dv0qNzvL5dow4AXxdFiBA56D0myl55pewPYjejn5ZEQp9WF0zo+YBgXz91gQPVJs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765806205; c=relaxed/simple;
	bh=nsbFlHT7t91E43W7U8+Fsp77nyGuhWQL8pPq90Wth28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ghSathkD5qVq3SVGnd62KBB9D0LBiPCOSLSLPB2347sPxDUMqbk3Y5b3jSFLq2gqYumF0mqNdU+y+bfUX68vnLVBbcINQOR5yJYFUwNl4bH+C1pujDJTdr1Fiu9dEA1yLZ/Q8DumCNZCz4uSxLjzVLT122Raz5O3KAzRzYxR9Yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6SN+Txg; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6SN+Txg"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4edb8d6e98aso2574691cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 05:43:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765806202; cv=none;
        d=google.com; s=arc-20240605;
        b=ccslI/30y4qBj9ulFbazIAFyaFnojzipxIU6XaGu3PnNde1XtOMEAXKMXAqxzG75rJ
         rf0cmIUD6eFygEKrhyAwgXLUTGbGeNpbbcn+jIaj0LOtoU8uqp/SojDWA/rRmunPa9YL
         ZSS7fqibnIdiFg2zYMljC36DvuYPK4BCmm0DA3iBBwkuhaw0ALP1MxHKdEzgfd2UJJoT
         zgwS350ugsBEhb2JDl1RVrDwcnIt8+BVXxflPJyrWjAsmCaxf6xsquu0bQE8moKhH9JE
         bi1SoTIdIiPt6GSI9ScG3zglAzCWfJkaZwAIxiLg/XG0rRZybHR9hCs9y5dg6QiJPniI
         lkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zf3hSW2fHb+vZcqGeYrEECUOHTRoafS8R6kEtlKr8/I=;
        fh=clQBGQ3wfkgbXCNKKIDswnBTBjQw7wtFELtk881WE7w=;
        b=fHqNn9YiANtwRt5hko2HCzXZ43wUmDkVLt0r/6eci2jlqeLKq7pTTPOTNEARHxAf/0
         kJozmoGJAHQXN7vZ+Ovwww85uoOi0MPyWKuht+BnCz04hM1AdOERKWQ3N0Voz0T4h0eh
         0TrmFk+CXPomIGBt+9yCVolS+KaMWAKy7QNL34OiRehTC1GGPgdLVjeLTwsflO5GALo7
         PQw/zQKcUYWpiikUoa9tMRkMTt7YsmZW0+UMdjBFhI0VaDyzSY5RhxqIQuZZsfEa/H3y
         JmRIyNQY+nVYlf75UYgGgQTj5mISBEjAY9zvYo6kgcaDcrO9NYL+Hv4XLLuGbvT6q2ar
         0vHA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765806202; x=1766411002; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zf3hSW2fHb+vZcqGeYrEECUOHTRoafS8R6kEtlKr8/I=;
        b=r6SN+TxgF9HDwyTL6n0YxTk8K7+hxsi9ZzeJOrB3DYdvYIAKHPpU7Q3REkIwMiw3l7
         5v0rOoKKZO7/g4Q1yJTvPuosdP78E3KEqr6JtY6GDBeoj7tvFPxvj237GOKu9SjsKJET
         Kpku8n40fko1YT/4oFpImd718YfSZtZdhfB5b4RdRwP5dD/K56gMg0T2BOs9qLxsvufE
         ACS2L8OmZMTfGZEDZippllwcMnHSOD8+B56omOXWQzYE4I/28bH8KxvR/Z8+R8ErTOul
         SthZwF3xIttG1T6adGpEMTYBJ4Ct1xWtaejZF3fbSN8EXlLAIyKv6RI1+yuTT/BZP6mZ
         +7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765806202; x=1766411002;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zf3hSW2fHb+vZcqGeYrEECUOHTRoafS8R6kEtlKr8/I=;
        b=BQlDtoU0TRYFi/jOPY7Xy+63Lj3fUKwvdmCpQaYBaduEHdMkDX9Lcc+CGcP5DStL7o
         LOdp2mB1oU+A3/UkaLe5q0yr7zvNLEnvnCAfF6HQwvllz8mis2Zq0SkHtXRh5NX7Eka9
         A/NmTWvxB+MIcm8ssg9T9LggPxXHDciutBTrXxtbBe8nWykD4RjX4QgiRTYNXbIQ896x
         nZjtCjF0TDlBIAW4788t1mDLSmTpTYpQNm0fTW7DDJjZn3KB5KyDmayKnOO2NRupmMHY
         HksHoXOzLGb2puzjAxjPuoeaoFKFHw2vSo97M1c/8jwGGO+iXgtUltgD1YqdAyaz4xmh
         pHgA==
X-Forwarded-Encrypted: i=1; AJvYcCWS9xTkqlDVd4kgMe9DqLe4ESckydXPAh7nObQSnHkir+jRSl0WP7W1KfClPJ3ja/80GA0h1mg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLSCVY7BFO+rzclYrqHWFo2JCNEvKhcQBaubeZ/X9YfV0z7T0h
	nmQarHF4rDLnT57HtUVO13xZrJb/vaBlPUnpZY7JbquqkNpUxUJWTsnDm3uzAkEB5YNrxFqDR9o
	NjmsTrMc97vptjUkdaLfcM+fQRKRcGmsIjnbEgKfs
X-Gm-Gg: AY/fxX5S8lMq4+87D/86RQ/MnD2qsbCoy4/k+kkZTfN4x9mQOw2chdNoId8LUUCE+ty
	jF9ZbszbQIWKn1R7LW6KigF7G3JbMA/GxBEnZDSSpsqQbbN+7yVsgdgOlrMwhNKCtoEuUom24GH
	BcfUBvNrDfppqFTocbDigR2ijDC92G5Ql3OZlFbMumkryXrKIB6p4xnpZR0rhpQxaB0O495aOcY
	0O5UGQeTtuQVeKb+Bj91l7AzwUQhWPZXjvyIY9adxXs7EaQkDaXaC0vER98176pvwnwgnDi
X-Google-Smtp-Source: AGHT+IFzDElWJwyr6+nuwAlH/P9H4uymOrx5buaTQt2l+b4Jh2LO43obqrs0YFrGsbjpoetfJAAeMF7Kmpc6x+crfXk=
X-Received: by 2002:a05:622a:1313:b0:4ed:b665:3779 with SMTP id
 d75a77b69052e-4f1dd58a1d2mr20890381cf.16.1765806201435; Mon, 15 Dec 2025
 05:43:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215114409.212512-1-alexandru.elisei@arm.com> <20251215114409.212512-5-alexandru.elisei@arm.com>
In-Reply-To: <20251215114409.212512-5-alexandru.elisei@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Dec 2025 13:42:44 +0000
X-Gm-Features: AQt7F2q1x7ATNnNzIPh308Tfm8dpOMHBrZ2T4CqyYv5-2vMJtxpKgN6HpQ3ZEqw
Message-ID: <CA+EHjTyCTetJ+ieRNFG9QN6gQT_4b+G29i-w9AB745w4EtrwMA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Dec 2025 at 11:44, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> synchronize_vcpu_pstate() doesn't make use of the reference to exit_code,
> remove the parameter.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index c5d5e5b86eaf..afecbdd3c1e9 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -854,7 +854,7 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code,
>         return false;
>  }
>
> -static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu)
>  {
>         /*
>          * Check for the conditions of Cortex-A510's #2077057. When these occur
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index d3b9ec8a7c28..779089e42681 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -211,7 +211,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>         const exit_handler_fn *handlers = kvm_get_exit_handler_array(vcpu);
>
> -       synchronize_vcpu_pstate(vcpu, exit_code);
> +       synchronize_vcpu_pstate(vcpu);
>
>         /*
>          * Some guests (e.g., protected VMs) are not be allowed to run in
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9984c492305a..9db3f11a4754 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -536,7 +536,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>
>  static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> -       synchronize_vcpu_pstate(vcpu, exit_code);
> +       synchronize_vcpu_pstate(vcpu);
>
>         /*
>          * If we were in HYP context on entry, adjust the PSTATE view
> --
> 2.52.0
>
