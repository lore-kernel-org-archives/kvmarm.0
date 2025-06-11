Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D1C1B21AD
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666054; cv=none; b=DaWvfOmbRc/0u65s/8qz1+LABsJ1oD+3guaFFpDG8wPy21q74B0aK9ssY0TmWuy+iD//yo5nWp8ZI7jPrNJHBeu9Stlbv6+Mvvlt+9fVvTqhL0wL/UCFbW800XtsNKdhcjFrercY1DHPcSbNok8dnbfZ0dTkg4yCHj0qG960SqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666054; c=relaxed/simple;
	bh=L+PQ8oC5SKj2Pvt3GVWZzPVy8l1E6eCuxqGGzJ4Ezoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bGp6PnnbtUbSQCxV5gs6OjsQqt8h+Ao2DDfDbXbRXBuJJm8qbQCZF5pQ3bDrb09HyS0nCmnxLF37kIL5PLS0YbQBRUDuf2mQemxUDUom+3t7vRu7QjoCCWiHP1YunIjgjtIjMYPcdpJ4hy0K7mmmktQYMu7WA1tCpbuObOSoKI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xIrcLz2O; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xIrcLz2O"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-745e89b0c32so261440b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749666052; x=1750270852; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+PQ8oC5SKj2Pvt3GVWZzPVy8l1E6eCuxqGGzJ4Ezoc=;
        b=xIrcLz2Opvbo1HLDfiV4weq/ICn5JiaoLQOKMAHRfcgetv1/N0oLJFiUDyZbDp9hV9
         zmC/cmFDkEhOhnV2Prp3bBgWIQoMib2xblP1aj93BbL8UkA7ZrZoU+Amj1hP+AmaWiX7
         2qsl1liWa8EtFM/06hwm+RPdESPxBbmtbh9UyGKhyNRyCCHhWOJv6skLF+t1l7O/mxD0
         DInZff7fBxDWmagX1Q7xuMgvYPRIkwpVyFECnAITo1t9Omy4vJEC80vjVpMQqCk1vhT5
         sjSBBBXi04UfLGvqQybNjskGcOG5OttnHPzC9Wj55VXRRM1ZbU0o8Tqh+EMHlyczpGay
         K4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749666052; x=1750270852;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L+PQ8oC5SKj2Pvt3GVWZzPVy8l1E6eCuxqGGzJ4Ezoc=;
        b=hTZmctqOT0ENHJmSHW+c8eFhqDbgMDVhav0XJtnuJgYsxd8oe3Zkrt1DoDpN3jvLRO
         UGIxUtTRvR8ivocB6gBVExsU6BruczRLIvFpnaKk1yIN8KK3X0UKxyvcPqHSJBPYM2s5
         nt538v81vlLs7In2suSLNsR4b6fTMbDOrklTk92MnNKFGlXuDzX1S+pikSSZA/WE/OJX
         8YMvoYQ/P9S3u1YWTJAiGW9kbt/jQPA804tXzrfeKO+4trrY7qXk+gxolLWM80cU5Pjd
         Vellph6w7G6uJ/tLqwdfxFwbAo+UjDQk0Jeypj29Dryo1ef+r0uL0B++9igHeGBO235g
         Drzg==
X-Forwarded-Encrypted: i=1; AJvYcCUswCBbYBhAfsIyUAhH8ZM9X0SlzqBmEQGWLMH/zwql++pcUCGUZXIOi+s8ejjA6pa9VmzVoF8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsJ0MEDch8WheWRLRrOfTyfteNFbL8bxCym1mUMQpM7L7+FVCD
	7809fW+y3Y+UNfu4QbjHuZ4mM07/OeM4f/uuxVYz7kgvbM0bLQ6GhhNRhMmTyJyH5OoFEs8N6Fn
	2tmGb0ObdSmW/qJav/K9RTcYRYQ==
X-Google-Smtp-Source: AGHT+IF9dOmPoH3f/Yv0MDUAXNH7QyABROACGGNRSdkVBP3APUAHFDt+InrBgJ0rMfVnQW8MeeLtIRfDXx/Of21iag==
X-Received: from pfnx17.prod.google.com ([2002:aa7:84d1:0:b0:746:27ff:87f8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:41:b0:1ee:d418:f764 with SMTP id adf61e73a8af0-21f978c4298mr1110324637.38.1749666051578;
 Wed, 11 Jun 2025 11:20:51 -0700 (PDT)
Date: Wed, 11 Jun 2025 11:20:49 -0700
In-Reply-To: <95fe5d24-560b-4c20-b988-6d7072ed2293@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com> <95fe5d24-560b-4c20-b988-6d7072ed2293@amd.com>
Message-ID: <diqz4iwmw35q.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Ackerley Tng <ackerleytng@google.com>
To: Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Shivank Garg <shivankg@amd.com> writes:

> On 6/6/2025 2:42 PM, David Hildenbrand wrote:
>> On 05.06.25 17:37, Fuad Tabba wrote:
>>> This patch enables support for shared memory in guest_memfd, including
>>> mapping that memory from host userspace.
>>>
>>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
>>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
>>> flag at creation time.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>=20
>> [...]
>>=20
>>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 flags;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 flags =3D (u64)inode->i_private;
>>=20
>> Can probably do above
>>=20
>> const u64 flags =3D (u64)inode->i_private;
>>=20
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +}
>>> +
>
> I agree on using const will have some safety, clarity and optimization.
> I did not understand why don't we directly check the flags like...
>
> return (u64)inode->i_private & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>
> ...which is more concise.

Imo having an explicit variable name here along with the cast is useful
in reinforcing and repeating that guest_memfd is using inode->i_private
to store flags.

I would rather retain the explicit variable name, and looks like in v11
it was retained.

>
> Thanks,
> Shivank
