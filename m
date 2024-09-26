Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86001537A8
	for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 09:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727342313; cv=none; b=hNtod9zBHS/t57f94AA+moZ5VGrfVBlGBBlWBWxlct2qumyVHzj82AKOQ7es3G2ztzM4wiN70a1g0I1ybEh+9D8xpH4kh7ElyfkxH03a+c9sefFDlIHcc+tvrcok9k+BnbE6rm/8VNMzhdZ2PCwuELpwXZDIcqntG41RyZTvdyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727342313; c=relaxed/simple;
	bh=t+0HprDGIny5DyKaTjHjbUILv+CFyx1UMTMYlJdPpkQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n2mQj7xCq+MbT52dSpOEwGjFGjYZOoDZbU/alRoEl4BkNSxMZkQmrXUMW562ohg0c5a9z63qVeLcGwcpfZy9yvYDcO6W70dOJYon/ym/QBOmPjDcId1H4cpadQL6wZgUQ2+zHOtssYyd5V3MCUGyoBcru/PvJ57bF3pa9FHxaiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fx10L0DY; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fx10L0DY"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8a789c4fc5so317419066b.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727342310; x=1727947110; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+0HprDGIny5DyKaTjHjbUILv+CFyx1UMTMYlJdPpkQ=;
        b=Fx10L0DY0ZRPsPDKWh5op2rw3QSjdBtRv2Sfk5fUOV1nwjcpBUvz+j7epO1R7PoCDg
         5Sz2GdiUkvICSnWpqxLKoN/DSPcaYo0XsdfnXwdEQkNybHCXQ+YWjZgw2B69o0SjpXCK
         T3cR68heZoDnv4lfkqS3lOpFyn/0UrTIsyjfk6SPVNvjc6cmirYIqkAcUVAYy7dcV+/n
         vHg+KD87P9asZ1Dh5So2lupZs+e8DqJj0PijreMhYEvlk09KKod0HO/+a1GeheD3kGJt
         gjymE9VVM2nXTP4HLBcmR03P+jxsAo/mMPTdm4r/Wsb3wIxJeQ8Sv0YG27MTAFo7KEtA
         /4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727342310; x=1727947110;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t+0HprDGIny5DyKaTjHjbUILv+CFyx1UMTMYlJdPpkQ=;
        b=KspNoNN6Xh4U8/gpzbBxftm9iVnH1z89D4GJ8V1aeGW+EEXI+sGxZV+oU7j3b/pw1p
         li7ppGw9AXgkBtLiml5CeX/cxbq4Rq8dZVqunI07pSm8lsBnhOe1NsP0o0IXHH0RpMFb
         BBCF4TNmikqciNZV8QCbLjtVg9rjY6qaThvaZEJmjrrL5/d9UPQXF04NPGX+ei7pjHQx
         +YXC5ZnOL39auKgNewIXkWCdffmfEOGe5Dljj197wQoPCYEBN3yn7D9K9iQyPX11AVG9
         x/hlYYPH21d028xs/SdIkeyNv+4xgXRKtkkB5aD10nVkzGNa98b+qqOT7MRmvwPuUf1g
         SKcg==
X-Forwarded-Encrypted: i=1; AJvYcCUSZon8i1hAKqwF1y7M5SwsgOcxF6XnQrAck+8HAyNcApoQ1FwWZfXEJWMT/kjCigs9MuoJSFQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLTbb9bhjCkajfZbuoiZrJc72svNL8U3FW3YGf8cmdhkvrPkbJ
	ahhH38QFGNf1KJiNI358BZL2padQjytMvxQJnCQM28UjlKuCkIYz
X-Google-Smtp-Source: AGHT+IGpqNPJK1s6i2Y5LV2mdudC516wJ/Q9mIUBcozWq9rbud6ltBH52LHG9Vz2rsfEkWd93Kp+4A==
X-Received: by 2002:a17:907:8687:b0:a8d:4954:c209 with SMTP id a640c23a62f3a-a93b165dacamr300948466b.22.1727342309802;
        Thu, 26 Sep 2024 02:18:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:438a:71d4:3b8a:6ddf? ([2001:b07:5d29:f42d:438a:71d4:3b8a:6ddf])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93930f8440sm324989866b.182.2024.09.26.02.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 02:18:29 -0700 (PDT)
Message-ID: <21e5d209fa4c24c49dd72ba82dd6e5fc65bf52e9.camel@gmail.com>
Subject: Re: [PATCH v4 6/6] arm64: Use SYSTEM_OFF2 PSCI call to power off
 for hibernate
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Shuah Khan
 <shuah@kernel.org>, David Woodhouse <dwmw@amazon.co.uk>,
 kvm@vger.kernel.org,  linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev,  linux-pm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Date: Thu, 26 Sep 2024 11:18:27 +0200
In-Reply-To: <20240924160512.4138879-6-dwmw2@infradead.org>
References: <20240924160512.4138879-1-dwmw2@infradead.org>
	 <20240924160512.4138879-6-dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-09-24 at 17:05 +0100, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2

Can remove (alpha).

