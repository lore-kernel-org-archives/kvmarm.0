Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8808B3B19DE
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253307; cv=none; b=PmDgCw4pcxra/oRbWjiCtoHz28Ed6kX8HGaI27IoLQ9zy/P8PuG5YUfWebBhWp9VLCPpDExByKWgjbCpKphRm2xmbCDUHwwaqlRxuNGDru3GrENGeT+zi/1+n5MfyDigR4LklsN8Gce0E/0RQpxr15k3ZYJdQkkuzqqI1UADcEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253307; c=relaxed/simple;
	bh=J70PSk4TuclHa9H+GWTRohBykqCDbewlmIAeSi0eplQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QPWLmWm+YQ54/dr/f+glPRJ+kVoAacWpL1IVma4jTv3UYHbv7hNtzIbQpY35bXQ1v9jXzvPJRmaoC7wwDSny8avYiwx12Tot9dK8WuIzffb5kW0WyXXelpYVG9pVn95oXmyj7tfC5jAtBqXQ/oLBwJ5exTB51FVOOX4oxOzGo5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IkNORlI5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IkNORlI5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785253305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rMNFpvzy5MfR1oz3Xik6QKGfu+2zB21OUn6rfuSU1is=;
	b=IkNORlI5snKxZnFiEST/omcfbm96Roiow+IzHAMufjxng1vO+QHjXAX0tyaOkgIVpiwqQw
	2D4iRBqr1hoqQd+vAtqxFXvxzWCTDc+riK50BJvP0hPfQrmVX2a2qLMzaebQ5yM0zJsifT
	h3FtWYsZAecctawipfZt9+o9AuAM/V0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-oMXB3CqwPuKkJNZY5IFSxg-1; Tue, 28 Jul 2026 11:41:44 -0400
X-MC-Unique: oMXB3CqwPuKkJNZY5IFSxg-1
X-Mimecast-MFC-AGG-ID: oMXB3CqwPuKkJNZY5IFSxg_1785253303
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49571407d1dso29610595e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 08:41:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785253303; x=1785858103;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rMNFpvzy5MfR1oz3Xik6QKGfu+2zB21OUn6rfuSU1is=;
        b=DzFGBVWU0H4QkCrSo9BnKWGFhXXqW0O5Da2On2+nu3A2QC7ltRPu79wXnUDZ126I+r
         FrdcCEo7R8tdEK2MYldS43krBc+Z/R+6QZyooIvXvjC/yiu02xGiP5BnyA95ehGu6pJ7
         WS5o+wwOee6O6dZsQU96tuBhV0YZXHvBCGo8XJHRp8VQnrw7KrOI16lWZX8B6aPCNoLr
         fcYo/9bgBNB/5yxB+f1u8T/ioqcdA+vT+kf5itxUxOvWIiBsP0IAGixn/QK72ZbLoiIQ
         QLRltRUgEKnyzI7XVPLZXQoA604K3GAGea4I6j/hrGbXSmpdZnUrUw3g6zd4eDRK7CKs
         tMWQ==
X-Forwarded-Encrypted: i=1; AHgh+RoP5+obpTKm++MkFdVw0D/UO65l57beTm3St3K5Y8l4JoOrEi15mJQ6+xfb+bOxZTnD+f9wfEM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yywm64MpW7FhQ8l/6HOFlKn++6WuuwcVzTBjXkrVlKG4sZP0VY+
	oxb6L6orxFZiIK4C0G1oIpfx/Nz7DG0F3sUIRfasGlyekPQo7FO69H8+oc1JUq06Mn8JQPLTSIH
	I+XvlffTgPzP9uGwAxqG5L6DCXj3pkDXFvrBacxGOw6vSJw06maKW6AMwS2HWJuAdsZoDYiNutB
	OLZcbDhFGvWKf+23J3ILGoSXIJa56UkBTk
X-Gm-Gg: AR+sD122YLp78g3SWe90YMGxLTCkNyWEp3zPBuHNu1hj4feschI0eIVd04BJA5D/3eJ
	+aqxbwQg+AkI1cUF502e7IqOrv8DRHzI5LQBN7Qj0BAms/tyHmcv3IRy8otLJ0fUEMs1ZDaNE8P
	l0PXvQ1whKCwcwPrngMTscHQ6uqhsxvEacO393b9Fik9Rww+krmr8o+deXaIDbRXH/Z8B4n4mhO
	fOy/NhrS4gpPl2WMDDuWWxt5yS2ScZHkS2yq/NZ666xZqU25TpfOEK723xrhA==
X-Received: by 2002:a05:600c:4744:b0:495:40f0:e77 with SMTP id 5b1f17b1804b1-496c6415054mr33062505e9.5.1785253302877;
        Tue, 28 Jul 2026 08:41:42 -0700 (PDT)
X-Received: by 2002:a05:600c:4744:b0:495:40f0:e77 with SMTP id
 5b1f17b1804b1-496c6415054mr33062185e9.5.1785253302495; Tue, 28 Jul 2026
 08:41:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260724084742.3358321-1-maz@kernel.org>
In-Reply-To: <20260724084742.3358321-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 Jul 2026 17:41:30 +0200
X-Gm-Features: AUfX_mxhUuq42c31F7OP6DNvw1uz5kBf-VSuqSgDiWSNEUPnMa8_Yyxglsm-09o
Message-ID: <CABgObfbvvYDC6gyhw_FBPi7Bo35WPuaSyyVDkz7HA1M6wdx5vA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.2, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, 
	D Scott Phillips <scott@os.amperecomputing.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wfg3-OB4uqrWipFYe8M4tGij7LiyE0pbIT59a4NmYjY_1785253303
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 10:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's another set of KVM/arm64 fixes for 7.2. A bunch of fixes for
> AI-discovered issues, with two main areas of activity:
>
> - plugging annoying LPI mapping races
>
> - fixing corner cases in the EL2 tracing management
>
> The rest is a heady mix of CPU errata workaround, API tidy up and low
> impact fixes.
>
> Please pull,
>
>         M.
>
> The following changes since commit 1590cf0329716306e948a8fc29f1d3ee87d398=
9f:
>
>   Linux 7.2-rc4 (2026-07-19 13:54:41 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.2-3

Pulled, thanks.

Paolo

