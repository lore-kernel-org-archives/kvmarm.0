Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4FF1F956
	for <kvmarm@lists.linux.dev>; Mon, 10 Mar 2025 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614334; cv=none; b=cE485TzxX1XuCdQlUyS7j32h89FbDMLzE6GTmb/wfiNffk2fQu2G4Gweh73QZ1H4yNM8PQaZeeNJph+FKjbkIeBG71BJoS/JlCIAphCJHM10OKFVy3noZrugUxTuwwQ5aXysnUnfZ7pG1PEmuvQv3j+kvIgrDQkNotcpQDQ0RZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614334; c=relaxed/simple;
	bh=PrA7rfUbhe2Pewgr5X93FRTG1RoQPZ5lbvHmNEd0rGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogdNTOSqAIIhRGX4t6AC2yn+iID3HHxcNWkqx6lbVOP/nR/WVDphdCMqn3+e5w7TuKV+iBvBm3bVDnnX513BLQmvXWPG2QNhigwNuFAAhMarMf3j3mHK51y5EcmhTePfyn4qmK1sGqNKIJWYDMHt8dDmp1wSrmI7Qij3tCLYUms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bn0o13h0; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bn0o13h0"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so203051666b.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Mar 2025 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741614332; x=1742219132; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PrA7rfUbhe2Pewgr5X93FRTG1RoQPZ5lbvHmNEd0rGI=;
        b=bn0o13h0yr6kATOj8J4zGbPLOP/dDKR/J/ErtBrR3iC5vzCPgO5F9NbcEwbEKXTglQ
         WbCCP6KDLHOSYqtohd6+uOY2W8rh2Q1nwwrD8LPmPtUWM0KumrjMj01ZdK1Xz113RWZK
         vguzY3KXXLRJL/hn8jlToH8hIU82+w0Lr7XbcTFNMsV1eqOUazgIBxq1XXisLOWOiDnJ
         p5oorkuOonRzQ4VLjECjS4palXS5bnQAeHF/y9WWigstz7HOGAeF/xcFlAdruWi3zJMT
         i+SEQKYcZ7ox7ZH+o3GO0dkSBs9cln/ozsbwEpPCyt0E+ENN8UtcjWhCb3/8kP8LoIns
         Ei9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741614332; x=1742219132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PrA7rfUbhe2Pewgr5X93FRTG1RoQPZ5lbvHmNEd0rGI=;
        b=uh/oElF7XDXAuF67Go2iQMnmIs2W48Dke02M8XSTZzwtBDfBAIqO5m9DPD0KrPkiLY
         IUGPXwfRBPY8WR5y+fOgjI/LapsAnan3mhSYfdt/jeKGWt+hADPyjKtp2C8bvsEvjJoU
         JoF7Lf/Y/6Qy3hTzSNNb9OwhL3fGwfY1sbdviE1kxPIBF6x9L/i6RnZsA2XpCbvOij6n
         Tf59/uJU+5+0oGfvPuaUqV50ZpKYZvjocsm4phlWuxhjCvyWA+LP7nc9oHLDsMSRKhZu
         gGyHKrWSBULMjJAhf3nk5Pe3rBmqyh+X9T4Z+ur0qKeBS+gtScoQpycHYhnvpgV8xpZ0
         m5yg==
X-Forwarded-Encrypted: i=1; AJvYcCU62eafGUXnZEdQ0cgKRcL21aSTshgmd8n1HKz2KyCHEHIaz/1VXQts5+lCdyJCkA9r93va6qQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW4LJnXAYYLlJQdy2W0VAiuT5McsAGDj0y6GRpuFDrUY57Xj9Q
	F1EOr0lAOOJxTt8764wKdM+gvcoF86rDQ2s5gjSlHKCiOrwv9qgRmYUrIqMyoqmEEp3GizWZnZX
	Q6dRYCvXJsGsH5uvsczOu0jIV/wI=
X-Gm-Gg: ASbGncsEIFaGP2SmpA+flJR3aTjekMvqCE6GZZDhNv5YfZOX2q3NhQ5y/QX7qEdr/bx
	KFL+9YPC1LDXBSqi0e0kjdtniPHxy78jotAznPrMOKOe8ngTT7spVHF2ZMfx6/BMAxXy0X+jB4p
	xvYisEPInTaZElLgO4WOWgJhOdzLDyHHQas4WEEsb4H7yA1ysNUzuvPuc=
X-Google-Smtp-Source: AGHT+IFrlV+UOZmk75f6ffZGqWNA8kEVBO9qwi1sfylUDo7SOrHnrhelQqcwKfQa9tx5Jczcf/SvJhuAPzOyWJApbV0=
X-Received: by 2002:a17:906:33db:b0:ac2:7b8a:7a24 with SMTP id
 a640c23a62f3a-ac27b8aa77emr821669466b.3.1741614331525; Mon, 10 Mar 2025
 06:45:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307220304.247725-1-romank@linux.microsoft.com> <20250307220304.247725-5-romank@linux.microsoft.com>
In-Reply-To: <20250307220304.247725-5-romank@linux.microsoft.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Mon, 10 Mar 2025 21:44:55 +0800
X-Gm-Features: AQ5f1JqLOmSVWjJdyk8kWYqh8Q05Ls-ycUphJL8s1J0KBJmCwQzJ1qeS4exHJxg
Message-ID: <CAMvTesC+McATYa-xsi0omJ0LnFUUUooBk_r+oYSHYimyXPz5ZA@mail.gmail.com>
Subject: Re: [PATCH hyperv-next v5 04/11] Drivers: hv: Provide arch-neutral
 implementation of get_vtl()
To: Roman Kisel <romank@linux.microsoft.com>
Cc: arnd@arndb.de, bhelgaas@google.com, bp@alien8.de, catalin.marinas@arm.com, 
	conor+dt@kernel.org, dave.hansen@linux.intel.com, decui@microsoft.com, 
	haiyangz@microsoft.com, hpa@zytor.com, joey.gouly@arm.com, krzk+dt@kernel.org, 
	kw@linux.com, kys@microsoft.com, lenb@kernel.org, lpieralisi@kernel.org, 
	manivannan.sadhasivam@linaro.org, mark.rutland@arm.com, maz@kernel.org, 
	mingo@redhat.com, oliver.upton@linux.dev, rafael@kernel.org, robh@kernel.org, 
	ssengar@linux.microsoft.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tglx@linutronix.de, wei.liu@kernel.org, will@kernel.org, yuzenghui@huawei.com, 
	devicetree@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	apais@microsoft.com, benhill@microsoft.com, bperkins@microsoft.com, 
	sunilmut@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 6:04=E2=80=AFAM Roman Kisel <romank@linux.microsoft.=
com> wrote:
>
> To run in the VTL mode, Hyper-V drivers have to know what
> VTL the system boots in, and the arm64/hyperv code does not
> have the means to compute that.
>
> Refactor the code to hoist the function that detects VTL,
> make it arch-neutral to be able to employ it to get the VTL
> on arm64.
>
> Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>
> ---
Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--=20
Thanks
Tianyu Lan
