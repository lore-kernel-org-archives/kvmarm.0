Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E3B170855
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722506140; cv=none; b=bsfSOK8pIwpF+6tZhsx4YkVLr9Ufpz8G9G8zLmz6fugG18rhgXO4nsaKtBetqAc8Sq9ItgBSHt4++Rschml+o33birDOFpPgql6ihuPj6TITzD3+c9BfYfm2UJ0YMXDN7DNJmeRA6LM0+wpOklX6qMyprzGLpcax89PIISQ9fmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722506140; c=relaxed/simple;
	bh=CfWoHfDxpbd/BrLn4R6OTlWdsgX7K0q/kTBzQqeOmF4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nR7hg6fNy/kkQNxuATkXYRIz4oBZy+lVrhjqK9gq93iieLvVkPvoklquDyTLsn6egndvneftH+8ssGsheXRloaA4xLdluwUePnx9MBBGUAfONMkj4pr5EF5DFtsKikBPWFANXsQ/eMoRtLRdwcG8naVFGhdtTviJNPNCzZA0/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MNdz8peN; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MNdz8peN"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc34677so9743903a12.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 02:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722506136; x=1723110936; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CfWoHfDxpbd/BrLn4R6OTlWdsgX7K0q/kTBzQqeOmF4=;
        b=MNdz8peN6KtrqBOQwl6xXah3O52uqJETLTuIhe8Yqe0IbAswEVgAZvgsmdRTJx6kg6
         gL8Hq+5n03pihPla6+En3ARVm7/4ycB0G3wzhcoX/fhq5bv8vf5EwaWHT8I0oXS5Xfqg
         sAnFbZcW+g0QJPccVFoliIvosDHib60KYMik75S/j7LgCnfZNQngFB087Yphxdmau1bd
         B+9NLsL3ZnQZ+bSuEAItna6freS92E+l5pZO1CiYu19vgrP0S8qCPxzud3pWEgKXd6TK
         POcJBHnvgTyUAJBhaUkgIkryxvyRF1OHLQ3z/IvizIllIrHvHgWZMUmUhnrt4KqWnQJJ
         mpJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722506136; x=1723110936;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfWoHfDxpbd/BrLn4R6OTlWdsgX7K0q/kTBzQqeOmF4=;
        b=whjgsxPU8mcGv2eEWzs96QkO16F8VQv+YxbTAm0VV6jbncyswu7nXLMNomp6Vjgbpl
         IvumDdbjmTlycIfKLDo4stgMu6Vx2WP7YlVCjY2bE3zN4sLGpPm9Z7T3SOHGtRxlL5zu
         /nsonSm3LcCLoV4/WPUHgFsdd5glA7MqOXrToDa8/2kGAE7SUKvlJrjE9VAao5jx4qRa
         6srWbWUQ9gtQeez7UYfL5ifQb+Wdda2BAh2tU0iK8v6Z0xQ6zMNN0x+ccScXv2bSmcgg
         uE3d1u4LV2oAI9rH6uh1lbZ271gE0iex/neKRaF9dP/WWlL71bhIkPVrdJsWA5oFqD5L
         ozUg==
X-Forwarded-Encrypted: i=1; AJvYcCX9fmeXjrcXA2/vgbF6n2aPEThOyZzYlcKo3NkelzzeDxP59r5OFYKngL6lxD89UtvN44n/C9+adHvzOv5nkwHnZwoeMN5G
X-Gm-Message-State: AOJu0YyM03AS+y5zDbddstd4dV/fc/Bwk1VfJRciMV4r9ULezkFwpIKL
	35hQiWr8rA2RRXTDRxfPQwCSvQk6YLX5qUrlSxyFnM2VOJ558T+nzAHsSmvPlkw=
X-Google-Smtp-Source: AGHT+IGb/nSGVf7NWCnHjhhrhlGi5SRtFpH69is58qT222M0oYGxJthjaOlCxTOcuwDzU1FyViVsdw==
X-Received: by 2002:a05:6402:b32:b0:5a3:5218:5d80 with SMTP id 4fb4d7f45d1cf-5b6ff4e0399mr1182829a12.21.1722506135641;
        Thu, 01 Aug 2024 02:55:35 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac6377d005sm9858902a12.38.2024.08.01.02.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 02:55:33 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2329A5F80C;
	Thu,  1 Aug 2024 10:55:32 +0100 (BST)
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
Subject: Re: [PATCH v12 26/84] KVM: Move
 kvm_{set,release}_page_{clean,dirty}() helpers up in kvm_main.c
In-Reply-To: <20240726235234.228822-27-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:35 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-27-seanjc@google.com>
Date: Thu, 01 Aug 2024 10:55:32 +0100
Message-ID: <87h6c4efe3.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Hoist the kvm_{set,release}_page_{clean,dirty}() APIs further up in
> kvm_main.c so that they can be used by the kvm_follow_pfn family of APIs.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
