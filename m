Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8052C1591
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 13:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753967151; cv=none; b=AIaMOnTN+Z7nzoBuPVmvlwlUWMk9fSCkbGs+begKTXqdHYXDfq6S/hbWAeXcCpvomZEvLEzEpZcC5LT6Op+o17rC3IwuaWtjnOc0mGl8PJv2whWYbwtJeeKotx+dtMqyL7QCgiKHPv8193BI4nw+TnsD18ZuwnZcvjOMowg3F5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753967151; c=relaxed/simple;
	bh=7qSPh03uMZ7StVEng+yU51LTFaBmp1NzTRNYNPKQCl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XkCtRfaxUJJG6/DCckNvDwjPSJDi9v5gFLs07P5J9zeOlzE/x39D8cHzQZSEY6vyVS1SYreWwxSWJ3DMH1cgSES8y54kq0mEPMAep335qybO5nNpCdVdEOrTAEhA9Yo7+VrUNnDZe101993mFS8x3ANFSmER3nEbSuSP/5zP4B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eVRdZ17l; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eVRdZ17l"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso373581cf.0
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 06:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753967148; x=1754571948; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azlnxXtB5Jsuh9COWfMgAvblkqVwEyVB60V5P6SvQDE=;
        b=eVRdZ17lsawYuuUNpLcEy767KdoxKxUq9X6D5OK+2Mmdc0p4QEoxAJsnwtLZRqyOHp
         a3yvOI+7HhDiSNVfs2YKOp4mQEO8zWxDWoYr+WJ6TDKYucEOrJermPikAO1fV3aAOmor
         a7gNgz52Y4lxzb6Dk7iu3qAKs9Tsq8AD/OlJY3Ri+PjKyURyn8dUss6I2RojU302eJ7w
         8QMDShIijg9PwB66IBOn9SvU9iZiiL1BgWWguKTjswJQ8HgLqnR2hDDzKM8uhlcqQiYf
         5F7Td9zJLVj5ROBj5wTduyhH5PASb4QYlDkBYXZwcOdF5TQy/WN73RlDy2Fn4oyA5LgL
         roWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753967148; x=1754571948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=azlnxXtB5Jsuh9COWfMgAvblkqVwEyVB60V5P6SvQDE=;
        b=QTCDTDPTJeruuEao996xMuX6sz2P/usCL4SgyO2I33/wKaKMD7TGx8n3+50PxLNKP9
         WcwWjOBMeRpbjtw5xA74DoFyv5Vxrnth+Sqd33gdNIym5G2kr/jZOItBgX5rPm9yYwKX
         GRPljWU7dTKKPRPzj3Vov50mF50rwDFRK78RQX3HEjpjCH4omgPFM3S7ST7EAi033wce
         +Vt4O3V5biLVJRQEE7DT3YLWtM53KN15MWa3P7bbUfthy1oHcYxDsj+oHVVCl2JoU3Qj
         UMG1Gild0XZ2Jq9gPKQxEJrrR7c5kEEJZ2W0aLlncedWwinjqiPvD6MffERrenxOTqUM
         XtMA==
X-Forwarded-Encrypted: i=1; AJvYcCVoe8AeYy/o4QyB3QtL0vo7dGqpzCW2LXaf9a/NvcPdVFCf6Zj5LXLbyGgHBG3BwsLw9ib048s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEee5cTId7QIgS5YDyFNRfsyvVJo8TeK840SZHVkz/1aYnHdUR
	dtV3009Gtp4BoDOSiqANbPKCwAxBB7wawwcGHpxLXiEQIugxUirz607nlN8zv/fYvNxje+xvHzK
	+1m6m7QzZWeGHuYcoNdYl7uCsuyTJoMuptygNV3pf
X-Gm-Gg: ASbGncsnJEdW2IRCDzN2WzLvvj6uJEQMQ9jc7uae4QUOyi4CD3kAfZediXNOacPF0eD
	wTOqXpAMZynHnG50OWPkKfOnvuemkwT4R2q8LZuRKgdWRDlq8Q/Cdm54dBHx8YdrHjbnWQyRmxT
	bdff7vIWLx6vmczSSF8Uo7gT5Lb1a1mr3bmO/SQjgkrnbLR0H4hjwUHANbgfGCf/Tyv9hjCTPJp
	Rvuc2B2pGqbeInu3CvoWlmLam2wH72nhwn31FMHxv9ESA==
X-Google-Smtp-Source: AGHT+IG+Ybn0Vf9a5KS/oI2MPqQgq+Aie0mL4apPe+UjdVmKjQHShnqct+PxWzBC5y1VuCqHEe7C17wcsdo2FMSH3+o=
X-Received: by 2002:a05:622a:180e:b0:4a5:9b0f:a150 with SMTP id
 d75a77b69052e-4aeeff4aa90mr3279921cf.16.1753967147797; Thu, 31 Jul 2025
 06:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717234744.2254371-1-smostafa@google.com> <20250717234744.2254371-2-smostafa@google.com>
 <4a807c89-d57b-463a-9166-836301ee9947@linux.dev>
In-Reply-To: <4a807c89-d57b-463a-9166-836301ee9947@linux.dev>
From: Mostafa Saleh <smostafa@google.com>
Date: Thu, 31 Jul 2025 14:05:36 +0100
X-Gm-Features: Ac12FXwWogNP-7wQS8mC6AnYZpyiOY3JJZqjWXTPFb2lLRrEX9SL9P6DuXwNkow
Message-ID: <CAFgf54q3KVOZ0Tji+dpnvnPCbvpN4z1Yhm5jfpEmDPhndo6bXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Dump instruction on hyp panic
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kunwu,

On Thu, Jul 31, 2025 at 1:59=E2=80=AFPM Kunwu Chan <kunwu.chan@linux.dev> w=
rote:
>
> Hi Mostafa,
> On 2025/7/18 07:47, Mostafa Saleh wrote:
>
> ... ....
>
> > +     /* Dump the faulting instruction */
> > +     if (!is_protected_kvm_enabled() ||
> > +         IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
> > +             dump_instr(panic_addr + kaslr_offset());
> > +
> This part seem like unnecessary, cause it'll be remove in patch 2(Only
> the comment left).
>

Yes, the idea is that the first patch adds that only for CONFIG_NVHE_EL2_DE=
BUG
while the second does that for all configs, I split it this way as
doing that with stage-2
requires intrusive changes, so at least this patch can be picked
separately if needed.

> >       /*
> >        * Hyp has panicked and we're going to handle that by panicking t=
he
> >        * kernel. The kernel offset will be revealed in the panic so we'=
re
> Another confusion is that no similar wording to what you mentioned in
> the cover=E2=80=94specifically "Cannot dump pKVM nVHE stacktrace:
> !CONFIG_PROTECTED_NVHE_STACKTRACE"=E2=80=94has been found in the code.
>
I am not sure I follow, this has nothing to do with
"CONFIG_PROTECTED_NVHE_STACKTRACE"
This series added the print for for instructions as:
[   12.016044] Code: a8c17bfd d50323bf d65f03c0 d503245f (d4210000)

All other prints are from already existing code.

Thanks,
Mostafa


>
> --
> Thanks,
>         Kunwu Chan.
>
