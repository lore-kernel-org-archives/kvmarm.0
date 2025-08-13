Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ACF30146B
	for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 23:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755127655; cv=none; b=Ayk1U5+K1OrOzBZ/5izYsPL9jNkig5ITCRBSOb0YQceJcCMNlQiONe2vAGnpacIH3XA+V2sDVrLFeJ9tayFnsoOD1F4fhakh16I9/wyyFT0Rwq2OSfGNJ3yNafu8cgHa8VZ37mhRGtJeG4mC9kncpFPVV2P2wfYNYD4bzxcKunQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755127655; c=relaxed/simple;
	bh=n3zi5eBnDJxAq5Y1VMbs/IRUjVefPwWnMWHx3rHj+nk=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=m7wY4KeUL3JHYZhZJPtqcl2QR/GOBR2G57GfGXitY8Lg0c30C/9RJ8djMl0CU0gQGA4gaBWTxzyy/6y7UAht85AuCi2oDGqKJl7f3Yf+LosG9OOD2YwqxyGTAydFk3cHIwMx5ASqTzgtRuTJucsWzpFAGzamTMl7RcHeoHKEK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BtLG92gt; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BtLG92gt"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e2e5c0d4fso375463b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 16:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755127653; x=1755732453; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:cc:to:content-language:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=671X5sFGwqHEAR/PM0HKyNG8ZucV9LLOvqO6yHtGxIY=;
        b=BtLG92gt9Zs5lztj+mWdDyvGjJzJE2fD9CeX0l367tcJB91/PaYz0jWpG+P5EDplxF
         cga6MdMoon3rmSG3VEbuEdGnJu+RszOrieSTMwBxWVHzxcDwxjQU+DxFbRkI63WCLbRO
         e1PsJMiz+T9CydCLUuRbT68DlPsczkXuhZw9+BrRSWQeNY8ZjJGwk/sw5Z2rqTlNFdhD
         XceaThIRL0TubtyXHZaGy/+hh5lZfhIb9Z9rGiYC3aX7G5J1Q70a0W/C5nEtqJZaCFil
         wG0wPZdHCgfCtbhwnpjzn9VSJLAPWQ+c/hi92BL0RQZib4WSqpST0xBjv/cgoIQli8C4
         kP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755127653; x=1755732453;
        h=content-transfer-encoding:subject:cc:to:content-language:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=671X5sFGwqHEAR/PM0HKyNG8ZucV9LLOvqO6yHtGxIY=;
        b=lPswKbqcr+iVuDPqgdl5HIfQf8VV7nq3PTj2FZs8isrR29vxp7vJTmn9QDVOWVhyO9
         gehIGGFi/jeVYjnSexDSH8/GUGiVA9vSjYQXPENxB0NjO0e16cHF80dSSHpu2tisAjas
         +z8Bd+bmwYezIWtXJRIZRO1kdibWigiS9Q1ZQ8bMRe28NG4Uz3B8XkI9tHXACo53sMTO
         rh3e8u2NVTz/rbS0ZuVRJLAKSg88gBXFV3wCTb8Uv4FClJoSWJ6js/FknUmBEA15eOC+
         Ex9OyCmB5S1jhWF75biS8q8z3yeqYHnD0dwzq5bt+Lp/qmcIxownQWgu/PynLILaAVaM
         2dpg==
X-Gm-Message-State: AOJu0YxWMCFjPXT4vp1JFUt7CxugwTMjmJ2ti/2ZwnnoxVrn2pZYaVpq
	g/0X4sTvw1ar3/SRAXw5uLETTUL3XUYMKziNA7OgVo0bnjllCVGXczeFqdGvzzotckAJZIfCLPS
	SSjqg
X-Gm-Gg: ASbGncvSWz+5wUFTN5vrPIb+I6WfnBYr8JLzIFBtwc3iW3zv1Jhh3xnEC1UmFRNjKXb
	ODATudWKCCSDbJ+iX/2GhXqQbQ+XniiFcpz7/5re5KLjw/Uv3LFXejsqwpx7t9bUgSK1cumrCDa
	pP1LGABrwJWwG5nIFWl1p1cfmLgihL79EqpeDSkweVe8hWoYiTDyUnuR4XkXv9Q0RtXpIJ28G63
	PChzX5zohcgy27++zDjGSdO8vynK47ks7JbbKgzvo86YOcvOTKo0czAFvmOOOAsFCwfTbX+Zgaf
	u7hiJdeeiL9nScRsFSLblrkVamRmCfYI94KyUX4ttVEOKsf24BKHKeLpmk7pW2rjs/l9fP5MC0T
	r32IQRMfAQxKBXmSYZoFC0dV2KWZPYIXImfXdwqA=
X-Google-Smtp-Source: AGHT+IHLNkaJfIvv5CCD9tks/OXBzVDSKXibWWP3Z4/VR2Un3vGNBroCQpwE1UPfeLcXxPi8EvMN9A==
X-Received: by 2002:a05:6a20:7f9a:b0:23d:b341:c2a4 with SMTP id adf61e73a8af0-240bd28603fmr1161297637.38.1755127652631;
        Wed, 13 Aug 2025 16:27:32 -0700 (PDT)
Received: from [192.168.4.112] ([206.83.105.236])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfd88dbsm32941165b3a.103.2025.08.13.16.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 16:27:32 -0700 (PDT)
Message-ID: <1c6b4f19-6cb2-4da0-9acc-d63307880de1@linaro.org>
Date: Thu, 14 Aug 2025 09:27:25 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
To: kvmarm@lists.linux.dev, qemu-devel <qemu-devel@nongnu.org>
Cc: Marc Zyngier <maz@kernel.org>, Peter Maydell <peter.maydell@linaro.org>,
 Oliver Upton <oliver.upton@linux.dev>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>
Subject: KVM sysreg ids for FEAT_SYSREG128
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hiya,

QEMU (ab)uses the kvm encoding of system register ids in the migration stream.  As we 
implement support for FEAT_D128, it would be good to agree on an encoding for the 128-bit 
registers so that we can avoid complications with migration later.

I don't think this is terribly complicated.  Simply adjust the value in the 
KVM_REG_SIZE_MASK field from U64 to U128.  E.g.

PAR_EL1 (64-bit)	(__ARM64_SYS_REG(3, 0, 7, 4, 0) | KVM_REG_SIZE_U64)
PAR_EL1 (128-bit)	(__ARM64_SYS_REG(3, 0, 7, 4, 0) | KVM_REG_SIZE_U128)

This will currently be cleanly rejected by index_to_params, resulting in ENOENT for the 
ioctl.  When KVM grows support for D128 guests, kvm_sys_reg_{get,set}_user can select the 
read/write code path based on reg->id & KVM_REG_SIZE_MASK.

Comments?


r~
