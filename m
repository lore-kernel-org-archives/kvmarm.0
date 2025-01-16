Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFD31A8F79
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737068723; cv=none; b=K1e9G78njcXiFkIx3nUq9725d3fqfVLuiQ3xEVHoJ3QfkPd5QA2pSQ5fHOhOwDK4XHf7PDJt9h8sGy3IOKfQ6xqoB9Axwyv6l6t3F1yQkZwphkxczWFPCWijU3S3Mku/Sl1iZdynrNzi6xcylQtcrcn7c87r+mzO878KCWBNb18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737068723; c=relaxed/simple;
	bh=suEN/33SYD9kr8IhLu9T5fGefoNFQ4pijv9IYyE6MGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZnIbrCijYWQR/w+FK8PdUbl63n/DmMR3pkVxepHdPlhSLakBdAn9uF2CMBSoWVoRIS0YiIEOvqLeY9ir5RTS15jdQCgqCOqKKdJhptS5ed6T2Lumt9SBgVJrQVFm8laOdYMWcO1sNijmNaZP3G9fjTnOAWEXYXCaML6yoPAb5MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3sWabSh2; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3sWabSh2"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e549a71dd3dso2900890276.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 15:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737068721; x=1737673521; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ownLtPpk0wxf6r6Wq9E4jSgq7bXvrdC32yvYQuD3YI=;
        b=3sWabSh2J1G2UKoDjlyK8tXnPg1QuuHW70YYU5A9LyKcblRLq2/+8j0sZBDULRMbqv
         59G3iykDDQFUet/oh6rDGK0Oh70D3cuHBVUuWgZ9O6TfHnKGytRqlbOzyxUpGzQSBwZW
         kOrOKKRxqg3jpz0Y5icaukPr2sgqU9fb3uQ/tb8emnqSdQRpOUopnXyO4SSFz3BorAkt
         /Ec4Bxk7UNku4MOnk4ejG8oc+DpgSHvHfip1D2Qv5oWloeES5ArWMiA2LEDdl0ywlM1C
         KJFMmVZwEn31fG6So/g6pHynA7kSyRgbmDtcFWDBNPSCOniGe0YKjE+9p3c9coBZnlIm
         4Uhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737068721; x=1737673521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ownLtPpk0wxf6r6Wq9E4jSgq7bXvrdC32yvYQuD3YI=;
        b=uT3/xe2BkabcaVkLEVJaURGzUm6kOaz5lw9Rbp2SkAKV2rWJeyUNnAJDQyftETHDQu
         cwyKaDlPBCm5eLX6g9quvkawYfGdj4570Ifkk7COFLIkVVH4XU+RclWmExEPPdt6v1ff
         1tCR5DviN8+xRiYEw22Ecp+Y1qL2oX7tp9iSK0hLD39mxn0VDbOJsWoCuBpj7xZ1kXDB
         21T8181Vvu3WnnFb8ulJhuEdHCkD665PI/Z+kwTmNvxlCq4VwvsdQ7+OGbe0VJk7lOfk
         4Vp3ZI5GtOnpT/kqDU7ibzNfqzJh6ur5pIUOzFJcH2x2++G2Xi0glyoqtvI0U36ZJLqo
         oa2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4KZymLSwvVJrF/WaI23tX1G5ohxa9hVPGObkrrNRoO2ZtuDILfK5ciR+82rAqC2jLEy/8Guk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo0wKH3t9mHQqxIZSLcqMHP/+63nqSWDdbswKTpbzvl+mJ/whw
	tXtozxv7Cebgpb19M0SX8fpeQc9dL7isKgZm34zxbICG4ogIjpYFkvGvGecOw5k8PniZuGFxcyZ
	a2VDZDSiGvXVDpldUnCrAEWlpNrwsfmkse/HT
X-Gm-Gg: ASbGncuvCLrHbkC6FJ5gsVEgHjyQBa3/OneBFuQRi8zMsBjBEELw9+ll7XI4zWhrxaW
	OM9Y5nKMoNK8r87pdIoUDe03+SCv5cuvrkTdvySqUBSbCJOLBmGCogATMEE1sR1Y2U2XL
X-Google-Smtp-Source: AGHT+IHMnqWCK1543bGJ7is63MhDeR0ycyx0XklGqD/4LG6uvyEtx2Qm3xFEDxKFZ6o5qY44BdR/OD9k5OQNQTNdcJY=
X-Received: by 2002:a05:6902:707:b0:e38:8749:815e with SMTP id
 3f1490d57ef6-e57b1310a25mr249418276.30.1737068721056; Thu, 16 Jan 2025
 15:05:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n> <Z4mFL8wfHjvz6F1Y@google.com>
In-Reply-To: <Z4mFL8wfHjvz6F1Y@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 16 Jan 2025 15:04:45 -0800
X-Gm-Features: AbW1kvYhIT_qdEvLNggXEyTtjFcK3iljN13YOJGI8jYSmtn1o-5KlOinkDsaqTE
Message-ID: <CADrL8HW_hgKZBX98Z17eNqC3iJruwLJcFv=pswgT8hKayMYbzw@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 2:16=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jan 16, 2025, Peter Xu wrote:
> > On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > > > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn=
't
> > > > replacing it. And as of right now anyway, KVM Userfault *does* prov=
ide
> > > > a complete post-copy system for gmem.
> > > >
> > > > When gmem pages can be mapped into userspace, for post-copy to rema=
in
> > > > functional, userspace-mapped gmem will need userfaultfd integration=
.
> > > > Keep in mind that even after this integration happens, userfaultfd
> > > > alone will *not* be a complete post-copy solution, as vCPU faults
> > > > won't be resolved via the userspace page tables.
> > >
> > > Do you know in context of CoCo, whether a private page can be accesse=
d at
> > > all outside of KVM?
> > >
> > > I think I'm pretty sure now a private page can never be mapped to
> > > userspace.  However, can another module like vhost-kernel access it d=
uring
> > > postcopy?  My impression of that is still a yes, but then how about
> > > vhost-user?
> > >
> > > Here, the "vhost-kernel" part represents a question on whether privat=
e
> > > pages can be accessed at all outside KVM.  While "vhost-user" part
> > > represents a question on whether, if the previous vhost-kernel questi=
on
> > > answers as "yes it can", such access attempt can happen in another
> > > process/task (hence, not only does it lack KVM context, but also not
> > > sharing the same task context).
> >
> > Right after I sent it, I just recalled whenever a device needs to acces=
s
> > the page, it needs to be converted to shared pages first..
>
> FWIW, once Trusted I/O comes along, "trusted" devices will be able to acc=
ess guest
> private memory.  The basic gist is that the IOMMU will enforce access to =
private
> memory, e.g. on AMD the IOMMU will check the RMP[*], and I believe the pl=
an for
> TDX is to have the IOMMU share the Secure-EPT tables that are used by the=
 CPU.
>
> [*] https://www.amd.com/content/dam/amd/en/documents/developer/sev-tio-wh=
itepaper.pdf

Hi Sean,

Do you know what API the IOMMU driver would use to get the private
pages to map? Normally it'd use GUP, but GUP would/should fail for
guest-private pages, right?
