Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E75820690
	for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 19:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687462784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Edd2SuIQ3rUI8IaV9M9bH7sRwy/Lge1qapI4gHEyAgk=;
	b=OIUnQEbRhBxmbBVFev6PhYTv/dTe105WgDnz6KwZCut9FSG1bwo6RqsaYkTb8KZdRZm4xn
	38BbTBC5aQ15uczZOiPyxqyBAYkopme/5L3qRX3PFWpaO0MhBhsdtcIoKn9G9udvZOvcgi
	r3iZULZzBJjuIOeqIizTkojWqteM+HQ=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-n7yZWqUpPdyRx_hJRIATaQ-1; Thu, 22 Jun 2023 15:39:43 -0400
X-MC-Unique: n7yZWqUpPdyRx_hJRIATaQ-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-440b5fc1749so1189797137.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 12:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687462781; x=1690054781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Edd2SuIQ3rUI8IaV9M9bH7sRwy/Lge1qapI4gHEyAgk=;
        b=SEML3sMbAYzakhLwrNYv5nv6O0iVqo1POfWI/zmDLYfgVCG5JE/umGGpxYHqHKTnRV
         HS1y0nhIXgOPx/5J2tsdqYL0kYzGCw2pfKOFzE9ip2XcPtGk7vSS3LlnV/42MTA01tA+
         /gqcmCtgVeUYok5zQ9gzeZ4DTSG1RyoqsbzTSFv5M2tPevauYNxpzlPj2fjWVf8f2QuY
         Px9Y1LtUY6+Pr6VGuyARDULzMiUWf//hgMjNyoYQfypAOJ7hZq8o5fVWebFul1RbY0rY
         EN2PPhWFGqsVay0Xk5rzcUNPM8TufUi2n6N2zlLEykjVfX+ovk1svFw1WiUHjSK2R2Ft
         H1YQ==
X-Gm-Message-State: AC+VfDy5YnS9Ra1lP37jXatyNpEW+R38EVMryuYlvi1GAQFE1oF/mX2c
	hv46fCKmh2tgS8woOUmJHEs/ZoYpomD4O3wlgg+78Y+YuV4nglINJTykPAtWlxO3/W8iY81fT/E
	ZuVTMZHcftCQpq2rVEUvKNSHRP+tUIBrC
X-Received: by 2002:a05:6102:485:b0:440:b6b5:eb30 with SMTP id n5-20020a056102048500b00440b6b5eb30mr5603039vsa.10.1687462781615;
        Thu, 22 Jun 2023 12:39:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6v49HgjgIIqCSi3sjYhFVyX+ZxdXrX5nJ0x5xE7UTZXMcQlvPQVMPZn47t28O8kk5Ah4NtrZD5jfO+Peujdv0=
X-Received: by 2002:a05:6102:485:b0:440:b6b5:eb30 with SMTP id
 n5-20020a056102048500b00440b6b5eb30mr5603019vsa.10.1687462781337; Thu, 22 Jun
 2023 12:39:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230608155255.1850620-1-maz@kernel.org>
In-Reply-To: <20230608155255.1850620-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 22 Jun 2023 21:39:30 +0200
Message-ID: <CABgObfYTyzDQoGrt=cFHyejH7e=R3jZ+K5BC=Wa4SyQJ_UbNEQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Reiji Watanabe <reijiw@google.com>, 
	Sebastian Ott <sebott@redhat.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 8, 2023 at 5:53=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's yet another batch of fixes, two of them addressing pretty
> recent regressions: GICv2 emulation on GICv3 was accidently killed,
> and the PMU rework needed some tweaking.
>
> The last two patches address an annoying PMU (again) problem where
> the KVM requirements were never factored in when PMU counters were
> directly exposed to userspace. Reiji has been working on a fix, which
> is now readdy to be merged.
>
> Please pull,
>
>         M.
>
> The following changes since commit 40e54cad454076172cc3e2bca60aa924650a3e=
4b:
>
>   KVM: arm64: Document default vPMU behavior on heterogeneous systems (20=
23-05-31 10:29:56 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.4-4

Pulled, finally. Apologies for the delay.

Paolo

