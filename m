Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298505A0FE
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717403351; cv=none; b=uG3HBB40KCjy7OdgWOFppv0zlrLQRKNpgJKYioLqRrP/opWw90kzvcuTHamw4scaWrHdv/fSQUU0rlHBVnIOigxhkccd2rmPmGoDtu6KkY3k03eLON4nP/YXZg6M6uu3yvGbmCeaNu6dwe2/9FiXEleiHE6J5jp3+IlV1QzGAD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717403351; c=relaxed/simple;
	bh=fVlesX4K6cSN+H27FtRqKLsABghCdB70OOUw2vP8InE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ok+JGP70aWah3+cT4mDG+oD/DMfRiEhq9M0yhppLlWZ4++L3zoP0pcDWYlF02fIBYS9oKY84UXRS9p34A6iZmwkbL4BqL6j8SQZW0d667XhrPzmkNe9tfuhryy3QWu3wUgOhqvur395zsnxwPsyQg69v+tKAZ/5T8QwfL+vxtmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CyvnMdSu; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyvnMdSu"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-80ad842d3a7so882717241.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717403349; x=1718008149; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsRrbQlTYp4acJ04+n2YT0Gg2I3oGU+nfMgVxL4jWys=;
        b=CyvnMdSu5tCLk948l6fENkUN1uBui1zjs0FVAPv4uT7+Zdl/XGciwzSgmQdYiD/1iW
         RYF64NdCL2Vl8AqpNvsE4iub0srY6DvZaxQpFW/aSFhAdxxwGQFVyU5h6zc0X/Nm1uiH
         Ty5WiQXLONb4rgFuvw0XpHakqbQj7IkMFwQlBTy46vd2Wc7clGmSjkHFLr3kTKuBwXfi
         7OjFLQZ8FaE8rp03MW2zE+8IpcuwT0y8syeUQM434aIECa/nYokbN5OKdQWrfsIZMA4u
         Z7cWTZje26NAk5r00oj/CWIA6q627MaKrZ1kxLfKY6xUd5aRtBH6Gmsb7QrH5L3JBPDd
         Q4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717403349; x=1718008149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsRrbQlTYp4acJ04+n2YT0Gg2I3oGU+nfMgVxL4jWys=;
        b=NJvfsnnr2+6Y7ce6OkVopbpxuEUqT+S4eOTPxtUskxdaXwOXOgrgC+aI5mBigRwxBH
         qrOFiYDoLWuEq2yZJW75Ow0cFS02tmV0Q1Tk9ZYVNvRPTk0S91zEOePs+iCL6OQQofyw
         ncD84svBTEPSyi+EQSQYSdZbOgE7CBeG36dpU0SJIeCD8+i4FZyFmCMI3wu63Kp9607l
         NkuIQsJMsqBs57xTctvIb4oHiM5j0yrD3MGmqFxOPm+iQM1qdIKKPDJliaahOhaFlwf4
         u4h2vyIquoFB34r/Mzpk1iq6FdhsaTmS/6XSr/Q9C1vi7UASkq4hXPFJgr24PW5JaxlD
         +Nfw==
X-Gm-Message-State: AOJu0YxcN5HB2vc9+Lr2o9eNRRKjL6Hu5SfW+PjFY1YX14peVvxc4Uzk
	IarZN8OJf6czF33PDsrGXayZFFaWSt/jYZqnKZ7O8CCSDfvJ7oZdzsEclrhQ4yuhh9lJEIn2BJY
	2vuDapUAvsbFhnRqPXixkFuBkf0NAWt1P0F2o
X-Google-Smtp-Source: AGHT+IHqW2rY46wg+8JcwKXV0j7cagliERoKbJylkW6Bk1dhKJmBfrD6Zr8O7lrCAevYmFsh2fzpp7Jg/3IJKXo9oEw=
X-Received: by 2002:a67:bc03:0:b0:48b:bc9b:d816 with SMTP id
 ada2fe7eead31-48bc21b9a2cmr8150064137.19.1717403348400; Mon, 03 Jun 2024
 01:29:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com> <20240528125914.277057-2-tabba@google.com>
 <ae1d98b5-d3d4-49f8-9478-2a20f89d8156@sirena.org.uk>
In-Reply-To: <ae1d98b5-d3d4-49f8-9478-2a20f89d8156@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 3 Jun 2024 09:28:31 +0100
Message-ID: <CA+EHjTzPAD9xqnEWU-Yja67L4_Q79ntpTV7E=J-zLKFYaV-9SA@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] KVM: arm64: Reintroduce __sve_save_state
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Fri, May 31, 2024 at 1:26=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Tue, May 28, 2024 at 01:59:04PM +0100, Fuad Tabba wrote:
>
> > This reverts commit e66425fc9ba3 ("KVM: arm64: Remove unused
> > __sve_save_state").
>
> > +void __sve_save_state(void *sve_pffr, u32 *fpsr);
>
> The prototype says this takes 2 arguments...
>
> > +SYM_FUNC_START(__sve_save_state)
> > +     mov     x2, #1
> > +     sve_save 0, x1, x2, 3
>
> ...but the macro takes and the function supplies 3 arguments.  This was
> a bug in the code at the time you did the revert (the prototype had been
> missed when adding save_ffr) but we should still fix it.

Thanks for spotting this! I will fix it on the respin.

Cheers,
/fuad
