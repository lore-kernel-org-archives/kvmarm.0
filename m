Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C39321445
	for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 21:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771448770; cv=none; b=B9GbOqwiWqnZcaqMDcOCA0QKk4/BTm9or0wDFxQGg4f3aSh+ANLxGRulOM66fs+yVaX7LrvkYhRPBlIX0t13FvaWI4NIagcw6wj7Ql9NQl3Cpt96PWEMP3XD2Z8R2jqEYW7kQTerzaaSzdXNpd5tKk8jYSwQi7MtlYdXRTbBcoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771448770; c=relaxed/simple;
	bh=hZ+rjhElxgLGmkoWnG0q2kPevdexQ7E+7PhYwWYUAmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gBhoPVsH5++tILsYaIZjyQ3O6vz1LismdCiMqdKKX1eewY7hLSng4AKlx7Run7FjGqs7miwNNEtWzRDClxkAZKAIFZ6mS5NTFIfq48APo91Bu6OJoFWlrlX4scpJCEm590ukMQ9wivR3TlRCEGP5F2jJriEoyVBiz+fo7DimWkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jUgsSsnt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jUgsSsnt"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35845fcf0f5so487021a91.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 13:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771448769; x=1772053569; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccWJDzJ7m4S4l+nz4VuzRpZZrXnjyW9kyBaNIifc8MY=;
        b=jUgsSsntmWi3GCWzTnxPZqFXHPkYe4rA4fI0Ra4kMv8NWtikhD3kaQ6IB21X6P+iX3
         GxJRRXkyJ9vO1W6mIYPJvjKzO+CEO1YYxPYu/5E5uywTDX93eXYXbiHW0XO+64huOqHB
         LNVNqDXhGJfKJFGL1K3Ml0+4U4ma3IK5xnWJzSWdem12AbNZgowJa9z/VXXowdASGbEe
         OIZ/fsQI0LcrFts1ej7nHtAtu9Y0WoAi+xIJMQlwSWp9fo9pmO5kHsMB39L4aktqJ8Ok
         Pwx2G4ooQFYtLGjqfCpns/bcQztZA3ZENEuMVd7bRDhe+dwY2JuXHESneNBY8hpxxqgh
         6huw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771448769; x=1772053569;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ccWJDzJ7m4S4l+nz4VuzRpZZrXnjyW9kyBaNIifc8MY=;
        b=h2UkDGiTQVhDFXegH688JinejaDn7/98SUJm5b93xMU+Qwar0pBs+3mbeubmem0Jt9
         4PH3JJ4NEqr8lRnCJl5YfMubp+3u+cY0SQKhgItcKsVsyDJpcZn1+5cnmXckLz9AwOqq
         PnogNFd5bsag1+0MlwWt651QIIWWJwzL8uNgibQqce6QPHpS6tLDIg/FyLOeVROS5COW
         oDo9pvwhLFXq4Q7TwJkhaZ5x+Zyns0sBWzXLxjVsWFNWsPMIic3+Z8nuRUSFFEd+9Cgs
         BlaKJ1qK4rY7bvSdLhqZkmPJuud4yw5IK6W72iWpvcoGHPatX/J2pkalWqxGE7K2EoCq
         ys+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkW8EGISlwe5PH/urnnGUL6fJUTJQsFicGSpcSiIqplajDAW3nQrV1XQyG/us7fn8TShICx2I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/h8zD0FoLArWeXUrgRz4doHFXGsrYEisBGFGprlMsLK90OTlh
	fCkacce1gRoY/c5ec2N0V2A0TRLM1HPqbatW+/Jhsg/0elg85UtWrWWbNYCCYYkpK228mX4plry
	GSOZrtg==
X-Received: from pjbne18.prod.google.com ([2002:a17:90b:3752:b0:356:1da4:5dd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5584:b0:34a:c671:50df
 with SMTP id 98e67ed59e1d1-35888d58b61mr2639291a91.17.1771448768639; Wed, 18
 Feb 2026 13:06:08 -0800 (PST)
Date: Wed, 18 Feb 2026 13:06:07 -0800
In-Reply-To: <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
 <aRZ9SQ_G2lsmXtur@google.com> <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
Message-ID: <aZYpv6O15YMlGkzT@google.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2025, David Matlack wrote:
> On Thu, Nov 13, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > My slowness is largely because I'm not sure how to land/approach this. =
 I'm 100%
> > in favor of the renames, it's the timing and coordination I'm unsure of=
.
> >
> > In hindsight, it probably would have best to squeeze it into 6.18, so a=
t least
> > the most recent LTS wouldn't generate conflicts all over the place.  Th=
e next
> > best option would probably be to spin a new version, bribe Paolo to app=
ly it at
> > the end of the next merge window, and tag the whole thing for stable@ (=
maybe
> > limited to 6.18+?) to minimize downstream pain.
>=20
> With LPC coming up I won't have cycles to post a new version before
> the 6.19 merge window closes.
>=20
> I'm tempted to say let's just wait for the next LTS release and merge
> it in then. This is low priorit, so I'm fine with waiting.

I ran this by Paolo in last week's PUCK, and he's in favor of the renames (=
or at
least, is a-ok with us doing it).  If you can prep a new version in the nex=
t week
or so, we can get it applied for 7.1 shortly after the merge window closes.

We don't send all that many selftests patches to LTS kernels, so IMO it's n=
ot
worth waiting for the next LTS to come around.
