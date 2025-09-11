Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CA234A31E
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603898; cv=none; b=mcIh5OMalv2+E17d0kmGB3tEvV7p3fHwXQsqCacBNsVkpx9Ip9k0LJmv2sxMee5WuiZKpNrO1wqQCYo4XFyaFqpHPYAESv8513TzAK9QbKLIhla0d5dK7qRLpJEMdp2g1PRM3uT4GjmLCal8cHNz4eAU0lPA8ztewYgT7S13Nmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603898; c=relaxed/simple;
	bh=4kGiMNWl70c+t1jpo2wDVgJIIXlrUNj+YdEfV+tcftE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tTEUp0kdRNwjlZUqVlsN3TZUU0s6sCA+D7WFFojeppszrVlPMNuk1b5Lm2keqoHNpUOFG4UIRennvjPFWcdpfz5IzUii0PZ7VBxwVAWKACNisBZJ7AA/8Ic6o3BN+FplJ4ucMST4h9OIFjeMkNMmitCvIqkKq4ijAHwv6kOpf/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MeGAtm+q; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MeGAtm+q"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-72e565bf2feso6242707b3.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757603894; x=1758208694; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=knG17Yq8OEl51CMsovL2EtZQpAt43iivBldwrOwPUGA=;
        b=MeGAtm+qduvYA4PlDiG807UjXpJLegbcTKxHqceR4SpieSfgBSkAAPYjevhKovQ5uF
         jsGK6H+nY3Ur0pd7DUaM/oBGVixIkTWJd/a+80aTzqVjwO2NYJaxStxEk3JQuhCQ6Ckc
         qTJDfrfs2rXMVeKd8gLjewf5iaLnRYTi+7tQQo38ki6rydIHmQkbyUfN7FSaqqWbjQt0
         8Px+/9zU6D5QAXu+J1LdQ8i78kDw7GaAGrt2IXATHJ/BODNCR69j82MPBwMgHh+Fg1qD
         l3kYG8Zbz0OlbK7ve/Q0VY3K+mVcl3Q6iNBoi1pxAuEkiarY02XVVlxXj/2UQwfi3uKI
         5VFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757603894; x=1758208694;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=knG17Yq8OEl51CMsovL2EtZQpAt43iivBldwrOwPUGA=;
        b=S0cb8juXAyyGxXUnAa2VQ/mY+74+tubC6hNfSAJ2mrDWW6Xq23rOWp3VsX+d/hVTb4
         vhriFT8FziZ+79vafBqWNVflt5nydEHswSYR+KjtXHMyFwXSjktW9XVPT9DoFXOs8A8U
         MTneXCDPb4Zs6NbJDeKs4BLCiPtH5SQcrhGcxTjnckCaSAa6g2tJYX3zxBUfSRgY4o6K
         +He5lK0U642UhhyJtc6QxFvhWECE/1/UH5eSJqWYSsxi00m+x6ryFKvWHVuwuiyJWvDD
         Qv9C77J0pvxzN2xiyJGjlEc/kuUc+FY7DpZfYlnpSIpOInNz4fVij/eiZvkFmznXM8N3
         1TuA==
X-Forwarded-Encrypted: i=1; AJvYcCW1+TDisxf9g/kl41eAvVSwC8MEsdozJ4x2rGmBXUddJBWPZm3YXjLFdvDsJrxjkQPgdP7ncpo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHG5F7qGs4UEHUwiDrLNzpcIuAJqywKuKqV+X+cW0iSdxjO9Im
	BMhebk8V0TTRm9j5xkgSh0bRXY/VGXc0cZ+/2tpFtl+8tSgn80NqsaoRLrQw6OFMDmEiskorMLS
	pytfEGiwTQKKbhEyx5uDVQvWgQIL1Rpp2nZ+eVXegJA==
X-Gm-Gg: ASbGnctFYrqmfnYVjAiMmSRGV+8aqkwUwknMNRTMootqZWW5wReSixQ6AutsFKAnkr+
	Mnz8laCotAxiySnTqgcvCMA7U5EWaRcomi2b2bFQSVSCnr1J3jzfLBQXV/d9zJxof0s68wPuBRH
	5VvqUkjhmsJO+SyQfbotmubDDXZMoI4SF4mDhDwBp2Ti8MekD9HYjrG7WSv7K+q0zHi0QC1hKbu
	M++jKtY1/WtEVS0A2o=
X-Google-Smtp-Source: AGHT+IF3H557iKfUovfqwt2gL5bCvaJImvBqsOCUlSfE7rbWLqZkyw3UKcIFfROpG6jQIj6ebdJJMvpqUVlLx0flUXw=
X-Received: by 2002:a05:690c:b9c:b0:722:8611:7979 with SMTP id
 00721157ae682-727f534c628mr212302917b3.26.1757603893463; Thu, 11 Sep 2025
 08:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com>
In-Reply-To: <20250911144923.24259-1-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Sep 2025 16:18:02 +0100
X-Gm-Features: Ac12FXz6fXkfCmLnxnecWlBKlTxswjmrip5hHL8mvpSj6aSPT4PhMhm5w4RtkfM
Message-ID: <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .
>
> Sebastian Ott (2):
>   target/arm/kvm: add constants for new PSCI versions
>   target/arm/kvm: add kvm-psci-version vcpu property

Could we have some rationale, please? What's the use case
where you might need to specify a particular PSCI version?

thanks
-- PMM
