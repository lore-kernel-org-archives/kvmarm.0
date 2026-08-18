Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C58447044A
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075760; cv=pass; b=QQcPknj70iUzXY6kPcNxdbDN9WNRaqCb08Zwb474iRY0mA63oZnYXKB7axirMf8BBHtYfq3QtTSIK4s2xu71mCYevnfEcJ2HTCOSmY9BNGzBmUF8ZfLHXe117yVvrQFrX24trPrsXc3Y8v0qgkxciMqWdD0PkQqMzlQ3xIJ78Hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075760; c=relaxed/simple;
	bh=O/48gIa2vUi7FxYUqNtDfgAuIWzA1oYF6+91I1abQAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5oXsPUY1FGEHP3JFao+ZnKGPSl/k620A6TOt82AeCLcGLahY17UPjXsKRbKHoJoArjGlcgwnVGOscTbEHfVuqRc4UCK6pThDtGOMMfZmMBxnfAc/ZTzq6cEd/g55HM8P8c9KySM/DllIuxuCB07k+jjk3AcmXMmA5K1Nw9+HdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J8ezsV/L; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J8ezsV/L"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-495509b08ebso63545e9.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 10:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787075757; cv=none;
        d=google.com; s=arc-20260327;
        b=fkptld5BpXKMrQmuP0tYbPj3yeYZWZGPc5jQw0TB2IAK4WT9ndElLEN08pa51OmSMf
         a+Ibc7byeiQ8hvTTCwJnre5WNdNuthDQj1AWj8wWenpyHDXCs4KuzLVh0xJkXfKQ2emc
         5KvM/M3xqJjsPw0do6GAaPm2aA/cssMv8y6X6fWMH7Zfxlgk9dAk46/EDnuQGZ7JL5o7
         6JM0ZFbFIrQSQVKEQjGFWmekXW/aGSnQrvmw0Pw45HRImJgnHSUbYzOhTfYt6RwDvEgo
         0pq3YmTMGCSQy2o6qYH04BOqQ1ctYJV1Xd4EsBdfciC3GuVLhYAkw+oQLaDb4yslTOK1
         LReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xdwPE7pm0zYRhFo3gxRQ7Z14QbNNHShboTJ4Fwvcgk8=;
        fh=75cRMBKtA+LNrRZk27/KX7XUE3LQNz++PjJIvGih5zw=;
        b=ioT189AGMy4zRF0p9bt/uf2mji+irYi6JVKMDVvLVpNjRCKdZbia9TdtlKJwnkIMj1
         K/KB5Wj5N8ypR1qgcISBslM3KPHXS88WIiGfdBbAcViCJwzhp0u8MsQ9e0eFt8houKuC
         ZSJvmLnQWWS0GqGzo2i09Ko0nqZ7pJ/T4sHZQLP0a+ZH/tqzsrEwVo5ZddoabgTGmbq+
         OpJTIA8Mj0Jew8wG9g4fId8hql24vX0M9ULA2ySbQqVx8mMB1AyiTDqPmbgp33LriuE2
         lZCXRTNAS6ATedMJGGgK8GVhEiCPP4rPEbEblwnn2Hc9bZNo6WdWnGj55NqrblWOBTEb
         W7Xg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787075757; x=1787680557; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xdwPE7pm0zYRhFo3gxRQ7Z14QbNNHShboTJ4Fwvcgk8=;
        b=J8ezsV/LvB4mJyazOB6cJnDZ2sOvd8dIoocjUhq/2rLKLkSoH79Iy1RFlphzJqMvQg
         EfxVXUwlHHOW9Njbu7uNPLLEusHMXFhZQpqvJPO2lFKb9Db+C2wY5c7uuZo8PHuWO97Z
         PQooA0hF/N4FCQGPk4XvlF9gL0WYDYvGDZPHF1aP0mRfn2+VE2bzQzF4rjOxCxrOHVHz
         gKKIpI25yNuiaWa1FOtNre47Kza5vHDH2L7fQqsHc+clrRK+P6Y6FwpzGgKNnzmmRopY
         t1aQj9ZeSJ98rJ9stD26TBgb13a1ESoIFrp18liKeHkuCdBeupwvNBx6j+iD2f8YoXC/
         6QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075757; x=1787680557;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xdwPE7pm0zYRhFo3gxRQ7Z14QbNNHShboTJ4Fwvcgk8=;
        b=EApsNl3JrRA5y0BUGR82CjWG7RqRU6lXG+FlNFfGCIYpXFyCvMHzFmbv0DCciZimF1
         9xnCU5esapCLXowPmMTQIEMQ2jXfDGQMw+hMNisilvWa7eaeO9MQbAk3UAxVvPzM7iwS
         FdDhnYq2tGFsFvpmSGfTndPiQpDyvyznL4XlGF8YvGFzpW5EhHq6LEuh0Bg0+fnOU/Wx
         kapmhzwEMtTjLcQsmObzTHYt8GWSPDR/grV+E0GHsBckQUJfO2xNxGwJhbY03H11A1DC
         D2Nr0YwDS8+NIJKZOeFIDVfhfq95V+Z9NL0rFaTciC0SQExdpNSINX7qEMPgFKs1yGK8
         DTGw==
X-Forwarded-Encrypted: i=1; AHgh+RrUpEJTywVWjA7ESviBBWk1CwBeGQlG+DNY40oZJ+9WT1731dsqIgyK+wZcG/7qxasnD+SMu1A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3kip5IkatRPgw3S97Euai2ueohuOW8Uu1Z+YznIBNpJUfxOBF
	O3f6PqP1xDvZUyNUbkzuY/TqWWhQ6+l99ijHjpygR6aF10E1Najh9uctNnR2nOIzstn/vvXbqIw
	c79hk073puXqWpqStbiD9vnjN2P29PDIi217hzceMMIqYxUNgb+zKAd1N
X-Gm-Gg: AR+sD136d/TlNg5glvLtJ6qQFw0y/fnu2iPZldIg0GrCwuV070WiudbPgmHJouiwPjx
	GmBGoSFgSYadVOll4AAflC44V0d02rOASFxYhnpyB8K3T0GwswWNDlvPoBAai0dGxoi/H2oCJiQ
	L0M4hnUBKa099v9SbHqE8ePU/GQIeFLovpzWr+iR7jEQSK9pjiJKLzBiqcIGCq6787+A9d4Zv3z
	aXC/8nAIBkmaqGR78596xmPv2gahA2D7GbTllbBbLPZLY/ODoiH8W+b46V2jouLiUZqB8S80/fP
	0oPk+pdfeeGLpAPzJVoDtt3QlvGK68auItL+Zdqv0o813yDOSvwhOcQBHE2aH8e9apvr8Qp1AZg
	V7Q==
X-Received: by 2002:a05:600d:8445:20b0:495:76cf:3bf2 with SMTP id
 5b1f17b1804b1-499a2b6ddd7mr990425e9.5.1787075756253; Tue, 18 Aug 2026
 10:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817080759.25601-1-likexu@tencent.com> <86qzjxyvpx.wl-maz@kernel.org>
In-Reply-To: <86qzjxyvpx.wl-maz@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 18 Aug 2026 10:55:43 -0700
X-Gm-Features: AcwNN1Xge_o53aSOcYhkgsrThZL6nmQlGNWnTD1LEZPHs0U-nSXTMj9os8NN8Fw
Message-ID: <CACw3F53-_kQV34Rtjc_ZLnS8=SNyPzW5PfRbczEAGGF2oRZ5wA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
To: Marc Zyngier <maz@kernel.org>, Like Xu <like.xu.linux@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2026 at 1:53=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> + Jiaqi.
>
> On Mon, 17 Aug 2026 09:07:59 +0100,
> Like Xu <like.xu.linux@gmail.com> wrote:
> >
> > sea_to_user backs guest memory with 1GB hugepages but never checks any
> > are reserved, aborting instead of skipping when the host has none:
> >
> >   kvm_syscalls.h:68: mem !=3D MAP_FAILED, errno=3D12 (ENOMEM)
> >   not ok 1 selftests: kvm: sea_to_user # exit=3D254
> >
> > Check for enough free hugepages up front so the test skips cleanly.
>
> See my comments at [1].
>
> This test is totally borked, and Jiaqi stopped replying. It is a
> liability, and I'd like it *removed*. But if you want to fix it,
> please go ahead.

Sorry the test was written in a way that is highly customized to my
testing environment, and I have been occupied with many other
work-related tasks.

Like, I can help review the patches for the test during this weekend,
if that's not too late for you.

>
>         M.
>
> [1] https://lore.kernel.org/all/86y0le9cvz.wl-maz@kernel.org/
>
> --
> Without deviation from the norm, progress is not possible.
