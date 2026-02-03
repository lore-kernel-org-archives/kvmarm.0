Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6ED241665
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 13:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123634; cv=none; b=Rc5P/Yder3CT7qGR8DinMghkfgtHQbk9k42vbMju8+eMHKe/ey/N1vQ9MJxJFdcNIvNkdHPH3ItVjxxAg/VMAEciQtNg9QK9tSfQ76b8bXBzWC+iUyPx473Nu2HRzXf9oL+UfZuvFCHPJSyAnbgF+fLA2pvMaxBhmAUUACk3KVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123634; c=relaxed/simple;
	bh=QfrRwcFVbs7HXzfXIJF1G4CMBzqUTb6IXs918LJA2kU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YaCdqP6EQ0sN6ROlLj64CMufmgfWvd7it5iuU2H7CYUagYMA9d4+aQ2YRG9dDbq5JpecO5/6I52kFO6kb8CmjPJ77W3lFnMoa63oXh42I4S5jbZ4/eZbpgP/riryKgsDZuYokEL5gr6K6Kmz4EowumTvwVS9rz2RLHify25mBI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kbDvapGF; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kbDvapGF"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6582e8831aeso8595639a12.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Feb 2026 05:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770123630; x=1770728430; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfrRwcFVbs7HXzfXIJF1G4CMBzqUTb6IXs918LJA2kU=;
        b=kbDvapGFlNBTxEdTpPvyNkVAXP7KcxJZN/7UlNWbo83YiyT+ejpLv1rN1wqPdUh5tr
         AXIeKYFLY6OukNTgslWrQIJrrYPf/AQw/OofZvs6Sek7RQaOc0nEDg3IL4B0DGMHjz6N
         E5feRPPAT4JChyoJwkFSQYZH99/BeJGgpqJvHwoVlroMqhfnRzehR/i8PqL8LWNMo7FL
         Xy7jbkXBRx3rg4b90WXcC0lKJOmT1zylKv1AHgP0cimTPawEICXQ7KnOZDV7L34ALOeM
         LGHBBaOA1XqBYOAPdKIYyU3JGPWcNmIUC97VLYwhGTOTFnVtPWvgnlkhHplL/fL4b8uJ
         jEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770123630; x=1770728430;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfrRwcFVbs7HXzfXIJF1G4CMBzqUTb6IXs918LJA2kU=;
        b=ADZD9m3CwMZSLwVuJVqmpjHRGSfmpnguvS+0A58elvD5ynh9j9ngJn1PQaYlRQ9Omt
         oEuS4k+BSn6ALT0qYukPIYrFNV9krd2+KCpaiM5w3N7YpRGJ5zgwIQwsSsJ2Mu+MuK1r
         p897bM9Ur+Z4iL+YYSq93j9dXfYpcc3IL9bvme50cY9i9AoOb+pUsIiyfSTH9hsKj1Jz
         YMCvabjmapuuICxUI9gGZ8fuXh6iycNAiPoSHUyjAQIEEtC+sDSLiJTYaubj8wkN8wF3
         GxcrqAWsO0Qmil0OL6uItzOkl1Np6UwgNzFRh97b1kBTJ2gXrnsyAo2BYhRyS8r9Wd1v
         Nb9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2yAyQWRFx+WhL0jQlD15AK6pRLkjAF20yc9+f3FqTTNKk4SY/OnJCG/SPiTb+h+rzJTZ5ZDo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnwTT2+vy9cHWYJA9/RSC1JUEx7o/Vc74k2zKDeKaBnC07SZbF
	jADmSS0jKqObabNHOa+bAVmYFX90Ndv05Uqt97/yPOA5VzpLrl34tq1PzeK0UB7vPfw=
X-Gm-Gg: AZuq6aIdQZUMB6SYmAGm32K8eDZoiKPRU4ga8O0glMUwUNbLjJEcQr1U4+qZRBXvsU+
	szhghVsjbJvwhYYAFM9XpzXRsdeatGfcRuwre4JwQ3D9+pAL7pcWea4oJUlbkpVOmuLPl9Tp+Ru
	wLIY84CxQ6xf2IUza03KFrIZfYj9uEoto8/Tn6JEJvigkXk1t4FmSmTBcBhqg7cib2bKZMXvnTD
	oZjfdi0ZH4P3VK+YSgNB1D5Lfd7RfLCBJi+mwLgp3BOS2HaYAeNZJ8sIs3geKX41RaZ8QDFa+7L
	muvdWSwA69kGBLu1mhiVT8DPozTagjBFbSCLzjgMZXC/E+2CEcNO/wk/JmuS7D0dooXye5Dj8ua
	88y5aC6FX/uf9UeZJ/ebX2P2e4VFNDugoISghRP9ChL+NPle+zrkyUnV9pHDzfogIYj5ky98Xcp
	ifZ22wVkBFBL4=
X-Received: by 2002:a17:907:1b20:b0:b86:f558:ecad with SMTP id a640c23a62f3a-b8dff5260f2mr877455366b.7.1770123628657;
        Tue, 03 Feb 2026 05:00:28 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf1c5b38sm1024503866b.53.2026.02.03.05.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 05:00:28 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1C5C05F841;
	Tue, 03 Feb 2026 13:00:27 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,  Joey Gouly <joey.gouly@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Suzuki K Poulose
 <suzuki.poulose@arm.com>,  Will Deacon <will@kernel.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Oliver Upton <oupton@kernel.org>,  Dave Martin
 <Dave.Martin@arm.com>,  Fuad Tabba <tabba@google.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Ben Horgan <ben.horgan@arm.com>,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
In-Reply-To: <20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org> (Mark
	Brown's message of "Tue, 23 Dec 2025 01:20:55 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
	<20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org>
User-Agent: mu4e 1.14.0-pre1; emacs 30.1
Date: Tue, 03 Feb 2026 13:00:27 +0000
Message-ID: <87o6m6nfro.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org> writes:

> Update the definiton of SMIDR_EL1 in the sysreg definition to reflect the
> information in DD0601 2025-06. This includes somewhat more generic ways of
> describing the sharing of SMCUs, more information on supported priorities
> and provides additional resolution for describing affinity groups.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
