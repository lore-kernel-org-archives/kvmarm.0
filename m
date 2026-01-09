Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAABD363C4B
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974184; cv=pass; b=Wux3q6pO3SyJD0IkgB4C3hnzIJREgI+jgTiEQvQO20+Qj71dw/ypq1hCQMc/KRYg1bHUhJp8RSBxY09ddhNgae9iuuJLIc1M2wL9fe0yT/uJ/QRJ7av7eL2nKd1+NEElfnXymf6A7liAX+bJUZErs6MvQ11bwreYQ5PvENrCwYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974184; c=relaxed/simple;
	bh=RJop5DvCjIWLKeaevl0mMUi6g/p1XvGrRQjivQIYqSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NxbJQNWfAbT4CuPR3TiR0RmkVywSo3TdroudqbMSkfwyRhZ9y8h4ureC5hYFuiEKXWO5DktQ0IzDjE/n/o7RW2OaKPgaASJKRf2EQNLCnYKVhLltoxwS3Tv/0AUE+Q5IW96agREEIMr6quEzCpQJSpnleT1yyp8hfEW3q166Fto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eQDX7mk1; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eQDX7mk1"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4edb8d6e98aso578401cf.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 07:56:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767974182; cv=none;
        d=google.com; s=arc-20240605;
        b=lzTxo5qbF7jyOQWKHrriuOWTXGo56cT0iaekcM8E47QbLOZDIxMdL4CJcg3bnR3xLF
         z5Gwf/H5z9vu+GWXO87rDQNMiE8SCEssGgsw9C/Tse+mIpZbTgzGxCJshwK46+WFImkN
         EUyCKtdJYuKFX+1CShS5D9R5VNt0xAAJLPj7TjvIfKQlxUiscooweOPKjYxqd2ASVOGD
         3gAmqqCPvLWrkLow9kz77Te8ZvIPxXtZhGnDYgRMqtxoWfOV4JBbpkAhk+7Xj0zdJAbM
         hMGy2Vgz7WrmS+NQJUDfO9wuF3BkWY7lFS1PAkBsQAlwWtzOuX8C5eCTEnG9f0oIKi/L
         E/pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b5CL8FxNgdT9nItA6mQg13QZSgYd92jfbMmDmpgGf0w=;
        fh=gS4hqtiNmxazLIGXMNpLqOWUW2pXwa6a+nH49L55EAQ=;
        b=RjaPVmOqdLDFpis+I/YXEovwcgO38SUh/AUBYMGYCCAFz5WPrFJ510aKjxigtbvba8
         tGpzK/SSX+mq+PPbx3+V3m+SweOd4mDozAaPR7OrG4UH1O+UR1ATG/Yqck4G8YVp0o39
         kCiu+aZ7cyX8C9vPKUwH3ibjOVshgW2C46P8Y58zayZoTwjywiTYOaJmhXUEUG/l0CEI
         2+I1lvOPlwBtUc9m4PTOWbz2O0zUTayjlQbiJUqWLjpbC/760qWBFRiSdRPReRwzz2gO
         22qLV2i+RjZh454OOh/tev3TYfJVXX82hylxj9iNis4dys/WGe2LvraUbZBvSaOHRiNJ
         Ty1Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767974182; x=1768578982; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b5CL8FxNgdT9nItA6mQg13QZSgYd92jfbMmDmpgGf0w=;
        b=eQDX7mk1IUJ20gOlc7pTGoU+2ezRDYjUSh+zLGqJai/57AOnW0fkdPYpoQc2aSGpdh
         x3wSOSMwtCBIRkZJfbkCznEp+VC0GeyvKlL48FxlaBEvncKFu44q6uJm9q/9l+JAMSNu
         d7GcVm75KrpWc9nNg8aDp02yOeZ3m3hZW4lbAohLNuaD5+Q0wcWbh5oysXNulYFlA0vb
         AKcdF6hxaiKLiItpXNu42X42BSMQr8TPkqyWLMnquQilpJQrCbYYzMRXCaIU46p7hlFv
         eJbrmaTkYVfyoC6FHVO9xlO5qs7RrXmh9gVkgiPmKytSTBZoZBETB4liwizHKvGvpvho
         nf2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767974182; x=1768578982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5CL8FxNgdT9nItA6mQg13QZSgYd92jfbMmDmpgGf0w=;
        b=N+nDcbCDj3v8/7PmCwxk8gHOvfwu/LbVwXQwnd1Zn0BOcDnPuFhX7Et3anVURt9lGd
         DK0HIiWDtiuNU36Tp9O+hDDOtch7fg20sNdIeDYPzKOP1SoetydCtUJe1dX0mqUhacGS
         bUW6GqGw2Kfqh3I38eTzzcrVX1LWQgvO2msfGnWTexfhv660IxgMJJUmEoSTj6IjLGg4
         uv5HnqKNPTs9/UnzVvW2k23OIGkP+s5qzt/3vVPkfDNr1hZnR1dMa5rsibx33D+swYJ8
         zdrLJxnf6Ufxl+1fvhWDiqxE6g+5DwgEOdCJGHcz991qglKo5fvjvWkuMYbHTnbExUwL
         C3FA==
X-Forwarded-Encrypted: i=1; AJvYcCULEgXYe7hLLlIRL/3l2ZiFt3FnQN+kO1UFNmnLIs047MhoBboN+MIY5ulQ6wMAr2VhSVrLZTk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnbbsfMQepW6H06OGt4iCNUFVTNrihQWCmgnigbiTotwVab9re
	PPDvmkgbi4SF6QTf/xjxGxmfasglKAIMZg9QkHJHtt/LT3hT4xZho1DB8EtsF8isU+yWW3kEa3W
	0TFBlKOr05nnW41CH2XrkrkJI/DlMp6VcbifWBCro
X-Gm-Gg: AY/fxX5qhM7waOvoxwAnklwF9f2GgSt5MpdjPNK8sIXmFWoL/i0YylTnDYlL81u1+Ek
	1Ttg6Ln6QhBvyrqsZC+VPDdmpkvfVKWH77CGvOOBp+dZxrnRkReebEBGLQCWzSCS/K+RqA+Y9pr
	gxYsPcPtjWICZ9f9kihJdQbT8s6YeJiBpMbYbDnihMfdbDGatDyly9dG92X2ZcSf4WWvAMRQY0F
	3s9RfDdj+z3e/BJgs5g8JkxQCF8fenMtEn1CDYs4oF85uDWgVjEqtzD1C8z5NEo4j6KJjwB
X-Received: by 2002:a05:622a:1827:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-4ffcb233993mr10494381cf.17.1767974181223; Fri, 09 Jan 2026
 07:56:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-12-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-12-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 15:55:44 +0000
X-Gm-Features: AZwV_QjYKCnQMH_dJFXuijQwcG8RABb6JnH52RR1LbUrpQK_8_OFYA5NFixm6a4
Message-ID: <CA+EHjTy95BPnZzZcrR8eOekTm9Cv41D_BCkH1puWtDG3JO6yTQ@mail.gmail.com>
Subject: Re: [PATCH v9 12/30] KVM: arm64: Rename sve_state_reg_region
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

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> As for SVE we will need to pull parts of dynamically sized registers out of
> a block of memory for SME so we will use a similar code pattern for this.
> Rename the current struct sve_state_reg_region in preparation for this.
>
> No functional change.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d15aa2da1891..8c3405b5d7b1 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -404,9 +404,9 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   */
>  #define vcpu_sve_slices(vcpu) 1
>
> -/* Bounds of a single SVE register slice within vcpu->arch.sve_state */
> -struct sve_state_reg_region {
> -       unsigned int koffset;   /* offset into sve_state in kernel memory */
> +/* Bounds of a single register slice within vcpu->arch.s[mv]e_state */

nit: I'm not sure that the space saving of s[mv]e_state is worth the
added difficulty or reading compared with writing sve_state/sme_state

That said:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> +struct vec_state_reg_region {
> +       unsigned int koffset;   /* offset into s[mv]e_state in kernel memory */
>         unsigned int klen;      /* length in kernel memory */
>         unsigned int upad;      /* extra trailing padding in user memory */
>  };
> @@ -415,7 +415,7 @@ struct sve_state_reg_region {
>   * Validate SVE register ID and get sanitised bounds for user/kernel SVE
>   * register copy
>   */
> -static int sve_reg_to_region(struct sve_state_reg_region *region,
> +static int sve_reg_to_region(struct vec_state_reg_region *region,
>                              struct kvm_vcpu *vcpu,
>                              const struct kvm_one_reg *reg)
>  {
> @@ -485,7 +485,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
>  static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>         int ret;
> -       struct sve_state_reg_region region;
> +       struct vec_state_reg_region region;
>         char __user *uptr = (char __user *)reg->addr;
>
>         /* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
> @@ -511,7 +511,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>         int ret;
> -       struct sve_state_reg_region region;
> +       struct vec_state_reg_region region;
>         const char __user *uptr = (const char __user *)reg->addr;
>
>         /* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
>
> --
> 2.47.3
>
