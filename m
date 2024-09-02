Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3751CB508
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725289180; cv=none; b=OMCGuYGI0/7QGUyzDV1T0oP523WQIBkoGnuKlR0KDP2jlzAtG/NC2/D9AmG9UnujBSZfUbznUhrWMLkCjR+wReP371ca2wKr33F3NVF4bL85+9OrgbynzaFcvxLa33zj/cjN9JDqgkjQfS/4X+umYaw918U5PcyVuyr3vduTL6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725289180; c=relaxed/simple;
	bh=CgTyxOo8Jl5Q+k9OoEFPn1JOt4mCXe8pIKl51Z9r2Zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9Al/Wx0ZXwfaMSWeM8/Xd2Ep2JHwMkfOBUbaqFgKmgpIGAMPzW7gufyZNGh3TKPRTHPxCEgxaqrhoPynUgxqlNpOUr/7QrFsDGQg35JPS//ULFFhfBpIPKB2PDNviZOR6wqXHboPjAnrEvMb07RgBmg4q9lx19LWXBJa147lGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LV8Vx42t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LV8Vx42t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725289177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CgTyxOo8Jl5Q+k9OoEFPn1JOt4mCXe8pIKl51Z9r2Zs=;
	b=LV8Vx42tAAZaZ36mdUjQ4MTM8A17brHdDv7mBrK0BiT4l+7BYqaMAUikzNzqGfHOtV/GQA
	GJvpCQGF6/em+V+sbKzhdQBhl6JKryJNFNU9JC9xFH7ESn2jOpMWqAFsBiGF9D2n0Aj80W
	R+5SkPUi8xY5h3cCRummllTiPjilBaY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-6hUVOL2zMEKqYwE3uptN8w-1; Mon, 02 Sep 2024 10:59:36 -0400
X-MC-Unique: 6hUVOL2zMEKqYwE3uptN8w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42c7936e564so20000725e9.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Sep 2024 07:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725289175; x=1725893975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CgTyxOo8Jl5Q+k9OoEFPn1JOt4mCXe8pIKl51Z9r2Zs=;
        b=Sw444ZqxKyxLZY69XW3ZWsad0QN+FRq3k2cGm0gORy7gGXCMNrPN4YCsgb+PC5G2ww
         s8DZbf2lpAdHBGmzNpx15uJvD2TmUlzkS5kF1+kMuCVu7UAF/vVsZZb/c0a66eh5LdUs
         1uNu6GumpQ/sAZAJaigr8YFyjYDehtIT6D5cWoe+TO/pf84dJ8Pnha4CALiZpnhmGH1a
         pkRRHrwKEJlxVgO9i+nM8MQDgS8K7eFa69FSjK/yZhc9D/HyzyBdfR35xOuZHSx9Kpdx
         FGsCwRHOoN0NCrH28SbKXC0pWKHA3Vt69QxJI6VyItOmP31VNCLCEanUN0mal8E6F7D9
         s+FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT2FwNi1LdAUo2ItzeTmYlK4TBNBFqEa+oJLTB9an44q1oyKBcUzRWUqiUjw/x99FzDdrgbtQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyerHVHyGZueSfIk2ra0EjlfWy9Top6OazRQmnBZ+n2w6dOkxni
	LTBZxrIobxuaOkS3aWe2BWtKNqWzx781FrfzDONc+H5djp34LMk57ogE/yvosKffGgQBxqJWIkN
	7WlkCeBLND0DcMv6e5Yu552+rc96r0LJToRUTBJy7esAqevqExUIDz/tqTAdQfyqOJPqI/XXHp1
	R12ezVnuFabt4lLr1dao8MsFfcQ7dm
X-Received: by 2002:a5d:4e01:0:b0:374:bd03:ab7c with SMTP id ffacd0b85a97d-374eccc299bmr199094f8f.33.1725289175429;
        Mon, 02 Sep 2024 07:59:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgxSO4P7+F3cMCBY369yImj7GvTpdVVLeLtGciNsfYGQwOJyWr8f63VuFOvFicjE9kRzThXGBTwX2LQ8U0ciA=
X-Received: by 2002:a5d:4e01:0:b0:374:bd03:ab7c with SMTP id
 ffacd0b85a97d-374eccc299bmr199075f8f.33.1725289174997; Mon, 02 Sep 2024
 07:59:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Zsb4kbq6FAfgg4WA@linux.dev> <ZshONupF3nIhAlRf@arm.com>
In-Reply-To: <ZshONupF3nIhAlRf@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 2 Sep 2024 16:59:23 +0200
Message-ID: <CABgObfZ=P-Qc20SD=duFtDbCefWGO9YoEcA=S0DaTo59x58iYg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.11, round #2
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 10:54=E2=80=AFAM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> Hi Oliver,
>
> On Thu, Aug 22, 2024 at 01:36:33AM -0700, Oliver Upton wrote:
> > Paolo is on holiday for a few weeks and has asked that KVM arch maintai=
ners
> > send pulls through the architecture trees in his absence.
> >
> > So lucky you, here's a pile of kvmarm crap from the past week.
> >
> > Details can be found in the tag, but this is a set of small fixes
> > around the shop thanks to syzkaller bringup on KVM/arm64 and a few
> > recently introduced bugs.
>
> Pulled into the arm64 for-next/fixes branch. I'll send a pull request to
> Linus later today.

Looks like this pull request was never sent (the last arm64 fixes PR
is from August 16), so I pulled this now.

Duplicate commits are generally harmless so it shouldn't be an issue
if they end up being sent by Catalin as well.

Thanks,

Paolo

> BTW, I'm also away next week. I'll randomly check emails but if you have
> another pull request, better send it to Will.
>
> Thanks.
>
> --
> Catalin
>

