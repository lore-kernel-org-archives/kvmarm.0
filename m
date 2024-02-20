Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741AC3B2A8
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 02:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708394631; cv=none; b=RiYwt45jRfpK+tvm+BvGhcbUGAa0rsxKdIhbL25D9sOXuULUXihbgrJYf0nPfT74DsDJlsNmNHNaaKuIK6NEqmw5RRR0h9p1MV7vys4Hx5VdLMhttFnEvEPaT9fbHvfppDG98gAU+j6uSAIjz19aotCuUbRkWnCt1bDKp8fA1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708394631; c=relaxed/simple;
	bh=tl0G24XOjbGzUHwVuSKAML2L5w2w/ukL5jhI0xL8Wbk=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 MIME-Version:Content-Type; b=U0GXdL/PGx5hIROnSNdFoJe4Cf22FVFo9CYuIDr1pMCcNSBEwSx6v/a2QxfjDZsQwQArN0ysWJxxbwryuN8+ELxoadgxr4QbgZEbbt28xFG6Qo01rRIkyUgwRPpYYpyqA6vaVBNizqHh44NetBq2I0gMPQJc3W+VHqck8UmtT2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N2d27Txt; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N2d27Txt"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d7232dcb3eso26222225ad.2
        for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 18:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708394628; x=1708999428; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Ut8HYrvCDFac0esrbFqk2cfgA544kkLlPQaAT6Wttz0=;
        b=N2d27TxtZg7UToSQLaRHKXCyRIX/YcsBFhltv1ng7SWDBTi5JROwyihqfIo035K7d3
         lIV/2EnWisM/ApDmfx/xNU27Qhk/2kNoSJHq8VmKPVe8B+K72hd+Z/WOEq7tgws826SS
         Z1LqCE0kDrJtadsDLISOsvFswgkSZZSW8xi9cYeEACvuLxa2Sv+yEqmRvy/nRskemEbb
         1dzQ3tmFPX544zl8+h6AkskhH08pQ6GnzqHYdHb5CTv8LTCk2wDVV/0S0qINtrxf5i62
         3eQuqlrvc8K+3ZGG7m785GntAi0jJ6Y8zeDI66Ib40cnSD9ielnR2ptKmXTX7SWTOtCs
         IHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708394628; x=1708999428;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ut8HYrvCDFac0esrbFqk2cfgA544kkLlPQaAT6Wttz0=;
        b=fV1au6iyqaGHzgFL6E831OkT8ss+Oiq09F89O/haWFmp1V522dcJXpyZa0gAZxAJLH
         LtQW5CXsCLG4TkpiL9Nj80kwtHgf/i3avQ6yniTBXl1kSbB3x0iCEfoiQWjXeIa4T8Ev
         j7dp3XIsTpjzNmfDXSKRLS1ejen4hqyrEId6rVtlGpWgrDGu2ez1CbFs43Lx3aKk/bok
         N7sAdborBuMaTcFdmEMx0oXsV5Gj+dvb3wskfSrHi3PKfLpMG0CoS7O9fQ3eCIIZcDim
         /jiGd6sIZM35QQFKehJknnJCZil1NDEXM9elB8rQM6gCiooXQMRnQMhgQOr+TYDqMJuo
         k8Wg==
X-Forwarded-Encrypted: i=1; AJvYcCU9Tr7YjMJIyUFoyy3Pykmgjh9zvXKPNHEtoAf3OMsEcfR/qqI8tNg7xdEt47qsTKh9dtxJtmQeis6zvUAaWKffQQ61dXNt
X-Gm-Message-State: AOJu0Yz4lmDyq5N9xDhyNgNP/waFc1lsJCg13YpmR4tKhPubh4x8hRJr
	gij0LBSEn4szoVxQJezzSpP8x8Lt3VS3y37iSwNRewzP/tEmVV4C9CtyeXVnSSc=
X-Google-Smtp-Source: AGHT+IGPIHUy8hPqScHiSoGgxRjrCJE9JJnAWETOMrecbYtciaMsbgwu6AZ9cPzFGRlUwvHmQwNF1w==
X-Received: by 2002:a17:902:e5c3:b0:1db:fcc8:7d96 with SMTP id u3-20020a170902e5c300b001dbfcc87d96mr4258933plf.14.1708394628501;
        Mon, 19 Feb 2024 18:03:48 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:a328:9cae:8aed:4821])
        by smtp.gmail.com with ESMTPSA id kg3-20020a170903060300b001dbbd4ee1f6sm5058425plb.11.2024.02.19.18.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 18:03:48 -0800 (PST)
References: <20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org>
 <20240203-arm64-gcs-v8-23-c9fec77673ef@kernel.org>
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
Subject: Re: [PATCH v8 23/38] arm64/signal: Set up and restore the GCS
 context for signal handlers
In-reply-to: <20240203-arm64-gcs-v8-23-c9fec77673ef@kernel.org>
Date: Mon, 19 Feb 2024 23:03:46 -0300
Message-ID: <87zfvv7uyl.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> +#ifdef CONFIG_ARM64_GCS
> +static int gcs_restore_signal(void)
> +{
> +	u64 gcspr_el0, cap;
> +	int ret;
> +
> +	if (!system_supports_gcs())
> +		return 0;
> +
> +	if (!(current->thread.gcs_el0_mode & PR_SHADOW_STACK_ENABLE))
> +		return 0;
> +
> +	gcspr_el0 = read_sysreg_s(SYS_GCSPR_EL0);
> +
> +	/*
> +	 * GCSPR_EL0 should be pointing at a capped GCS, read the cap...
> +	 */
> +	gcsb_dsync();
> +	ret = copy_from_user(&cap, (__user void*)gcspr_el0, sizeof(cap));
> +	if (ret)
> +		return -EFAULT;
> +
> +	/*
> +	 * ...then check that the cap is the actual GCS before
> +	 * restoring it.
> +	 */
> +	if (!gcs_signal_cap_valid(gcspr_el0, cap))
> +		return -EINVAL;
> +
> +	/* Invalidate the token to prevent reuse */
> +	put_user_gcs(0, (__user void*)gcspr_el0, &ret);
> +	if (ret != 0)
> +		return -EFAULT;

You had mentioned that "ideally we'd be doing a compare and exchange
here to substitute in a zero". Is a compare and exchange not necessary
anymore, or is it just being left for later? In the latter case, a TODO
or FIXME comment mentioning it would be useful here.

> +
> +	current->thread.gcspr_el0 = gcspr_el0 + sizeof(cap);
> +	write_sysreg_s(current->thread.gcspr_el0, SYS_GCSPR_EL0);
> +
> +	return 0;
> +}

-- 
Thiago
