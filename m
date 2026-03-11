Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E7C3C8714
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224199; cv=pass; b=G5+5YQilvmYHmsQhJWQ6q1lRgUn3x2VLkhTkVpbEkv1QimtA2FK/FAT3br+Ub8ShcyQnYrZ7oCU4Ath3DQ4iw3fA+EMH2TS399vly1mZts99qrRMBsZZ/glrr6nTaW7hrlBaaAPNMZ8j2W6GPcZ47svtdWPDqW7kmQD3ycuMg60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224199; c=relaxed/simple;
	bh=PZjh8Wq8UM3WPe0jCvrlGH5Yb9jCzpdcEBt2t+duabo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mgWFSUYCHqOD+HnldxMGv/N1+bMvhFAfsrV7NtvrcCMrFSDu72Ui+w+DoDFu1RldR8ljvyGpCtfmcF99/U7dr/9KeoebweLRRbFPeNOnwwKoSUXPhSYc9HeIuP1GBD+cfNZGXoTocKanbKo9sl5g25HUb6DNto1bEE6w37Fy8A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ak42bsY5; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ak42bsY5"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-509069a7a7fso507561cf.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:16:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224197; cv=none;
        d=google.com; s=arc-20240605;
        b=BCJHhKJJTChpKzr0gmOoogPvHzRMvftYGkubSEXXiP8+oMK9HzsCeKo/D8/TlP3sUa
         99f9wcxcNzhjJIkLqzcPuj2aj6Qxdb6E4zZn8SniFlp5F/iymokXtFyWO7Z4+8KjjXk+
         H79dZwLzUXPAtSv8w2fLYXd1EUMa2hI47JfXIKI7suooBSf0mla40kauIbK5nsRu6Ud+
         YMDC8D5mpXiHy7X97igURTUuwvIrN/2PsmPl8kwu/i204ViAfpz0aEGyeYlPNMucefyd
         6jql0ySmcEmqqu9wVelzZyU2auv3MPdIrXWxb2xxtxjXLSAUKKbiU2JvKEO1vAHPAW5v
         dqow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=N5q/OoIe7MzcEL3UFP81+GVcYNliiB+ErNkv7hGJrr4=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=BDUlDuejQpYwCkHT8HAK4NX6VI9UDWvxMCd4U//FwBZzrjM+Z5nSkmLanJRaF4qA8Z
         Qj7t6hWppaGXTI6Rz/UvQQQCF3yEVtcAZWq1d8v7/f7gdGrscG0CuQE0u9OTYApeAmHx
         iEPxFYnfiRp4wwCHVyH8xTlgb00rAWaH1A/02vZzXcwJRboV13sAiZQDG63yBRLs+iEM
         it5Ay+3ni/1q7uX4BKhjSr8bn9oI6qZsHlMDQbjvoLIsxOx1uPVQU/moO7y9bdCFeMU5
         XPx1P8OMxScR70vsJwZasA4wMjlAPdgdJ4e5QxSGvD8hiFzskSARRIZHm8pfmSzjMKO+
         rw3A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224197; x=1773828997; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N5q/OoIe7MzcEL3UFP81+GVcYNliiB+ErNkv7hGJrr4=;
        b=ak42bsY5YhXhvUKoAhHaOitcm1vvqtsxGlFoix/p3m4eX2fN/dhbSJg04VTQyrd31/
         8zVMnZNSJND59BSpJU9SO0QZtuxAbOgYFqsUEJnb+7bMNNc0YIKWF8ZPV15AE38RPGm1
         QCTKZG3W5YwYJFPDHfbIT9IBeps+xfN6SjesOltPbskSXSDXJPHkrEQcJvRHad6LF7J9
         9cmLkhW+xBgUmZyULKKKmsAsE+pu2ijB9B8gD8ubxeXeau7G0DlaY3YVoQ31jVY4SkcF
         IszpKHjbzRFWkomSk6u3+LShlaDlrfZSfX7y9mySq4S/XO5LRFtFko/fOXtmCvjJGRtz
         ID3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224197; x=1773828997;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5q/OoIe7MzcEL3UFP81+GVcYNliiB+ErNkv7hGJrr4=;
        b=FYTEVhBOZ4JxIgHhSquFC0Bem1X2IY0cm1+3k1U7+z3iE6EgVDdhwOYS2mYXRAG9FQ
         MAHIIQJ0hBXKIeQmEYZUKtIHxGHy2ik9yRcSB6VaxWldDEKaTQrHObqg7G10u90vVm8k
         bzVESFNKuTUHtQr/wc8Jp2HEhOgL7Bsk2GKheGSl2TdpokqPJ30TcQdyFX4i/xCIMaJT
         fFPliFvLHgC3u7Tf/dGBncwhEIpvT5rz/9Wku4BY7MT5Z2ubeq/hq9Z1huMeYphSk6dN
         tmtgloClZk2CkXUGTXsvGBsivc7HfY3HhD+EMzep9ccOnM1LlPz5lxMo5NZSYyPJEmqX
         /fcQ==
X-Gm-Message-State: AOJu0YwlKHnBizkhZAPwU6GvhENlqwqSsOG/r49nszwtG35t3BDtpi68
	poFT25CsPkkBAuJjhLwcmEljozlDGlRo8wI7Gpyu8CCO58eTGMEq5To9cDJjw+dnNocxVmoE4Fk
	vV2SpdGPjUARdonrr+Z1FemrWbE0muv0by5Bd/d2k
X-Gm-Gg: ATEYQzymvVoqQ3IYyyon5DY+q1xWTVOTH1yae6NwGxkP7YzHW7x8wZxrwap6AR9Zycy
	iwwCCjVUQRI9416EYPOfqEQ+Ck+W+YAtBgBVrEmm6ySmwrHztL/tgO9GQ1R+RH33ph7yMzUSwFU
	kEc85fZnTnz0AVYM2Q7K5uvvA2QuoBqg9iqGWSIGeWuHqkUmx+ebgM6hqxNOCfdSt6gLglMQFUC
	+V1u1vYpomXIszRBj05dUvusJ4RyVsSpWsDBcQ1TnTboqk0BOjw9cMFL7q0f1qMfY0mJqs93+gK
	jUSQLHzhshfiaicD+Zn5ATF8G4mT7oVciJ4V0Q==
X-Received: by 2002:a05:622a:19a3:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-5093827a36cmr11288421cf.12.1773224196603; Wed, 11 Mar 2026
 03:16:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-5-will@kernel.org>
In-Reply-To: <20260305144351.17071-5-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:15:58 +0000
X-Gm-Features: AaiRm50BjnGexUUYazkxEAHHsZsBXlEzYbXtALA_qr4JeNpp8BQ5cgNF7CG_T18
Message-ID: <CA+EHjTwnyVKZ2SHJPWO10erH6NjjmQ9J3RKZoKOZx1uM4woY4A@mail.gmail.com>
Subject: Re: [PATCH v3 04/36] KVM: arm64: Don't advertise unsupported features
 for protected guests
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> Both SVE and PMUv3 are treated as "restricted" features for protected
> guests and attempts to access their corresponding architectural state
> from a protected guest result in an undefined exception being injected
> by the hypervisor.
>
> Since these exceptions are unexpected and typically fatal for the guest,
> don't advertise these features for protected guests.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_pkvm.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 757076ad4ec9..7041e398fb4c 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -40,8 +40,6 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
>         case KVM_CAP_MAX_VCPU_ID:
>         case KVM_CAP_MSI_DEVID:
>         case KVM_CAP_ARM_VM_IPA_SIZE:
> -       case KVM_CAP_ARM_PMU_V3:
> -       case KVM_CAP_ARM_SVE:
>         case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>         case KVM_CAP_ARM_PTRAUTH_GENERIC:
>                 return true;
> --
> 2.53.0.473.g4a7958ca14-goog
>
