Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8519B5A3
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 13:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059375; cv=none; b=ikLuFc3vhvmlB8pwGivU9oJq+/cq5XgPJ+Hnow2tvHN92UVS060lOLUSATBlZWxBsBffKDb2WufCGhUl4iP+DGOGoO4M1EY86ljUy+XfMH5SNf4JdFiDm+plePPXJLtoD6oPOYBemJtHzKQAc4IN7uoJGvFy7qAvpZbfi/E+5UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059375; c=relaxed/simple;
	bh=8sd1ImM8DoqK9W8lt1KuphpIcTi6YN8Ipnhx1kfGSOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PH3dHHDPFgzzo8J+Plp2fn6qq+/Q4oGxKCMeO8eavVrx/GY0LvCdl4yrN6i2bvvkWqFKLwe6D+pxDP504Kk3QE7orq9rVnArSYt/8jU+f7JaPOjTd2SZCAnidZE4Hbz9lXxyA/yIa8ujol5G8jJ1TSinM4u4o0GVMFCoFF1818Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e33GHtLz; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e33GHtLz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8sd1ImM8DoqK9W8lt1KuphpIcTi6YN8Ipnhx1kfGSOY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787059371; v=1; x=1787664171;
 b=e33GHtLziGb32c9U6JSw4dd+zcwAXbDaJWEU0ZR+xpdGJDEbNAAD0+nA4yII40H1oJv3WZXQ
 KmuLk0q/10V4xHaKHwLv7P5epG6RrBlfkxc5NBcBaeT5KTTHEth+6kRpjukgsADJy05TCytkUVL
 CgRdU0BMEbandL7rslGLApZ8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f50.google.com (209.85.167.50)
	by smtp.migadu.com with ESMTPS id 4bba23d07b89262e;
	Tue, 18 Aug 2026 13:22:51 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so8714e87.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 06:22:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoqMcvDuSZFPwylDk7sGkinALCFMNAI8ogGhIalAso/zH5NZKK+3WJhivqJmJ9ML7EkvBsy5go=@lists.linux.dev
X-Gm-Message-State: AOJu0YxynoZfOOGhOPig4Fpb/oZrt9/wt755hbP1LnW+tb2P4LKdVIaR
	sUNFCkO4ah1A4sAKkYH+VyUb8G7c0YfcyCCLjogCdJryL6KPCS7jrZFgg38IWNWiRoq7UDdnWss
	85l3Dj15MPDqWswUtAHPfi/63ZJnEWkgTNjJltpgJ
X-Received: by 2002:a05:6512:3c84:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b47435fb3fmr174179e87.9.1787059365308; Tue, 18 Aug 2026
 06:22:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-3-fuad.tabba@linux.dev> <20260807105558.73D701F000E9@smtp.kernel.org>
 <CA+EHjTwVKkAwWUeMrF_m2-35kyhESqAezOKJy-Pj=vA3qE5Bjw@mail.gmail.com>
 <87fr0pq5uu.wl-maz@kernel.org> <CA+EHjTyQ-1sUhgs0LNuPa-VJ=J=+vS7UCwJJU0ATJG9LtEQpSA@mail.gmail.com>
In-Reply-To: <CA+EHjTyQ-1sUhgs0LNuPa-VJ=J=+vS7UCwJJU0ATJG9LtEQpSA@mail.gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 14:22:09 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyDix+y6NTLTsXP5j9Sn2VLOZcsw94LntQxg_etRBJZuA@mail.gmail.com>
X-Gm-Features: AcwNN1XKkVvTo2mJqhihOHA24gckO8qA9o0xqJestbJceVWVo9JpC11WbONO-n0
Message-ID: <CA+EHjTyDix+y6NTLTsXP5j9Sn2VLOZcsw94LntQxg_etRBJZuA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array when
 init is retried
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi again Marc,

On Mon, 17 Aug 2026 at 19:40, Fuad Tabba <fuad.tabba@linux.dev> wrote:
...
> > I really don't want to have to think about the intermediate state.
>
> Agreed. I'll drop the idempotent version I sketched and do teardown
> and reinit instead.

Here are my thoughts. Three patches, all fixes.

vgic_init() will undo what it created when it fails, so
KVM_DEV_ARM_VGIC_CTRL_INIT is all or nothing and a retry starts from
scratch. Same thing you asked Karl for on the redistributor rollback
[1].

That drops the count check I sketched. vgic_v4_init()'s early return
stays, since vgic_its_create() still calls it for an ITS created after
init.

irq-gic-v4.c goes first, as two patches. It removes the domains and
frees the fwnodes without clearing the pointers, at four sites, and
the teardown above makes that reachable on a path where it was not.
The second is a leak in the same error path: when
its_alloc_vcpu_sgis() fails partway, the SGI domains already allocated
below it are never unwound.

What do you think?
/fuad

[1] https://lore.kernel.org/all/86jypv1lxo.wl-maz@kernel.org/
>
> Cheers,
> /fuad
>
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Jazz isn't dead. It just smells funny.
