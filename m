Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100069;
	b=ZkKvKB5PyN0teElI0t71PHc9rTJ7JFQ0svMeqj5Ih1Eud9ikTTNi7sa6G85OhGTuyV9H
	 6sLJgy6Fi/ibImjVW2GeEgXFvxT1Vk+f3Yvvt9WyyIZr+PbahreuGrY5XOioAQxvf8s1s
	 5owFg/hUViXVkGwDMcBdtTRucUrHEXCLkv6VRLnn/evVSnZB1WHlv3k02I7LtVhuB+Lnj
	 wen46wm0mUMAPW4gnvVP2zQS0s5/XBmEEGlRYj7lhA459MUdYNmF9RzCxqRXNhxsKeFKE
	 E+2W5AJOYFuCCKeT2F20h3dq6p+Y5jBz6J/OPIkHZ4yMWi/Q+dRpP0ujAGhlFcOKWpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100069;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=P2zzf8FFEBL81oIQV+yxC49Gt94XvsXrSt4IwcmCdEQ=;
	b=IGMd3RZVfqoeoTntmilx7MShgqcc9hZpcjRAnnKZPprIwNT6vZJex7L7fneLUK4fs3cs
	 TuVMwzbvuOrB4sYZvVb16Dtam5dobKws6Tb+SFWQcDKgNSPN0WoBrixPzObIdT6L+9lyt
	 FgLoX//1euaErm+Kj6ndoHXT0i1C0y9CuEjH7w1Q+eghzbnAqygJ8H/RiHdPexZz7wMHz
	 sE5MkULS0/RtIyG+uPSHTDX6D6CxrsTgxtMeqtzHhyatcvjIi0+xm7X5Bak6zfsrLWiA0
	 ZSwM31FpOynk35IcVnI6gxMkUYiLmFZMkS94JCXF7+yEjcwiWsHjfijiby+/xuFIIPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HHP0PDhX;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59175606A32C
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 14:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59175606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HHP0PDhX
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ee2d612733so8166555ad.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 06:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795100069; x=1795704869; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2zzf8FFEBL81oIQV+yxC49Gt94XvsXrSt4IwcmCdEQ=;
        b=HHP0PDhXVOn54mMobsb5Zn86GpLodfIOZdSmhN1DtlIwCDjdanHdZL9WyQ9aqIbmRk
         w5q5hYpKVhr6lmEnw7t5neQTF+C+Qy8yn00oiJbOaB9PfX2yDVh4oMsit/liBd0xMfad
         kig/jZ+8DXKC9YVhN+RBDJiy3gyRKcDv7vl6xeS20AQvuGH6BgE8V/QCU2oBbNvbHzii
         DGZ6+FTPmsY8iG0QwL58ptbb4diRxluYUrGrJoFo9DRHUQq1pgrhCwvGK9reZ5iaK8d/
         ML8T9xklPyyHJ4bfadhur60kJBRF0GTvgSdkOGHkJuVISHTiDUc+VQ0Du0hX1Hi6l22C
         h4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795100069; x=1795704869;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P2zzf8FFEBL81oIQV+yxC49Gt94XvsXrSt4IwcmCdEQ=;
        b=vxGX3BuW3dITF1ijYmdgXmCv3ZQEbjWj077SjAGEuUsBVpXYlHACqeCmh67Qp+/oht
         1DBckeyCKJd5CXD8EFdsDgK9wJMVj8hxbXOwilF9yLsVAz9JA8EmDlzXp1yp+9GGBk4S
         NPYtMzbt23OyY71ppKkUQr+goJMlC3TX4Zai6CZMtGdQcTefIvxUQtjSvN76O25Hiuvf
         mgl380dBFBXji6VKkmfa6Lz1cpZ+EwTm38OI4eIVQDCdtTf3d8DK9UeSEV/HEcj1SCsQ
         TOe0pLfwJY14h8Q6vFO/vH3/b1ySZTGJmcUb5YP+ZN4gOErPyu/Oy41sj5yAUlGvIWRt
         HrYg==
X-Forwarded-Encrypted: i=1; AL+hErG1pkF4NKdOD0bd+j0BFpaIKowl7nRHu3Ht5t1DdHadubFqfqth2TxjBUfikBdaRRmzYuVAO/E=@lists.linux.dev
X-Gm-Message-State: APuU4Z97uaFtVOvmf4KsIZxp8WdJmSpd8IVevw2o3EMApIb447iSz/9k
	9FX0Zya6TC0clVpmRgktS1zt9tTjRZtrB/oYrV07neFRVEjgDA0IQVXQcVnm7LwX9hDsOCZBbaY
	1b0eRXQ==
X-Received: from plbkl12.prod.google.com ([2002:a17:903:74c:b0:2ed:4c9b:1bfc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74c:b0:2ef:f2e0:db0
 with SMTP id d9443c01a7336-2f03f18fb43mr715205ad.10.1795100068394; Thu, 19
 Nov 2026 06:54:28 -0800 (PST)
Date: Thu, 19 Nov 2026 06:54:27 -0800
In-Reply-To: <120ad525-efa5-4129-9d97-fa6fa5db747f@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-2-steven.price@arm.com>
 <CA+EHjTy5xBmavNWSYPjqU9qXtssV3ZHzsUr1s_4bVOt1GnDLVg@mail.gmail.com>
 <6bb490cd-ebbe-41d7-adf3-d6eaf0e53478@arm.com> <b1ef7241-54b0-4a17-83b6-0008e722f2f6@arm.com>
 <8a095a42-662a-416d-a5d7-79e10161201c@arm.com> <cc27e6a8-6bfa-4c82-92a7-33175baf6803@arm.com>
 <120ad525-efa5-4129-9d97-fa6fa5db747f@arm.com>
Message-ID: <av8No1rvJLXwciId@seanjc-mac.roam.internal>
Subject: Re: [PATCH v3 01/11] KVM: arm64: guest_memfd: Check mmap support when
 preparing memslot
From: Sean Christopherson <seanjc@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 19, 2026, Suzuki K Poulose wrote:
> I see, thanks Steven. For context:
> 
> Arm64 currently (without inplace conversion support) only allows GMEM
> with MMAP flags only and relies on kvm_slot_gmem_only() to detect that
> the GMEM has MMAP flag. But, when we enable inplace conversion,
> we can't reliably reject the slots by kvm_slot_gmem_only(), because
> all GMEM slots are marked GMEM only with inplace conversion.
> 
> Also, from the API Documentation,
> 
> "When the KVM MMU performs a PFN lookup to service a guest fault, the fault
> will always be consumed from guest_memfd, regardless of whether it is a shared
> or a private fault (unless in-place conversion is disabled and the backing
> guest_memfd does not have the GUEST_MEMFD_FLAG_MMAP flag set)."
> 
> So, in effect, with in-place conversion enabled a KVM_CREATE_GUEST_MEMFD
> without GUEST_MEMFD_FLAG_MMAP is an error

It's only an error if (a) the userspace address in the memslot points at the
gmem fd and (b) something in KVM tries to actually GUP the memslot using the
userspace virtual address.

> and thats what this patch is trying to fix in arm64 KVM. The question is:
> 
> 1) Should this be fixed ? How does TDX/SNP support older VMMs with
> inplace conversion ? What was the conclusion on this breakage ?

There is no "breakage".  If userspace doesn't point the userspace address at a
valid VMA, that userspace's problem.  The only thing the early check would do is
prevent weird use cases that may or may not be valid (and for which KVM doesn't
care), and error out earlier if KVM guesses right and userspace really did goof.

> 2) If it should be, then shouldn't it be done in kvm_gmem_create() ?

No.  As above, I don't see any reason to have the check at all.
