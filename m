Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94634F46A
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608369; cv=none; b=CK27e3P0OGuYVUS+S/DWvmwtOy8x5VEJN4DxmcrctLb4H591DxyUPIY87xDv2zDuKhonPtZsJDJ0Ry5xfgQdh7kxpk0Z2CGDXwTMOwDvKK2FDEzv1hyx9QatqGhGhqFx1Y91iWsd0r+0HkrVk2pn0t/pimEqnsxXekYnh+JjiP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608369; c=relaxed/simple;
	bh=St1GXFYFnQmwJYS+6lpFf6dXoKkG15hVX4vyJdlNAW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mAD1lzQx1+5WYFzJYDjMWGKDPUwRgn+Usiy6z4EoYIA7d5LkDCgvLibHb5BNDxfvmvrVI0HlUM5/pgNPjjGri2l4Caf3Qh/PTocsD2ULTry60pAs6ViYcXT9Dof3jqthyT/iKwd4/luNTaAlLw4nwiwV/P9C+qr/L/64OkMuUaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e4CPvtL2; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e4CPvtL2"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-61381743635so630905d50.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757608367; x=1758213167; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3oSOMVjrhS6G3pVuMKnnpOUFEcnFdvdNa1gz4DKRv8Q=;
        b=e4CPvtL2VhbKyN+1ncZjtmd8EU3s/vD8JoPsWQxsQGqb9EyRXf17mcuXac159NfLRV
         2sn/oY2Tt/8UGwQQaTde6FBE41LjcoDAX4BTzcFGw35eoqs+Ik+dLnEUVfV/ZA0gIlEU
         7xbdB387DR1FdQxkfPNU/xeYgIFHD+kOk12DFdEQZ6ZXfvFXW2MTWo8mr3b8c9NlCE2a
         30fCCDLLfXz9K1JOdP03v9OFlxWESkX5wetka9B/UqdOSqY3aUeTCsh4ehA53h2avbaf
         f6uXBeljKfXCWttLYzH/uQFw5y97eYp+D8LoGrbRdcPVUSf70ixCBckhEo2Blkb1WOGl
         dCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608367; x=1758213167;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3oSOMVjrhS6G3pVuMKnnpOUFEcnFdvdNa1gz4DKRv8Q=;
        b=wCLeToCdkUN/RyjknXUj22r0TH+YRYpjMSHxlqaw2UBU41KWXbM1PTD0Zu2LXVHg8T
         kS7HVCkzpWfmdpZwLrC6a8/lCmg0vCjFLx9mDLHkNSOM1kosaUH00QzGqNidn+ulcGhL
         j3snezLghO3THC1/ebjmBAv/HNtQfkUK7SxV56bLJyGS8rlZ1K+KhFE36Ou26XyO+NML
         34wsp6GAJcobpbemRTgWxPSyLvytVYBm6zMRXX7tj1Q6cGxmvEFJ6zS6HHTi8KafpFfe
         xgFefWMhMuwQblHqq7saVwMpDeRVpDepJ6V9Pi0ZJqCbUSUH8awtpaqNnvz3PcbYqxX5
         omVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmSrRRq4ZIA8dNPIuhmdsHT9ZrMhKvq5SiC+Dy+VwI9dY8F3WIkvkp7iNDUbn67fyg+xZI+/4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzumQTnHwpbsqzmcnEOT9BncwPclq5a17aOfCSriMLdiQLgWUWI
	FogdDTc9vWT5pubsWMiwStlWfHv5AN0c5B5bY+n2ah3DegP9aiQDQkga7SGDH6OV8pdyHqilTLR
	8j1nH1aGhju1M3jJZLbFg6z0VTBRYTi3nNzMcAGcJrw==
X-Gm-Gg: ASbGncsTVX62xsFjw8KRMaqfWqoM4cOdYF0RGPPm95WhUo4eV41be//5rx+evlOMkgF
	KabGgSi1Km8pCtbcWC/gv8t4JL4YxXC68b290+7KXURX/wB3VDEP+PQe/A7PrX9bofBYpiC8jOJ
	uY1gbEOAIcvSvn7/3ZGnisolkUnNkbWiap411fETEWgdAdD15J5n8FrfFc9lRLO8F7CzhQkT+6L
	wqo9J82vdWKHfac/MY=
X-Google-Smtp-Source: AGHT+IGeH4N1vRnvak9qS44/0yvd4kSpobvGAPZaf480hH7OvuTCc6WKyKo4fqYHz2dGmlPhCMyjzhePDUvTwh237O4=
X-Received: by 2002:a05:690e:1a59:b0:5fd:9dff:f343 with SMTP id
 956f58d0204a3-62720222db3mr166980d50.20.1757608366474; Thu, 11 Sep 2025
 09:32:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
 <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com> <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
 <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
In-Reply-To: <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Sep 2025 17:32:33 +0100
X-Gm-Features: Ac12FXyeDpESW098EQeaKffAkGnL6LiJ4UVpPXhZdC_pEr0Pe8Dw3xSUiOGspuo
Message-ID: <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 17:29, Sebastian Ott <sebott@redhat.com> wrote:
>
> On Thu, 11 Sep 2025, Peter Maydell wrote:
> > On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
> >>
> >> On Thu, 11 Sep 2025, Peter Maydell wrote:
> >>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
> >>>>
> >>>> This series adds a vcpu knob to request a specific PSCI version
> >>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
> >>>>
> >>>> Note: in order to support PSCI v0.1 we need to drop vcpu
> >>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> >>>> Alternatively we could limit support to versions >=0.2 .
> >>>>
> >>>> Sebastian Ott (2):
> >>>>   target/arm/kvm: add constants for new PSCI versions
> >>>>   target/arm/kvm: add kvm-psci-version vcpu property
> >>>
> >>> Could we have some rationale, please? What's the use case
> >>> where you might need to specify a particular PSCI version?
> >>
> >> The use case is migrating between different host kernel versions.
> >> Per default the kernel reports the latest PSCI version in the
> >> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
> >> when that differs between source and target a migration will fail.
> >>
> >> This property allows to request a PSCI version that is supported by
> >> both sides. Specifically I want to support migration between host
> >> kernels with and without the following Linux commit:
> >>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
> >
> > So if the destination kernel is post that commit and the
> > source kernel pre-dates it, do we fail migration?
>
> This case works with current qemu without any changes, since on
> target qemu would write the register value it has stored from
> the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
> on target to emulate that version.
>
> > Or is
> > this only a migration failure when the destination doesn't
> > support the PSCI version we defaulted to at the source end?
>
> Yes, this doesn't work with current qemu. On target qemu would
> write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
> register but that kernel doesn't know this version and the
> migration will fail.

I was under the impression that trying to migrate backwards
from a newer kernel to an older one was likely to fail
for various reasons (notably "new kernel reports a new
system register the old one doesn't") ?  Perhaps we should
think about the problem in a wider scope than just the
PSCI version...

thanks
-- PMM
