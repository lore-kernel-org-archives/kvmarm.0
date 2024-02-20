Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF7136B01
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 02:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708394453; cv=none; b=TSZeDaE0MKRTndt4LoygSyyg4BYGdUNOr0yjACaibzdZGBHvMLw66ZoMor5b9oigJVHMBidL+VTPZRENOj31HN4aKUa0ZBZ3cjy7+CCgCNTPez72OwnDaE/6cKWoZafu95ysP0XaUWJdaLYjgnvL5LlgktmBXtWINgreAe+BuFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708394453; c=relaxed/simple;
	bh=qiYCOBCXkZA+S1xJHN9t4SVRhSQ71ysKQ9Kl/44/lHY=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 MIME-Version:Content-Type; b=dm+BxGTJpmu4h8IIAWZ6yxXImNdvh33a6hR/g36YGtIycXKh28UpbiUVDU8qKnnYali0MiTRwYazgaTf4AtkuOwC8bBJ+wu96lyCOkDt8Aj8PvXbZmaVoDev6cB8Fi8S3OrgLZEtrDYaQk45d4MXFvkN6HjH296/hiNKAhhLsKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YxFeDpf2; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YxFeDpf2"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-53fa455cd94so3522577a12.2
        for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 18:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708394450; x=1708999250; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=TPVEuybRyh8o5XcrU4e2hriNxyZdgI2hibiqaIMVscs=;
        b=YxFeDpf2YSn/UiOKivgydgsNsNLAmoUrJ0cE1W9XKZB2trBiP0jUPh7hAHALwld/GF
         JcfNXKyxb9IQvLbzc+96IRQ/68leBKG3nMbIBlWlL4027c/WDM96DCOps/apznrLRCGh
         XQqk3bMxTr4PR8maM4NVJUvrSlPHbIhKWf9Ib+eOV0bKMBlV9W//BwSr1iVeoqxiTHuR
         dHeLuVQ6ExqTEEN5AiG7TxfeQvU35HqmfCqEfF2OaPMrs6hWC0aRyUve8D18TIr33jvP
         opWxFq76fC0omR5bZsARf9faUAm5hORwsbHLqQvBmnfTWKBsi332cICFgFA4MgiucDtX
         FN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708394450; x=1708999250;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPVEuybRyh8o5XcrU4e2hriNxyZdgI2hibiqaIMVscs=;
        b=wwqjkv88KNe+zCUSTXRblq376GNzlQ9G4sbWCDuwLi2TowUUuJ3H5XVi2xXohzALOJ
         HL4qOqkiU0AYHdUt0FTI62BrImsjyRrcrNr6WhMdgmjkVvvD7okijUlbudrXsyBC2WtA
         CzUvsUC+Oo9GwDERSAOXgIkA9mMrDbTMLOI2zx1xTLiN9zQqaCrKUfuYM4/IEPmbvPFX
         0CNdkQCfzZYE4SmGBfhnAZMtpyO5/pgOpYy+GrVbeejZB249PIyoVIgEO1A135KypDOu
         7TMJ0NjI8DCyRHx3SArVNeOJAlt6JAGESwR1jVGEcoCq/4Yz385rD9ow321Yn3RhOqmp
         rkCw==
X-Forwarded-Encrypted: i=1; AJvYcCUWZpTx3hvE0UIYAAdTxuj3Nza2L/0GfyDESsVhNgJYSAJnQQVoQmxDK7JM2wzumlReTIfb5bU7dAgYzulKjj+BJqJRacGh
X-Gm-Message-State: AOJu0YwaXgXXUTTabLsQtbOV8Wk2fDJrKB1Ot5nOd1UwjEW5R6YbYSmf
	dW+LixACSwZ2D16HIZ6Q7tJQpH7n78MDtRl8OKtM31GQFFEWN83e9/xNp75cohM=
X-Google-Smtp-Source: AGHT+IHQRCR15jZ5TkL4psb84wN2RgNzkdO9BEfcOkiOYvFiSNgotMA3Enz/ysz1JOMgmumVFviryA==
X-Received: by 2002:a17:90a:de0d:b0:299:3332:a649 with SMTP id m13-20020a17090ade0d00b002993332a649mr8755614pjv.18.1708394450582;
        Mon, 19 Feb 2024 18:00:50 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:a328:9cae:8aed:4821])
        by smtp.gmail.com with ESMTPSA id z19-20020a17090acb1300b00296e2434e7esm6167416pjt.53.2024.02.19.18.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 18:00:49 -0800 (PST)
References: <20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v8 00/38] arm64/gcs: Provide support for GCS in userspace
In-reply-to: <20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org>
Date: Mon, 19 Feb 2024 23:00:46 -0300
Message-ID: <878r3f99o1.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hello,

Mark Brown <broonie@kernel.org> writes:

> Changes in v8:
> - Invalidate signal cap token on stack when consuming.
> - Typo and other trivial fixes.
> - Don't try to use process_vm_write() on GCS, it intentionally does not
>   work.
> - Fix leak of thread GCSs.
> - Rebase onto latest clone3() series.
> - Link to v7: https://lore.kernel.org/r/20231122-arm64-gcs-v7-0-201c483bd775@kernel.org

Thank you for addressing my comments. I still have a few nets and
questions in a few patches, but regardless of them:

Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
