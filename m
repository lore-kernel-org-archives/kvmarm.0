Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5A2E6CC9
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760659064; cv=none; b=leibUwBUVwTV/cRRi4fzDM9Pcwug4keSgWzYL6DCQQwO3oeyN7AJT9hHPef35dygIIooNA8JvwFijsalgUfGUa0hIs+q5ygdh+M6oOzt2GjPsBjKupHtYMj6o96udKyCWnVp/QoqfzD5eJl68f0s4Cf8hCRZvQf6FlUldkYWk3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760659064; c=relaxed/simple;
	bh=vOAdDSYX83kzIXZY6k7808Nqc/n1Jrd8SmNl/kz/Z8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vue+NIL38kmZ0sICZCsgzccDVSDs4pCOGuSzm7MetBlz4OiZEvn7OzE07NswkCzoc7fwS7fIWre0zxLAopO1AfPoLKHyMPpuydVLqJtz5a5YKaj93rciO7NtpmpL8DULhjdWVPZ0M1abvZ+f8u3lCdiX5rhXYaSSU8wbS8G81hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gHEn+qsX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gHEn+qsX"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6a33319cb6so711485a12.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 16:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760659062; x=1761263862; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+gFerwj7sc87prcy/GQMGpAh3zQW+FK7X8HO9E9Qn8=;
        b=gHEn+qsXd0Wm1b0yWTjTPEFtwdWZqd4Hqh1LeJlIcOTivyr1nUIIAI8pVpNQP27c+I
         AVzyxgvVvza5Woy6JJIF9BP7SqRkK393xCvm8E9or8PK7/j6WWoTlfDkVwQploQFu4Xg
         CryxSBmwHmcFWtk8x9o5T1AKu8/k1lg1gd3//jhVCpX2IaeQUaw8M9z5nHqEqExfBRTe
         85fNSGYQbrWunzhuN0lmXuPiNK8J4y/1MtMY1eGZJlhNGJKosIYNJNjnuNzrpcg1bHUK
         1REdBRjfktfIm+tsd8u1IAQFX/2GH+zk7zltT8HHFHJYCR/A7iuWGvFPFUQIq7o0xtSc
         1z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760659062; x=1761263862;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W+gFerwj7sc87prcy/GQMGpAh3zQW+FK7X8HO9E9Qn8=;
        b=Dt68IXLtFnwmaxIzx4npuR9gT8iRRMWC2cQ5yYq3Kpcpwu8pdErgmVOBjiz4WY8kG+
         UZ45YoK8bK6WK9RQtGn/6JdLNdTHnamnzcktWoaSR2XM9chGjIZAAM23xYNkL+2rsuQ7
         sZgMOIvXhkJKvAP9dzFGqUaX/HcIKEmsxZpt8PnYzHEB0jnlp/uhz11PgfPUNa4GRLPu
         6BvhMxT5YgiIXLep6NWGcjifrkKSt+cGVgjRxuhfrfJgJiZAOgfBU5MFMxu7LNdtnPwl
         18PufrcDFtClFsHzs/vgBIjWtrIuPFWHuS/lW1Xyaz383rAnZ6em986GB85u/5HnnZna
         w7RA==
X-Forwarded-Encrypted: i=1; AJvYcCVwnyIAtl3dR1AsCxxXv92RVqI/IvyobZhknkoAfeI+GZNfw+GsybKAatQXjm6bcsIjw1DOMi8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+Ih2zjyyfJ+o6Ee+JEsDuF534eIzCOZIAFvC43cRcPAtLfE5W
	PeVnuRKxU3zGKGK7l7Z75dCWphy7DnMqCFqfugecRYTLDwUNIv+l1TlOAbonbFXVin4bS2hSj3Y
	obrHFkpDaFAUIS8QvTYkjzGs+jQ==
X-Google-Smtp-Source: AGHT+IE2GZ6bYZtCSD13nlTnA7H2MPbbvOsHzo3LQjiehRmABnDXMBoSAsb+4L5uxVyy1gpfUlSoXNG9qcSb1xRc+Q==
X-Received: from pjyj8.prod.google.com ([2002:a17:90a:e608:b0:33b:9959:6452])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3992:b0:334:a99f:926 with SMTP id adf61e73a8af0-334a99f0c06mr1602497637.11.1760659061843;
 Thu, 16 Oct 2025 16:57:41 -0700 (PDT)
Date: Thu, 16 Oct 2025 16:57:40 -0700
In-Reply-To: <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com> <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
Message-ID: <diqzqzv2762z.fsf@google.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Ackerley Tng <ackerleytng@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:

> On Thu, Oct 16, 2025 at 10:28=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
>>
>> Oh, I take it .clang-format is auto-generated?  Is it a "formal" script,=
 or do
>> you literally just run the grep command in the comment?
>
> I just run it and copy-paste the results there from time to time.
> Yeah, a very low-tech solution :)
>

I assumed someone was doing this from time to time, and I ran the grep
command in .clang-format but IIUC it only reads tools/ and include/
(which doesn't cover this new macro) and so I thought the "automation"
would miss this new macro, hence I suggested to manually add the macro.

Using the command on virt/ would pick it up. Would it be better to add
"virt/" to the "automation" + update .clang-format while we're at it?

$ git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' virt/ | sed "s=
,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - '\1'," | LC_ALL=3D=
C sort -u
- 'kvm_for_each_memslot_in_hva_range'
- 'kvm_gmem_for_each_file'

>> I don't think I care if it's in the list?  I honestly don't know for sur=
e, because
>> it's entirely possible I'm consuming .clang-format without knowing it.  =
I added
>> the entry based on someone else's request.
>>
>> Ackerley?
>
> If you are not relying on it, then please just skip it, yeah.
>

I'm using it, I believe clangd (my lsp server) uses it to reflow correctly.

>> Is it possible, and sensible, to have per-subsystem .clang-format files?=
  KVM
>> (virt/kvm) and KVM x86 (arch/x86/kvm) both have has several for_each mac=
ros,
>> pretty much all of which are more interesting than kvm_gmem_for_each_fil=
e().
>
> There is `InheritParentConfig` nowadays, but from a quick look I don't
> see it supports merging lists.
>
> So to do something fancier, we would do need something like we did for
> rust-analyzer, i.e. a `make` target or similar that would generate it.
>
> Otherwise, we can just add extra macros at the top meanwhile.
>
> What we did last time is just to add `tools/` to that command --
> increasing coverage is not an issue (I just started with `include/`
> originally to be a bit conservative and avoid a huge list until we
> knew the tool would be used).
>
> Cheers,
> Miguel
