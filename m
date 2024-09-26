Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4248B1547E4
	for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 09:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727342101; cv=none; b=OncL80cX8X7OiP2i8htfyVXqMzrTbh8kLuTzWuq5tuzjMj1hnct1LLWZC4zH5Y1S8kMNsPRmuX1fTMnMYFbcg/AvKyjO4Hs4K+sNBM92GKZbonyMgkZmibRj4Bar8VUtIeLatR9g+2XJzutfslhA3LuAVmN6gReEpE8Dgo+TMR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727342101; c=relaxed/simple;
	bh=5CRALTb60twaABfzMtifOzQaiO9ApKULKNiRaSr55Og=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K4NP6UkdIZYCc1gjFbqqlpNf8VnFLZJ7hohoDMiSux8GBo5jaNHIj7eSXGoMsQJSeKPuSb/BPbo3dGC+y98p/XwAUyfiD3UuECAUTXPVCKqHi/pzM8BNBaL7i57+9daa/eoiCkuUCvgfl71Q5RCJ4Brd4MXIuVJHQVC7iZnopbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q7Jk+wS2; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q7Jk+wS2"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a90349aa7e5so109604766b.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 02:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727342097; x=1727946897; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CRALTb60twaABfzMtifOzQaiO9ApKULKNiRaSr55Og=;
        b=Q7Jk+wS200QcEt/BmYdBsfGum9MxKdUCShQZhU7nBWp1bRjP07qwLisR8W1/oK0Ax9
         t0tfEQuHBhX6EwCaNtm5EG/p7UeGwFe9EoJUlcGHwYJHUCDgQDP1OWnXEiveN888x+o/
         +8Up2RkLOH3GECEztDd4wKVbr+vGyj5a5UlBzPVpl/rps4yXowtcrqHo8lo89z3bdtUP
         AkkHOC9r83DqvL9P0WkynvrwILUmPqmSW/9JDqq7/eA2kEL0EaNpjfNEtrfFH7oiVmnM
         STF0+rgFmv2kl7vuJo6dM672Rhy4pS2KEagC5jXb6zvZ1ZPCX+Ch5gCEtC5pJ181eCs5
         wRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727342097; x=1727946897;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5CRALTb60twaABfzMtifOzQaiO9ApKULKNiRaSr55Og=;
        b=abdxQ6p78vWIcEMU0j+gGxmbx0t3yM+tnwq0AX6CwzFjRYMHK+sSOR4Bssrm8Zquud
         FGvp8ZzeO/upHh+sLR5ZXefIFiKY4zoyKOUuITaJURYEMBwSoI2OE79IFyLLpsaz6wVP
         fgojoKyGcEEOrRBW8X2hD01XYRFDAE3mvXs6QOBJ8Kqn7acAviGSuX0P6Pow3s432pcb
         rwT0f1pegJrOsn0vDWGfKGkFeG3ZYy788r7CYquFoLvKdHomYwl58n481d+R3Gnn6sPE
         fLCFBppZ9cRqtGECoWOY1TBun05xT1yaiCxBlTdYRVL0/f3JfMIV4xfoqPTKrLVRrywe
         g8Ng==
X-Forwarded-Encrypted: i=1; AJvYcCW/L/HE0vLulyVIJ5aT6mQFmkMwUt3+2jisw3xaCwj57Ap8osFADlI8jTKAa7/uH0CGqxgIvMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRwEm+J/b88+7/jx36Dpptb7JYxycm9RNb8xgQbSG1e/4iWD+d
	1Uvnpsb/Gaj1T/iq+nVcmOE7Kv35glCsUNNC0SDEZguzHRUZ5vzE
X-Google-Smtp-Source: AGHT+IFuQpCkW97RwiXsH3H+4pPmO2s5+Udb73F6RcjEM6YRZ3bpHYtgsjXjgkpzlG78J1VZAoyE3w==
X-Received: by 2002:a17:907:7d8a:b0:a8b:6ee7:ba29 with SMTP id a640c23a62f3a-a93a05e7e95mr521203166b.44.1727342097231;
        Thu, 26 Sep 2024 02:14:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:438a:71d4:3b8a:6ddf? ([2001:b07:5d29:f42d:438a:71d4:3b8a:6ddf])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93931336b4sm322256666b.188.2024.09.26.02.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 02:14:56 -0700 (PDT)
Message-ID: <709968e9b2a947787177f7ea3eefcc89546bffd2.camel@gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Add PSCI v1.3 SYSTEM_OFF2 function
 for hibernation
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Shuah Khan
 <shuah@kernel.org>, David Woodhouse <dwmw@amazon.co.uk>,
 kvm@vger.kernel.org,  linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev,  linux-pm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Date: Thu, 26 Sep 2024 11:14:54 +0200
In-Reply-To: <20240924160512.4138879-2-dwmw2@infradead.org>
References: <20240924160512.4138879-1-dwmw2@infradead.org>
	 <20240924160512.4138879-2-dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-09-24 at 17:05 +0100, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2

Can remove (alpha).

> function
> which is analogous to ACPI S4 state. This will allow hosting
> environments
> to determine that a guest is hibernated rather than just powered off,
> and
> ensure that they preserve the virtual environment appropriately to
> allow
> the guest to resume safely (or bump the hardware_signature in the
> FACS to
> trigger a clean reboot instead).
>=20
> The beta version will be changed to say that PSCI_FEATURES returns a
> bit
> mask of the supported hibernate types, which is implemented here.

Since the final spec has been released, we can revise or remove the
above wording.

> Although this new feature is inflicted unconditionally on unexpecting
> userspace, it ought to be mostly OK because it still results in the
> same
> KVM_SYSTEM_EVENT_SHUTDOWN event, just with a new flag which hopefully
> won't cause userspace to get unhappy.
>=20
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> =C2=A0Documentation/virt/kvm/api.rst=C2=A0=C2=A0=C2=A0 | 11 +++++++++
> =C2=A0arch/arm64/include/uapi/asm/kvm.h |=C2=A0 6 +++++
> =C2=A0arch/arm64/kvm/psci.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 37
> +++++++++++++++++++++++++++++++
> =C2=A03 files changed, 54 insertions(+)
>=20
> diff --git a/Documentation/virt/kvm/api.rst
> b/Documentation/virt/kvm/api.rst
> index b3be87489108..2918898b7047 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6840,6 +6840,10 @@ the first `ndata` items (possibly zero) of the
> data array are valid.
> =C2=A0=C2=A0=C2=A0 the guest issued a SYSTEM_RESET2 call according to v1.=
1 of the
> PSCI
> =C2=A0=C2=A0=C2=A0 specification.
> =C2=A0
> + - for arm64, data[0] is set to
> KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2
> +=C2=A0=C2=A0 if the guest issued a SYSTEM_OFF2 call according to v1.3 of=
 the
> PSCI
> +=C2=A0=C2=A0 specification.
> +
> =C2=A0 - for RISC-V, data[0] is set to the value of the second argument o=
f
> the
> =C2=A0=C2=A0=C2=A0 ``sbi_system_reset`` call.
> =C2=A0
> @@ -6873,6 +6877,13 @@ either:
> =C2=A0 - Deny the guest request to suspend the VM. See ARM DEN0022D.b
> 5.19.2
> =C2=A0=C2=A0=C2=A0 "Caller responsibilities" for possible return values.
> =C2=A0
> +Hibernation using the PSCI SYSTEM_OFF2 call is enabled when PSCI
> v1.3
> +is enabled. If a guest invokes the PSCI SYSTEM_OFF2 function, KVM
> will
> +exit to userspace with the KVM_SYSTEM_EVENT_SHUTDOWN event type and
> with
> +data[0] set to KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2. The only
> +supported hibernate type for the SYSTEM_OFF2 function is
> HIBERNATE_OFF
> +0x0).

The spec says that the HIBERNATE_OFF parameter value is 0x1, not 0x0
(which is kind of unfortunate because it doesn't match the
corresponding bit in the feature flags).
So, either the BIT(PSCI_1_3_HIBERNATE_TYPE_OFF) value should be used
for the SYSTEM_OFF2 functions in the code, or the definition should be
changed in the header file (unless the text in the spec is wrong).

