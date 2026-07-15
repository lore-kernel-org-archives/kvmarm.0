Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AD62F7EFC;
	Wed, 15 Jul 2026 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784102279; cv=none; b=HncIMaOT1kmsAgvNZ7T3STbz0dz8A3UahyeOqCGe6I/YOOS3ks7YOpxOZYVxgzRaHyGQHGDsnlsOiSFSOj5KCYyrSKECT3k70OIYFjMgWVe6Tumisbu7FRnWApnz8FIqouXYUAUoMpEQZuOmFg1Lycb1lmTqRzmnCdxEdWsIg9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784102279; c=relaxed/simple;
	bh=l+EBYMXIg0RPACloR+xXR1oGRjANPOlLPw6QzCMBZyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pp4VfvuW/h49/oLMf+30Zl/rdlBDwkllCjDic9XbM+/cB2x/hfPMQWX2Yky8ynmlqXnElZ4vL4AXmf5YL3fDKOA9drNH/64qxqYwT2j2Fnf5xdEUTybTg9UWikY9gOQQ4EI0PKR+MPGlcDJ7FNjYhB64dEqI2RQwwT7MXSAeZro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2+DH64e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2+DH64e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AA01F000E9;
	Wed, 15 Jul 2026 07:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784102277;
	bh=DR+pvW4EsCycgYEFvfd5k5NgYUoYOtxUYUldfNIACIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2+DH64e5dAyDit55c5haPRKvxjv+dG1pqKxE7Ft4VqzcD96nCOLXgOeCmfMwKBxm
	 cJR/iNjYxRPYQJz6RrndajgOkH2jfZu4vpYCdJz0KcH0GWTwDj01OjBBpF2kA9ewsF
	 Q9ivDceRKMQ4ui6zVteEE3edaC8BqWq72XkmLdxj+4MewO2byLkNe3bQfOGqxqU8sn
	 TE1jAtY+hE73VoYMsaNYwUfvAByGuutFlG0nCPbXujJSS1RUQhEgj080iAirzeXsce
	 hsEUPEtUHsaN/Xk+4BUb8J9POqa2kvey79Q9e6bmfVZSxUt7fGPhQ3e5SwOt2uouxd
	 /1kOjMv5md5cg==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Keir Fraser <keirf@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: arm64: Tidy up is_created
Date: Wed, 15 Jul 2026 00:57:54 -0700
Message-ID: <178410226173.1693421.13945529652068436522.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706103129.706974-1-fuad.tabba@linux.dev>
References: <20260706103129.706974-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 06 Jul 2026 11:31:26 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
> - Carried Keir's Reviewed-by. No code changes.
> 
> This small series tidies up the host-side kvm->arch.pkvm.is_created flag,
> which tracks whether the hypervisor-side (EL2) VM has been instantiated.
> 
> It comes out of the ongoing pKVM (protected KVM) upstreaming work and runs
> in parallel with it. The changes only remove dead or redundant code around
> the flag, not any of the functional paths that work touches, so there is no
> dependency in either direction and the two can be applied in any order.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Drop the unused EL2-side is_created write
      https://git.kernel.org/kvmarm/kvmarm/c/581829501360
[2/3] KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
      https://git.kernel.org/kvmarm/kvmarm/c/9b36eda4dfe0
[3/3] KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
      https://git.kernel.org/kvmarm/kvmarm/c/008ea7a6aa01

--
Best,
Oliver
