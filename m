Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CE189B85
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 08:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731434; cv=none; b=PaS2LZ9ziuS+Dffqnnni1zSqiih5oPJVSWQrwN/xjPTGGBFMa8Bb/1K+JMyYfdP1+PK4YN+LOuAkAfVFcop7IpR6ptx24OwNYdcohPdOVxAMkbfbCjomPs5xtYeOjz0bASGd8up3dgyPfULI+xJ4zF3PUIGVBy3Hty1lEEKCtVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731434; c=relaxed/simple;
	bh=u2dYj5Y1qBZA90BsH2TSbGZFTLu8yxuGwSmgwkAGjIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hIkcWIHj8M3al8zDYL6aPKbtsV+E++V19zCl6kWvG0Sak8RJmjsOeI7i8oWqZR5YINNayDvrrcQMlXlfAp/8NjN7WHzK7fGzwPIs2IiGhVbGvPbmLgdGhZXccOFTkv3fRAL7uRo+eEjSI5PfLLIgh0wXyO7Eu+kL6BRq1icKlD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pyYlhZ8W; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pyYlhZ8W"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-434e5e71a08so70805e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Dec 2024 00:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733731431; x=1734336231; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u2dYj5Y1qBZA90BsH2TSbGZFTLu8yxuGwSmgwkAGjIM=;
        b=pyYlhZ8Wpz4Nw5QSXPmuc6Jwc8TXK1kh/3ACyF61NTdJWlDYKR74cufq9bzNf3Hl2V
         sn1aLYTJP29ZnnUvCaK4KtzVSzNRLng6R/iPRLKYPFmxwz1MtQ/o777KppeMKNdYPilP
         bSRG66/oTms20tFE96gq9/Zx8J3qEwR+LVjtE66H3+gP7a2XTep8gay8qs9yyfsFmo4x
         CV0fWcf3rUrpTgzZbIz92CyHiDbD7RiL7UJqpA1EF+h/3ZOMQHfsKcxXDcJssUVEaWpk
         fPmWeuZacfMUMpIBfzzey6tqWnEHflbxWTs3Ypu47PBtxjE2aLJpDVYhXJC7Zzye6nW8
         v0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733731431; x=1734336231;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u2dYj5Y1qBZA90BsH2TSbGZFTLu8yxuGwSmgwkAGjIM=;
        b=CZC37+RAoaszXSYUm7bST3C0tKxnTsD6ZYyYtH9MHHee0XVFR0KtKuu5+QbZwniKSc
         hnygraoB2ng5aSwI7v6yC8JjZsTFqSOTvef90Y3j2nmBPVcXqMfFFy100W5PYh9UUrZ+
         buMoScB8uxHpvwtbAomCO8HeeSVEBlbHL1vRkKDBDgrlxR68rllO7kme2fVXCBhaEk8f
         FuE98stSQPvkAnMQ6UrzETG3HGmgZqMRhzPiQVFj9EqLkv05J6fWt/TZpTfNBhfTsghp
         9tyM2HrRhQaa8czTNcctCKp73bCNgc8WEQdwB/2Y23B378Y6k5xv6gWK4xHtyYNu7dfG
         r8Kg==
X-Gm-Message-State: AOJu0YxuiagtLsV0eEooajeQbSPEJJlFuzL6uvJA2hWkCQtCDIT9lPeO
	zGX3K514vj2QUzPM9HrHDhz31P5MzknDJ4bPEnx6XZMzs2hDGRz2Vk7UjkEFlNZowlYY5UiF/Pg
	f5GXB5JDzWFSMRx+bm+uzUVNn78/AjtBaT75n
X-Gm-Gg: ASbGncss1KMD8jy2D+9vfF3ObVYMD4VP4UgRlcNfh/k9rHKCx1C4qQKE8xF+seeH5bO
	scvU3Xxi4h8C0OXreD3+sQNVVBWrZ9g==
X-Google-Smtp-Source: AGHT+IH67eWORsr+jQiiZGauYOoVdBjdmBrCOiv6ZkJPLXQX3gVK7771Zd+rTsGuMSZ+nHtM69u6cyCjbWXgGjzcgm0=
X-Received: by 2002:a7b:c8cd:0:b0:434:a0fd:95d9 with SMTP id
 5b1f17b1804b1-434e92d5118mr2174695e9.5.1733731430538; Mon, 09 Dec 2024
 00:03:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-2-tabba@google.com>
 <Z1MihH-aLq6lTccm@google.com>
In-Reply-To: <Z1MihH-aLq6lTccm@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Dec 2024 08:03:14 +0000
Message-ID: <CA+EHjTyqLnXmkBp9yKGES8XXgChb6LNHS27uK+5iEWpSOU=iYg@mail.gmail.com>
Subject: Re: [PATCH v4 01/14] KVM: arm64: Consolidate allowed and restricted
 VM feature checks
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Fri, 6 Dec 2024 at 16:12, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:28 (+0000), Fuad Tabba wrote:
> > The definitions for features allowed and allowed with
> > restrictions for protected guests, which are based on feature
> > registers, were defined and checked for separately, even though
> > they are handled in the same way. This could result in missing
> > checks for certain features, e.g., pointer authentication,
> > causing traps for allowed features.
> >
> > Consolidate the definitions into one. Use that new definition to
> > construct the guest view of the feature registers for
> > consistency.
> >
> > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> > Reported-by: Mostafa Saleh <smostafa@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> >
> > Note: This patch ends up being a no-op, since none of the changes
> > in it survive the series. It's included because it makes the rest
> > of the series flow more smoothly.
>
> Is the Fixes: tag above really needed then? It 'risks' being flagged as
> a -stable candidate, but should it be?

Makes sense. I'll remove the tag.

Thanks,
/fuad
