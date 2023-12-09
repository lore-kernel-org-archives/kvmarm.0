Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A4156DB
	for <kvmarm@lists.linux.dev>; Sat,  9 Dec 2023 22:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wGgwNhiP"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3b9e7f4a0d7so1557538b6e.1
        for <kvmarm@lists.linux.dev>; Sat, 09 Dec 2023 14:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702160904; x=1702765704; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=GIZ+mcVI5qd9xzhqd2Lq/djPmsscI/1vsqmZHAfk8NA=;
        b=wGgwNhiPoV4/q80dwUk3l4dMWkY1IxSUgifaUta1u7q6Hb4b2P3609kEWSOpysFsaH
         7z3Oc2pMMh/GRhVQ4/RG7FQuRiD5MIZjydhvB5hUJHUuDjuMLMGjReFaIx3UHHJBzSq0
         SuLvUEhEe5o4U8AdS7gyMRsOAWR9znuINKnSGNGyac6AD3lRuJWYiQB5PzfuR4JxZ/mY
         U8Ue51dly79cgjqyJXTmMk+DUYGPSTVEv/XlhDai056GI0fNxeXeHos23PhahRrrcppY
         q7LnCl/vyIbzR+1aLq/ss8EwfVLOE6Uo3rkIRfSKXf86ImvdH5BxKLv0aO1RBhsswYOA
         +nTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702160904; x=1702765704;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GIZ+mcVI5qd9xzhqd2Lq/djPmsscI/1vsqmZHAfk8NA=;
        b=jjg9HxuVONBo7YLYm1lu586tyStko+Zcalv0Yw8HyEwyFmQ/UZ3K1zc3EZTnxP5r7/
         63IFE3UoSubRv8rr2ecteoQQtM4hV+CkjfD0f7k3Jtinjd52gvWadGTmmbjDibFhTDqW
         Z2yTlMxfkppGLH/zEQcj0stDWQNIaxwbS1i9XTQkN01IkLZb63V9kI1ZhtNtE49ZBxtl
         fT6oHq8+RFrcCc5rEDpM970tdTSvu1UFNZG1F/Jr/bG+7UIsXXll3OKyKPvZpJjEb6m2
         qRVODxYghb2Y75M0bPWx33FGi4/WR8fVzhHTOZmq28PgZ9DcXhZ8MfLPdINwKhILtLVM
         RjQQ==
X-Gm-Message-State: AOJu0Yw7Fcz0RMCe3Nbtn9hF3yGky//XlyTJ+DM4fO6c+NeFNIMpZTMg
	xPR5xKr3lfuV6wI1oh40ZzU/sg==
X-Google-Smtp-Source: AGHT+IHe/3Q7T7mqAS39AMZy9ESnpkNFM6q37u24Z3u046keYsm8BlHmxnJkG9/CppRHC9PxpHjPRw==
X-Received: by 2002:a05:6808:21a6:b0:3b9:e87b:d963 with SMTP id be38-20020a05680821a600b003b9e87bd963mr2922446oib.85.1702160903962;
        Sat, 09 Dec 2023 14:28:23 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:ded6:9593:9f4f:5c29])
        by smtp.gmail.com with ESMTPSA id h17-20020aa786d1000000b006ce7ed5ba42sm3794269pfo.171.2023.12.09.14.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Dec 2023 14:28:23 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-25-201c483bd775@kernel.org>
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
Subject: Re: [PATCH v7 25/39] arm64/signal: Expose GCS state in signal frames
In-reply-to: <20231122-arm64-gcs-v7-25-201c483bd775@kernel.org>
Date: Sat, 09 Dec 2023 19:28:21 -0300
Message-ID: <87sf4bf1tm.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> +static int preserve_gcs_context(struct gcs_context __user *ctx)
> +{
> +	int err = 0;
> +	u64 gcspr;
> +
> +	/*
> +	 * We will add a cap token to the frame, include it in the
> +	 * GCSPR_EL0 we report to support stack switching via
> +	 * sigreturn.
> +	 */
> +	gcs_preserve_current_state();
> +	gcspr = current->thread.gcspr_el0;
> +	if (task_gcs_el0_enabled(current))
> +		gcspr -= 8;
> +
> +	__put_user_error(GCS_MAGIC, &ctx->head.magic, err);
> +	__put_user_error(sizeof(*ctx), &ctx->head.size, err);
> +	__put_user_error(gcspr, &ctx->gcspr, err);
> +	__put_user_error(current->thread.gcs_el0_mode,
> +			 &ctx->features_enabled, err);

Other preserve_<foo>_context() functions zero the reserved fields in
ctx. I suggest doing the same here. It helps with backward
compatibility.

> +
> +	return err;
> +}


-- 
Thiago
