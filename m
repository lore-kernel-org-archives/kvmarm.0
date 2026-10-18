Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA18363C6F
	for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792337446; cv=none; b=Iiek+s1CUZ3OdmvIZmtNeGBFeXX2yc9UAR5Dkf6DQp9IZ1QOsd/YxzWHK3fkkGJO48a3SBb7BokgKhK3vtAXCVDO1I+BlsUEtJojqHBBv30EEs4z3XoRg/gvXW6QLWyIHAo7z4ymA3CUbpjD6/OC9ITEdiu7oaxpJwQ38VqEOOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792337446; c=relaxed/simple;
	bh=/JipYdo2bB1OfUJDoroTZjZ485KsuI12cRAd7OrDUZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hyappgi705OGcsMKAy3FUdx2EvozgdmjURZSEEZN6L4tEi89Qj40uJW6zBUdjb1ioztHfvz3+cOUys2jEKtM4GNGT5uwiYV6rUxxIsypMx+7T4Vkejvyyfazoz1eS6wZwrew2XeRXBsLOUjm6ie5dUjabBpkR0vDHKv/eINOgn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U8eM9eGh; arc=none smtp.client-ip=95.215.58.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U8eM9eGh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/JipYdo2bB1OfUJDoroTZjZ485KsuI12cRAd7OrDUZ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792337441; v=1; x=1792942241;
 b=U8eM9eGhc2RfnOjNhpnMbs4gg2+nDzQG8clNYNBVE5sFmmxA/1Pmhl0rqcuoK9aKHzmVwkwO
 EhRfRm+8WojJcaZKV2urh9GjVpApNahgU4swYLOP7qRMIFE8EYS9lWgIswNjs0+dOXn5HFIkW86
 fPY3UYSbRLvtpPT86JbVThIc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d18b9db8650f1ce6;
	Sun, 18 Oct 2026 15:30:41 +0000
X-Mizu-Trace-ID: d18b9db8650f1ce6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso4825e87.1
        for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 08:30:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByYZnN0uuubIuXFz0lqvxPnCjxfqxAB1sLfElN583LwORQOE447jbtYKJe8Z3Y++D8gCC6XCKA=@lists.linux.dev
X-Gm-Message-State: AFq9FYKH/0vL1rmYIW2BP/Odjj/4udB1h3HhBPhZEOj8WHon7IpGshQ8
	LlZernLZrl0p9p+pTWC7iil8U/B25c471VxwoznZde/T5oJ4tZTF5DiqUAFrnSpCCNWlJ57H/LW
	4BfcgNB5JW9X8xTEROSCgHDal3MZgorgPGoNR5Mr6
X-Received: by 2002:a05:6512:4026:b0:5be:5605:3606 with SMTP id
 2adb3069b0e04-5be560540ecmr42233e87.8.1792337439769; Sun, 18 Oct 2026
 08:30:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261014162126.964330-1-maz@kernel.org> <20261017165204.3343275-1-sashal@kernel.org>
In-Reply-To: <20261017165204.3343275-1-sashal@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 18 Oct 2026 16:30:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzNJ_Cmzthn04bzHdu2+1cDmwqRsnK1uWQ1XBmxJdt04g@mail.gmail.com>
X-Gm-Features: AclHuK-MBUMuIZ1CdPDTxZws0S-OBMvb5spNuDbDe5Ykb1uD70nnFSK1DYZMkr0
Message-ID: <CA+EHjTzNJ_Cmzthn04bzHdu2+1cDmwqRsnK1uWQ1XBmxJdt04g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Take a protected vCPU's TWI and TWE only at
 vCPU load
To: Sasha Levin <sashal@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks for fixing this Sasha.

On Sat, 17 Oct 2026 17:52:04 +0100, Sasha Levin <sashal@kernel.org> wrote:
[...]
> Build-tested only: arm64 defconfig with gcc and clang, W=1, no new
> warnings. The only code generation change is the protected vCPU's
> per-entry mask, 0x6100 to 0x100. Not runtime-tested, as the in-tree
> selftests can't create protected VMs.

I tested it on QEMU, with the host booted with
kvm-arm.wfi_trap_policy=notrap and a protected VM using kvmtool. The
protected VM doesn't take any WFI exits (4415 with the default
policy), so TWI still reaches it at vCPU load.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
