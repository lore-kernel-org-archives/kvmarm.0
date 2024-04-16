Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B8212E4A
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 04:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713242136; cv=none; b=Fg3bRimf+3CS8nnJ7YxZ0az4OR+HSTnavkMmu3u80DJdWL/uZLOrjLxN8g/2yQAX/Byl43QPnKb4V8w/HiXAWfXGgNkSnAFSFMhIb7IW2uAtxe3hYmPOO/v6dkUbEpEa8L7nLbJI3HApVN7xK5mFOSLvhdf9Pb5VVQDtUxqysTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713242136; c=relaxed/simple;
	bh=cOhgRnNctXUdNJ0jnqCUCl9Xz1y3NSNZO3gnr1MZedo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ZFOdu5YgEDbUd2JzU4zOlWLb6dLC8COecVrMxPflO8Eza/sqe/EJ60jfs0JLaJjSwrZin7Tr23/GwGc9mmV3PddDiALodgHFHol4N0AwvIQlgk82MHrkq4u6VP13U2jLTXEG5bBdzkuP+sq7bRbNm/bYlZjBYpRM9U9th8WJZl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0cFYFC9; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0cFYFC9"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-2330f85c2ebso2648175fac.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 21:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713242133; x=1713846933; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLwD5HzpxmeB+EVnNEtNspSSCQV8hfcKNpR+O4Wv5vY=;
        b=D0cFYFC9p7phQVM17NLpHwmjhQ/P3vwz6+gAUy7UiTVHCqxcQEG9GPo0eaEcQ/pv8E
         0EA03v2uwpEfzH8ez332oCoqWvFSQnC5VC6AG+BTPIUGLn3SCKXqnZsOnugTW93GLGFf
         8oNDI3EBdE41dVz7IM5P6c9MDvEfo4lecDHYojhEIjjWlsRu2XDAP5glMS6MRzZOwbfM
         kMknw6LccdPXA8qs0w6bd7fHsUMcF1JVcWZYX30cxVionm301R2NUiNcDUWqXj6qjHiH
         +TWHo0LcbfKxoNIg/e+MtIYlIiAFN8D11ztd62BcU/lLY9Y8fB7R4IFqIMK3TtPFiyO8
         /NNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713242133; x=1713846933;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GLwD5HzpxmeB+EVnNEtNspSSCQV8hfcKNpR+O4Wv5vY=;
        b=a7y0rD2gmbpxzJMAgIIGqfUIuEJmvtWvtE09QXc1B3hudcIDAFAYf0HwBC5nDYruyY
         qpz5CJqSlitD8j8qSXCbkIbmwliYZvu9SNpgG4C+QljEdk4eCGJabqQDT0wye9UcaKng
         xBps/ruQheqlBTt57jlcB//sjuwyUdMcvjMwnwAX9ks+7ZII8PHNkFpmiESEO+JjN9r9
         +1YSxmqGfTR3cxTc6bT4gfBv+x4iIRCBoQF4djuTUKys/v+q3s7BK8oQfmlOkYzo5b5m
         9S/ttGhlGotHNLO+hcgolrwb7WavfHuvSQPnLkvSaTJ4nfmGgqgNItIr/IhCArRbpoPO
         fRPA==
X-Forwarded-Encrypted: i=1; AJvYcCWatqbmyBLc6Ssl6m5WbWUZXu7EfzDrBNcvX7Za3urMoYaCkuZj8XvT5rnthCMAwhR6HAdZVoJtpN1/7GvnCAyPTXgeQ/+j
X-Gm-Message-State: AOJu0YxrpJTaxXXecAxAqMH53LK40rywHLQR6Xp+Rn7dMjLs59rxO9Zz
	lb/N5hbiCYJgmFwC2Na8pAO1Pb6y58PCcLMPo7YYyb2zID6UJrxX
X-Google-Smtp-Source: AGHT+IE9S6g9yWAyzxiSrTkK0Xnbz1r5P0C/mXjGgRtHJrKsrnnxUq3ZmoOWYvnoFIsnuCl/8FucJg==
X-Received: by 2002:a05:6870:430e:b0:221:8a03:6dea with SMTP id w14-20020a056870430e00b002218a036deamr14305357oah.38.1713242133121;
        Mon, 15 Apr 2024 21:35:33 -0700 (PDT)
Received: from localhost ([1.146.4.136])
        by smtp.gmail.com with ESMTPSA id u4-20020aa78484000000b006ed59179b14sm8047375pfn.83.2024.04.15.21.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 21:35:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Apr 2024 14:35:23 +1000
Message-Id: <D0L9N9ZR13SS.2DNXJZGI7T2BF@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH v2 01/14] Add initial shellcheck
 checking
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-2-npiggin@gmail.com>
 <27ba7613-1344-40b8-bc4d-9a9903ebdcfa@redhat.com>
In-Reply-To: <27ba7613-1344-40b8-bc4d-9a9903ebdcfa@redhat.com>

On Thu Apr 11, 2024 at 5:03 PM AEST, Thomas Huth wrote:
> On 06/04/2024 14.38, Nicholas Piggin wrote:
> > This adds a basic shellcheck sytle file, some directives to help
>
> s/sytle/style/
>
> > find scripts, and a make shellcheck target.
> >=20
> > When changes settle down this could be made part of the standard
> > build / CI flow.
> >=20
> > Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/README.md b/README.md
> > index 6e82dc225..03ff5994e 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -193,3 +193,6 @@ with `git config diff.orderFile scripts/git.difford=
er` enables it.
> >  =20
> >   We strive to follow the Linux kernels coding style so it's recommende=
d
> >   to run the kernel's ./scripts/checkpatch.pl on new patches.
> > +
> > +Also run make shellcheck before submitting a patch which touches bash
>
> I'd maybe put "make shellcheck" in quotes to make the sentence more reada=
ble?

Agreed.

Thanks,
Nick
