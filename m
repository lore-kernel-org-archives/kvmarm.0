Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029014;
	b=1wqi61LcrR4LTl+rgmr4DrrUitA52tivkolCKZCkA28R71ICO0w1XUpwbA6J1ay4buRx
	 MfPf8J105pT/r4iCIrP/5hHjvN2sJ7VaLoHlk8JnpDX5u3eNbe9abxE6sK6GDWMnz2K7D
	 KkHP48mXVinQHdePDC7BiFe/W6cLo6ax3Fb9uIloz0C0fSbU+0th7bFxKL+G/kM9vcEpn
	 kKDb23cB+D2f9M3s2b1VKo7J1KdrbbiVZJAPA/oQ0u4wfD72llEJ4SXVJbLuCQSnh16J1
	 77nyTJ378mYjde0Ijagx2csSjoHo1ZISYIt/6i4v0n8waQNRtE/zs+qkoVnLv7+Gn4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029014;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:CC:Subject:
	 User-Agent:In-Reply-To:References:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=YxWsOpaN6CU+fFgVMclUNy68ZrjNu1idGsKCVJ6O9Z4=;
	b=4T/1Ueq6uZyFYbRStjJugXV4AP8dov3sLN+NlINzXBFTlzMkhsriQSD3u2aV1CMyR2xZ
	 P7ATWuSB5XOfB8BC4wKzERixFQ2qMqu4FqKxy69AQzLuKy6c/MUYz1eoJkzirFz8dGWhF
	 Thy71k7RBuCFmIokERdmo8g1pER4QffsqFaI5uSzevLbWXZB/rN7v8aUvRWoOFHVJWMwX
	 xx+dgzgcpkTI56WPdVe+ATGBnUnlFbgq4U/pI7+Il+M4nTP/EOLrNWpWZFfq9DWJQxiGJ
	 ob9LWjxaUFtfGfzL/OvzAXjfVz9nfCfIRvuAX9YuFXU3bLfasnk00FKN8Mh6UuztF1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=i6T5OkA6;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E65606A31C;
	Wed, 18 Nov 2026 19:10:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2E65606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=i6T5OkA6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=YxWsOpaN6CU+fFgVMclUNy68ZrjNu1idGsKCVJ6O9Z4=; b=i6T5OkA6HB7NG25CMcQ8Te4Ltr
	KxIOzXx/mNFMONQ4ViCWFPNmIrUOuZVTIe8TZnkkJlz9SvrT7bF+8x41WWOLI8qO2kRjpz3bGORzX
	iZXB3H/1+181sDQQBjKkDX3Ecxc0BS+EsdKOocrWt+stbQmWHtKIf0QpLepBumkQf/831tPfnEejg
	Mn0K+Y6S4HnvTOy97cfE4cJl/H97wFiYDnoEOJ+PmptkQJL2VFtvIU9o0jXrb7h8DKMAaRLOBo6Ic
	75Zv3gjRNJV25Ap9P2B/c6B1/SSOXgveIKaxkIQi9zRBBjJ2Hb8o/hzhGZMKQfHMsaX3VVDtMH58Q
	ZlneSFqw==;
Received: from [2a00:23ee:2910:16f:a90:4999:d4c:f045] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTl2l-0000000GRW5-1yMX;
	Wed, 18 Nov 2026 19:10:07 +0000
Date: Wed, 18 Nov 2026 19:10:01 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
CC: Sean Christopherson <seanjc@google.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
 michael.roth@amd.com, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com, Melody Wang <huibo.wang@amd.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, x86@kernel.org,
 coconut-svsm@lists.linux.dev, joerg.roedel@amd.com,
 Mushahid Hussain <hmushi@amazon.co.uk>,
 Sriram Nambakam <snambakam@linux.microsoft.com>,
 David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH 06/16] KVM: x86: Widen the plane vCPU fd ioctl allowlist
User-Agent: K-9 Mail for Android
In-Reply-To: <4e4fb011-9171-42c1-b499-27b0333a2fd6@redhat.com>
References: <20260608144252.351443-1-joro@8bytes.org> <20261111222911.477-1-dwmw2@infradead.org> <20261111222911.477-7-dwmw2@infradead.org> <4e4fb011-9171-42c1-b499-27b0333a2fd6@redhat.com>
Message-ID: <D0EE54A9-3FF3-4005-875B-A9AF04EB1341@infradead.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 18 November 2026 17:58:33 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 11/11/26 23:29, David Woodhouse wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> A VMM that puts an initial VTL context on a higher plane cannot finish
>> the job through the plane vCPU's fd=2E kvm_arch_is_vcpu_plane_ioctl()
>> refuses the ioctls it needs, while the one capability ioctl it does
>> admit, KVM_ENABLE_CAP, reaches *every* vCPU capability handler=2E
>>=20
>>   - KVM_GET/SET_MP_STATE: a plane vCPU for an AP starts in
>>     wait-for-INIT like any non-boot x86 vCPU, and nothing ever sends
>>     INIT/SIPI to the higher plane of an AP=2E The VMM has to mark it
>>     runnable itself=2E
>>   - KVM_SET_GUEST_DEBUG: single-step and breakpoints on a non-zero
>>     plane=2E The debug exits surface through the plane-0 KVM_RUN loop
>>     like any other plane exit=2E
>>   - KVM_X86_SETUP_MCE: mcg_cap is per vCPU and every twin starts with
>>     the KVM_MAX_MCE_BANKS default, so programming plane 0 alone leaves
>>     the planes disagreeing=2E Hyper-V shares MCG state across VTLs=2E
>>   - KVM_ENABLE_CAP: accept only the audited capabilities on a plane fd,
>>     the SynIC pair and the two CPUID-enforcement toggles, which change
>>     state that each twin keeps separately=2E Anything else gets -EINVAL=
, as
>>     non-allowlisted ioctls already do=2E The nested paths behind
>>     enlightened VMCS and direct TLB flush have never been audited for
>>     plane_level > 0, and without the filter any future vCPU cap would
>>     work on planes without anyone having decided that it should=2E
>
>Not sure about KVM_ENABLE_CAP, the other seem sane=2E
>
>BTW at some point I'll rewrite these commit messages, they're infuriating=
=2E=2E=2E

Yeah=2E I've grown kind of immune to them now=2E Even found myself typing =
"load-bearing" with my actual meat fingers the other day=2E

I've also been looking harder at the completion thing=2E We *can't* (well,=
 I don't want to) enter another plane while there's still a completion wait=
ing on the first plane=2E

Which means any control register or MSR interception which needs to be han=
ded to another plane has to completed first=2E

I think we need to be able to complete them with the RIP unchanged (not ad=
vanced over the instruction)=2E Then for VSM, it's VTL1 which will handle t=
hem and then advance RIP for its VTL0=2E VTL1 wants to be told the instruct=
ion length too; I could make QEMU find it but since KVM tends to have it an=
yway, I'm looking at how I can export that=2E

