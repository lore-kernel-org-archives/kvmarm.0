Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75910152787
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 22:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723069607; cv=none; b=ItoBw2QW7n4z1GqvrsAl87ab5OEfu3gE9I1zHFiJrs3htAFufeweHJdDcxs67buXPuI3ouzl7OaHDQaTs86WK7d1fffkgK/GljkK+C04dAsS9BiIgYrcg67P6/lpCYq5tV4uw3DLnxI1llyfTleyMP22c+wT2FrOJ7Zcmzp/yNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723069607; c=relaxed/simple;
	bh=32biW44HjRkMPGPPp6hzCLrqIC8l+yMka3jm4zZkurk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hGJjivdnOWGbqTbeH1LpVH37wxiecKBnDj5zvWM03ONVktICoOppSft/5e9IvVUA0VGs+6bF6qQ/FaQGgF1s4/Cv5h5NX7wS/+FZI2Up/DvYDhnu+0K0+0prduFvFwGpNV/wvfiWqOfSIb2SU787PqKx6qC9tn21ay5X2mnLmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qDA1qQhC; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qDA1qQhC"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2cb510cd097so336332a91.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 15:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723069606; x=1723674406; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=kBIy/YIYmaABmQA3j9o1k99kZxl3FitdDB149roFRGk=;
        b=qDA1qQhCdsjg4Sb57YXh8CyiLmAjtD0m0KjhE+g9K9oe3DguXhGn7/JQvkOoWd9mtI
         ci7Kj2PfyVxMzZJLBTrs1I7keNCHd69epBTGKU1altOXHe/Dvu8xQWVUFXJ6MIBnk5Yj
         mOv8BBTKsIY07fNvO6DL9wSXTUOR0qhMoOS1rRRZBwuVVoAObsiRhZMsIRIi3RZ4PRV/
         KjfK9i9eAwaDtqmizdpjYzdwo8XOiyEQJ5p7j+kS3ARr7OZbFAMS2MCrV6eE7SLk9xrY
         6DgLJ99kTca+BIwuVcvNBzla0vL5lXW3NvhZHsm/8jhMpLFSmA+dgy3+Tg1ySG2YB/yU
         gM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723069606; x=1723674406;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBIy/YIYmaABmQA3j9o1k99kZxl3FitdDB149roFRGk=;
        b=f+U+uX0nXmfVMvJjogovUtydBJoKONig3RjkXinbHKJZdnb8Lp5bMbwDCIkIknZLwC
         UKLfDY+su4ZZC9UsAmbj7O3vdoxvfhQM3kfcWeACUzppcf1TqS+dgN4/K0ASi8UOhehO
         NLzS0A1D90MZTI68sploMVD264esrfiRgHvBupvZ+V5YPYsgZsy+llDPVQOWu3zWSOYv
         VDn/D5/DujKTUJncTj7gblTnKvziSjlvcnMU8qpKaxKNfFTCXAnMxFkGtfUKW7kx4wLT
         YX5YVe83wKkbihKlNHmW2H5rypHFF2cirZ2HiNN6/SFFAaEa3Db98brUCdHIh+ZW/325
         bEcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgBZfiwq6sZpWD+JYcP3jcygam4H2WeF5dSwy9nI0HaRRlknx2x+xNMKzU8JQlQNfp/SIP9rFK0fhBsX2Cvv5Qommj3a+e
X-Gm-Message-State: AOJu0Yy+0ou9tvWEpX7kMTRZsOfR6lFAAzAeTSeGkAQx0Ep+K++VKJmq
	Jl2VvG7kOgee1wQlqXmIJLQEF3oJxwmbJR1QZ8flRvvvO7W2uJyAMSzqLnJLEiU=
X-Google-Smtp-Source: AGHT+IGd6zBFgLdZrc5fpXn4Fk0DlJIehtL2v1U5+1wFJBUpqiMspCMgOYDP5uaNavgy/IJn72zPoA==
X-Received: by 2002:a17:90b:2350:b0:2c9:7aa6:e15d with SMTP id 98e67ed59e1d1-2d1c33d4a01mr27917a91.20.1723069605605;
        Wed, 07 Aug 2024 15:26:45 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:6c30:472f:18a6:cae1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1b3b59ff2sm2100472a91.49.2024.08.07.15.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 15:26:45 -0700 (PDT)
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
Subject: Re: [PATCH v10 29/40] selftests/clone3: Enable arm64 shadow stack
 testing
In-Reply-To: <20240801-arm64-gcs-v10-29-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:06:56 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-29-699e2bd2190b@kernel.org>
Date: Wed, 07 Aug 2024 19:26:42 -0300
Message-ID: <87sevgdl5p.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> In order to test shadow stack support in clone3() the clone3() selftests
> need to have a fully inline clone3() call, provide one for arm64.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/clone3/clone3_selftests.h | 26 +++++++++++++++++++++++
>  1 file changed, 26 insertions(+)

Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

The clone3 test passes on my FVP setup:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
