Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2A1487CC
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 22:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723069914; cv=none; b=tkF3p5TjiUOYeP2NhJ0zeakItc37o7KdqGFJcBjeZPe7m2xwd0ShtEKip0CRlRFt4tJwQl+6m0lYkQArlmlCUEW37sbIlEmSsyfQV2jNc2uRekkK+VdTR/Pi8o1ccjdIj0h1VAgzBxeFkb/NcOeHi/L7+PFh7amNc6NV1GQOut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723069914; c=relaxed/simple;
	bh=lt01zfKu7+RvwlQbSg6i9IaxHABXiXlAJBTgnDtOuJc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZoXisWR6YJtHVlbTR4Wjhjq1/hYMs+1muLvS86QkMCc0JFt7uypdmMtqGpMHkXGQ59K7D6W3LdiR21x4rv8pjzsRhILQHsnwK6afvqQLcT5H7XQJZNyMxlno2XhRp6CSsmQuN5mviQNwhWguC3SNtS2MkQgu4+SrvcjVZcjpyOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L8tAnjxz; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L8tAnjxz"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fd9e6189d5so3945255ad.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 15:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723069912; x=1723674712; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Eqn3LooEfKQSn1SPZrgXd7kK5ryU/WoLiCmXsEwtkWo=;
        b=L8tAnjxz8nd0dyh0GwpO56ZujhjmGSi0mN10P7QNh/oCiZoqBYjucirbEi41RTCPHT
         fgs65RuWjDhszi4HEH7Dpivvs4xJ0Fbcoyf4k1UghWPExMLyTsi9p62LlT1XlqvHoXsT
         ndW3eVFZuUHrYgNXTp8QhbhTjzSoznFLnyEG04MkgIkITjeH74FkUZ3m4fuLWEKshpVL
         fZFAJemU1cPSTIHJNMZLUz3iNkRb/bDKmpO/mKiTqJaqGHTrSRqlcSGUR3JGct/6pIiT
         hwrTuik0sXPMQVxU6CTJQWHP+ORiME4NY0Ct7F1Nxg7isJgjPRZmCMMSTFCOwWdvWW4a
         LwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723069912; x=1723674712;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eqn3LooEfKQSn1SPZrgXd7kK5ryU/WoLiCmXsEwtkWo=;
        b=t99t/qnZBIR3o0lpYc+hB8RHLstCu2HAHp2uWkYRr/VUa6VAep+aHNzx29zC+H2bta
         pgI++weiuRpNMm4pPp/uWi6BoZ0aoCBpsnqzqwilzqTayQ4QQAG/ecb1UhymHAWoCGrx
         g3yRNl2bEPxIYlPrhdjZOuPvDDanNgTDwrKvO2sfzdOr0hHixu3HXRx90GJGN7hzTySJ
         NzoHrMhTeLyZRn/GLi6okMvhYpEfBexOk5qSi/dslV7kz5+ZQQxllIeqZzgwQD0s34zc
         /hx/RBZATAcyDsQW3C45BxSqkClsqnKyBmECZKH9fLjx0indIDodsFCtSnNA3vXTyG1a
         ZWHw==
X-Forwarded-Encrypted: i=1; AJvYcCUSit1vWgu49hTIzkhGHGvs/BLYjuB57QmwOEsH6FFqWk3nzAcvFxPk19wIdX0ONjzVLwZqncENoG4vSQybwz1R2iuB68M0
X-Gm-Message-State: AOJu0YywHXbU2FIxoxZvXtTO+CwTMFjr5nhgX2k9Ao/Ei/v61UzlC+K3
	wZd55lsw+5AG/DAb3q7/o0gJTL2rth1l8BbNj+6bDk/ecYj4GinIgYLP1hoeEOQ=
X-Google-Smtp-Source: AGHT+IHHjhsk2z4q9vmLjR7LsBMy2oppwwN+j14R3XW5fxPpM7oxaFufcdUW3gDCZ50Rjxk+EmoCcA==
X-Received: by 2002:a17:902:d2cc:b0:1fd:6a00:582e with SMTP id d9443c01a7336-200952641bemr1402985ad.30.1723069911749;
        Wed, 07 Aug 2024 15:31:51 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:6c30:472f:18a6:cae1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5917767fsm111712115ad.183.2024.08.07.15.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 15:31:51 -0700 (PDT)
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
Subject: Re: [PATCH v10 34/40] kselftest/arm64: Add very basic GCS test program
In-Reply-To: <20240801-arm64-gcs-v10-34-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:07:01 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-34-699e2bd2190b@kernel.org>
Date: Wed, 07 Aug 2024 19:31:49 -0300
Message-ID: <87o764dkx6.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> This test program just covers the basic GCS ABI, covering aspects of the
> ABI as standalone features without attempting to integrate things.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/Makefile        |   2 +-
>  tools/testing/selftests/arm64/gcs/.gitignore  |   1 +
>  tools/testing/selftests/arm64/gcs/Makefile    |  18 ++
>  tools/testing/selftests/arm64/gcs/basic-gcs.c | 357 ++++++++++++++++++++++++++
>  tools/testing/selftests/arm64/gcs/gcs-util.h  |  90 +++++++
>  5 files changed, 467 insertions(+), 1 deletion(-)

The basic-gcs test passes on my FVP setup:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
