Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF1013CFAD
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 23:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721085346; cv=none; b=j/TsOyTxvTPpMz/Iq4+WOzPtjSZ5OkfytU1VmGvoGJiAUVqSjDnkgxqS7cyT+FRYVUz49F8GqssDYXeFO4z4lxMZ95vUG7BtY1F4tfIf7+CWLcOjNEIlLSvVHsffFzWewpHybrQy9AeiQl9pfKo+O6Pn3B0P8+Emv+XBFT5GbD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721085346; c=relaxed/simple;
	bh=Q98GzkXhuy8Mqk8ABLLqoDEDauT65uD8JlHGR1iepyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PV1mx/LbQ4RC4ewR027N1B1xfBwheqbTUJoXwHrC/GobCSiKTvc94RzEhtflVkaQXSfK8iZfZUVYCKu//HoWY0akeSixm9SdPl1nrTFH4mg3neTJ7yPhHmlphKOqQ/3yz7vlUvW3LX5bO/YqiEZDtaaWONbbgFRWxMHdxmdBzLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sXeBAqmS; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sXeBAqmS"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fb2936c4ccso88075ad.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 16:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721085344; x=1721690144; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exEH9iPNcIg3KpVyQ+q3mCt+4C/Fcr8/ESkE/4SO1o8=;
        b=sXeBAqmSNfE2JtmoKtzIyxhFwu2dZaFr5IMfzNAokhKi7zMyBL3umc+1VYxZfxzmuW
         mzQUZTpWlv0dnharUCZLY5waKQZvPauh6jyAMohvyq3hcs6Vk17djrlBeAwu1K3UAVCy
         JNzRjPi92jsvX1MzdIJr7htAv96xbZLKQ/REEqVxdhk6TGGM7vTjMqqr24Kz77f/SYyN
         TsuJKvigSgY4m6Um+nbPfq/7lkNwO+jShXesa8/Ifl5v3bBUrQTZBzk4wEF7mF1eSdMx
         tCKz/wNJpZMMW6E6fH8URu1NNSmOzZLx69Gnkr1nG6j95ECrnHEn92RQproK6qMHVmhh
         d8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721085344; x=1721690144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exEH9iPNcIg3KpVyQ+q3mCt+4C/Fcr8/ESkE/4SO1o8=;
        b=UcbPyDA69FUamjeXLcsIwys0CvA8LTYXr4t12DHrfzlmbocmERiSzuijuFaPZL+27I
         S7ZIpVmkF547bNIVyn414L/gQM+MzanDR+Jf0AUeOqeDxbGrINuzSQXu2ptjYFf7ikDO
         ydszKOVhOgDQZt19ORQcT/wBD7KOFRMz3iUl341xfkT8Mv7FJb5s/wsOwKDNIpXJoWsO
         PlSHdRxesyFvCA/iW4sFEw4L9xKu/7hTofAE8Jc9Y1skfSeNusXB+g+avegMyy7MORJZ
         yahgMJzM4GcSS10zNKpTrq6WI/kG6mqXEDbey0THs9RASm8zJbZ62KdtI1YqWgfXIIZc
         m+qg==
X-Forwarded-Encrypted: i=1; AJvYcCVNWZrnm6kAmc7yS/2RZq8jy5KHV6wWdaWfZy6N9A2xKWxJUQKbzrjxm9QcVBIS04XQ9x4HctYvD9041n6cP+aQES8mU8gt
X-Gm-Message-State: AOJu0Yyia0Etd+JgHbmHdeAnvjFqaVI/TZI3apa1XF2Vk5NPzS/76ZeM
	Zlxk7sDfXYlj+Assp1SxBrp4y5y8HczzmESjhwCGsKyblRtKhtMAVRl/Zmiazk4t4UR/+8xJmjN
	RT8XvA8xegPUw4gFkjDA4kRlqn/XvelW7v79r
X-Google-Smtp-Source: AGHT+IF37bptgINSCLE9dDjInkdJLhm19J5sk44W8p8j4cV76p1iCJXBcZEjJTiahXiPn4ncuCw2O5xLUjXDk1VNB9o=
X-Received: by 2002:a17:902:f688:b0:1fb:2924:5c7e with SMTP id
 d9443c01a7336-1fc3d7698a7mr591975ad.11.1721085344002; Mon, 15 Jul 2024
 16:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com> <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
 <ZnCCZ5gQnA3zMQtv@google.com> <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
 <CADrL8HUv6T4baOi=VTFV6ZA=Oyn3dEc6Hp9rXXH0imeYkwUhew@mail.gmail.com>
 <Zo137P7BFSxAutL2@google.com> <CADrL8HW4PLTeC9Gq3Fd43-idjzOw8mXOzzG_RP1TYVoGp1_g+g@mail.gmail.com>
 <ZpFGYvCAQWhldWJZ@google.com>
In-Reply-To: <ZpFGYvCAQWhldWJZ@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 15 Jul 2024 16:15:06 -0700
Message-ID: <CADrL8HXLGj-V0Qd8U3xRXnJeMTKOJqB-TsyLTOo8j0sGo2byBw@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 8:06=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jul 10, 2024, James Houghton wrote:
> > 1. Drop the WAS_FAST complexity.
> > 2. Add a function like mm_has_fast_aging_notifiers(), use that to
> > determine if we should be doing look-around.
>
> I would prefer a flag over a function.  Long-term, if my pseudo-lockless =
rmap
> idea pans out, KVM can set the flag during VM creation.  Until then, KVM =
can set
> the flag during creation and then toggle it in (un)account_shadowed().  R=
aces
> will be possible, but they should be extremely rare and quite benign, all=
 things
> considered.

So I think you're talking about .has_fast_aging bool on struct
mmu_notifier, and we would do look-around if that is set, right? So
we'd need to have something like mm_has_fast_aging_notifiers() to
check if any of the subscribed mmu notifiers have .has_fast_aging.

We could toggle it in (un)account_shadowed(), but I think I'd need to
demonstrate some performance win to justify it.
