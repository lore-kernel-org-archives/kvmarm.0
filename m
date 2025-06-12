Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAD6299AAB
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742623; cv=none; b=HnuKeOF3VNhe9f6XliAr483v0jfWN1RPmtIFHlxmnENROborytSNmwivV+h5iYwmRp+YHKYd/mkdgCOn9uWP4WzMHPKsebFzgwjd12hUeYSG+zBuYhDU5dMlmraZFSJiI4VLqJ8Q/YjGsXnlebKePWwdTC+30sONuAXRz4PI8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742623; c=relaxed/simple;
	bh=wUzfaRCNXWxAipjWVnsPLleFiVr/W7oIJEdJrgXZxBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WYMcNOqPgodI5cEYByoA0xB8itLmmKiwfORFP3ycu/t610giRCHxz+9cw+Exi+zN4qLStoLLpba+FHN469RsvGX1cuzox5FGr9PD3a+nZcNWg2upSRQevFK+F2OMJpIgkuo6lUf/7lQanR/8De0m2lnACMXEaFwGXyNtqQgJi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qr22DKka; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qr22DKka"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7113ac6d4b3so9421447b3.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749742621; x=1750347421; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wUzfaRCNXWxAipjWVnsPLleFiVr/W7oIJEdJrgXZxBQ=;
        b=Qr22DKkaHUv92MaL+HwIt5wEy3iffq+RsXqnIhsaJSZjXbJF5T/LPHuLeCTTEiPVn7
         96Z8WXYFHW2mZlq8AzeW5ybqntDzxeLbj/0ca00ar+3vR3cNS+wVbQfuo66K4HWYQnZm
         iaMAm34AMDlLWRnf/AMy4lEC/aFwJKW2S5ie9OOA+QQPr1fWdEujASbiCGujlJAK2ehJ
         g5gPxWQaLwpzoCGBc8qdfQMDQg9dRtKbcGIUc55q/xfyCCtOXBODkkMuX3EZAMLoK7b7
         N0DbDTUa7OiLI2RqAzYfshL19Fy5pWtOWir2M+Y2FGZ5W70FJu7tlqa8HbXeMdg1GEUT
         w06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749742621; x=1750347421;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wUzfaRCNXWxAipjWVnsPLleFiVr/W7oIJEdJrgXZxBQ=;
        b=wCwG61AjqeP2FhJR+jgdfgeLFszfwXDwJKfdfRFEnwMdzJIAFVBfnC7psyspcjjkUD
         XYjtxwY9HcXUDSCYfXJLfwPJ7oVP4rZR9Xvb9nGwtLTq+W6e/K5kd+A9Wr42oNnAjvc+
         76tkJBah57fGFdzfSC592DN72ieZ9yhkxd4ugflvYfabfxEJaEZKXvdWZRIyM47w6SBe
         C5/XO05eq//yAdyLH/0I6Gjffzmo0XLXzINCst9WXSn7Y3t/Xm0dIHkGFANfd3qwZdTG
         8BsFtFf57mLD0cyjj1PutKbPlUbM+6pS6w4mCsnbGlt6XEVQ27VEPIk8ohgdvxj6/W7Z
         pu3w==
X-Forwarded-Encrypted: i=1; AJvYcCVpWeOIgkxCb7Obrr0flQvYnmaBpyL8xomzSCp4QrX7hJRgDI/4OoyWCsVRXjTfQZ4aPsMdpeo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwLg15qpFTpy+Au0hfllDJZD6P2jnmrvu4Zq1siXpNTUlWPwji
	CejTJ5xk6D6TgXf6DRKDeRFekyn5BoN7xyZgk6F9BviE9rreN64igdQWX4dTpJy3tb9SprNFIZT
	/C8SSBlc9RLoBWffwfM82GEaev+MPIv6lM7m6Nz8vvg==
X-Gm-Gg: ASbGncsOwAulY8vcHyCujfGIinkKA4+xgGuV01zoiqJDkfw2YF38lx7mpAmc9KO3oyH
	GIsyyqfW011RTxz77tCHbF0vRVd2aPAm4zKg46taqU5m76KsPXcj9R1SgZXUGRL6o2+Mi/p/hdu
	cqvkgBOz9CtGu+OcwoAqaR/srV90CzNWnTj9HglE/Z9JIH
X-Google-Smtp-Source: AGHT+IFAtm8qzr6DZ3uaSYxOLv9IeVEoJWiRE3BZrwJ8yLOpfYVXBv3GPKSCSeTz/MFg2VqncxBQeUgBAgmpJHSNC0I=
X-Received: by 2002:a05:690c:6f04:b0:70f:751c:2d8a with SMTP id
 00721157ae682-7114ec48108mr60341587b3.3.1749742620984; Thu, 12 Jun 2025
 08:37:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <87ikl99oxg.fsf@redhat.com>
In-Reply-To: <87ikl99oxg.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:36:49 +0100
X-Gm-Features: AX0GCFvQWjJwiT3qdzhS5zCC8eN_284PdbWsiIoJoiu0vOTKgt6QJf-RLSBsf38
Message-ID: <CAFEAcA-t09k_mcZhHRcHZQqdTfzn8-E3vjGoL4ViFfoZmCBk5Q@mail.gmail.com>
Subject: Re: [PATCH v7 00/14] arm: rework id register storage
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Jun 2025 at 10:53, Cornelia Huck <cohuck@redhat.com> wrote:
>
> Friendly ping... anything else that needs to happen here?

Sorry I've neglected this for so long. I'm OK with the general
idea, but I've commented in a couple of places about compile
failures and other things. You'll also find it needs a rebase,
there's a trivial conflict in an early patch.

thanks
-- PMM
