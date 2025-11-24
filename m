Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750BE314A78
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 15:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763999301; cv=none; b=sqBVPrSjtZDa44LphQSvVZ6sYWrdH4gMEjMPGV90lyf6OdWsHBni23YLpJbQoZlv1UtkblIv58Oj3dIJS5qj9DzR/VwUQ3UF/yT+xO/31Siobs1CNeOv5e5gTzj/pm4OAYkvytDsuCoKsH0Ri6AX1GOudbe78TY2tjkRpwklcm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763999301; c=relaxed/simple;
	bh=k18PGx7b9UQSd+RHbvmvjkc795gJID3d8ne1906zMdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HRDsmv0qOy/+LuD3opdl78vY8FW2YvyhNIuaApKmN9+7Kh7mtfb14keMAw3KGGrLZEPdhh/TMUGD7pQpfaiM7xRZ+mJuD6pAk5TqnRK+BD4QfYYJzLVfZ/ZvXZoXBgb1a0N9ddAKFcZkinMtBZibIVBgxWcUHjXHVCs6uwxpcQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eMc27OFB; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eMc27OFB"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78a6c7ac38fso47305357b3.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 07:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763999298; x=1764604098; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dhe14QqCiQiiyB/p8iyIjb6+UGtDhSJERPBSMqZWZ34=;
        b=eMc27OFBzDqrTZ2xYlw4tEq1V+CC+Ty2YAW+R84NeB9SRJh/mani4HZsTTqaMIjVmx
         K3/VHuwgjDG6gaRLf3boFlBzmG4FBpLQb3b3BvNjJHMAXukG5EP6CIAB7xJxjelTECsZ
         A4u9txxmQs3zJYsfEznzvSqF1DoLjP6ddR6pYHL0AqWjVOXNfkebYTyH0oH1Le8hYLMe
         d+6SPtl5jFpI/SVPgrUI9b2lStc7siXA0fJQg60cXie4a4q1itVM5REIx9T1fKyjPZrT
         LCOctIVZYJqhtraXiVnD24f4JiiR/vhxWhBJTV19OuSGA7AgmiJ/pWZ8aZybwiJq94v9
         EfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763999298; x=1764604098;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dhe14QqCiQiiyB/p8iyIjb6+UGtDhSJERPBSMqZWZ34=;
        b=gm7JK/FnPPLmsP6uW8zW6P3P9qfLyqLQCYmdjYuCSuR/YkfbyuaSrl3Ygle168pvwX
         wsKw5rbZcaJimz0nDYpjh98qLHd1HvPWn8oiYgXFx6jimKHdpmhq9V0GXEWDvyy6Mffw
         qqlVTKcOUvxBXEp3xtpUM0HdfUhVU5VWMiVuqpsbmvmLTBb/cM2Ekw4bYxFIadzxUu0+
         aQKJ6Xey3bL4t2jud5G9koh1rwamjRZyO5foSMSrM8EWzQKqZntyPgWEfE/uIvz4y/Rv
         NT8JV1aP8YFYtyxSjxvHIRBNSaLUFWTCmsnVjEkHFTJadTI5idnbzO5GYUhuC1cyxS+O
         DmYA==
X-Forwarded-Encrypted: i=1; AJvYcCWObX5qRRh3uQGpDmlWWA6gNIAmpvBhBj0GnmR8tARwIbihwn4w/DQvFLMhg6q0sT6l/uYcPOk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3MIXoelCcSAaj12ouOzE9Kyj0eOn7w8slbQ8CjCxBXaEfHp1x
	zuLjoD2a+BOk/WCOQ28/yOcPbzmkxQRwP1XDxo2MR9Afo/oynjMT1vKcFa6i8CcrNLcZcVIcMT9
	LdDaBLVaUIZJxx+B3kPRPAPpZA2CbVc2lawPDJNUB2Q==
X-Gm-Gg: ASbGncsKYPUXMZE5Bzl+DbgNZpcz91SpxxvYywpmc4ExXbCOYlxdaADs8JojYV12n+2
	GPDK2n4VlxF34MFB83/lAETs3yjJRtycxAI1bZUbFG43mcFJea4Mmpl9Svb4mQ0D0cJKk3rv3Un
	VfX2ydPMSC7vH1zAclV4wcnjthALHBH3Ruyw/NYE3oinXcEQUShL/lkAlKtZxONJpuQ7tcJMUpC
	8KY175CX3lx+N7AgtDMGuyFUbwiIWM+eE4/58B+qTinMfTJ3s9Afz2Adhpj170eybo3Ir6WhXgJ
	mEISJmg=
X-Google-Smtp-Source: AGHT+IFXLeEni9mHEbFQTU/eUct/W0PzmxnSk74uTOG+KIQijx0uZ3p8CfFH9qpt1kJGYDocY45XWQwqsmbH09VD3mM=
X-Received: by 2002:a05:690e:18d:b0:63c:f5a7:40f with SMTP id
 956f58d0204a3-64302acb21dmr6404480d50.67.1763999298028; Mon, 24 Nov 2025
 07:48:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902-kvm-arm64-sme-v8-0-2cb2199c656c@kernel.org> <20250902-kvm-arm64-sme-v8-11-2cb2199c656c@kernel.org>
In-Reply-To: <20250902-kvm-arm64-sme-v8-11-2cb2199c656c@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 24 Nov 2025 15:48:06 +0000
X-Gm-Features: AWmQ_blKJPr9UiZ03PNJYKVppsgjz7HVl46QteqBVXyuwWp-raNgrqIbXILR-YA
Message-ID: <CAFEAcA_GJ7gzn7aMCZYxHnJWvx4tHSHBKsOxtQ7NTb4gPjkMJQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/29] KVM: arm64: Document the KVM ABI for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Sept 2025 at 12:45, Mark Brown <broonie@kernel.org> wrote:
>
> SME, the Scalable Matrix Extension, is an arm64 extension which adds
> support for matrix operations, with core concepts patterned after SVE.

Hi; apologies for not having got round to looking at this earlier.

I haven't actually tried writing any code that uses this proposed
ABI, but mostly it looks OK to me. I have a few nits below, but
my main concern is the bits of text that say (or seem to say --
maybe I'm misinterpreting them) that various parts of how userspace
accesses the guest state (e.g. the fp regs) depend on the current
state of the vcpu, rather than being only a function of how the
vcpu was configured. That seems to me like it's unnecessarily awkward.
(More detail below.)

> If SME is enabled for a guest without SVE then the FPSIMD Vn registers
> must be accessed via the low 128 bits of the SVE Zn registers as is the
> case when SVE is enabled. This is not ideal but allows access to SVCR and
> the registers in any order without duplication or ambiguity about which
> values should take effect. This may be an issue for VMMs that are
> unaware of SME on systems that implement it without SVE if they let SME
> be enabled, the lack of access to Vn may surprise them, but it seems
> like an unusual implementation choice.
>
> For SME unware VMMs on systems with both SVE and SME support the SVE
> registers may be larger than expected, this should be less disruptive
> than on a system without SVE as they will simply ignore the high bits of
> the registers.

I think that since enabling SME is something the VMM has to actively
do, it isn't a big deal that they also need to do something in the
fp or sve register access codepaths to handle SME. You can't get
SME by surprise (same as you can't get SVE by surprise).

> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  Documentation/virt/kvm/api.rst | 115 +++++++++++++++++++++++++++++------------
>  1 file changed, 81 insertions(+), 34 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6aa40ee05a4a..94a22407a1d4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -406,7 +406,7 @@ Errors:
>               instructions from device memory (arm64)
>    ENOSYS     data abort outside memslots with no syndrome info and
>               KVM_CAP_ARM_NISV_TO_USER not enabled (arm64)
> -  EPERM      SVE feature set but not finalized (arm64)
> +  EPERM      SVE or SME feature set but not finalized (arm64)
>    =======    ==============================================================
>
>  This ioctl is used to run a guest virtual cpu.  While there are no
> @@ -2601,11 +2601,11 @@ Specifically:
>  ======================= ========= ===== =======================================
>
>  .. [1] These encodings are not accepted for SVE-enabled vcpus.  See
> -       :ref:`KVM_ARM_VCPU_INIT`.
> +       :ref:`KVM_ARM_VCPU_INIT`.  They are also not accepted when SME is
> +       enabled without SVE and the vcpu is in streaming mode.

Does this mean that on an SME-no-SVE VM the VMM needs to know
if the vcpu is currently in streaming mode or not to determine
whether to read the FP registers as fp_regs or sve regs? That
seems unpleasant -- I was expecting this to be strictly a
matter of how the VM was configured (as it is with SVE).

>         The equivalent register content can be accessed via bits [127:0] of
> -       the corresponding SVE Zn registers instead for vcpus that have SVE
> -       enabled (see below).
> +       the corresponding SVE Zn registers in these cases (see below).
>
>  arm64 CCSIDR registers are demultiplexed by CSSELR value::
>
> @@ -2636,24 +2636,34 @@ arm64 SVE registers have the following bit patterns::
>    0x6050 0000 0015 060 <slice:5>        FFR bits[256*slice + 255 : 256*slice]
>    0x6060 0000 0015 ffff                 KVM_REG_ARM64_SVE_VLS pseudo-register
>
> -Access to register IDs where 2048 * slice >= 128 * max_vq will fail with
> -ENOENT.  max_vq is the vcpu's maximum supported vector length in 128-bit
> -quadwords: see [2]_ below.
> +arm64 SME registers have the following bit patterns:
> +
> +  0x6080 0000 0017 00 <n:5> <slice:5>   ZA.H[n] bits[2048*slice + 2047 : 2048*slice]
> +  0x60XX 0000 0017 0100                 ZT0

What's the XX here ?

> +  0x6060 0000 0017 fffe                 KVM_REG_ARM64_SME_VLS pseudo-register
> +
> +Access to Z, P or ZA register IDs where 2048 * slice >= 128 * max_vq
> +will fail with ENOENT.  max_vq is the vcpu's maximum supported vector
> +length in 128-bit quadwords: see [2]_ below.

What about FFR registers ? Is their ENOENT condition the same,
or different?

> +
> +Access to the ZA and ZT0 registers is only available if SVCR.ZA is set
> +to 1.
>
>  These registers are only accessible on vcpus for which SVE is enabled.
>  See KVM_ARM_VCPU_INIT for details.
>
> -In addition, except for KVM_REG_ARM64_SVE_VLS, these registers are not
> -accessible until the vcpu's SVE configuration has been finalized
> -using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).  See KVM_ARM_VCPU_INIT
> -and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
> +In addition, except for KVM_REG_ARM64_SVE_VLS and
> +KVM_REG_ARM64_SME_VLS, these registers are not accessible until the
> +vcpu's SVE and SME configuration has been finalized using
> +KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC).  See KVM_ARM_VCPU_INIT and
> +KVM_ARM_VCPU_FINALIZE for more information about this procedure.
>
> -KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
> -lengths supported by the vcpu to be discovered and configured by
> -userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
> -or KVM_SET_ONE_REG, the value of this register is of type
> -__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths as
> -follows::
> +KVM_REG_ARM64_SVE_VLS and KVM_ARM64_VCPU_SME_VLS are pseudo-registers
> +that allows the set of vector lengths supported by the vcpu to be
> +discovered and configured by userspace.  When transferred to or from
> +user memory via KVM_GET_ONE_REG or KVM_SET_ONE_REG, the value of this
> +register is of type __u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the
> +set of vector lengths as follows::
>
>    __u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
>
> @@ -2665,19 +2675,25 @@ follows::
>         /* Vector length vq * 16 bytes not supported */
>
>  .. [2] The maximum value vq for which the above condition is true is
> -       max_vq.  This is the maximum vector length available to the guest on
> -       this vcpu, and determines which register slices are visible through
> -       this ioctl interface.
> +       max_vq.  This is the maximum vector length currently available to
> +       the guest on this vcpu, and determines which register slices are
> +       visible through this ioctl interface.
> +
> +       If SME is supported then the max_vq used for the Z and P registers
> +       while SVCR.SM is 1 this vector length will be the maximum SME
> +       vector length available for the guest, otherwise it will be the
> +       maximum SVE vector length available.

I can't figure out what this paragraph is trying to say, partly
because it seems like it might be missing some text between
"is 1" and "this vector length".

In any case, the "while SVCR.SM is 1" part seems odd -- I
don't think this ABI should care about the runtime vcpu state,
only what the vcpu's max vector lengths were configured as.
My expectation would be that the max_vq for VMM register
access would be the maximum of the SVE and SME vector lengths
configured for the vcpu.

thanks
-- PMM
