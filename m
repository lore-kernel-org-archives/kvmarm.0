Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6BD1BC07E
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740603; cv=none; b=exqNL7/x+pKILbsrudG6KmXI8YiOPpLL4k5UV/I5OTQSjXFSSdMImN/GA33KEYaSfzn1XHYlx9tRfqSjHJqKS6G73ysUBXxEvFguEW7T9dIdlH2iiNkNjtjvkvtXP6glvcLoQ6tIP1sgY01LrVVfY9CqWgfllFNioBA9Hpo2DE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740603; c=relaxed/simple;
	bh=rFdMFrYFoj15tqQwMYYyirispPzAR+g2+flXApqn9fs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L+vHTlSQXNM+c67qeI1MAZQHItpGXIx81lm+54rNk6xSArg/esvudSFa1SK0LE5zzIbORileqB2whWlf08ztNPQl3+zUvlPBCSbc1R2Nw98WASx6vdPcxWOI/ROVLp4VOOwY8ZqoS//NBwLOc56hLvSWA1KFmhcOXu8CzPt++XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WTRru+uu; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WTRru+uu"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb4fa17044so45105091fa.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 09:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730740600; x=1731345400; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rFdMFrYFoj15tqQwMYYyirispPzAR+g2+flXApqn9fs=;
        b=WTRru+uuZlNxRbRmdpfrGcQaeMHc9dzHIiYbFJPN6JYGPBRm4sOELbsErDIZ5NH/fF
         NXG4WHvEUfcIhf4ZEAAFEwwu9COaf2w5oFcnOLtTYw1wvZqN/12old+UZUHZEA/3BRya
         7LglF7ewtJTrbR9jea0Har47l7tjzV/T1l5KqCj71j92C3xAXb65aY6TuFne+zYpuWbT
         BqNg7FdQWuKansrFvj1ZOt9Yigri6n+xS1y3xHPbFJXQkYfGBqPKeWPjaoi3uqqav9P1
         ItqVDfeJzGeO683UZ9xM7EOYKEp2kRROdNxXNrYbThSRMX33ALh6aYHVQme+Al0pLpwV
         zu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730740600; x=1731345400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFdMFrYFoj15tqQwMYYyirispPzAR+g2+flXApqn9fs=;
        b=eOB/eV5X3eikXJ9Mp/MMsJiZ/bQ0oRNIWnCn7xmNwHtGRgIQYkqjBZRWWmFoMWmd80
         1Env4zSvxzSLzh2ZT79sUM368hPiJAPqBc219cbV16AwPOnHuOKJUsvUcbDjq6fPfEPL
         nbxioHduq3clOxkp8Pq6lzAW9kQgnC6XRTjgVKHQQcyy2KnhaUd1Ww8J1noTWnk79Q7F
         XArkDkaikOyLAAKstAADYmD8kqMMrLGBCygIJ+FXIJ2P27msJx5WLKSuYdoNHT3AV4kN
         o0apIXbYoB46dYbdUm9bpg0xO1lX+yQX6AXuH1LYcL6anSFBXmDQ+aFTJR8FEGqVnHkA
         ZXfw==
X-Forwarded-Encrypted: i=1; AJvYcCVA56BFeYrKE9TgQFlORIRilPmrlABu8u6zE3QXs+XCaKJjafrrhobQw1WZD8U0zokPUTueDhI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyK1rSSIsLNCo0KZEGxzp1+JdEMHLypK7EBKJjk5pVJjC7am7qd
	LeMGaSDilhYHHJennuoj0bUYYAxBTDYcHPrU6CQmx2YIxlk3olTW6q3ajCV7UtIFB3wkG694VBi
	xJzxWr1YI0rGdwPMUcqCiKU9/5S/FWx9qcjKvEg==
X-Google-Smtp-Source: AGHT+IHqc//LHND71HOSioZxH9lExkg8+Iw31TJF5rdqABwfBOuOfwCGbLalw9AOmeFTDEbdLaw1Qkagq/4QeWTPqk4=
X-Received: by 2002:a2e:be08:0:b0:2fa:d9db:7bac with SMTP id
 38308e7fff4ca-2fedb757365mr58358051fa.3.1730740598449; Mon, 04 Nov 2024
 09:16:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com> <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com> <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
 <Zx-9WxXkmkMuGIlQ@redhat.com> <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
 <Zx_CU9eeQByANMRW@linux.dev> <6c05fc4e-ce14-4000-bb2a-63496bce9e98@redhat.com>
In-Reply-To: <6c05fc4e-ce14-4000-bb2a-63496bce9e98@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 4 Nov 2024 17:16:26 +0000
Message-ID: <CAFEAcA_XhkBrco=V3Ky+cgvyp3cwqHXjDkmm+dP7N2B2av03bA@mail.gmail.com>
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: eric.auger@redhat.com
Cc: Oliver Upton <oliver.upton@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, sebott@redhat.com, 
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com, 
	philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Nov 2024 at 17:09, Eric Auger <eric.auger@redhat.com> wrote:
> Was just wondering if all the writable ID reg fields were associated to
> an official FEAT_ listed in this feature list.
> Let's take for instance CTR_EL0.DIC. Is it associated to a given
> extension or is it just implementation defined?

CTR_EL0.DIC is IMPDEF choice of 0 or 1. There's no associated
FEAT_* -- as an implementation, you are effectively just
reporting here what your implementation's properties are.

(CTR_EL0 is not an ID register in the architectural sense.)

thanks
-- PMM
