Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4865381E87
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 03:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381764; cv=none; b=kOt85Kz1A9XLgiF50QWZ44XvHJ7X90UOn/80cgsZnSnrhIB5+cSdv80yyHe6PK6tVIyCXUrLgmtkr2ABLrtxHiruaBj6kvSc+c2hvtth2YTDSihnFyzrhar5JGwDKnjfUwcr4cGhfWwG9uhOLkTJFi/m07yeLq4Tnj7U+MPTBZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381764; c=relaxed/simple;
	bh=/1yTzYFGg3pV1usAbAUtPbtP+HA7uKNwPQmps+iLHVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCcNXAWNKYXIO7dn+PBos1/rX7SiFRksdWJ+9T1faP+zKBWCDKzd6Tgyi8zkXPyvf2UW/1/8pbHpQthbLOtEpoKieFOYUmOkiCtsAcfyZQdMU6WHqSVSex+Luyf4Qaz1PSRExxb8Kp7oZBer3hhEEFa9PHgl/b8Lod5c5G5yrtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WC5qUcaN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WC5qUcaN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7E891684;
	Wed, 29 Jul 2026 20:22:36 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 451723F763;
	Wed, 29 Jul 2026 20:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785381761; bh=/1yTzYFGg3pV1usAbAUtPbtP+HA7uKNwPQmps+iLHVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WC5qUcaNXp7YRQUQva+KqAzlEwiNFkhj7vRPDnylSaQJ9cC9iMAcGpdkb6rq9cNiF
	 /OjqhnNkYflxnuK1FVgGTmKpcdsMQAvdg00NrAI4KnmgAfYsOjtXjolU8Rma8WQzmS
	 BYW4vmCoGUyIU7evJ61g8aN7ThcGiL3Myb5xUHL4=
Date: Thu, 30 Jul 2026 08:52:37 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [RFC PATCH v2 0/2] KVM: arm64: Add support for BBM level 3
Message-ID: <amrDfR-6q3xAAkTq@a079125.arm.com>
References: <20260723182140.4025575-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723182140.4025575-1-smostafa@google.com>

Hi,

On Thu, Jul 23, 2026 at 06:21:38PM +0000, Mostafa Saleh wrote:
> This patch series adds support for BBM level 3 to KVM pgtable, it
> depends on [1]
> 
> Changes from v1:
> https://lore.kernel.org/all/20260717130901.2239134-1-smostafa@google.com/
> - Limit BBML3 to systems with FWB and DIC and remove race check.
> 
> Motivation
> ==========
> I have been looking into this for the context of:
> - Page table sharing between the host CPU stage-2 and the SMMUv3 for
>   protected KVM.
> - Use the pagtable code to populate SMMUv3 stage-2 shadowed
>   page table [2]
> 
> However, BBM level 3 is still useful for CPU only operations as it
> avoids intermediately breaking translation.
> 
> Design
> ======
> Some of the conditions that BBM level 3 will be useful in (RWHZWS):
> 1) A change to a PTE memory type, shareability, cacheability or OA

Could you please clarify how BBM level 3 is helping this particular scenario ?
This is supposed to be a case where break before make is required.

Thanks,
Linu Cherian.
 
