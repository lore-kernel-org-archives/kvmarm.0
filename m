Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807193DBD5A
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772729782; cv=pass; b=C9smJISGf1aBkOMqqDovDy+GOfrLx1np0Q4a/nu8on9B2TpTE/jY3x2i1rwEi9aHpwKiTDD3icxt686vpzd4pEsGqvwt8Q8arL5kK8QP9WTDpLwH3QoW5J+ZQDCChDZYyY0l4qww8DB5fK6WZmJZCfKCO68ojUQiHSWr9Sowud0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772729782; c=relaxed/simple;
	bh=7+fZuvYjkTWPnYlnF0VNRGUh72MlyQ5Oi5QaZp9Vm1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FPFx3NADkucG6GLy95C9iSNZ0mZQXMy5u2KfAa3gJO2xMLybe5D7zTxOal1fQVoEiwQAG16EOgEGL0JDxKATGQebs8iOi+T7Xd7oKIdgo591lHZWlT5sLLMf+5qza5uex7makQk/+sFQys7Z1u83tDqnE2dW2CBASE20XrzT22E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZIxtohNP; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZIxtohNP"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5069a785ed2so551101cf.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 08:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772729780; cv=none;
        d=google.com; s=arc-20240605;
        b=L9lFEGKDWeT2ViQ6VGRdVljb0Wn6kelDWYAPwuBmnWJ5E9rneqyq5rUI+n0iQ1t5VI
         tWVyxwdejAwS94Jv9NMJ8vNvdW0fA/2Ey7J3FAQ2web86D7rTJUUd0Gj8+HrY1F4jOdI
         +EaTTuXGs/JgOTZuu+2xhtNnqfe3O9cOUjKY3P3pcux8DfHLwf9EPvKljPk4/GczgTua
         +bnDbeflXNvfIrTZcIqK7j7Tc6tpoh93aNRCYhfxENpvyUxCd8KX4y4w4wyiF0TEKCEg
         TEnS5vyuLNIuXxqQHJamxzQVb6cigfdLCheaGL3P67ZQENFomUyoIXqTRSZqeQtS1jcb
         HR+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=w2b4o87Dv8Tqe0cDumD9I6Yls5fZWHSIMLvm+YwvHiU=;
        fh=LXorY+4eGcPRBG4RjNcImdNsiRRatp0iZas/de1P1fg=;
        b=f2m0dTLt03zzVDrQJAuaYp8h9D5C/vr2nnNUYc2MCGUt0CibhpTadgZdbn6JLJ02O2
         t702TCtFONrtlu8X7OvjxtTJhhmLcRdh/QoRoyO6hux+qk5iAW7EUR3IoAQkjpxFKEkB
         l72nIiN3I/ZO6W0QvqwHuRyGyIO2HpI+N8vbAOOJpNixnjfQKf3M/d6dHexpbUonLu1M
         8QWvJob1rlcyfLd11I8ZDZG8zn1efDZW8WEGdVCsT99aETPMijz1+whj+6OFtvImuhet
         z7MzUiKgFyTsaRrKijflFHcamlm18J/zLF2G5PF9DjnkhA67zRHfva1wYpJ8CS2HVs2d
         0lRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772729780; x=1773334580; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w2b4o87Dv8Tqe0cDumD9I6Yls5fZWHSIMLvm+YwvHiU=;
        b=ZIxtohNPgxun/HpcEAWS71Y1wbGvh2U3K0uD8hnemzXInOHuRgTy2kv2YAjnoVPy69
         OBtxtRN9ZgvQ365fOUgdPqmaE42RJlUeZ3hNsb6fGpSPHDJayk4bmw7Pf8xodogeAFO6
         q7yv35bOw+WmjcwJVzzqmomA6vY19F2i6XvIHbCL0+N+RNEt5DWe5ZoRXED/wl2qegi5
         0mEuHtvrHf8Ttxl4gFFHQygYPLV4nlfqY7EFJFCdQYxq7M37uARhZPMOVz0snXit7Cbs
         cv8A0PlYqgHVep3eNTLeua3H/NVy/1tEkuRJpQdq+cVXN2PqCGsCUZyuzW/UzoKCcFDO
         IK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772729780; x=1773334580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2b4o87Dv8Tqe0cDumD9I6Yls5fZWHSIMLvm+YwvHiU=;
        b=mwqHBDg+7mJLGSMlJ6n8uVQOZaH9AKFBwD4dh53U0Ted4nmSASWCh9y9azIont6BHe
         AloB+HR9Ob5XiqwLWipzJBIhpYDYT2nzSc1GSRpXNekg//YJnQfLWpIqTk8iLiBEfctt
         RzL6Sei7YBNdXVfgcZB0F9Nf328H1737LK4q1wCcSMt3lJKECD+DiGg/mO3nVGaaI85s
         opV94fv0NuLRlxHIzhUSVofObthBO0rrKewWjlJT9fBlwGRwQDdm5Z926vvFlsYSYZXG
         15rRstw2o+f/A1WSSloBupEOVi5htLN0evbQV9x0e8U+ir7nxFnwThDJNCxVHAbWH32R
         /dRw==
X-Forwarded-Encrypted: i=1; AJvYcCX2F2WweEf4Vh+4FROyg434nUmZjzJhK75EgRt5/Eewv0LgwznyBBqVx6ADSy6fyqihzX49Cb4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGWIZK81PrjAhpaFGES9gDEEJJpMeIEFm0MR6q3mwJa6IxN0+a
	mnCfnZXAjYlHB0x+IXA75WydcbAHtztlrrDcFT7Oo47rmJ8qLRzTwlLNd6ax9DOLA5mUiaaTWEX
	Men9qMUjoZH0j7rtjN9jgLw42udB8Nmz4qclMk4yn
X-Gm-Gg: ATEYQzyYS9Hp7OsBpFRJVLoXYQzPJ1jmPPg6BJemI5MeoJiPM2vo4eyaDWsI0QsfTC3
	Xmyg48jmaWmg4W+e4/k/zKnrD2kA3ms3q2/0p7MNtgBnF1vJR15cdjGC8aTWXdGhFcmfAAZ+RTs
	N+xZXBDMBQg6SEtCyLCjJqBuCr0a/JwPUV2IGbJ/DfmrDFhRwOMWsOLFg08DBR4uil0sacFrquN
	iWekVxNCqP92W1yVjg9vBHGmWL8fIr/eaBWwR1e8v71tNyl89/ezlS8nghVzUj/kkf1ElsW81J8
	ZkJgwy1x
X-Received: by 2002:a05:622a:1908:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-508e78bc5a4mr11348321cf.15.1772729779762; Thu, 05 Mar 2026
 08:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com> <86jyvq6wyg.wl-maz@kernel.org>
In-Reply-To: <86jyvq6wyg.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Mar 2026 16:55:43 +0000
X-Gm-Features: AaiRm51dhM8VzhZriEGSXSixZJNkbyhhRpWwsRm0Q6k3mF9vnEvNvcsMfRmqcbY
Message-ID: <CA+EHjTyUhBqUGG+TC83rz5W11RcymQuFAr+FhFpRsPZbf--vTw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] KVM: arm64: Fix a couple of latent bugs in user_mem_abort()
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, yangyicong@hisilicon.com, 
	wangzhou1@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 16:51, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 04 Mar 2026 16:22:20 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Finding these issues just reinforces how fragile this 300-line function
> > has become. We really need to refactor it to make the state flow easier
> > to reason about. I'm currently putting together a series to do just that
> > (introducing a proper fault state object), so stay tuned for an RFC on
> > that front.
>
> If you have such patches, please post them sooner rather than later,
> even if the rework is incomplete. I'd be happy take small patches that
> start add infrastructure early and work out the full refactoring over
> time.

I'll try to have something for you by tomorrow in that case.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
