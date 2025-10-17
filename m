Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9263FCC
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760659808; cv=none; b=ufqSoM/870cx3Ijhjsrd4NqUUYHzwHQdyJgtNN/Q7GRwgXZYE/sMDSv5VpX3jwACnF6xigRDrVmh5pqs+s3HlIYhzJNnyNjeEzp65yPuzIIUkdO7BzXJXSpEH4H7Tvr42fOzPMuEB06pG48R3s443fXgYqhU/pRDyslHO73e5Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760659808; c=relaxed/simple;
	bh=E1AC9iyyw2ScMA/Vd6Wp/4knwNlCQVVOev8xoskItFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zxm6Ntm3H26fgK9TM/NyKZhuALfNx9D1oujrZI2KGEMKuPkEf8nAPP6yN0zTshfPigShoTKmC8zvIoSL+NguOv2/Uztj3PjanE0ELBAz/fCw4HyAdq+Hc9LmlYbbqd7q0jcx4KIofBVGi21nWV8E25wQ/Wa+iwpDrEYroK3cp0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TAxGBz1b; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TAxGBz1b"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-290aaff26c1so3373565ad.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760659806; x=1761264606; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1AC9iyyw2ScMA/Vd6Wp/4knwNlCQVVOev8xoskItFw=;
        b=TAxGBz1bP5y6ARqMTeYy46UznFwRcd65Hrzz9aEArQN8L2VJL762GBYyUhxM1zytiV
         PmChw6TZIxtsXnP2K7iF6aAb0gEIaBYxhuTPv77Kuc1aej8wsxMORQ6ySN12NY7G5M1Z
         N+zY/+VKMdKKVloqBNx7g1f4lIgbw/2RLcjdvBrJ+zdwfndYk7Efd03R9CImr17DAHwC
         TV/KowxkrKyAv0b2yg9SWsgX7dr22VpntMJuXMLJGJQ/nRWnxXzPpRNCY0AiIc2tVMQe
         JrsLFeAc2Gc+6BtKPGtOOP2KA23SetRMM49vUlbnkMqQDWWjQvaec7GbktB7S9Z2+xsj
         VGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760659806; x=1761264606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1AC9iyyw2ScMA/Vd6Wp/4knwNlCQVVOev8xoskItFw=;
        b=wqkItWoVAYJtPWtdzDHj+SG7+gxgsNu7NtpF3pSwmGU7aBdLG24bcIBii8CGBc1Ohp
         eA85PDlwFBk+cbvRYfUcZVMKozT107VZLYEH7N194KH3NdRmE3QnSOVSXOugtBPwCoXW
         yGsZdeLQNNtqGy415CVuz2UoOBtyl/AhYF62vqnPL8yIcibHVwF43YYzZs9Rx07dJqtD
         f3nzJBRLmDx6x4n5S/3jYbGocTQDdSMDy/1pI+cRaap8JMVNR8t2q11AKwV08kJxGfKB
         ++b0+oXG35YI5VfVba6V/5NJPLpWi7i4zQNXGCWxgOGJvtBHzWV9hNibfo5qqT2V9Tkt
         2jhg==
X-Forwarded-Encrypted: i=1; AJvYcCWHm3brNV1OImXuxY/odvIVGvsVk9QG+nipHp5JEO1ZxFx4bP+Ppd5R/V08nASQKQ4kjWKgfJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaaQ8L7THHLlxdmhlNVImrp+5YOTJM2Dux0/OjFOmlgdTPPdA2
	B018cWjdl7n73MJDHxscbp2DCxQdhObXtkHXqwBwrKI2D/ZvNyrbVF+a0XZclmRAy3BjRJU39TH
	uWbjYd73wGrpDX8tKNNV0jGB1OsCTqBA=
X-Gm-Gg: ASbGnctIqNR5SD6DdXlgTDT9HNyn+ndk0z2R1au/g/sv1TVPNW34vf2EkpEIR43t0g8
	F5fjG3JYJpbImym9fMII6SQApm2QkgRmw+hhjvQ66OO9++kCJGhY0Pvo1QI37PY1M4cHilpHUfC
	+tDXK1ty1PDUCEnlNqbhalxIpHXJaAe4Xd1wHo81yYrHO3xE8K4B1Avu76GSu445G98zh8jPVXK
	ZMLN2R53sRitO9GM3iTYESJdd8mZBWNfLfipOUbkhVv+6kapCYmkgnq1xnjgXgeOkuhsJI3a7qC
	g5A7qHaWq+MYEnzdmsgLKy+1XnF91fRmR30KXERQzeI/f6JQ3kJaH8wc+KnCA+1PRCBHTLsRQlL
	7s+QTeaLgbNyIug==
X-Google-Smtp-Source: AGHT+IHyIQx0yThg9KT154kOAtD8f8239Y2M/cEMXBlvtxveyWdxtgQX335VASRAYK/45RIQjcQyHtpm998s6Nd9ll8=
X-Received: by 2002:a17:903:248:b0:275:c066:33dd with SMTP id
 d9443c01a7336-290cba529f3mr11403495ad.10.1760659806208; Thu, 16 Oct 2025
 17:10:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com> <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
 <diqzqzv2762z.fsf@google.com>
In-Reply-To: <diqzqzv2762z.fsf@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 17 Oct 2025 02:09:52 +0200
X-Gm-Features: AS18NWCDoiITBSs67Uq2rZ6IBFom-AeoZUx_UgHO9S2h4SATYKwpJteeHcfF5xU
Message-ID: <CANiq72m0rNCaKandZgRa4dMhNOEN7ZanT5ht4kT8FLxYoWLVLQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 1:57=E2=80=AFAM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Using the command on virt/ would pick it up. Would it be better to add
> "virt/" to the "automation" + update .clang-format while we're at it?

Yeah, that is what I was suggesting if you rely on it (and if the
maintainers of the relevant folders are OK with it).

Cheers,
Miguel
