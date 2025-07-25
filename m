Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6A32EF289
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753460581; cv=none; b=XIMWBb4gh1eLD0cGHXGiN8qb+Bm9EqoXRSQBxC96CEHk7XnYyP9fASIQaUyRt99+Y/fCkbJJEbyrWxL4ibbbMIFshf1OTg7yokJZYp+5B0tiIhwa/h8edPy0Re5gH9mlLcFQzApRDFye1Jb1njvo/HnFi1IMXQz4txb9Bk+4XTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753460581; c=relaxed/simple;
	bh=WgMMn6ZE+UO+Db+AMvscSv4rxcyxcz2YSvR/V9F6PT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c1rL55BFdYyhHXGNjpTpSHBnK89L0ySjpvgMfoqWKUfdOG3A5DjM5Bc/33voe8os2i11y86sNgpZncpQzggXGY12OqwV4gg/QZfWbYRXmhxch80eFvV5U7JK1GTOesyRD7QAIWGudv2WUyRft3P8bH1dmDQZAIT+Ddyn/HQsGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zeLvvBLf; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zeLvvBLf"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab86a29c98so359391cf.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 09:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753460578; x=1754065378; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u74rPH//c6SnB7FAtWzTEu0clYtboYSpeyULU9wz9Nc=;
        b=zeLvvBLfiLh2tj9Kwr/FBBJKlJEEDObxlI0oNOY4KswCDWhYBtXa08/XDj8os4FJ4I
         +6LU4keo1bzfKM3JPgY5Dga5Ab6NEUjxdGkTivmzBO8zIM29FdvsUFKdp3w3rCDt36Oz
         i9tyeqo4aHjqNNTnVkjYL7XCbZVq7+pkSGvlwZIc+EExFzMDjq42y4+TTpSLLjV91Ee7
         DcekvsvbU/SRjS5MeR28hdzlqgZZZDhzmg2fJRjUW/gnp7y+m2eBH9YUHlhCzOlsAwmu
         5Xjso/Lcf5BpMax1Y9JhBQmozS5tIR70Ga8c5LK98bpCdQEg81DBR9VoMS/03iZFdyce
         K+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460578; x=1754065378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u74rPH//c6SnB7FAtWzTEu0clYtboYSpeyULU9wz9Nc=;
        b=XMI+/XBZ0SLtk9+SC9Kdb+chdiXlw7rfJY9Fr9akAfCvRHbhYnwgQpIsLju4N87p8a
         epyngiIwCCJDOGIlKAlE5F2Oi2smxqZ+HYoBBi9wqrkA0vZku9waKnjErROBwI3/AOn3
         hSJTzxMfVQsIX1xbPQ8NmIpCbDy1gedumubTOlxZVNrf/mYcGSymPgvb31p+itstBKG5
         H80eEPH1vezO86N38gKqoPO13jq1zFYdoEwv/w16gDed/axHj6FnqvJQruK/kJle/joL
         Sl5GDy5kcUFFcA94ccX4b6tvlR5D9rfg6WqHi5VWeU9c/BUgAJhZbAwlMIQRfHd72xMM
         PnQw==
X-Forwarded-Encrypted: i=1; AJvYcCWCuGRezUkbt3Kf73nXPQ24ADtJSkVSroFKv+0FGjE5AmtKyuyHNE8BqqxT27MdQcS1xrNrKVg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb5Wxn9J1NmNjfC3nvzrYK1RnD/oaY8r/tMzWWLcVrH57R3/1Z
	shgLQz5dP7fRV/Y9FYIhcwgZiow7f8KNrtvBbzWaeSUqwGmZXIVQz70tZlRI1wGss2NUgmF25Tv
	LLR10yqnWylf4lF4anurRk77M4lErlBvnmXszhu0f
X-Gm-Gg: ASbGncuj0zWhuYdZxy7PgKbIPVS8HWggIjpl6dXHShC2PPeUMtKSOrKyWLT8rjV2CP1
	ZN3yO8C1b91QT1hOs950KA22Y7gueCh1ZY1iJLIk09mlPPRBshfzj6zpx5QxdWsZQ1QCL4xboyY
	8AdQh7iftWiqC1LQHVYXSOyS6+bJZ95MsZtapvN17D87CCGZ5tAqz9KdBCJILPY+0D4n1fHH2FG
	Sh0moQ=
X-Google-Smtp-Source: AGHT+IGD5SL618OivdHgf3YPz/VJY7lvtmasgb/RxMGs4CnSxgWUrrNPAHtyRyqEw8bJFf0csvVrx4dlWjbdmBruZJs=
X-Received: by 2002:a05:622a:1a9a:b0:4ab:4021:b919 with SMTP id
 d75a77b69052e-4ae89f706d1mr4756631cf.26.1753460578147; Fri, 25 Jul 2025
 09:22:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com> <20250724235144.2428795-3-rananta@google.com>
 <aIObyUg77Um6VB45@google.com>
In-Reply-To: <aIObyUg77Um6VB45@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 25 Jul 2025 09:22:46 -0700
X-Gm-Features: Ac12FXwiy_BB8KHm3Sk8akfrBLEAKIqgsoVUrcDSZxShyAtLyS64CyISJLMjXEY
Message-ID: <CAJHc60y2-NvkyaUEsy4hKnGTwQy1HJSa_Mp08xfyeQkvTKWn2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025 at 7:59=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Heh, without full conext, the shortlog reads like "destroy stage-2 page t=
ables
> from time to time".  Something like this would be more appropriate:
>
>   KVM: arm64: Reschedule as needed when destroying stage-2 page-tables

This definitely sounds better :)
