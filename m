Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0BE176AB5
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953971; cv=none; b=VTuhhMoB8n5mQXuJqzP08yMZvqvHIk6euspCVJOcPOrtM2lSAwucuuVO4q4bPChdB6DBvQcu096AOzpinkcaA4V6TsSa0ZxwQ5A13x0dYtINe+4DwMEu9gul8/BtkmDZOrzaLxkuLsYPj7jzeFe790S8nXTM7azmoW664Qsq+DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953971; c=relaxed/simple;
	bh=avpO/6PxMyc5TR2UUj2QAbs8LE8ZZX4Di9GS2nBfoV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eq416JuKoL+ytybJ2bz1KZELhyoHXRJkabwKq2UCAKYcseGBehZxhT3zV5PJAAw2N3KMIUwdWJa8qk4+my9Res4iBOI7jL/6CtgxgFMTHmWMi6QdJaTwLVlLw5oYcla/AW8XLd20MJ7ZSbm03uRCzdWruWJuCu/O8V9JTc+Quf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=btxui45I; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="btxui45I"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21f20666e72so51906325ad.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 10:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738953969; x=1739558769; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6PteMFpVHv0SCUiRxwY3z5U3KHwtSW68qytN5IFUi4o=;
        b=btxui45I0XruvLiSTvOBoe28Y5dwuQtWpCblHJBK9bVcTWdzAHIG4dPftDxZwbpdXt
         xZvJc25QXBiP3YZb/R2mOvbMSdKJ3Usard94/UPMMBcTq591/ZXZ5fV46usLcOLv/mJP
         L/LoW5t5gTnufwmBmH/69A2iU0N2zcXJhUaNeqb6fUaNuCsDYpNSc5FTCkE+rqos5eJa
         ubKS7lOJZoCV8mcjNHcaFn01Tf9CXPMBdaVAbsdbSIMJfHuExGF5tC+1P746I4iZKI8g
         MegwdYpTpklpQ9s1ssIzqGbzC5B8YlQO0AG7vUB2G09ctqoBNbJx37iqZ+giUK6sMuPE
         Xyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738953969; x=1739558769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PteMFpVHv0SCUiRxwY3z5U3KHwtSW68qytN5IFUi4o=;
        b=qpyu1906wZyUAPmwPdufHtVw8KN/AFmEGhVG1CPZ4oGYF//74ozM1czb32sQxStuZb
         4T/VvcxsVJCG/7kaFE4nQL32PuH2z97HigTFu9gu0XhbMt22NRm7DOqETHUYtxViJYIQ
         XboPguv2R6L226x6nldXPvUbdjeylDx7s9rUkNsLh3k4yKctvCwsYha9GXILvRMG8kNH
         ycdnGrvQQF1SmdFgAmsTxTTIcXmSe+hxY6Y/Z0rhdE2iXheM4X9YlBMQDA+QyyZG7du0
         gMQwBJYhhbD0aWx/UozK8VL50wemaXp3puhRyjxph5xmOHtGTSwgBelAtzTJy5EFwMcG
         1NaA==
X-Forwarded-Encrypted: i=1; AJvYcCXUYsfNwYlkbUFQjWVUTv/S1ubIXt1dZ9pRIYceH1c5X5SCiObfWpto4c81ieLtc4NUTfkoDjs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAb0ZsTLAK8Fpdw62u56yut8CpQVw5FhUUeqEcfgJdBm36Owpq
	sCaV1CHVDbZ3jH5rwF+WGev0gsWWB8/tgYmcP+om1B1tyw0jPIwwnOql8SIr5dI=
X-Gm-Gg: ASbGncuRT7vvsk5BUeXMGM/j5ALNsAIwcHSPUzbtzRljLEF5vjsAB9QCqXrK3dPxCOT
	cF1mmiHKs61YuMddVtyOdJIiuddpgPo34yerwcvXoeQaMeHRZzvWcXwkmn7cS2XZYPUi4CyWku9
	yGjvJLCEguhXRxrYWI2LD9Ei+lDVaXFaddcDOBI+BdQr9DBgF+IOgPffm33/m1JuH6ZhccTv6qJ
	Kst6aYiwqg/1Tr5eCia0EpOxRmct7rCpBMMsamurrovbGjQJ+tblpFA32TW8m0ARflm51fZPYr9
	v6/2ZlL1U1G94gDDY9mNt5PtXs3InGDJDegxVEZOPsAmBa/pUGJFzH4=
X-Google-Smtp-Source: AGHT+IE7z8k4qpfSIgulmraWJ0y3FHwwvM3DymgfLwIPAxfpkzc/fz42Ze2Wcb4MbiQNvOsi75Bzlg==
X-Received: by 2002:a17:902:f60d:b0:21a:8dec:e59f with SMTP id d9443c01a7336-21f4e7637d1mr58683015ad.39.1738953969123;
        Fri, 07 Feb 2025 10:46:09 -0800 (PST)
Received: from [192.168.0.4] (71-212-39-66.tukw.qwest.net. [71.212.39.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3653baa8sm34150245ad.73.2025.02.07.10.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 10:46:08 -0800 (PST)
Message-ID: <1af2d33f-c876-4c23-afb8-be63447960f4@linaro.org>
Date: Fri, 7 Feb 2025 10:46:07 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/15] arm/cpu: Store aa64isar0 into the idregs arrays
To: Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-4-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250207110248.1580465-4-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 03:02, Cornelia Huck wrote:
> -    t = cpu->isar.id_aa64zfr0;
> +    t = GET_IDREG(idregs, ID_AA64ZFR0);
>       t = FIELD_DP64(t, ID_AA64ZFR0, SVEVER, 1);
>       t = FIELD_DP64(t, ID_AA64ZFR0, AES, 2);       /* FEAT_SVE_PMULL128 */
>       t = FIELD_DP64(t, ID_AA64ZFR0, BITPERM, 1);   /* FEAT_SVE_BitPerm */
> @@ -1252,7 +1262,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>       t = FIELD_DP64(t, ID_AA64ZFR0, I8MM, 1);      /* FEAT_I8MM */
>       t = FIELD_DP64(t, ID_AA64ZFR0, F32MM, 1);     /* FEAT_F32MM */
>       t = FIELD_DP64(t, ID_AA64ZFR0, F64MM, 1);     /* FEAT_F64MM */
> -    cpu->isar.id_aa64zfr0 = t;
> +    SET_IDREG(idregs, ID_AA64ZFR0, t);

This doesn't belong to this patch.


r~
