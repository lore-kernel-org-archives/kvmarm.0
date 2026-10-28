Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210815;
	b=kifvIMhZ0JKzFZNmXKzqNtykDYx8hdA8nkpZ0+52IRhFgA480F3UVxJ/Qancq1MFPAtR
	 QjcS2Vm2rcmmkXbDpHqvitxDZy6+Q85JIPw+mPFkyzLBs02uI0cUoaMvkjXH+dP+H1DlS
	 qRXLiLgKiKO9PzaaVmO6GSgSpyxDt3IAwI/jMhospcPmHosEkoje4FmInZFo8SiGT9t0l
	 iV9k9uq8+vS2XyMZ2+OokmLRvegWQ8cbv6zPkPFUwtA/CGQ775U633i/21BFSJO+fddJZ
	 IEKqO0Ak1/PyIslqJOdCWOBaMNfN9yHRGFDqbCvQpxc2psNzUfecAuBqnyo/+kExHuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210815;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=YCIM+YQFrajHkl7Ol4fId4ZkAJB6I0ksGBZA0GnY5pM=;
	b=kvRgtOvFoeH3ZG05XvhaLfgNkFXIgYkO8EzKbCgE+Wtiu9gp8erua+JJ/ZhNYou/U4U8
	 L25eRT1jD1YoRo5/Gp1EN6W9d137V+a52luxykcqNjzpe/hcFdugTK2ravrzvWC7GPVfl
	 hWP0DXjRyBeyrBY5cz6Lh8pbQG8IUaRTA4l6oj6jk/X+LwbhEj9SS5VGfJUN25RC1BY1r
	 fN6LKYfkqjoygxdbwrCJjqAsWAEaX7sP6vwpzKPifCZlqHgsPNo9M4H+rWQGlKtBk1+uv
	 ZSqlcz+IRII4wHav7DlGBwJbO8LE0DOFUF6C+ueDBfQUsEm7ZLW9l4/UwhVw6FbnlbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ftwbVx+X;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46822606A323
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 18:06:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46822606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ftwbVx+X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793210814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YCIM+YQFrajHkl7Ol4fId4ZkAJB6I0ksGBZA0GnY5pM=;
	b=ftwbVx+X7kyaaoB+Xji1FTum2/KukPUx2YNVsyF82Co/85PHkkF+DIYtDDCRaAuyGSHkG3
	oOQ205uqIc8o3e0gU9xMZdX0vRoxC5TIDhOsP9RCHZrJnj1VsalgVpZD7QU/eDFrj+yfk7
	6YVuWWnNEWD/SK8FqlVO+9vyIWd8HEg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-W9UNAREEMLeQuo6kdb5T1Q-1; Wed, 28 Oct 2026 14:06:50 -0400
X-MC-Unique: W9UNAREEMLeQuo6kdb5T1Q-1
X-Mimecast-MFC-AGG-ID: W9UNAREEMLeQuo6kdb5T1Q_1793210810
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a2063be141so11038615e9.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 11:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793210809; x=1793815609;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YCIM+YQFrajHkl7Ol4fId4ZkAJB6I0ksGBZA0GnY5pM=;
        b=sH+R0uAcz0C7VKpBCKxBsxMuRg+zZtiDuta48b7wW+Vyla6tGWLKGmIoE2g1A7A0iC
         L74uOW3tLRWw8Ad+3VMo1x262V0AIKpPwuEJ0aH79j9QJdo2Ci53cvPzxKm3pg5hRSoe
         dU9MW3TTUpsM1XbmNc25xsjuSzphosZDON3yWHSZ0ZD/iRodIv6jjik7h6Reud/rZAar
         vfRAU3IfC+x+XiIgmbabT6bqX4Uy/Gb2SlhyHU17aESJKgJtvpCpfBEvtd2g+ujRR7/D
         KqfKrKyQ7/rxg1ujBpDNMEMJN0ywegQnmixPrpo8vQfvVHxduBbinFO0qnHUV5yyQ9Qv
         8Evg==
X-Forwarded-Encrypted: i=1; AKwUvByOUJzV+k5Llp89iAsome5KUtXhxOLEmShR0TLPbb/ueAY5q2sGtgpWvJWs93XYLEtcWP4iw4Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYI2GWpmftVhuF+TWtB5gaDS9zup1/KMXEq3NzThdel6a5WtL3Gb
	b/enwOsT4di4e/oWU2t+VIiKmZrlW2Hn2OZ0xs42ZVv4ivbHXh3Fwzk5OunHpaZ7lwcxd/3u9XV
	zmHBeQ/c05vr/bcqzZaT8zKPGNKzAwAkGztrwDOCTDPp8bBHneSKeTWPzjVttx5+48cKmcnO5kt
	vTUrw3gYdcVQneW4K+U/KK7NR6iIMdVOeS
X-Gm-Gg: AYBFou0+S77bU7nzIes09rK8+p1HLJWZDKmDUe16HUWy7ybXjmHl211xn4JOWR4iUpg
	pJ/Stp6qPIUhXqn2URUlC/8yqMY/pOWWEUKagcDMhXkMQNZCpJaeDwkyBdFQi4HRp1Gd9ukFziB
	QbPquii1iXB9AlmnXqPcLgQq3Ub+qbl+C3DNvFZwqLyXA856gsirAFp88rhyYox8kI++XcHqTgT
	aRB6Du5qWjk9JvVFPbbXrAfC/o+J9RjMngeSZutnl4lJrcMhoCei8Uet7wg
X-Received: by 2002:a05:600c:4ece:b0:4a1:6c0c:ab93 with SMTP id 5b1f17b1804b1-4a9674e69dcmr70364655e9.28.1793210809532;
        Wed, 28 Oct 2026 11:06:49 -0700 (PDT)
X-Received: by 2002:a05:600c:4ece:b0:4a1:6c0c:ab93 with SMTP id
 5b1f17b1804b1-4a9674e69dcmr70363965e9.28.1793210809079; Wed, 28 Oct 2026
 11:06:49 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261027143424.2732449-1-maz@kernel.org>
In-Reply-To: <20261027143424.2732449-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Oct 2026 19:06:36 +0100
X-Gm-Features: AclHuK9bNQt52dZaGcgL3nkbgBCrd6uMFuOFFsScp1NU61vx-ZKL1_doFNpPh7w
Message-ID: <CABgObfYonkEvFNzm=94UWCnH5h9Jv_FFfwOir5EAoaeW29eqwQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.4, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Sasha Levin <sashal@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3HfyEVrbtxs_WIPuELk5fMMn2um8ZtPUG267gcZBC6A_1793210810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 3:35=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the first set of KVM/arm64 fixes for 7.4, most of which have
> been brewing for some time. Of note: a couple of fixes for mismerges
> in the initial kvmarm-7,4 pull request, fixes for the publication of
> IN/OUTSIDE_GUEST_MODE, and nesting for vcpu pausing. The rest is a
> bunch of cleanups for nonsensical configurations and some more pKVM
> fixes. I have already started queuing more fixes, so it is likely that
> I'll be back next week with a similar email.
>
> Note that this is on top of the initial pull-request that you sent to
> Linus, so hopefully conflict free.

Pulled, thanks.

Paolo

