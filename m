Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F0573188
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 03:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707190230; cv=none; b=kjIzRFA6Mjaaabh9kum3u7p1Kd9/h4BLNDvr7NCGMnHP+4bfMGOOZVZuo7o/ZTslX53bGC3dlEkSK+gfetwTID26w66F7CwKJ1H3KZcdtTKKK7U0XPdP8c+Cn4nZMhXYzj3HpEjvXsMPx6jkx9lOHuy3mrBIsk0DJRGHb/4cgOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707190230; c=relaxed/simple;
	bh=zv7vCVQbBPrW0B2XI5TnrFl6LvNX0JR099oQYFk0hEA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cxro9IhaA6sp6TIcpjPtsyLHHIveBrlcKkfd1XL6qxZSYYQkeqRgyTbX/bP+jupXAYhTgefstEYkp9Zxysy0Dqpl/2Y/NxYLSAAU43nPU/jdwP4dN1VsdoJwq96JYP2iiEg41m8bLWGVEqacVV0gCCUkb6OGTpqgk6ixXKvc2Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gPe5kZQ4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gPe5kZQ4"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6040597d005so96191777b3.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 19:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707190228; x=1707795028; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pt+xfWv8IugBoB7mNNPsK7vEotzvYzw0zzpWY98i+wQ=;
        b=gPe5kZQ4AyfiOTsYUaFEzvakHmA1peLkw6wM7Ic0fX+l5XFxPh3zYDbR3csDiGg1gi
         6xszWjQ51bqcPc1lUOvm+53WaPGbFnTC+xmUbClOe3qlbt7cI/Qix7cMi8M3wfzDy1Et
         kRjfz8n/eOQQ5UPRLdkny1Xba2xuKWYcUXYy73chp8MMZ+BS7SDH0OxvNeVaC4ZceJIu
         COQijJDQj570wkRSKk14ChVkS9586JTJH6Lryb1buCwWnAfTxEUolXS/92nJdAhUxSfj
         2b0TwNSAlU3qXeHUwbxkD/+mB9HdQlUvzmxiTjFyud6hzZNnSUZ5hvNVCCDGanP/oqK5
         N54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707190228; x=1707795028;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pt+xfWv8IugBoB7mNNPsK7vEotzvYzw0zzpWY98i+wQ=;
        b=w7JmSjZefkPNxLRnMsb6Ey3vDDvoFC3tQuTQCjsQAb+yD4vTwkbDXC5Q9wurOjuAUA
         DiZ9R9QoP7CilmRWELw397oMhoJrq6bffVExOV87d3cl9yrCr15WNsOMZnIT3kpHl8G2
         AdGsCKeeoOaYxJ0/dEoDkB1H48ouKrs14KLWSJ5u1BIWY454PisIgZnj8azkRfbt+HiB
         LxxuJr0HnmpO1HPJoIagUVy1FGHxTsiXqfFooH8CDt+bwXjfiZYMzb/jC7y83+XM4Ll5
         nWy58o1sVXnu5AS9+whjmxp7KR8Fj1NqE+V9nejC+4ca3yEjAjvJnSZUPItvV+qALz5V
         P5DQ==
X-Gm-Message-State: AOJu0YxgHl/G4vRmzgemmLaNsjQ2xd/w+S/xeJHx8TOlxoyCvmN9JQb2
	UWGJzIFm5j2Oc6LD9WNfxVvzkz0YV4+IMe6egDLdSyh3T+z3/2n7d1lWKQ/Ae1gbqnLlX8G180Q
	NsQ==
X-Google-Smtp-Source: AGHT+IGeICVQ02NeiSaxOWeov64L9LFkyRd2MjpVPnbBri2C/x18Z/L8boGFRDBdYT34E3OXOPhqdcQCE8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4cca:0:b0:5ff:dac0:6524 with SMTP id
 z193-20020a814cca000000b005ffdac06524mr91662ywa.3.1707190228139; Mon, 05 Feb
 2024 19:30:28 -0800 (PST)
Date: Mon, 5 Feb 2024 19:30:26 -0800
In-Reply-To: <ZYJFPoFYkp4xajRO@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
 <ZYJFPoFYkp4xajRO@google.com>
Message-ID: <ZcGn0t3l8OCL5mv6@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023, Sean Christopherson wrote:
> On Tue, Dec 12, 2023, David Stevens wrote:
> > On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Tue, Oct 31, 2023, David Stevens wrote:
> > > > Sean, have you been waiting for a new patch series with responses t=
o
> > > > Maxim's comments? I'm not really familiar with kernel contribution
> > > > etiquette, but I was hoping to get your feedback before spending th=
e
> > > > time to put together another patch series.
> > >
> > > No, I'm working my way back toward it.  The guest_memfd series took p=
recedence
> > > over everything that I wasn't confident would land in 6.7, i.e. large=
r series
> > > effectively got put on the back burner.  Sorry :-(
> >=20
> > Is this series something that may be able to make it into 6.8 or 6.9?
>=20
> 6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, I've=
 done
> frustratingly little code review since early November.  Sorry :-(
>=20
> I haven't paged this series back into memory, so take this with a grain o=
f salt,
> but IIRC there was nothing that would block this from landing in 6.9.  Ti=
ming will
> likely be tight though, especially for getting testing on all architectur=
es.

I did a quick-ish pass today.  If you can hold off on v10 until later this =
week,
I'll try to take a more in-depth look by EOD Thursday.
