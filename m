Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793347767;
	b=iMMHVjhDNIhjqvtfKee/PWtYAiBk7HMMZVcgnnxwrGoEih3G++uD3Xiqq5xdYFJASOuq
	 nbENoSMENab6hZ3/mtASZqSBm5bE9EYCzL3lVkQk4b98jvZmeyCGqffYSrc/0TXI1fJN1
	 nx2wd0cIHrA8Bju2MmlZ2ITowPAWZKr/MqPuqhRM5/VmR9EDk0Nmhx9cnIm2lF+ZPntEt
	 pG1XMDAIObN773bz0nUen6pM0v51eVdRlFRsh/Bjnv87UVjfA1VvotiCDEpdqzqt1dvbm
	 lh/lZIwHslvK8iNZgE/9+xOI54bJqOYIKe7ScNiiRoZM1NbfA8wGfzfkWm7D8yZXn0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793347767;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=TgSyY4/ng5nLiDGto5Kq5ST6lqpDa6TrnCUDb5pZH64=;
	b=HzrbFEM9QXG/HIeOj2WOQan18sGc1Z/FusnDmUYstHFOLIg/oagE8mEjV6JjQdJY0MI2
	 s+YsFr8pqj+aBiOk6QWoanG3bzzT7mqdtSw7rPP5DbfaFerJXYFn1DdXUzQt6CbeCfAMo
	 ohwa7c3/kzl6GLEZB0svJOgDSTjaHOIpdXSwopY6wqS0MycklOs6ZVaUXCK/1ITTCsULf
	 hP86rWcTGJFiy3bUs1EXqMuDL129p8HI4sD+OSWz482WEbp8EQK7/7IZrXuo/j7aVL89M
	 qldPWmVqFbTbmOuZr0TCic5AQa/Dif8CeIuhSfPdYjjjaz6pcqRPpeZRRsseFbuZPxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H8tc1xYp;
	arc=none smtp.remote-ip=95.215.58.120
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45881606A326
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 08:09:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45881606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H8tc1xYp
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=cPlhkNYw3K0eeAGK/JciXdzV5PYFFrSx544N7IS3wzs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793347764; v=1; x=1793952564;
 b=H8tc1xYpf5CiKq/Tv2tRxrQ+0OT59hQkkgtEphKhj4OlopeifxGW3Klg2R8cG5RZAqhZiBKe
 VdWbm2P9mhK1gY6B86bzsiee6lHM4z0+3zK6gsxITB4f51lSFjq/x80wKCuXsslxObaETnIgden
 Jl2r1705QsdDQan2OrrzsUYc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4fe9924e5eaec604;
	Fri, 30 Oct 2026 08:09:24 +0000
X-Mizu-Trace-ID: 4fe9924e5eaec604
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so3971e87.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 01:09:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz7b8T5x1NW989HMpC78qht3P12Rf/9AHQHVbwpsgDWM6DPQ69h9tAjFX8GwXnUg6wsPsgOqDM=@lists.linux.dev
X-Gm-Message-State: AFq9FYLdjKlTGS5Tqh/kViwxL0jIqpsDC9kQxG2rlaxL5w1lYXrut3Wz
	hw6itUzmGmHo1mmar/Uamu54HL3HkRzvrID/23oKX1ltbWVi8nv2iJgGlcLrhvdCaK8sULvXA9k
	juXZTp5NxvfZz6RTUP50Tx5NHwoqRK3d4ZXY6vUhu
X-Received: by 2002:a05:6512:3501:b0:5bf:c9c6:ae92 with SMTP id
 2adb3069b0e04-5bfd18169ffmr245950e87.7.1793347758933; Fri, 30 Oct 2026
 01:09:18 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021110700.493315-1-fuad.tabba@linux.dev> <20261021110700.493315-3-fuad.tabba@linux.dev>
 <auPCV6VdMEz4uZkK@arm.com>
In-Reply-To: <auPCV6VdMEz4uZkK@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 30 Oct 2026 08:08:42 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxKeTG26Oqt=jdUqnCrzTNTW49xggCWJRJQz_XdV6prhw@mail.gmail.com>
X-Gm-Features: AclHuK8pOIsgHYiMxZhDJpGYznE2BIP_eKzJt7aDibtxQihZUGQcXEve-pG0JDA
Message-ID: <CA+EHjTxKeTG26Oqt=jdUqnCrzTNTW49xggCWJRJQz_XdV6prhw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: Clear the whole hugetlb folio when
 storing MTE tags
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Price <steven.price@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Oct 2026 at 22:02, Catalin Marinas <catalin.marinas@arm.com> wrote:
[...]
> > +                      * tags. A hugetlb folio is marked tagged as a whole,
> > +                      * so its first tagging clears every page.
> >                        */
> > -                     if (folio_test_hugetlb(folio))
> > -                             folio_try_hugetlb_mte_tagging(folio);
> > -                     else
> > +                     if (!folio_test_hugetlb(folio))
> >                               try_page_mte_tagging(page);
> > +                     else if (folio_try_hugetlb_mte_tagging(folio))
> > +                             for (i = 0; i < folio_nr_pages(folio); i++)
> > +                                     mte_clear_page_tags(page_address(folio_page(folio, i)));
>
> I guess we could have skipped the actual page we are going to copy into
> but not worth it.
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>
> >                       num_tags = mte_copy_tags_from_user(maddr, tags,
> >                                                       MTE_GRANULES_PER_PAGE);
>
> Something Claude spotted and unrelated to your patch. A malicious VMM
> using memfd (not guest_memfd) and MAP_SHARED could construct some
> mapping so that the VM slot is !PROT_MTE while the same page is mapped
> in the VMM with PROT_MTE. try_page_mte_tagging() (or the folio one)
> above set PG_mte_lock but a subsequent fault on the uaccess to VMM
> memory will attempt to zero the tags and wait (forever) on the page
> lock. Not tested to prove it.
>
> If you get bored and want to fix it, I guess a copy_from_user() into a
> local buffer and then setting the page tags.

Thanks Catalin. I'll look into this and send a fix.

Cheers,
/fuad
