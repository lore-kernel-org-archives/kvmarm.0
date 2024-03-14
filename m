Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B646FE17
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710427546; cv=none; b=qGIoiKjvSGQiurixvYwvleInpyGVYPMH3E/YoILFwkcKjjYZfDKDAbNoj35VYtsGTsdIF8gJQ2qJqO5wH4FuVH7VsHhMQKAxk0rJlo4ESklp2NLB1yuVBEf2gvvDBzKWO41dVuYkvmz4sFbRI5ht1dksW3u62045NmqiL1stju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710427546; c=relaxed/simple;
	bh=BwYbNtMX4PnyM344LqBkdMRm1pxVcNQYFxGRXHYxk3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N7FVxzJzeFO68SVwCUV6V59wia1g5mXPwyh45KU6Co+e46tlym8BTbVoxMetdygVmCOTtxP/mdZ0Lp5paHu5IrzXLrN7aWVnF44PKO5WurgV6BKGu5y3I2/c6PL/wmheILDpdqQbCdb4U0cR9/ybt3ZnR+px1EhiPGeJfUUts3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mZWfIoOe; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mZWfIoOe"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a61b31993so18596227b3.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 07:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710427544; x=1711032344; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N/k6WMtb7RwOB5cuqYeM7NcbURLzoglqZlXeN+xJ3W4=;
        b=mZWfIoOegav6FW6g4j1N3LbhGZh1ztWFuGXRkhEE3I2GgDRplfB7V8XyNAJaM98yhV
         bxWG0ar479r5DaiEhYhF82+88B8Nbo56F+kap0UzvCKMGKJdL0bXO667psBJYSLxMfGe
         eoToAYrkNcksuvisRp/pdWe5GX6eeRGgnniC2uuBWHzIK1KTU7OXeWGvUQBX9N5SCmwA
         UC1hr/8HvrQkEIuAfB1LX9k6twnHnfuOBodp9XI8qegrmD8ZUnA4fG1vSPTFEbyftNBX
         sNhyoDsXo7+nOnK5rRiJLix+mF05qVn2UJRP1rpCqLtjuD2injC0bViG5n5ZWuxw6Wl9
         uCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710427544; x=1711032344;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N/k6WMtb7RwOB5cuqYeM7NcbURLzoglqZlXeN+xJ3W4=;
        b=rhUOUkahN+QKksExISU922btM+M9WRlHZ8NUmuP2K5iBwf+Zw7UAKXUTUnOruoTfa5
         RVi9KS+/M+e5Qgr6NR2Xr9hKa3UJIC6dGJ5g4hAfrVV3BQ4ejXCCmCSkFq6L/MQgaHoB
         udPFo04YetZN+wmPLC0S7ehYS4xQcw9HIhT73y/gZhLr1w+1vbwdt3HMpcxESs7tmM9e
         DKk8BtrNJz7mbKq8jJt3UNIaABz+Uhea1H1Rs6249x/XMwcc0To5uejKI7izvTYVyeKr
         jsgZRdVVZIxlbFSkMpuTGP1VZHvzLlQG0gUdaBC5rKAe3sdKYW8YsU2LbmqDRTiwl825
         dzAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo8wTkmSKBHHwPU5+8sfPh7HwJtBa4dJi8xlMLR+Xd5oZeejbiLLzZ8YmeGF3BxEdd/zwFrCtU1yFJnDEI3x+7D0YNlEz0
X-Gm-Message-State: AOJu0Yys5VLOtdkNRiuhgywIIUMIRypgfMzK3Uc0vyjd02eX69AuYIsx
	7AR8mxLT1H2v95enAMYStpGM0ERUydarCy++xXS67aNgu8lD7+0qqGRKeSlEmqNtNoVKVEnL7AN
	W5A==
X-Google-Smtp-Source: AGHT+IHpdqj6RcMzNjIcmD1eQX996cq7nCJZKMO6Qyf7mySaaPKB0yPHDYQWu5bD5KeDwG8rKwGqMIGgd/A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2848:b0:dcf:b5b8:f825 with SMTP id
 ee8-20020a056902284800b00dcfb5b8f825mr550085ybb.0.1710427544358; Thu, 14 Mar
 2024 07:45:44 -0700 (PDT)
Date: Thu, 14 Mar 2024 07:45:42 -0700
In-Reply-To: <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com> <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com> <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com> <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
 <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com> <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
Message-ID: <ZfMNGMopN_Ncy0mf@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>
Cc: David Stevens <stevensd@chromium.org>, Christoph Hellwig <hch@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024, Christian K=C3=B6nig wrote:
> Am 14.03.24 um 12:31 schrieb David Stevens:
> > On Thu, Mar 14, 2024 at 6:20=E2=80=AFPM Christian K=C3=B6nig <christian=
.koenig@amd.com> wrote:
> > > > > > > > Well as far as I can see Christoph rejects the complexity c=
oming with the
> > > > > > > > approach of sometimes grabbing the reference and sometimes =
not.
> > > > > > > Unless I've wildly misread multiple threads, that is not Chri=
stoph's objection.
> > > > > > >    From v9 (https://lore.kernel.org/all/ZRpiXsm7X6BFAU%2Fy@in=
fradead.org):
> > > > > > >=20
> > > > > > >      On Sun, Oct 1, 2023 at 11:25=E2=80=AFPM Christoph Hellwi=
g<hch@infradead.org>   wrote:
> > > > > > >      >
> > > > > > >      > On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christo=
pherson wrote:
> > > > > > >      > > KVM needs to be aware of non-refcounted struct page =
memory no matter what; see
> > > > > > >      > > CVE-2021-22543 and, commit f8be156be163 ("KVM: do no=
t allow mapping valid but
> > > > > > >      > > non-reference-counted pages").  I don't think it mak=
es any sense whatsoever to
> > > > > > >      > > remove that code and assume every driver in existenc=
e will do the right thing.
> > > > > > >      >
> > > > > > >      > Agreed.
> > > > > > >      >
> > > > > > >      > >
> > > > > > >      > > With the cleanups done, playing nice with non-refcou=
nted paged instead of outright
> > > > > > >      > > rejecting them is a wash in terms of lines of code, =
complexity, and ongoing
> > > > > > >      > > maintenance cost.
> > > > > > >      >
> > > > > > >      > I tend to strongly disagree with that, though.  We can=
't just let these
> > > > > > >      > non-refcounted pages spread everywhere and instead nee=
d to fix their
> > > > > > >      > usage.
> > > > > > And I can only repeat myself that I completely agree with Chris=
toph here.
> > > > > I am so confused.  If you agree with Christoph, why not fix the T=
TM allocations?
> > > > Because the TTM allocation isn't broken in any way.
> > > >=20
> > > > See in some configurations TTM even uses the DMA API for those
> > > > allocations and that is actually something Christoph coded.
> > > >=20
> > > > What Christoph is really pointing out is that absolutely nobody sho=
uld
> > > > put non-refcounted pages into a VMA, but again this isn't something
> > > > TTM does. What TTM does instead is to work with the PFN and puts th=
at
> > > > into a VMA.
> > > >=20
> > > > It's just that then KVM comes along and converts the PFN back into =
a
> > > > struct page again and that is essentially what causes all the
> > > > problems, including CVE-2021-22543.
> > Does Christoph's objection come from my poorly worded cover letter and
> > commit messages, then?
>=20
> Yes, that could certainly be.
>=20
> > Fundamentally, what this series is doing is
> > allowing pfns returned by follow_pte to be mapped into KVM's shadow
> > MMU without inadvertently translating them into struct pages.
>=20
> As far as I can tell that is really the right thing to do. Yes.

Christoph,

Can you please confirm that you don't object to KVM using follow_pte() to g=
et
PFNs which happen to have an associated struct page?  We've gone in enough =
circles...
