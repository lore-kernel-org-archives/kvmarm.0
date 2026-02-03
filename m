Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FAB396D2C
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 09:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111701; cv=pass; b=HjhGrmwRpUBkV7QZ0mtr9LrLhWqlgm6pkVk9VapwFJUFDUA4uhilSwTkINbuyhiE6toL4d0+wMy3dNcupczR4KhFQ5NrgflBJk2MBoqUYni5+vYNI4DvXcySgMNmV8SOvkRkJeY9mTWAN7FycuMciikVBx2novRGE9/kyjC+MkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111701; c=relaxed/simple;
	bh=us1083ZECDfL4S3CH0lycoRH/Kw+2jLcC17kXf2gHtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZNitBfvE2pfE/WwSObmdqlGimLLIv5gaqbXVRXkcX70D70Ih/9ECg1R/oBmPSfO95xMfdDZ9yt4YyBvj9O400LRymgmwl8EqwCZ380YuDfrikkX5OntGxjyutAPkVtzRgAuIdzVKU37FOK5YLFWuUhavI2UlNUmMpWldHW3ZDIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jyQdUAaS; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jyQdUAaS"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5014b5d8551so275111cf.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Feb 2026 01:41:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770111697; cv=none;
        d=google.com; s=arc-20240605;
        b=XEtp9vgM2iZmZb3cNIVMES/h6TTMKY+AxyxRBq+xI0ViGfuVeFu8B6AAnhAaP8IHxF
         a33iIunUX5aDfXtghHpvjbiNiWEyJqacGbzpqnRCHtQs+j5ll1QQqi1rgyk+iudS7mya
         0Rn/Q5YNSaYS72Gz0A0D7q1NezaAvb6HxBHg+wC87y5UdLVt5jVoqjmcZ5K0IpxnYY88
         IeEDPFVPIaGXVyz9gyt8o11rPffr3dmOl3i+CMkFQDRjjUusL+tLlN/ttLMPHgCmXfcE
         rfBK5x271dlcIUehQWxFJvekgTxwa8FOMZiKq5/iXf0nFno0nepzzuOlr85A1uSRA2+d
         k+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Fex5v7o8CPkY7hhbst5vKC6sK9Ovg5CdBS9vwalDDZM=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=Qs3ubVOTi7NlJN+4z0xPqD4cWqSRrMI0R2Q1hVDwjeRWi5KF/uQLQoSpbUkuZ6iD/8
         qZsWo51fMwcEXvfvvDFJEOy4Nv6U/YwxYtIlVawc11YdXI4Ud4AdY3ccMMtTFB4l4WA2
         7ODB5jY2sEBHBMxMGS9F7yK4M/vhRRDb/Pr9R/51JXYkooQs/p55QEEWiWe9AhpCeaGI
         rdVPS0pM4ECZ4GF4HWhprJHY81Py8oJnswN8tkEzpO1mYCkVRhGuQApfR7d91F4daN9o
         hqkkLmxtiei/mQcJ6QFN2YFLIryThXbNkHj9E26NYun5Koti8TFogOPoSKF8ysd9bBLy
         QcRQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770111697; x=1770716497; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fex5v7o8CPkY7hhbst5vKC6sK9Ovg5CdBS9vwalDDZM=;
        b=jyQdUAaSUjf1b+RjmiwlgIjF24n34OGp/s97ARFs1GmaEFqswceLuk1kUaCfjqihUx
         5OXmVJ5J2vHbD0kl66iUEdw5Ob927d42NS+hRYR6tR0p2YT9Glkre4VKNnoo2yfrIrd6
         O9ijt5ywMtL5QnLyiQRIzqJ90usIOZWD+//axVCSAXKYkJUnhLndLd7LD63rhnfifb7A
         1cq7WjsU3yWrHikxmjEF9QVeWsQLFeloZ5B/J3iNVTe+h173ql9sFQHHRgDrNhrYqGBz
         lf5pWR6YvwQPmfT0W/WJrwQaUyeW+WYCyWj629vrMqZJWtuipd9mRL9OprPENU1cdAfX
         5ekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770111697; x=1770716497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fex5v7o8CPkY7hhbst5vKC6sK9Ovg5CdBS9vwalDDZM=;
        b=bcMXvnazO1eKutRE8V/2gT5WutMU5cbZ8cRQLMzNGB6nlcgJ5joBPvQCwr9G7Ka695
         HRb15+H8zoz2VZxqxzZbQJbks92gj5hkcJxsWOzkxwPnqOKiE9jV/atsIwl+uNbyvTSq
         Uf4nzDkyo+lFVxSSzvCv0/imX1w0MjqGrEZQX2+EMvywZyQFcZRwChltUuYfv1wUyz3Y
         lKoV0hinGl88htJtDfu3cNqRZJCGgs6mI+sX3WhcgPFhUGZE+gs+G4X+Ycs74PhLnG2w
         mT3pxIf0iliJDRx46uTIbfEhDenzQWpreJ25g3WXQ+vDpYPZTuEDxuLZmOqUvPO2tN6r
         R1AQ==
X-Gm-Message-State: AOJu0YyQRYjQL+CcW3TGa1Y7YSnDRfePoQhI3gqJKQfxM8Vek4x9YJPm
	M9BF663lVyVzCrQBu8VuFGbJxIogpcdOwZJnrWofAQDt/P0n1RA0QegEVyjIereraI5sw0CTCch
	ck2dDMah20aCcnZd1mjhsDpHCuIfC5B+TNXFW9CI0
X-Gm-Gg: AZuq6aIBcDUZ3XAYtE7DZbGoq//ZqP7QqTBVOjM8dFpQuwSrrn1o0VQX3C5dTVmPKn0
	86PdKnuTJYcF0Qk80CGBNF/BFEB+bbu+zIMIOGiI/0Bk01bmbA/FEjIQBBdAYYtrJxkOLkREdw+
	zV0CXJIINqm9W2XVpSjthHfMZWK+BZjhXPXL3stYfLt917/w/3nW8oS4abYxxdGTYWUL5gARnMb
	Qv0TIorO03wGA6lLmH0UDHolEqX30CoB+ut1SMuarYKtbOzXDfUohDow7nH48X2/O6W/NkOWxgE
	v/2h8Y5OEA/BYUNDxury0jseyA==
X-Received: by 2002:a05:622a:610:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-5060f0d0fc2mr4910981cf.12.1770111697142; Tue, 03 Feb 2026
 01:41:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260202184329.2724080-1-maz@kernel.org>
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Feb 2026 09:41:00 +0000
X-Gm-Features: AZwV_QjqZ1UnCxkfe67UIBzq-4b3eaUyZq-nxMFFw9q75AKQJgz1vWaiA_7G-bc
Message-ID: <CA+EHjTzyiOFyy+Zf-2Zxd8W3vap=88xjLUF7bA4OWZOGTDOR4w@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] KVM: arm64: Generalise RESx handling
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

For the series:
Tested-by: Fuad Tabba <tabba@google.com>

Thanks!
/fuad

On Mon, 2 Feb 2026 at 18:43, Marc Zyngier <maz@kernel.org> wrote:
>
> Having spent some time dealing with some dark corners of the
> architecture, I have realised that our RESx handling is a bit patchy.
> Specially when it comes to RES1 bits, which are not clearly defined in
> config.c, and rely on band-aids such as FIXED_VALUE.
>
> This series takes the excuse of adding SCTLR_EL2 sanitisation to bite
> the bullet and pursue several goals:
>
> - clearly define bits that are RES1 when a feature is absent
>
> - have a unified data structure to manage both RES0 and RES1 bits
>
> - deal with the annoying complexity of some features being
>   conditioned on E2H==1
>
> - allow a single bit to take different RESx values depending on the
>   value of E2H
>
> This allows quite a bit of cleanup, including the total removal of the
> FIXED_VALUE horror, which was always a bizarre construct. We also get
> a new debugfs file to introspect the RESx settings for a given guest.
>
> Overall, this lowers the complexity of expressing the configuration
> constraints, for very little code (most of the extra lines are
> introduced by the debugfs stuff, and SCTLR_EL2 being added to the
> sysreg file).
>
> Patches on top of my kvm-arm64/vtcr branch (which is currently
> simmering in -next).
>
> * From v1 [1]
>
>   - Simplified RES0 handling by dropping the RES0_WHEN_E2Hx macros
>
>   - Cleaned up the kvm_{g,s}et_sysreg_resx() helpers
>
>   - Simplified dynamic RESx handling
>
>   - New improved debugfs handling, thanks to Fuad!
>
>   - Various clean-ups and spelling fixes
>
>   - Collected RBs (thanks Fuad and Joey!)
>
> [1] https://lore.kernel.org/all/20260126121655.1641736-1-maz@kernel.org
> Marc Zyngier (20):
>   arm64: Convert SCTLR_EL2 to sysreg infrastructure
>   KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
>   KVM: arm64: Introduce standalone FGU computing primitive
>   KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
>   KVM: arm64: Extend unified RESx handling to runtime sanitisation
>   KVM: arm64: Inherit RESx bits from FGT register descriptors
>   KVM: arm64: Allow RES1 bits to be inferred from configuration
>   KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported
>     features
>   KVM: arm64: Convert HCR_EL2.RW to AS_RES1
>   KVM: arm64: Simplify FIXED_VALUE handling
>   KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
>   KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
>   KVM: arm64: Move RESx into individual register descriptors
>   KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
>   KVM: arm64: Get rid of FIXED_VALUE altogether
>   KVM: arm64: Simplify handling of full register invalid constraint
>   KVM: arm64: Remove all traces of FEAT_TME
>   KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
>   KVM: arm64: Add sanitisation to SCTLR_EL2
>   KVM: arm64: Add debugfs file dumping computed RESx values
>
>  arch/arm64/include/asm/kvm_host.h             |  38 +-
>  arch/arm64/include/asm/sysreg.h               |   7 -
>  arch/arm64/kvm/config.c                       | 427 ++++++++++--------
>  arch/arm64/kvm/emulate-nested.c               |  10 +-
>  arch/arm64/kvm/nested.c                       | 151 +++----
>  arch/arm64/kvm/sys_regs.c                     |  68 +++
>  arch/arm64/tools/sysreg                       |  82 +++-
>  tools/arch/arm64/include/asm/sysreg.h         |   6 -
>  tools/perf/Documentation/perf-arm-spe.txt     |   1 -
>  .../testing/selftests/kvm/arm64/set_id_regs.c |   1 -
>  10 files changed, 478 insertions(+), 313 deletions(-)
>
> --
> 2.47.3
>
