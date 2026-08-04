Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650035C6B9
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785846125; cv=none; b=g7ufOl8p1M6slLEjberDwv1ztYfrnUQGI7MekvFbtD3QMzL0mT5P7HgX9CkAXNcCHphemqz00MmHEORxYU+SG1ZkRku6mV5cTCZISAwwdzwdQxT30D4yLNQ7StvbT4W+SUV5M4UrBiNiuaopdnEnrX9yQDngU7+pxvr/ShCnGio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785846125; c=relaxed/simple;
	bh=K1XdpXzCqeMfT3gx1+GfQWAVnbTVzSRrQini9XusnHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbHHXSFgggijitt6KOiTEztBvFISG7Ssx5lTMZhVrGQyt22EGa97y3VFD04IztX0gjplL3+hLXFAnNTeOqtYw2y6kE0EV2NkRfuR9HIKoy2fmror90A5PygvmjOSfnfuPrFMUc+j9hHGtItz9xnXttieHIRGFGdaybRXQnvXZ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CpC6BOIX; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CpC6BOIX"
X-Forwarded-Encrypted: i=1; AHgh+RqdI+JtYgY1+ozz7xYo+CxJIjRTpZ7vnzKjgwTAU3Nu3M9p13EguBUDM1rbT3GsBs/fubeBEjQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785846121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K1XdpXzCqeMfT3gx1+GfQWAVnbTVzSRrQini9XusnHU=;
	b=CpC6BOIX+6Kdqrp5RhgsQqTPpl5cRQ4HowlS1wzmnxQofBYqHrTMiXBykcRz1yOwmjbdPu
	PHh2LBBq3yA7E7SoLJFkJsjQhLoU35aRIk34vAZv9w4YudcZoXQXrArXWQQZ+iDzBMyhFk
	sFk6l0FFyjAStgBKat5rQe/9ws/CT6A=
X-Gm-Message-State: AOJu0YxMEBYjYVbu1QWXGPGk5gVpAxilMwZFgVzhKqJctIKoJ79sncAE
	x06+rGzNsTI6dVT/IZoT0uzf/KobOTNxcNW6ph1aPohmvqpQ6rnMZXeeBDPXZwVI7omCDkvEVIi
	UdKzRp+u3mKpQt4MydCXy2IcN7dCdWiB03g8fQj3x
X-Received: by 2002:a05:622a:8349:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-52ce3f3c749mr201921cf.3.1785846085744; Tue, 04 Aug 2026
 05:21:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715142841.80544-1-steven.price@arm.com> <20260715142841.80544-16-steven.price@arm.com>
 <865x1rcvfw.wl-maz@kernel.org> <f971d029-84d9-4c66-9875-36fa8f1a2a1b@arm.com>
 <86zez3b6ps.wl-maz@kernel.org> <7beafe29-0c5e-418b-8797-190f1850b18a@arm.com>
In-Reply-To: <7beafe29-0c5e-418b-8797-190f1850b18a@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 13:20:48 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx751071VhZPf6ABaZngTqOdPG+_aVLCTct_G_ksfYviA@mail.gmail.com>
X-Gm-Features: AUfX_mxGnxORLKO8iAowkYu9tpNhSCXZ535sQNq-ffLHKfhzkRZPZxsKS-feAzQ
Message-ID: <CA+EHjTx751071VhZPf6ABaZngTqOdPG+_aVLCTct_G_ksfYviA@mail.gmail.com>
Subject: Re: [PATCH v15 15/37] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Suzuki,

+ Quentin (who's on leave, but for when he gets back)

On Mon, 3 Aug 2026 at 16:30, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
...
> > I.e don't hack into the API. Use the information you already have to
> > decide whether you need to use the existing API at all.
> >
> > If that cannot be done for whatever reason, then you need to indirect
> > the call with a set of operations that leave the existing code
> > untouched.
>
> Please let us know if you think we need to explore this ^ ?

FWIW, pKVM already has this kind of indirection: in protected mode,
the kvm_pgtable_stage2_* calls in mmu.c dispatch to the
pkvm_pgtable_stage2_* wrappers through KVM_PGT_FN(), and the callers
don't branch. It is global today because pKVM owns the whole host, but
a per-VM version would let the CCA backend handle the filter and the
IPA aliasing internally, keeping __unmap_stage2_range()'s signature
intact. That should work for pKVM as well.

Cheers,
/fuad
