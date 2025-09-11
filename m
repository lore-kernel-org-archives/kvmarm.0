Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539EE186E2E
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606553; cv=none; b=Btbj8HXU6sM8I9agkzJMqtyhph5sYEB3eDwiXNuI+5AMH9/hfj8wQH4B2VxCcyBZwyWSE5r67Efj0tf/C67w5IzLUHRwcQoCS0VnDX7lVmdx1QhqamY7JQF+3dUgTQbR7+jUK1H+c1l3xavadiAxD8LtdRkxntTausijzYqg72Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606553; c=relaxed/simple;
	bh=vSPFoGtwxh002ejWcm8cx4A3GNPgAgTbG2HYC/Blbdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JNJZ2t9PBvTZpfbX6m/GDjIdcC+JNlT/cxZUBjv2WgcHjM1SggNhq4iH0diuX8aX0kMjQsc+Ui7JAvkQc0+NQ1AEANJembS+6SVC1WfQyR/KFLObsdSgPl+Adqn4IaZ5B7FfbVITkEhvk7btMXJhbREWihtwqAfAmSg2Qhk94WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qTlEZEWt; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qTlEZEWt"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-601f279a7f5so301424d50.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757606550; x=1758211350; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7dRGjVVwpjU1/n+vvstizJLUX8chlCa0TZSJ83N8d/Y=;
        b=qTlEZEWtr8AXF9xi1xeoEodg31LNp9D8Yxt4XDiA1md8Jr4tgztLjnyZD1obBZZpNi
         SvCxeo+LjARHtclgd0IrlFR0aaOOWWGuA1/l2Nub/VSrSbeGEmayFFUb5+6E1zs+riH7
         N44YA5hXQXgx6ODG+ou0/u+lo0k1divcEx3xOuTOcKZXMP5RPJorpCIxJVxxnJwTacMD
         IEC45wmBG4+LrRQg3xQnhkEjn1qbn3Qi045VNoXQZV7eAgISSiWDmHroD0EL7mOK0Mri
         KTW18fJhd6K59eYaiZKrQmQVmkco8E7U9vokb53ebq2idDIv50CzXgeSKhJQDNu8qZRg
         Pzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606550; x=1758211350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7dRGjVVwpjU1/n+vvstizJLUX8chlCa0TZSJ83N8d/Y=;
        b=kvKI86HUKvEZHB8ddMg06Q90f41vnFE5APBDwQsFzsNJsUN9E6DkwRD8lCy6w6+8ML
         aovLndoma4QofjIK7Qs8OtpCuivPT/ti4EslRHy98q1gr55Au5qqmUsQcHqrDfLq87JB
         bek8ERueUcfTHSW/flrTzGcZQWfb15z/O+NQKKJ4D/TGIqavLT/3szoZB2jbSdZnMXjp
         +/B2efkbThycQttVuZHtbyE4AOaiXhJKD2VxyjgtzR5K81jyrx8TCuDpd9jJyprmnfM/
         9TpcT8Y1eVg3b67h7xMVXQ4Oi7JM+9raZyQvo+SP3kI5lZjuBLv4MHm+cfAFBIo1vAUu
         RN1w==
X-Forwarded-Encrypted: i=1; AJvYcCVC5/4HFmbna7f8B8pLrdNjIQmqC7THlVFa9c8aVl7xkc6bQvtMt+BrRNBReS2vNQBgWgouUkM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsvWDIm8IIou6Av9f89p/tKg108ezBl+Ss9SKXb52ZvJaOHz6U
	TwmGiEv1oOlq40FR7UUrX4lWbsYSugMFrab7aXDvOBR3GswhVwS669vGmeVsl78NpH3uB3DRyy/
	lLjt6WBEQqmg5xearGjn2y8E5iYMG+efC305M5fo9aw==
X-Gm-Gg: ASbGncsgPTCZd/dCdMhhAneJgDVmfL7f1X7H146JjbLIQHfXlz8o7dO/n4dT1lSnitX
	/kXtgs7W57lp6xLBoO9lJW5TrdDd/5q7/D/wSlayCiKz2gzEq+wtSmOReaZ5zuFLXI7Cs08lTSH
	Ha1soCc7waqlMpDPeGw1LRlVi2dbKdUrDrs22WC+PjaqgakAI3ojnyYLj+xS9EG00BaI9886WdC
	1WjRuU7
X-Google-Smtp-Source: AGHT+IEcRWg0Ibv9La+c1AHa5/EwzBNdLFmIeSpsqfPLBULrqQYCnbKIvwEz11pcW5Z0PxHmVsBAk1FKJbGhiL4pVXI=
X-Received: by 2002:a05:690c:e1a:b0:721:1649:b070 with SMTP id
 00721157ae682-727f5648a22mr172576627b3.44.1757606549654; Thu, 11 Sep 2025
 09:02:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
 <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
In-Reply-To: <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Sep 2025 17:02:17 +0100
X-Gm-Features: Ac12FXx96W2Z904Fh96vP6TMP44uauq6yyDdA3EE2iGnUzJEwgpWwDS7kISm_EE
Message-ID: <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
>
> On Thu, 11 Sep 2025, Peter Maydell wrote:
> > On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
> >>
> >> This series adds a vcpu knob to request a specific PSCI version
> >> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
> >>
> >> Note: in order to support PSCI v0.1 we need to drop vcpu
> >> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> >> Alternatively we could limit support to versions >=0.2 .
> >>
> >> Sebastian Ott (2):
> >>   target/arm/kvm: add constants for new PSCI versions
> >>   target/arm/kvm: add kvm-psci-version vcpu property
> >
> > Could we have some rationale, please? What's the use case
> > where you might need to specify a particular PSCI version?
>
> The use case is migrating between different host kernel versions.
> Per default the kernel reports the latest PSCI version in the
> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
> when that differs between source and target a migration will fail.
>
> This property allows to request a PSCI version that is supported by
> both sides. Specifically I want to support migration between host
> kernels with and without the following Linux commit:
>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3

So if the destination kernel is post that commit and the
source kernel pre-dates it, do we fail migration? Or is
this only a migration failure when the destination doesn't
support the PSCI version we defaulted to at the source end?

thanks
-- PMM
