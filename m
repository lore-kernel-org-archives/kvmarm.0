Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DCAEDB
	for <kvmarm@lists.linux.dev>; Wed, 17 Jul 2024 01:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721179298; cv=none; b=Qhl7MTzGYnYemSj8ix6B2bS5cXwgS4byjXvu2SW9ZS86YU0T0F6OdTqNI83C76drFEWjkpYyVe2YF52VtI9oc07Dn0xW51NXc2vNLUrwYhuUvUXtAUq8ji8rI3RW1MPDQqcntZP+TrM+I1bVFeWSKAFcQI3NJiH2aZ8eBkJhEwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721179298; c=relaxed/simple;
	bh=lhXGzSMA/JZRKD/aeyepBh11njIMXYWpRmumnS6D6Rk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VL1C/d8nLJWz6EO1kk1E1p9/cKB+0+ldrc5pdjrk+ulmG7AVVZua5NDaJk5RgYbAKBBw0AGAp6p1NqDtgeRL0VHvxc2dbAt8j9RZIU0WqTq1Hk10UG8PkMEjYcNGhTw5MYSKuWT/rGQT7KEWY9uWF1gD9IAGPEwTgXB+Xcj+3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zd/ljHA0; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zd/ljHA0"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-376266a65c8so1798015ab.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 18:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721179296; x=1721784096; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HxSuTpzy0m4oHhnzHH3Vl/gMhNpkpWEzqeVsFcwdgKA=;
        b=zd/ljHA0oRqEyAwN6DXZtdmxNxPRda25TZWpCE9aObmv1eTZRaAcbqYv3MUHsbWwDh
         +Y2ve3zS28lAdK2lI8l0gWr+MqGKLll+tH3IP1cZE+qGBSgIUA1wrU92lKtNwmTXF1P3
         54WqCwZTsgw7oHfhR2AgQTT0nRsEYs9vDFzfi5kkSOETU0tBcuSxW/wKx5ZIkdqD9Y43
         NS3k23l5qrkMeoHWH1VMRKSl8POFkeZPwgYki0WrBAeSEj75nmUua6Ago3e+8PHGVraR
         YKauygjqSgAJtXBX+QIw9Kw5Me+gTHxs5GJX6AOhY4XDre3phi30mjFA4h6yZDiiCTXv
         94AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721179296; x=1721784096;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HxSuTpzy0m4oHhnzHH3Vl/gMhNpkpWEzqeVsFcwdgKA=;
        b=IGwqATeW4Qp0OacLdBmXuTzUoKS9A+aRwWRsMAe4J5JTwnQzJ+C2FrTBysWL/b/ObY
         LpTvydk5ZmFbhPQJPcD3P/yU3DPsfX+w61EvuOomJC8y5eCe5/aBoZk8quNIvtSrEa5j
         X1w3MqOJuZudWFWuyVa+EIGXH+6j4gChXAZABgWgQiJ/GZV7oVcKsaPFcefODGKrlWGn
         0ahdhx+J/eroFzJ2iTDJVu/5yiZzQPssScssZrj20JS4Onpt9do9Vj7NuH/fTepsP6SX
         LvpQUHU9bIPzx5NegVm3LZfKXyZyfOjPKCt5nWUUiWthyoj6pDBm2fwY9fg8oracdsxN
         sJCg==
X-Forwarded-Encrypted: i=1; AJvYcCVReSY2zqIK/ADbye9oFgucT7yTbG1+vbLNIOBPRXKKiIR1Mt+xolR3ZJzZKsCVn6xAYEWeF82boRxWNcDtTzBouU9n+gql
X-Gm-Message-State: AOJu0YyqfjwmsDnAx6k41qiv9X8s3VfqbNoP2AxRd5ZlxSrhbntlCFwy
	GJeZ0k3aRds42wqb2FHA7iXd93+Rdtz2MEj0Jqf5VBwPoKIZwd097ft85HUu8ME=
X-Google-Smtp-Source: AGHT+IFRPVkYVOcZWv1UNdg1RTMru4FboqdZLxvXpxoWV2PdP22CoQ+3xARnx+an75M9dDo1WCR1/Q==
X-Received: by 2002:a05:6e02:13a9:b0:381:3989:214a with SMTP id e9e14a558f8ab-395557ffecfmr5071635ab.10.1721179295925;
        Tue, 16 Jul 2024 18:21:35 -0700 (PDT)
Received: from localhost ([2804:14d:7e39:8470:4ae3:bddc:48f7:36a0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ec7c5ddsm7023267b3a.124.2024.07.16.18.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 18:21:35 -0700 (PDT)
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Andrew Morton
 <akpm@linux-foundation.org>,  Marc Zyngier <maz@kernel.org>,  Oliver Upton
 <oliver.upton@linux.dev>,  James Morse <james.morse@arm.com>,  Suzuki K
 Poulose <suzuki.poulose@arm.com>,  Arnd Bergmann <arnd@arndb.de>,  Oleg
 Nesterov <oleg@redhat.com>,  Eric Biederman <ebiederm@xmission.com>,
  Shuah Khan <shuah@kernel.org>,  "Rick P. Edgecombe"
 <rick.p.edgecombe@intel.com>,  Deepak Gupta <debug@rivosinc.com>,  Ard
 Biesheuvel <ardb@kernel.org>,  Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
  Kees Cook <kees@kernel.org>,  "H.J. Lu" <hjl.tools@gmail.com>,  Paul
 Walmsley <paul.walmsley@sifive.com>,  Palmer Dabbelt <palmer@dabbelt.com>,
  Albert Ou <aou@eecs.berkeley.edu>,  Florian Weimer <fweimer@redhat.com>,
  Christian Brauner <brauner@kernel.org>,  Ross Burton
 <ross.burton@arm.com>,  linux-arm-kernel@lists.infradead.org,
  linux-doc@vger.kernel.org,  kvmarm@lists.linux.dev,
  linux-fsdevel@vger.kernel.org,  linux-arch@vger.kernel.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-riscv@lists.infradead.org
Subject: Re: [PATCH v9 05/39] arm64/gcs: Document the ABI for Guarded
 Control Stacks
In-Reply-To: <20240625-arm64-gcs-v9-5-0f634469b8f0@kernel.org> (Mark Brown's
	message of "Tue, 25 Jun 2024 15:57:33 +0100")
References: <20240625-arm64-gcs-v9-0-0f634469b8f0@kernel.org>
	<20240625-arm64-gcs-v9-5-0f634469b8f0@kernel.org>
Date: Tue, 16 Jul 2024 22:21:33 -0300
Message-ID: <87msmgu82q.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> +3.  Allocation of Guarded Control Stacks
> +----------------------------------------
> +
> +* When GCS is enabled for a thread a new Guarded Control Stack will be
> +  allocated for it of size RLIMIT_STACK or 4 gigabytes, whichever is

s/4 gigabytes/2 gigabytes/

> +  smaller.

-- 
Thiago
