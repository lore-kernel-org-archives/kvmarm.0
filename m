Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7054437A
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 09:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722503025; cv=none; b=TXB5ml9TN6LtTWXhQv1iwNcG0s/gBMXi6IscEVK9xupSPVoqfgA/Wwk2gmq8PYvTdyCm20eojhSfXWnrhihXNBXs4/HydTfxmyLXogIfCUBEPbGNLb/8JEAEl1NYjKu7WPA3iDm41HVJ2y7K9GtPUnuh8BZMs3FGvcBZbOgJ2UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722503025; c=relaxed/simple;
	bh=M/Nhi0sMK7PpCm2r/uuIU8M4tCHIO/lVeQuknqZEy3M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ndVKETzX6ACeynzA7ZJdHSidFL1iQOUvkuCy9h6PMOZYhjz0CIEEeiB3gPRghviMkDtWCdt8uRGV4hhu/H/PqjKOsDXc3BhKlwGry26IVKzd98KDr7NoisVcIMD4Z6obA87+cbCD+MlqGUEZ05bp7tz+JrWoar6zlzDzTZfN8VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZmEewjAD; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZmEewjAD"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7d26c2297eso823959066b.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 02:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722503022; x=1723107822; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/Nhi0sMK7PpCm2r/uuIU8M4tCHIO/lVeQuknqZEy3M=;
        b=ZmEewjADCcu3KdLu3yApe4e3vWEcgBEQk5tfVVHkWmRuqkD0hdMbs5Nc9/2fEx16ns
         ZLXkrtB69tnrZBMj8rzaDK8iGQn1bmhBdMbQPorKee4fNa8dHsBCMIzFyvAj+/yrWVUb
         uhzWs72LCMIguDHwJghj9xUD3Qd0rpD7s8hpP4/M8e25qXiES/VWZuBpqycpXcanChyC
         QmLSo+eSQYGomE2ykzMwrobJ1aSt8g+z4iqEl6+sxWRbcqis7S0VDHeESnLp/x4Yize7
         xoeo+/r2zM4iKJkrrdtfXAMCPJUG1bYRPxwm1PpvauXgj2Ox23g0Hg1NzYwoRp3ZGf94
         +80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722503022; x=1723107822;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/Nhi0sMK7PpCm2r/uuIU8M4tCHIO/lVeQuknqZEy3M=;
        b=wgC2uBy3DAvJdu5j1GgHIuU+jJHrOhGeZFTK3LzIrqGsjxiaqPQxeHkOFzLMZ+rA45
         Z1L/r1LoCETaek3qSZUF2CM+7mRLjCQHQafTG3DScxEbu4JlU6jt2Rsjt3U6TiIJYhL2
         M1KunpbsLZtMM8XA9JdP1Od8Z/NlVDC/C1yHdhQTai5p4dO7D/kwPs/ROPJoKIlim+Bl
         rdjMxODBfHtsE6qFyB8yPE3Oz8CTV6vvXSYBxRxu/ZRAUYUdEednxgneB580n2MAh0AF
         2EZ9scSk0SCWF9lZOZBRLKKXX47uMEsKh41+rAnJ5LFbalx5g3n9bdRVoey0ice6P/cN
         C5Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVJg6Q0b6LX0ix7Bd5hxJMi9qsbvSg6z1V3zrxbwy5Zs6hum8tQJX7GxPVCEHDpsfiTeHRes3REigM6s6tNjBWGprNFih/J
X-Gm-Message-State: AOJu0YwA5elh2vNINFYcmGuQDmW3EsiFzTTYSpqyb1RUA2bfwDR8VUgR
	FHBWXIQsrrXV/9etTlbyLf/dFI4Dv1kgTMgi2WhvAttLyWnU5r5En39p7fBhhOI=
X-Google-Smtp-Source: AGHT+IHhni1Uh+bJITVWfhi2vAVjvXUzKzH/nw0taqtk6cxicA1yt55vq2KJXrilVInru0VfNsUVMQ==
X-Received: by 2002:a17:907:a4c:b0:a77:c199:9d01 with SMTP id a640c23a62f3a-a7daf4c7df7mr132037366b.22.1722503021389;
        Thu, 01 Aug 2024 02:03:41 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acad902e2sm878292566b.146.2024.08.01.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 02:03:39 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 36EF35F80C;
	Thu,  1 Aug 2024 10:03:38 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 04/84] KVM: Allow calling
 kvm_release_page_{clean,dirty}() on a NULL page pointer
In-Reply-To: <20240726235234.228822-5-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:13 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-5-seanjc@google.com>
Date: Thu, 01 Aug 2024 10:03:38 +0100
Message-ID: <871q38fwd1.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Allow passing a NULL @page to kvm_release_page_{clean,dirty}(), there's no
> tangible benefit to forcing the callers to pre-check @page, and it ends up
> generating a lot of duplicate boilerplate code.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
