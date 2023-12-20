Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C955C79DF
	for <kvmarm@lists.linux.dev>; Wed, 20 Dec 2023 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p9gMJt+c"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e7547e98f1so3333787b3.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Dec 2023 17:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703036224; x=1703641024; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMpPDRTJH35hvvkbLxFhPjnJilPUQ+sVkxQSPUGNzAE=;
        b=p9gMJt+cA6nrpLCIVcC034VgLFW7QjQhMjN9EbZ+1lYtGe6N4Bjy1XRND/dx7Fc8XD
         kSF0Yxm4zwor07rv2xt6Ltz0DG5ruATlGw4A82Xq75zRr3WKKducq46UvSQpC9ng40dS
         0ZvnYyugk1Qo3XRQYaLPRkDmKTj+Dm8DWxdCe4IzMi5yWbYTPyi3Se3/lzxjMnK/ZMao
         0mA3xXCIci1Op6qSct58xUw4wlRhhAHW3deY8WYaolXaXQwQumYNHuvX6Y9FlIYS4Akb
         iz0JrnXsPQcuqVWw0vfJVGv+T11tkA0x6CRSrZIJtDWjmKF5M7IoTUJWIqjchfGfObm+
         AFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703036224; x=1703641024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZMpPDRTJH35hvvkbLxFhPjnJilPUQ+sVkxQSPUGNzAE=;
        b=dC37bbXNilsxtrSxPj4ylqKHa2tKlIckIhSlnYvVmCYD/yvy3p1qY9xM9r1X4qzRvZ
         rXnsGv+5vWznyaFpgh8k0ReUNsNMjXhnmpbLThKXpafGkE0BXzH5ZfgBdXHQsBRg5oi5
         dVWhUYlKJGE5fC/mpVJDyhGqq1ZvbbaFzOzA8iFRoUTBkzjEqbAhUlA2JKZ8dL+drXvG
         /tq6shKxmG62sVN46jAU5qkGnm/qvqe52Dcz+1Ofva9HCnrHEnS/2mkVAZR6SSH7QBGr
         6C7sLnDSU71inQZIrtSUm4+1hRYtOTD1IsM3NKUUmTPIsJT4GrzLnQxfnCzOaqVqAjdf
         XP5Q==
X-Gm-Message-State: AOJu0YxinhZhjBVunWe2sqgsc0Rs5EtlhRD9hzdpNLp0W/2Z8ag1U8pj
	PYEFBiFWHdzXriBP+YDja/+oP6KjcKQnwK+n3A==
X-Google-Smtp-Source: AGHT+IHkW3C5TUe1j64s0L+R/fMZTOwVtCHzR1lHKvZLh86Uotwca9XCKzPvHhUBb8usj/+FHyFqnAW4Z34=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2913:b0:5e5:d445:d9a9 with SMTP id
 eg19-20020a05690c291300b005e5d445d9a9mr688492ywb.3.1703036223803; Tue, 19 Dec
 2023 17:37:03 -0800 (PST)
Date: Tue, 19 Dec 2023 17:37:02 -0800
In-Reply-To: <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
Message-ID: <ZYJFPoFYkp4xajRO@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023, David Stevens wrote:
> On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Oct 31, 2023, David Stevens wrote:
> > > Sean, have you been waiting for a new patch series with responses to
> > > Maxim's comments? I'm not really familiar with kernel contribution
> > > etiquette, but I was hoping to get your feedback before spending the
> > > time to put together another patch series.
> >
> > No, I'm working my way back toward it.  The guest_memfd series took pre=
cedence
> > over everything that I wasn't confident would land in 6.7, i.e. larger =
series
> > effectively got put on the back burner.  Sorry :-(
>=20
> Is this series something that may be able to make it into 6.8 or 6.9?

6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, I've d=
one
frustratingly little code review since early November.  Sorry :-(

I haven't paged this series back into memory, so take this with a grain of =
salt,
but IIRC there was nothing that would block this from landing in 6.9.  Timi=
ng will
likely be tight though, especially for getting testing on all architectures=
.
