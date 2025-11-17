Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F2F32AAA8
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763374748; cv=none; b=gF9ekHx5z/QlEQiXUiL7QhHpnIYl7alAXpahbnSpkyLDoNe0v4AKfKG5+nXsY3UQcEYpwDoZGXOH6J4WqLXLDnfXi1s1+sf/HASd1THVFEN7NxZVWXozwiJthaYRlRKbC3Syns74n7c5AMB4L+d3yu5oKfHPKz+vJTtLGOfYHuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763374748; c=relaxed/simple;
	bh=zPYvPpxWU6t3N3nrbTSIJZK1EyfAajwNVGCdUHzuU1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVXMaib0cnLknuFUEUdpiHYSTWJPoHyCSQ9Y4tcAHx7IhDjJE0taiQJmBJKfosB8iDDlOXPEzx4r12NnD0JWmltXOEOijxsZQUWwg4nC0Ws0GG/Xc8WVoIEg9J3WwGN+17K2UKS4oSLWxc+ymNagjScwI64/MMrQiYIcFUOC7U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O12UahIB; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O12UahIB"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4edb8d6e98aso653551cf.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 02:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763374745; x=1763979545; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7dSZwG+Ut4tx3N9fD6TcZFfeIFY+rAbw7tsG6scq/hU=;
        b=O12UahIB2YKrTra3dErTXDZc00L0rL02t4KW3/dbgutc98C1OkzsIy4ZIFbw0+zmfi
         p+nKu4nHM/HBVx6KU9RtmSSd773CRp7DzO3FB1KoGulnaKErGheLcpVBk9yHFj3DnDYx
         rwtLriz4cjVNAzl5SpO3ozGB/q9N+yqOTW8tMHdLFTvrs8nxIpaqF9WgMR0FDCIVjBxN
         2AmAhDtjMMPSS2JwsdUkIwvEHbfZY1+Sz9fR/SBYZ7V8Z6mXNb3JOM9+P09mCfO6aGik
         7ayulyHlfJTjk/4UPpKW2VN3dqedD8bT92KHE9KFUDEiv75ugqLs+/mqxtkDHKncr2p1
         jcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763374745; x=1763979545;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7dSZwG+Ut4tx3N9fD6TcZFfeIFY+rAbw7tsG6scq/hU=;
        b=gfYTzoBK68AZHwBapU7RH2HAojbeYw6Q+PaFnvcz44r27pBQ4xloWrz8dHIwE2XPfI
         NaVfXXRX4hyyjTnxNUneN4BqhkjCNsB3p8S1W/RVHpCEgPh7fKhbpzo0G+U+oP7tTm9n
         VeWDb05ZW//WLc1+Pc5gR7EqkUBzStmzZaxvvpnbCcb8KQBWrgBREBxy4lAZRGxVOTb6
         zVnwM7sKiy0UcBWZCQATVrPt+Abrva+ZKbTYjIl98qW0oE6PODDO7lgEUyvwLN9FA7db
         mS/qxX8peBpzhkxq4Vfz7VKKAa206HhW2QOzhHPZAVsOsQwpPsnvXQqKPMphw1S1ifFF
         FKYg==
X-Gm-Message-State: AOJu0YwZJ/+etCM4hj4VqEIDq1/bT4cjtlZl+dhPU18c+8yJFXXo9zrf
	YqVKrpRIzCmz4hapjDOD0KZkwaO24frtDbf/DtltCM/PvdKE/wvwyh95bLl269Z8ucCDJ44mM8s
	eMD0UF/Sg+tfy+A18ba6LOtAVkNsd624dY2dDo0r9
X-Gm-Gg: ASbGncsgnEKYic6sAmHyO1QHWt1ffJZ5sEQWPOI2kzqcPTxp+v30/A3oOYkX/iqr20v
	O+Z337C5QxHu1O8i7lT3HmUx9W/EmHp6h7t2fMXidLR0N39cuwyEYaO75tIgRnHmf7PT6A2oIvy
	Khq4YwQW58qFY2oH71guooV739oo3RgMQVnYX3zyJ5Y4HC/l3taRCErm5DrYGeOQlJYNbhEhcaR
	zj7r8h9c4AKPjhRYPkLab8WzrW63G5bc5wFg2ERuSjNLv97hPFle6pJhJcB3sZGN+3djhAprDwQ
	IxqXRw==
X-Google-Smtp-Source: AGHT+IFNmczB2ds9iTzz5FRf7oU0BYqq8SdTaWadzkP1SRAFOc8Pnz8a3JfCCCKf6Zz2U+3uKM0Q8RAviooSDsFqVnQ=
X-Received: by 2002:a05:622a:9:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-4ee0292790emr11283261cf.10.1763374745320; Mon, 17 Nov 2025
 02:19:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <CA+EHjTzudrep2hEno4RPwh8H88txiVYFoU7AyJYVWG9SFSk87Q@mail.gmail.com>
 <867bvpt25u.wl-maz@kernel.org>
In-Reply-To: <867bvpt25u.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 10:18:28 +0000
X-Gm-Features: AWmQ_bkalvPmo1B-rqo9IVXjMt6TjFkbAXf4VPzF4RKYlhIEuPNWjQgsoTvi3Ag
Message-ID: <CA+EHjTyLGFUDbyr_B1uj5ZpxQA9ypCBy0ZUNRQ8M8VdLmXimnw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:54, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Mon, 17 Nov 2025 09:40:47 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > This is a follow-up to the original series [1] (and fixes [2][3])
> > > with a bunch of bug-fixes and improvements. At least one patch has
> > > already been posted, but I thought I might repost it as part of a
> > > series, since I accumulated more stuff:
> >
> > I'd like to test this series as well. Do you have it applied in one of
> > your branches at
> > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> > , or which commit is it based on?
>
> I just pushed a new branch
>
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow-fixes
>
> that is based on -rc5, kvmarm/next, kvmarm-fixes-6.18-rc3 plus these
> patches. Let me know how this fares for you.

Great! I've applied the pKVM patches on top of it. So far so good.
I'll test this series more thoroughly and review it as well. Stay tuned...

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
