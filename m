Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E6F332610
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 07:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198546; cv=none; b=lVNVwzxt7UxtvBmhwKfGbDrxKa0kwoM4LoCll1z0yXQyJ/yz2NV3vDHPMMRUWvsbimOzlaekgUCxxEFg9Nf3PhCxs7Ur+jvgiYnLhe9Af9Er9aQlfMbLJUyym9Xk7R1Z7CFsqnTgcEEsF1ynN0afPTeukZ3Lt5OP8OB1lxAHwh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198546; c=relaxed/simple;
	bh=kYG1qUtrYuoYwGre3pnueLQi56j1loWT37Xi9HqjsC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ddJKXKr2k05RKdVYEn/VedkuQOCf6Cad4c/yge43jv9jnsxa/1hyRozEDDkAqcM8xS+V+4J98UpSMD79Lvm3jHcwda/K37HuE8cbj2KVNMQ12dHEFP3t/7ULQnaVi2sF7lxiO8T8WRQj0L4NNxgQlEclaGCTrjsA3rVGFyKVIfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xz+uAHO1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xz+uAHO1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751BA16F2;
	Sat, 12 Sep 2026 00:35:40 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F4723F7D8;
	Sat, 12 Sep 2026 00:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789198544; bh=kYG1qUtrYuoYwGre3pnueLQi56j1loWT37Xi9HqjsC4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xz+uAHO15VP7noIkEJ9vctptjJm1Cff4sp3p2/xmhRv7Os8svrxNxVhXZfKv7MC4x
	 7uQbzmrdfKbunK3+Co6Yi2MtHV4y+n264ubh1tTS2XoFOAKcpiA6ftKyTycBHyFv8e
	 lIFPbpvdALegNhW7pFWv7042GkHib3wkNcXD5OIk=
Message-ID: <55a0701a-3b01-4ab0-ad67-fa3d91e315aa@arm.com>
Date: Sat, 12 Sep 2026 08:35:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 3/5] kvm: Name every exit reason the UAPI header
 defines
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-4-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260831192406.1341841-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 20:24, Fuad Tabba wrote:
> kvm_exit_reasons[] stops at KVM_EXIT_INTERNAL_ERROR, so the panic path
> prints "UNKNOWN" for every reason KVM has gained since. On arm64 that
> covers KVM_EXIT_SYSTEM_EVENT and KVM_EXIT_ARM_NISV, and the newer
> KVM_EXIT_MEMORY_FAULT, KVM_EXIT_ARM_SEA and KVM_EXIT_ARM_LDST64B.
> 
> Name the rest of the reasons the synced uapi header defines, up to
> KVM_EXIT_SNP_REQ_CERTS. KVM_EXIT_PAPR_HCALL also loses its CONFIG_PPC64
> guard, which the build never defines, so that entry was missing from
> every configuration. The neighbouring PPC reasons are unconditional
> already.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


