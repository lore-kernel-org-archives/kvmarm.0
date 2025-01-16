Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044D825A659
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737071218; cv=none; b=L0azLS21Dc10DseQRMk7bsV1nUfyCuyfCa4VbunWZps+PTZcGMqC+yQl/B9apWm7AtF3Y04eXFxDsg8AJaFCUULtHFtc0BEIHb0Dnt9njnavabR8dzbk8nF3qjwUs5ltlgiyurYxpBl1gtDuNvmKv5Czc0C/vs4PW/0TLbMIbLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737071218; c=relaxed/simple;
	bh=3EwIz7mnMJW3m1YZtHus0i5SxyyBh7S8/iqg+UaggVM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vFUnOG85/IKipsu69yLJcOz0O0W9pnfEngw+D/BlMmG2K6EvH+mOWL8fqDZzNh2WiJy7ZjyB66pSZuiNGv/2lrJz0JsA4y0vuhCyptSqtceqSGV2JRKHTtGdEa1+kGLF4NTh12XCDOb2Rd7vLUtnZJJ6GTI2TaeVkDgnnlafoTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SLnvtwpf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SLnvtwpf"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166855029eso29957825ad.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 15:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737071216; x=1737676016; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B+30IFm68jg6NDwHeVAkv6hKYafQ3ykW53j/B6i3wSI=;
        b=SLnvtwpfAsv5Go483NsylTrceq0pj3bAdGc0goGXUae0AIU/ymS/FrCZRBLjN3vb4Q
         UTxX3X0RIvP0ZEHSn+LjiKPrE91GILDmljY6oJTpUrxig7FUNyecV5DKgEdmg2Oc+9JP
         UG/W44PM4rOLy9hKUfz4OtDiivVlAkKCTcdtTnYujtjl5knrJeyM2xZz7+GCN7p/M+Ia
         YeFZETNCRmAYIldM0t7x1SQ/j/Tkhi6C5Q505b6AgFVtzETwvRfvFdk1nkTG3QuvJhgi
         WwgbZ26fkGXiR0nzDHrXe4wtm5XCnmUIvwSuOK46rS0V1LlWUFuBE9ODpGzioTvHpN0J
         9Ciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737071216; x=1737676016;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B+30IFm68jg6NDwHeVAkv6hKYafQ3ykW53j/B6i3wSI=;
        b=MyYJdGHOSVU5YSYAuEKFjNBen82Lj3QjVTdF4B+h8hwAMpeTW9NVhfh+8pDYq9ykWD
         tec/BbmyDtf5sAUcFhvoCt2DePy11Zfw7+S8Wxc3v7yFX684blJhGa++URqH0TiqIh/k
         AuwFfBGyZX8oGLAqXahJ2eU3ZsRau4P9jAr12qwgyJnYVv51rilEQ2pRDBZpOah5A7ce
         G8NvqMeNSQ5L45Muz4gXGuB5uwBctfcoBEtsJZj7Uy6m6Bxc68jJ8aRz8Nq7RsMYarIj
         7u7OcmL/n0OUYFskNu2XLq8ZYAj8c+TZougTFkzgAaPWb1dkWXHMB7sb7bzvGqf0XP5Z
         9Ogg==
X-Forwarded-Encrypted: i=1; AJvYcCVY9TCgx7etFnf43ESOMlqmBaUgEX+zzIc+wzgLhNnWeC79SfMiWEs9ssqWsUNdqHdfyFZAUHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgZIDLqxpNxJZKOT6+UjXYQBJn5kqKvPbpkRlLu8Sl+Lr3snim
	lF6wvAKqAAjrP6tVDOHe5tu8P5Ob8EC7PWJ2jhtuB4Hi7rs3LWvLWVLvk/04eGgL9+7cNtA7iIy
	0kg==
X-Google-Smtp-Source: AGHT+IHZR21brkH4uVP110TgbprGaxMRRHTjbTHJnd3oJv8cZv6zsGMgvWQaUzQjRW3B/1TQyJ2Gb8Ip7wA=
X-Received: from pfbhx8.prod.google.com ([2002:a05:6a00:8988:b0:725:eccc:e998])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2da5:b0:725:f1ca:fd8a
 with SMTP id d2e1a72fcca58-72dafb5580cmr1293395b3a.19.1737071216234; Thu, 16
 Jan 2025 15:46:56 -0800 (PST)
Date: Thu, 16 Jan 2025 15:46:54 -0800
In-Reply-To: <Z4mTdOc35hF26PeY@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n> <Z4mFL8wfHjvz6F1Y@google.com>
 <CADrL8HW_hgKZBX98Z17eNqC3iJruwLJcFv=pswgT8hKayMYbzw@mail.gmail.com> <Z4mTdOc35hF26PeY@x1n>
Message-ID: <Z4mablD78z45k1u6@google.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Peter Xu wrote:
> On Thu, Jan 16, 2025 at 03:04:45PM -0800, James Houghton wrote:
> > On Thu, Jan 16, 2025 at 2:16=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Jan 16, 2025, Peter Xu wrote:
> > > > On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > > > > > For the gmem case, userfaultfd cannot be used, so KVM Userfault=
 isn't
> > > > > > replacing it. And as of right now anyway, KVM Userfault *does* =
provide
> > > > > > a complete post-copy system for gmem.
> > > > > >
> > > > > > When gmem pages can be mapped into userspace, for post-copy to =
remain
> > > > > > functional, userspace-mapped gmem will need userfaultfd integra=
tion.
> > > > > > Keep in mind that even after this integration happens, userfaul=
tfd
> > > > > > alone will *not* be a complete post-copy solution, as vCPU faul=
ts
> > > > > > won't be resolved via the userspace page tables.
> > > > >
> > > > > Do you know in context of CoCo, whether a private page can be acc=
essed at
> > > > > all outside of KVM?
> > > > >
> > > > > I think I'm pretty sure now a private page can never be mapped to
> > > > > userspace.  However, can another module like vhost-kernel access =
it during
> > > > > postcopy?  My impression of that is still a yes, but then how abo=
ut
> > > > > vhost-user?
> > > > >
> > > > > Here, the "vhost-kernel" part represents a question on whether pr=
ivate
> > > > > pages can be accessed at all outside KVM.  While "vhost-user" par=
t
> > > > > represents a question on whether, if the previous vhost-kernel qu=
estion
> > > > > answers as "yes it can", such access attempt can happen in anothe=
r
> > > > > process/task (hence, not only does it lack KVM context, but also =
not
> > > > > sharing the same task context).
> > > >
> > > > Right after I sent it, I just recalled whenever a device needs to a=
ccess
> > > > the page, it needs to be converted to shared pages first..
> > >
> > > FWIW, once Trusted I/O comes along, "trusted" devices will be able to=
 access guest
> > > private memory.  The basic gist is that the IOMMU will enforce access=
 to private
> > > memory, e.g. on AMD the IOMMU will check the RMP[*], and I believe th=
e plan for
> > > TDX is to have the IOMMU share the Secure-EPT tables that are used by=
 the CPU.
> > >
> > > [*] https://www.amd.com/content/dam/amd/en/documents/developer/sev-ti=
o-whitepaper.pdf
>=20
> Thanks, Sean.  This is interesting to know..
>=20
> >=20
> > Hi Sean,
> >=20
> > Do you know what API the IOMMU driver would use to get the private
> > pages to map? Normally it'd use GUP, but GUP would/should fail for
> > guest-private pages, right?
>=20
> James,
>=20
> I'm still reading the link Sean shared, looks like there's answer in the
> white paper on this on assigned devices:
>=20
>         TDIs access memory via either guest virtual address (GVA) space o=
r
>         guest physical address (GPA) space.  The I/O Memory Management Un=
it
>         (IOMMU) in the host hardware is responsible for translating the
>         provided GVAs or GPAs into system physical addresses
>         (SPAs). Because SEV-SNP enforces access control at the time of
>         translation, the IOMMU performs RMP entry lookups on translation
>=20
> So I suppose after the device is attested and trusted, it can directly ma=
p
> everything if wanted, and DMA directly to the encrypted pages.

But as James called out, the kernel still needs to actually map guest_memfd
memory (all other memory is shared), and guest_memfd does not and will not =
ever
support GUP/mmap() of *private* memory.

There's an RFC that's under heavy discussion that I assume will handle some=
/all?
of this (I have largely ignored the thread).

https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.co=
m

> OTOH, for my specific question (on vhost-kernel, or vhost-user), I suppos=
e
> they cannot be attested but still be part of host software.. so I'm
> guessing they'll need to still stick with shared pages, and use a bounce
> buffer to do DMAs..

Yep.  There's no sane way to attest software that runs in "regular" mode on=
 the
CPU, and so things like device emulation and vhost will always be restricte=
d to
shared memory.
