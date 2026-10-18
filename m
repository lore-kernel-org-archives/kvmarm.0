Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083043D6479
	for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792349599; cv=none; b=MxjqbfkpPnr35tjIU6w1JKOsvIhViMaOykulUkomuor7V/rrT3QXYW+Gc62tzGhwCLjKz5LlfATFBw9o7dF1eG4x4OOyJkbyNOiateCx4yAHUDSHAwcANMT9sFE93ZXmXhsysB6pmVE3yG4GbPUhzmRYVrWzXw8a46fhgEw4B8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792349599; c=relaxed/simple;
	bh=gvK5NFJp9PSzi9hRYXJM0Oi1MlUUKy+sqFwkKYu8iFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BN3x3IIYEqC2yxvRbSJZmxMCtqwon/i/RZ+rS5UuJffLzGUFclAcXC7W2AqGm0GPnACoMh2j+UYisOR468D71Zo/g/QYk6vJxMnLZBu9NcPRY4nzv5IWCwBWWOMckyyhOaLf0moqtodoYSSTBcNQ0H9ov9WbT8+4XEIe73GaRik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dyD9V4zW; arc=none smtp.client-ip=95.215.58.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dyD9V4zW"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gvK5NFJp9PSzi9hRYXJM0Oi1MlUUKy+sqFwkKYu8iFs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792349593; v=1; x=1792954393;
 b=dyD9V4zWFb81O7FzhY6EGMAzOP2fP6g7FzdFPL5L3Lpnq4vuziLb7Tyf0snLWJsd1SPQgvyG
 OE50OyO/NwA8dW53zkyaqxjv6xB3ffbzjqHkFXNYHFhEZp2TQhPobm3XGTtFQ9dxQpkn21zlD3g
 pLfaI/aEPpb0Vud8gxMKKRlI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d13d44dfdaf924c0;
	Sun, 18 Oct 2026 18:53:13 +0000
X-Mizu-Trace-ID: d13d44dfdaf924c0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso5162e87.1
        for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 11:53:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBweuyyk0lVnpLK6bn/MFYoZdV84mZ2LKB0U6bIUcXx7NeSLUrVRXlaGHCsE0yGxgetlM8NX79o=@lists.linux.dev
X-Gm-Message-State: AFq9FYI3+6ymsRPdR6CO4mndVVYgJIHQoRd8lEI8wBUZmQ8Age/YwIAi
	V8IOsphY4E0+lC6Myh3ErW9FuhFGPqoI4QC4oX10Wkk3ciGTpD0jvH3rVY2q7ztYZgf5l6ISptF
	Uuw2eR5EuqHo+wgRm3dq2/Cz950WshYKqgWhrxCa/
X-Received: by 2002:a05:6512:3a95:b0:5bc:ce5b:96f3 with SMTP id
 2adb3069b0e04-5be51cf3ca3mr112016e87.4.1792349592319; Sun, 18 Oct 2026
 11:53:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261018080921.3942517-1-fuad.tabba@linux.dev> <8633u229lq.wl-maz@kernel.org>
In-Reply-To: <8633u229lq.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 18 Oct 2026 19:52:35 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwHP7h_=e1s-iCDekMNvHGAQA3K1zv5v_4=PXQw9ueiFg@mail.gmail.com>
X-Gm-Features: AclHuK_UQW_4n5Vfv2y3fMN8nLjYC3wYR4AsLV2Y4-Ndgvu9PNfAVf7ecY50duQ
Message-ID: <CA+EHjTwHP7h_=e1s-iCDekMNvHGAQA3K1zv5v_4=PXQw9ueiFg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Only enable S1PIE and S1POE with the
 features they imply
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 18 Oct 2026 18:37:37 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> I'm afraid that this only addresses part of the problem. Ultimately,
> the idregs themselves require some sanitisation because KVM uses this
> as the source of truth. I was pointing this in my reply to Broonie,
> and this is (probably) what sashiko is blabbing on about.

It seems so. The trap tables were only one of the places that read
S1PIE and S1POE. Sashiko found another: PIR_EL2, PIRE0_EL2 and POR_EL2
accessed from vEL2 have no FGT bit, so accesses to them reached the
hardware registers.

> I hacked something that could be used as the bases for such
> sanitisation, although it is quite crude and doesn't cover all of the
> possible requirements, see below. I've only boot-tested it in a nested
> guest, and I'm not even sure it actually works (my test box doesn't
> have these features).

I'll send your patch as v3, rebased on -rc3 with you as the author,
once I've tested it. I'm dropping v2's trap table changes, since
they're redundant once the ID registers are sanitised. I made two
changes to your patch. The sanitisation now runs before
kvm_init_nv_sysregs(), so the nested RESx masks are computed from the
sanitised values. I dropped the res1 half, which isn't set by
anything.

Cheers,
/fuad
