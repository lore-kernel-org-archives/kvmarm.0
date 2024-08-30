Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EB51B81CB
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725032070; cv=none; b=kTcawQc5tC4SaXS3F1OeULz2DSy+VQpNrh5vM1NPc39JD9Cyng/XWhhSkSRGudCg2G0guFaY/t80ZYx4WWgp7K7kde81l+4ecl1ZbajGYShlHb7nrZ8aYJMEPdEbvF3j64sAQdDjyEXZgKm7sexDNZhccnx69kYMeiI5V0jbTkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725032070; c=relaxed/simple;
	bh=fpS42aX0b5K/b3Q1uAIPaQJhJiOQBXKx/N3vFKIRp18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JFPyaupqqAUEgXiOYGItzv9Zqgc2b/attC/23aXt4ew3K73eQXG5YdyFphiAPAKswVId+9gIz1nA0QLbZTYATpPMOXr7svwiMi5DrjCWEgPvnpRAqUlUneYVAupBLJ4VueKul+2oFPaMXY2MEHocwqeLGvkFgNkno+8s4aH1qZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylyRRNgf; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylyRRNgf"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f504652853so22756161fa.0
        for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 08:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725032067; x=1725636867; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpS42aX0b5K/b3Q1uAIPaQJhJiOQBXKx/N3vFKIRp18=;
        b=ylyRRNgf/uehfpwCc44EWJdVD65SCbCItFgUrXedXVHREwuI2WgNOjbDFpktXIV2Uf
         q5SpjKHx5BDb1H3tc1N65IwvQhPLVAtx7gg5GBkTF3w0NYGrGHIRzqfQ+39MoRo3aOit
         kIICvhLdv0MGV0cUGd14cKU4UYKzfkiASeZ/6M1py+KLSifaiR7B5jKQnrZDRFOQacCu
         D/nW0042v+F+PGUAR7GvoHNFDL2OmuCYqSD655ZmAjSiQpHFveYN1RHnL3RtYLnfWgF2
         ryDVXC1M4TTCJxs5AgRw046sAIDDRfk8SKcRo28pb7byvZ9gdPx7TFmwxSauyqoSsdwL
         hgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725032067; x=1725636867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpS42aX0b5K/b3Q1uAIPaQJhJiOQBXKx/N3vFKIRp18=;
        b=A5kisXsA2c0HwVgBGFWOxLXdxCNFZjORU7vXvDgf7+F0gA3OQpBEPTXJFXm+fhjkpb
         ixKCxSeGLs8O87q0fQYcJ7t3d4x6S4+w7fc1EBwArP/PIOI1lGiTRJzeMOLUJxcrl+f1
         eRCEteJNyXfeM8NrOgLC7ow2Q5xQewt9aEuCC/pu3B7SBU2DwtNsCT5+nles6jF5UGP/
         DGDI8AnwudZ2CYD4aeOmTQy40Pn6hrt7MaUKPd/9LRnM+Bf4tykYNUGe5ldTU37O+b62
         TQHPWSogj1MKFzvqqBuQdVYEZSesajmZ4KazaMhAM830NJw+B5wemjVQaSll/guOj64o
         2L/A==
X-Forwarded-Encrypted: i=1; AJvYcCX4p+SvPj1wXbih6YpucRSyJiqDIkCjhXeYhvA9E7ql7HL7GJE1lBKGdd/vwewdNDWzt6XPGaw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxuoz7RDsTc5S2MoUxF7/xZ6jolV8v8lG70W1KQv81mlGLQC32C
	313aagavP1lPckjOY374w7gE3qHDc+kIYETCrBYA/1CxApHFMJr6RqnkJUhAWRF0koBfS8X4NRL
	juCLNLFjoCK3N7HVB3GhFiKueajl1nvzP33pv
X-Google-Smtp-Source: AGHT+IGwBJXtOV0i3GYyRTdCgSnRpiivnFkx2coVNIZMzMIKNaMNwsMNP5zJF5zp0+JOd+xMSn0E3uXDKUV2VAuZcjg=
X-Received: by 2002:a2e:a544:0:b0:2f3:f39f:3719 with SMTP id
 38308e7fff4ca-2f61e0a5143mr23582771fa.29.1725032066374; Fri, 30 Aug 2024
 08:34:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com> <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com> <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev> <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
 <ZtEW5Iym5QsJbONM@linux.dev>
In-Reply-To: <ZtEW5Iym5QsJbONM@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Fri, 30 Aug 2024 08:33:59 -0700
Message-ID: <CALzav=daN3y9nXNuj7pPpn2u_aAQ84t161z3odP=MGLYCLfYMQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Yu Zhao <yuzhao@google.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 5:48=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Thu, Aug 29, 2024 at 05:33:00PM -0700, James Houghton wrote:
> > On Mon, Aug 19, 2024 at 1:42=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > > Asking since you had a setup / data earlier on when you were carrying
> > > the series. Hopefully with supportive data we can get arm64 to opt-in
> > > to HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY as well.
> >
> > I'll keep trying some other approaches I can take for getting similar
> > testing that Yu had; it is somewhat difficult for me to reproduce
> > those tests (and it really shouldn't be.... sorry).
>
> No need to apologize. Getting good test hardware for arm64 is a complete
> chore. Sure would love a functional workstation with cores from this
> decade...
>
> > I think it makes most sense for me to drop the arm64 patch for now and
> > re-propose it (or something stronger) alongside enabling aging. Does
> > that sound ok?
>
> I'm a bit disappointed that we haven't gotten forward progress on the
> arm64 patches, but I also recognize this is the direction of travel as
> the x86 patches are shaping up.
>
> So yeah, I'm OK with it, but I'd love to get the arm64 side sorted out
> soon while the context is still fresh.

Converting the aging notifiers to holding mmu_lock for read seems like
a pure win and minimal churn. Can we keep that patch in v7 (which
depends on the lockless notifier refactor, i.e. is not completely
stand-alone)? We can revisit enabling MGLRU on arm64 in a subsequent
series.
>
> --
> Thanks,
> Oliver
