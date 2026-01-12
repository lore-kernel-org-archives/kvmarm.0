Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C9A36D50D
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768240799; cv=pass; b=m4mJNopNnOqLx/2qBCTQxFgUpTBjWqiwPYHb2dRD/U2XrcLu0MulynQgFAvJvkXmeXpRyZ1cGHT+ApGcK3cylHXM9DXmo2ihN2gRqP2oMJ8KZj7r2D/4p4+kuuKX3iDCWvtG/LK/WU2ajsLMzyNhHMGIw7YX9/A5sjDO6yp1XWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768240799; c=relaxed/simple;
	bh=W2KRaBZYvG8HVg3eIWgL8kg0vNUppturNmvWPxflHbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ioQSJtmWmp3W+Ism7GmIf3X7r9fJi7FA+b6Z0aZl2W/Pafx2jaQMCj1NQl352pqUwypORI50a4UOnHPdS/ND1DQ653GeUWqDxkOt54H5HtI7CO4mHGEWwYMXNU2JI089l9qs+SDkwvdBVqCNiMzZ6hNOU33sJ4702qvOlDaFVSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=14VrtpBG; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="14VrtpBG"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee147baf7bso101cf.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 09:59:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768240796; cv=none;
        d=google.com; s=arc-20240605;
        b=EZrZIax7FkIKZVGk/mI2DtB/ZCDG8QT/5mq87ulP+TbovnTqgKkpTDmnwbtSrVOe6B
         VecZHfTGzrAk0OuEuooLqBk0LVXoNWNQ7IeOGs8xUmybI7ROXjdfCahBlwzIFQwpwkc4
         VWA7ev27T7jfltvNJrDGSkbSqDnqHdm/w6auiSKB0FhnA4sPYpmAOd25yee/wdQ/PMQt
         QGXfzJgE0i7B+cfrnlfdemFYoZa53bVV2ue2yWEVyAXfK2ce7V76gQTBqASJHVis7o1H
         sxhL6NLUYornsL/55pZKSK5FMXErnxUI2wZDIj2JwqhU18JbeZjKU8Aumf7pDEBIgDSh
         JRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bJjpEAphM/NB+/t61DhxYCEIiQ3uh5viKOO+at6PH6g=;
        fh=7nDkinjk4PcwhtMIoZIw9mqAzt9siRxcl0V+LIg9Qbo=;
        b=dBZ0IpRpjphwuH5sDFUFFeoQckPuEIUilOjaGVd6RyBI9xdjeFByFtT3zSavm5yUiV
         pUchhpPJYjhm93yoNjh4lROB2BT941LH4tDQoLXNg+mU5ZhpgO0AzGmau62JQ5OprhZ3
         bx3J4XUlegi5QahCOmSmzetr7xFmfTuTrC+OodNd81vvD0iGTTe9YC2xhbntOG+Q5nA/
         91Bf1Bj9/KBMOuXlarNjo0T5rkmAU/J/s5S8yNMOgYdv5Z8iu65ODRSEKX8xysrebNn0
         7aGooy9vzuAu5+UQplUvKAuL1Q0RRSvzahxrvU4ZQvW+fOGjanLayjRKUpiRXBKmJEaV
         FyGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768240796; x=1768845596; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bJjpEAphM/NB+/t61DhxYCEIiQ3uh5viKOO+at6PH6g=;
        b=14VrtpBGdZwqlCemEmhX9rW7ZCHKTp+i3eUXxYN9yBBfeQXFsJwkRMdaXwMnRsYWAf
         UMUv/t1e7rmfCio/2fq1EP9G7ChbWTDO1E9TqC7Vby4gBCVBNsMGKJIV7FgMaKX7O56l
         d5Ad3suayCTG/Vy37vUbAK2NyKmFokI0rdNMa4J6rYni63TnFs8pQLlVowg4maUgQaNk
         0MWEVG4kUZ+2zsL/VbH+NkKtlLFuVYNUsPScLr85OeQJ7BlHVrtBLiTnq0Pz4PQBYVCV
         wtVbfNiMhiwX+12sjoxQGLIWXtpC4yaulIWvCoO+8CRae1tBA0bYT1nXSnH7upHY+7Ym
         Rm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768240796; x=1768845596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJjpEAphM/NB+/t61DhxYCEIiQ3uh5viKOO+at6PH6g=;
        b=jblk6Mm1fHpxo/2S8ItmUXWaifVs8+7Hb9CdTlKDdg8THC0pum74umMmyURhN4sMMK
         2VkUvoXfA9NuKimdd1o2IihRDp0hdOqBTATaGRJ46rn/AWN8jYq8LcHNtD/GhwJIlP3n
         2ubykTiIZ9tkbr/MpssIfjV5O6oHYVTZEdriI7T6oE3s3Nql4OKg8Gh5JXstdwG9bMNl
         l+KObYQzNF6BPXx9YPZBalo9p25J50xhNHK0Bq8o3/eFO9pXlf8WyCrjsNIt1Xo7jchn
         9yugMj62qwMHkGpLFaqrYv+mFIdrZlETUJoW9J2lYmOmyFX/pWjjkVxSRBxLX5kXtjYe
         KFsw==
X-Forwarded-Encrypted: i=1; AJvYcCUU3xFu90DEBCvBFlmlogUgY/go7HgTT/FLXFrHGnx5uR0ClsopYKc38X8xdpZZ6VEBOeX+CGs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk207VQ9aRk+TcxDL+0kQAypF2PwjH+aK2ezUh11SxKdRkxVCk
	gC33HuLYSI9uGLGlpbKAB51VirAKi//qWn7qJ2Yn4DHmG1P1LxdY7nXOdrjtnSMENolX5LdxdKp
	Z48Uof5CQomm3h2rkQW9dPDr9FqZ6I4B+seQFZHvd
X-Gm-Gg: AY/fxX4VzikpdaD7Iy3Lcm4sQgWGjTckY8+LS4Rb7XHRgAi+Iuoe3eJ2GBM7l0wvhSS
	Eg6Fi/wnOOmX7QnpTJzy7/3qpbUtqSg8ruobs9Qxvmoa4og5Z3ZR9KoQ06yNXhGzK96topLVBRz
	Dpn2OkUq2AQNJwEr+KojR4KZbssMQ6MCBglz8Fm7b/FLedKYgERnfssH6+qt7JqepyI2fyC6UeF
	egtmAQMeXl62SJTK0eazSclOJtt9oEEp6jJlsPWsrgTZjq6plUkjei6EgCbGX66aD+EFFB/
X-Received: by 2002:ac8:7dc5:0:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-50119766a66mr21632291cf.9.1768240795172; Mon, 12 Jan 2026
 09:59:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-19-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-19-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 17:59:17 +0000
X-Gm-Features: AZwV_QiQU0Otl0OZ50pDvqjq5GLQexN4JJXUaeH6JoNDjhaymp7I-l_cuFsktUI
Message-ID: <CA+EHjTwQ4fLBE1YXoB6M0eamSgGDW=nfLaC+-_surBfVbh3byQ@mail.gmail.com>
Subject: Re: [PATCH v9 19/30] KVM: arm64: Provide assembly for SME register access
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> Provide versions of the SME state save and restore functions for the
> hypervisor to allow it to restore ZA and ZT for guests.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  3 +++
>  arch/arm64/kvm/hyp/fpsimd.S      | 26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 0317790dd3b7..1cef9991d238 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -116,6 +116,9 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>  void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
>  void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
> +int __sve_get_vl(void);
> +void __sme_save_state(void const *state, bool restore_zt);
> +void __sme_restore_state(void const *state, bool restore_zt);

Would it be a good idea to pass the VL to these functions. Currently,
they assume that the hardware's current VL matches the buffer's
intended layout. But if there is a mismatch between the guest's VL and
the current one, this could be difficult to debug. Passing the VL and
checking it against _sme_rdsvl would be an inexpensive way to avoid
these.

>
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index 6e16cbfc5df2..44a1b0a483da 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -29,3 +29,29 @@ SYM_FUNC_START(__sve_save_state)
>         sve_save 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_save_state)
> +
> +SYM_FUNC_START(__sve_get_vl)
> +       _sve_rdvl       0, 1
> +       ret
> +SYM_FUNC_END(__sve_get_vl)

Since this is just one instruction, would it be better to implement it
as an inline assembly in the header file rather than a full
SYM_FUNC_START, to reduce the overhead?

> +
> +SYM_FUNC_START(__sme_save_state)

I think that this needs an isb(). We need to ensure that SMCR updates
are visible here. Looking ahead to where you introduce
__hyp_sme_save_guest(), that doesn't have a barrier after updating
SMCR. The alternative is to call the barrier where it's needed, but
make sure that this is well documented.

> +       _sme_rdsvl      2, 1            // x2 = VL/8
> +       sme_save_za 0, x2, 12           // Leaves x0 pointing to the end of ZA
> +
> +       cbz     x1, 1f
> +       _str_zt 0
> +1:
> +       ret
> +SYM_FUNC_END(__sme_save_state)
> +
> +SYM_FUNC_START(__sme_restore_state)

Same as above.

Cheers,
/fuad







> +       _sme_rdsvl      2, 1            // x2 = VL/8
> +       sme_load_za     0, x2, 12       // Leaves x0 pointing to end of ZA
> +
> +       cbz     x1, 1f
> +       _ldr_zt 0
> +
> +1:
> +       ret
> +SYM_FUNC_END(__sme_restore_state)
>
> --
> 2.47.3
>
