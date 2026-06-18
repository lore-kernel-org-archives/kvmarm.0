Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C82E5B1B
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797661; cv=pass; b=Wz96rTzVdgjwC6NTsA0i6rwdVbGDzzXdpl1zvIlcUp+kJqUu6I+3hmmwJlAw4kg5Vt0ktdoGqICvyOGh78vbWbRwU0j8jCFrcqs0rZKJwz7BVJP3McG4pRryCHkcEXNXMWOIQEiIyOXvexiUF2D3vs5mT/ybRJFCEgxpnRxnZV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797661; c=relaxed/simple;
	bh=g7vtpyHKgi8Q9bKtMWDzvuqyQMGCDO0MPTPIGsJsJoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=APQBqKMAcTiZJd6+xbj2MoYn99y2WgOaC2qvlQD3PzwlPklfN882B1SStIGO1F7yvLUVsYjHuTkAhljoaJ2/9n1BvbPMR8FFUo18Wrbu//hP+LR4A1fAAqxrLJOGE1faDVRupYgZ474kPFBwo1Bp/D6A6UYsLiFDgijZOnufh2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jiJ5GYMO; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jiJ5GYMO"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5175d339e8bso296521cf.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 08:47:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781797659; cv=none;
        d=google.com; s=arc-20260327;
        b=A3hg+G66nFn1NblCSxQpZZ0aGa4GdDePEarokwiewSsNDwEx/U7S70F7Ezd8lbn7C7
         phqLUFNFup0jExe5plcdUk5LKxD2OBVErn4m8gFfD3vrn/iAgt2jPs2R7GKwMHydnGn5
         8eX9OcAmS77cL+PCnU0N3/Zk2lJXFI2NaJGrIA/SwNePpA1SjaBNB2bW3jXK25DIRbNE
         xPNzLeVvQJ8EHPD8ybwGvDYGb1u6s/KfaKLpmP18FNEitaj6X/7OJLl5qPXmbWGCMuHw
         lyhd75KSCdTXuka/eeZ7uptoqKT+7UUCsfkBcV4Oo0dFuUgJh4Ztpg7jG572leCogZGC
         E2QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MRFgdoA8Tb9xPyc7tsp0kLt91evXE6mSbWW3PiLEJGY=;
        fh=q0QD/0zQrsYumR3V8AsV0P8W6LYUAD1Lo6zw/Ak3Bic=;
        b=PSCKsycCwFS139APDeQMitlT+axAllrl9FpIl29CVifjZHQJp5QIZvYZnTDkhurvbB
         5vQQ43i6Bj8gN9KTwNCKxX+rCZuz8zouZXd6CZTae47XKFnJGaA8n44oPbdOoB1/7fYw
         7YBeik7QHwntrTRVstJ/9c/zKzAA2m98qH1stIOmf1dTWWsDGFXOBFbOa/aU3lQoD6EW
         UftaT2DJbSAVnkDAprvlZ6KmjkScioI6HLbIm1dlDV5HbEEFmcc4AI/qUkqlGjPrJlpG
         Zr3Xofi1wwAbbtrgvjJ+KyqdRnqIKllOOABkyVM9mfRp1E9px1whKrySF4NNRqc6gF99
         gqSQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781797659; x=1782402459; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MRFgdoA8Tb9xPyc7tsp0kLt91evXE6mSbWW3PiLEJGY=;
        b=jiJ5GYMOrW8YnDCySSgQWQnbLF837MPzUpWZKEVXriY8XwCIq6Fc55p+dyrXfCgsGo
         qCVgtg3hoGy8RUFaMkHBlsPPclJUn99xSmww1e5vAHDYAhrhLRYbTcTraQzfqXy6GAJH
         3FX0VCWJcoZESVjnEN4xmKsjzXIlafgoYwJ/UvhPUne8nwhFx/pku6iD9GZmBSVlo5Ms
         B2V4ZA3k5fzXSux3AfiNrbsEMC4MqBCSId17nnIY0s9ZKoxVB4Pf/tOm2bNA7ElZ9x2B
         5PVb46EkZmFc7BOYGID4fwJt+5fC4v0icoSmT4meJ7Dr5aF+BHXdRgCtqI8soEgYteHl
         T0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781797659; x=1782402459;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MRFgdoA8Tb9xPyc7tsp0kLt91evXE6mSbWW3PiLEJGY=;
        b=HIbcUaWhCQckfVwOk9Yn6li2SXR3AepsEsggjjPVC6uU3fwaQgQP14yDwWtM5r7olb
         rL5P2nLBmvmRoZGNoschy12f6Rbp58Z6Dl6vMH1DpvjyNO6UdjFemkgAvMJbSAJJwNXk
         OAE3YAQW/VVw4/Tt5vDQuvLX2zUohsnw1mKyUkQluioIae9Pfw4VQyzojX2bOcQ8xPxY
         D2WssvWx+Ps4xsDI2jEr1K3nyV3X4LjYlE/jLdwOtZCXulqHGbt3rET/d1xv0uyTduwR
         cVl+Q65XzsJvsxD/rclITHZGnDhMW7GAXcJDFDpv9+ny7ElPdK1BEPWLW/y0mFxdUzl7
         kMkQ==
X-Forwarded-Encrypted: i=1; AFNElJ9UcqYUxEuweiEMeJ4NOvbaTOf9FUW2xzzSrzLyjiBwKek5TXhxTtEjIQypCLi18Jj4Xo2Qu+Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMCcpRoZrQvgOxx49CMK1UcCGkPEoOQSIscPw262txg/TwDe8G
	Uq0yjO8SFq5Ctzfrz4r06ZGptFS3TdpuzXpEraAX6tUQQV2HSDA1Jgj6EO+Mtag16bdElljpsBT
	4JAXUaTKJAq2fcCYT7TeDwhWQF/FEHC6lDVmlTpn1
X-Gm-Gg: AfdE7ck9eNqmUa9yOfi2Xq9DkwppJUhzzhFJfTcv4iRVNufqXs5UK2Z8bHNxbCb2dgC
	qtToZstThAF2l6CO0lY6L8kyKDWwVm+NRwEWTzuVfi9jQM7rlSBXhcp8NPLcm8VvCQHccwDU0sS
	g7teEeKLDb6oN44zQXvjYgEWVOp26VfI3lozAh6npZJqqQDxSLJqHXNUztqSwrk2LtNy89nGgwF
	pNFGwuWXyvaoTeRt/MVcUrdKSRXTSlHvyt0p/tEDX3dSqhJnMIVt1zRiR+BiLAKK2qJZOnDrM4P
	rFSTyu0v
X-Received: by 2002:a05:622a:4d9a:b0:516:d570:82c0 with SMTP id
 d75a77b69052e-519c9775acemr8514741cf.15.1781797657663; Thu, 18 Jun 2026
 08:47:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 16:47:00 +0100
X-Gm-Features: AVVi8CdsITDRUKHQCPiJRE7xA_VLp_pZNxNzO3JRnh-OLh6r8j1TswlbWR1CqTM
Message-ID: <CA+EHjTyjst=3hrMwX2Obh8hNpEQNJgL7i-2xcOpgDrb4kHZfNQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] KVM: arm64: Fix missing ESR_ELx.IL in syndrome injection
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 13:16, Fuad Tabba <tabba@google.com> wrote:
>
> Hi folks,
>
> After sashiko caught the missing IL bug [1], I did an audit of all ESR
> syndrome construction sites in KVM/arm64 as Marc suggested. This series
> is the result of that audit.

FWIW, went through all the issues Sashiko raised [1]; the only real
bug it found is the one we already fixed [2].

Cheers,
/fuad

[1] https://sashiko.dev/#/patchset/20260618121643.4105064-1-tabba@google.com
[2] https://lore.kernel.org/all/20260615131116.390977-1-tabba@google.com/


>
> The ARM architecture mandates ESR_ELx.IL=1 for several exception
> classes regardless of instruction length: EC=Unknown, Instruction
> Aborts, Data Aborts with ISV=0, and SError. For FPAC (EC=0x1C), IL
> reflects instruction length, but FPAC can only be generated by A64
> instructions, so IL must also be 1.
>
> Patch 1 is the bug sashiko found: inject_undef64() in the pKVM hyp (EL2)
> path never set IL. Patch 2 makes the same fix to inject_undef64() in the
> normal host path, where IL was derived from the triggering trap's
> instruction length. No instruction that reaches undef injection has a
> 16-bit encoding, so patch 2 has no functional change today.
> Patch 3 makes the matching fix to inject_abt64(). Unlike undef
> injection, abort injection is reachable from a 16-bit T32 instruction (a
> 32-bit EL0 task under an AArch64 EL1 guest), so the old code there
> injects an abort with IL=0.
> Patch 4 fixes the FPAC syndrome constructed during nested ERET
> emulation, which did not set IL.
> Patches 5-6 fix SError injection in the emulated and nested paths,
> neither of which set IL.
> Patch 7 fixes a fake ESR used to exit to the host. The host does not
> read IL there, so it is not guest-visible.
>
> Changes since v1 [2]:
> - Patch 4: keep IL by masking it through from the trapped ERET's ESR
>   instead of OR-ing the bit in. The ERET trap (EC=0x1A) always reports
>   IL=1, so this preserves the source syndrome rather than adding the
>   bit unconditionally (Marc).
> - Rebased on v7.1.
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/87pl1t8q24.wl-maz@kernel.org/
> [2] https://lore.kernel.org/all/20260614163336.3490925-1-tabba@google.com/
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Fuad Tabba (7):
>   KVM: arm64: Set ESR_ELx.IL for injected undefined exceptions at EL2
>   KVM: arm64: Unconditionally set IL for injected undefined exceptions
>   KVM: arm64: Unconditionally set IL for injected abort exceptions
>   KVM: arm64: Set IL for injected FPAC exceptions during ERET emulation
>   KVM: arm64: Set IL for emulated SError injection
>   KVM: arm64: Set IL for nested SError injection
>   KVM: arm64: Set IL in fake ESR for pKVM memory sharing exit
>
>  arch/arm64/kvm/emulate-nested.c    |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c |  2 +-
>  arch/arm64/kvm/inject_fault.c      | 18 +++++-------------
>  4 files changed, 10 insertions(+), 17 deletions(-)
>
> --
> 2.54.0.1189.g8c84645362-goog
>
