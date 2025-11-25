Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B8532E73D
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095510; cv=none; b=keiKir7KJcAX7bwz+Y2+fnUKH2zCifTrGT6bLFtow/5fk1R9FQ4V11BwpIuWl+PDOGUOarRNYnjkzKNtP4cnCakKh36j+02J0R2g3gowycItH1RYqKWQTn4RFXXOZ8LhZ36GIxXSGN0NwgkWstDN+3JsX2QpZtDG0vQMvWa1qsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095510; c=relaxed/simple;
	bh=MSWaX9NjuLJ6vSRA7GHqTQ8KVuL7BdPXBD15aiBv8rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k68+iBsah+6cQtBfeEfDAQNTi0SneVWIYGx5ohhspQm5VCOa3EBoErpWMIUDFp7lV55pOwpENl/F0PtOqT87yHsA9QERjQRAoJo7iU8SS6LqSNpRdn3wGvGf0TnTP7XPE/A86wI5BLVW3gNu0xQOooZys3YXJmyeHY1oe//yEPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4229A1570;
	Tue, 25 Nov 2025 10:31:34 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 294003F6A8;
	Tue, 25 Nov 2025 10:31:40 -0800 (PST)
Date: Tue, 25 Nov 2025 18:31:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, will@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, shuah@kernel.org
Subject: Re: [PATCH v2 0/2] set_id_regs cleanup
Message-ID: <aSX2CSJEwUYkn5GQ@arm.com>
References: <20251125101207.1492580-1-ben.horgan@arm.com>
 <86cy56qgi3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cy56qgi3.wl-maz@kernel.org>

On Tue, Nov 25, 2025 at 03:27:48PM +0000, Marc Zyngier wrote:
> On Tue, 25 Nov 2025 10:12:05 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
> > 
> > For this v2 I've dropped the ksft_test accounting fix. Mark Brown has
> > more extensive changes [1] and looks to be a user of the set_id_regs
> > test rather than someone just doing some cleanup. The other change in
> > this series is to remove ARM64_FEATURE_FIELD_BITS from the tools
> > sysreg.h header rather than the kernel version. I'll send a separate
> > patch to remove the kernel version.
> > 
> > Tidies up a few small things in set_id_regs. The removal of
> > ARM64_FEATURE_FIELD_BITS touches other code only so much as it removes
> > the define but set_id_regs.c is the only place its used.
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Thanks Marc. Shall I take these through the arm64 tree, together with
the removal of the macro? They should have probably been a single
series.

-- 
Catalin
