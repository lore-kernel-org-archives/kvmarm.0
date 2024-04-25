Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4C3155A39
	for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714085793; cv=none; b=N1vfibzuCt7THA3cImbnO6exwwPRxil++USwkUqRSZlDodv0VlD31PhcY5paQJb+98u7GtEpn3ZfJ0FhMD2hxbt8BRFH0WlFD8dQHH4MKcKa47kAaGzMol9domiejjm1aARbMY551baqxTnlgjO4pLp9k1cACCK5MmP7eoD55TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714085793; c=relaxed/simple;
	bh=KYtF1y9QVO5lRyrlFu3LypLQR8DFwKeNUbD5+t8eWAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IrDzwmo5MD6W9APfZDpA2cVXSWVXaY7Wr3Af03wLrxAvabSfoMUYNuQqMJRJkW5k5b9YfdkekWw56UdVGzabiScWUrONRYQIVD8nwVmqioAgeOrglTMzt/CiWgmbFIAYxCB/v/F/prIVvRqzGfo5L2TVncGg+bhBoThjF6YYxp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o0/S1fyy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o0/S1fyy"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b76ab0b46so26496127b3.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 15:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714085790; x=1714690590; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkB0Oe3ETNpX0Q3btEZQH9RDe4KISQYsNCkxgD0xRNI=;
        b=o0/S1fyyXHIA7p6gsN7ZrcQUC/41bgVL93yI0v4S/pxoqmHHjDSj1VlPrT8x2+OUFW
         YUd4TWQA+DJf3j2NEUEUwmJElgt/GQNPFP9eQP22GabOvhh1StS+EO016BZxSYlOItKw
         WM8+baVTTY58RTHAd17AxAqQTXPJ8X9DP/e2hk2AB6Mqy162kEkWctTLbUHx4Mu7fxrA
         5rdo9YefVqttI4LPsATnmSZ6Y2eAOlS3sNLH6cygOO2HvZl93QtvMekhFV3eGzJiugxW
         WajnfIj0/XURwVWVCwsd0r4a4CWzPDpKv2orDNKkSFoCE+py/vuNINFGGJve8etocexj
         ao+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714085790; x=1714690590;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kkB0Oe3ETNpX0Q3btEZQH9RDe4KISQYsNCkxgD0xRNI=;
        b=o/ACW3hddTW47E+v9ATadQlcvAGbin9fmM8QBCn6hSO40xGHAAoFj5QyuIQ95C+l1f
         ukm5UyNEcl+1r5WIIvh6t/5SSVqFzh7qksFHPbv8ATF2phswxn8sn7QJKWs6IpL5ZbYQ
         8DXlvLIbY/za7bZAsdFVj391DihygCVhR9/oLRTHsyFfua0uY3sEO7nuPVQzQxmpnkwU
         l1+1ETE5cBuJMalSu1TBgXSwQ+OhDWtoQiMhkUUO1gYl8MiXx6RjMXMDWmCZzL5w+7AX
         QnL9Q4QyvN2yJINGrVOH+8YKJpBOOi4IqC+0CotY/Xwndwe0EtYMIyfQ7YcN3XBUgnj+
         +MPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7C6IH+us9g3fXkXfK4X3nGVZ5bbIQ45BYqyC4JwWZDDpAwQSxggzyL+tPFHhTwor8fvcz0eqqEUpYN7NKVpU6Xqx4ms1d
X-Gm-Message-State: AOJu0Ywb+55rt9USPMdGA7WUIcD//mJDy/RLOlVPJ7FUkJ1uJzNLsX/x
	VxZyd5cc/hFooaEEw7661fKGMKDPSGCZLDbLpngoOyepaz24MdHC60kz4Ne9ytOOO54/7E6nMNf
	Y3g==
X-Google-Smtp-Source: AGHT+IFK9QispM2ICO/aS/Bc4lsJTNQ0CRIQjWqhFAfzup1zpNtFb4vtBZLcBygyOTGdpJexadd4ZWJU6fQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:15:b0:61a:b2d4:a3fb with SMTP id
 bc21-20020a05690c001500b0061ab2d4a3fbmr220432ywb.8.1714085790530; Thu, 25 Apr
 2024 15:56:30 -0700 (PDT)
Date: Thu, 25 Apr 2024 15:56:28 -0700
In-Reply-To: <4195a811-7084-42fe-ad10-27d898fb3196@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com> <20240412084309.1733783-2-steven.price@arm.com>
 <CA+EHjTwDaP6qULmjEGH=Eye=vjFikr9iJHEyzzX+cr_sH57vcA@mail.gmail.com> <4195a811-7084-42fe-ad10-27d898fb3196@arm.com>
Message-ID: <ZirfnPFPo1cMwFQc@google.com>
Subject: Re: [PATCH v2 01/43] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
From: Sean Christopherson <seanjc@google.com>
To: Steven Price <steven.price@arm.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Steven Price wrote:
> On 25/04/2024 10:48, Fuad Tabba wrote:
> > On Fri, Apr 12, 2024 at 9:43=E2=80=AFAM Steven Price <steven.price@arm.=
com> wrote:
> >>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range=
);
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index fb49c2a60200..3486ceef6f4e 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -633,6 +633,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_=
hva_range(struct kvm *kvm,
> >>                          * the second or later invocation of the handl=
er).
> >>                          */
> >>                         gfn_range.arg =3D range->arg;
> >> +
> >> +                       /*
> >> +                        * HVA-based notifications aren't relevant to =
private
> >> +                        * mappings as they don't have a userspace map=
ping.
> >> +                        */
> >> +                       gfn_range.only_private =3D false;
> >> +                       gfn_range.only_shared =3D true;
> >>                         gfn_range.may_block =3D range->may_block;
> >=20
> > I'd discussed this with Sean when he posted this earlier. Having two
> > booleans to encode three valid states could be confusing. In response,
> > Sean suggested using an enum instead:
> > https://lore.kernel.org/all/ZUO1Giju0GkUdF0o@google.com/
>=20
> That would work fine too! Unless I've missed it Sean hasn't posted an
> updated patch. My assumption is that this will get merged (in whatever
> form) before the rest of the series as part of that other series. It
> shouldn't be too hard to adapt.

Yeah, there's no updated patch.

Fuad, if you have a strong preference, I recommend chiming in on the TDX se=
ries[*],
as that is the series that's likely going to be the first user, and I don't=
 have
a strong preference on bools versus an enum.

[*] https://lore.kernel.org/all/e324ff5e47e07505648c0092a5370ac9ddd72f0b.17=
08933498.git.isaku.yamahata@intel.com
