Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989EE1F94C
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 09:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741339609; cv=none; b=SCKCkQw4HeKI90rB5oq5l4iF0iZME6QVY2yHMenl0YrSRMVWd158SxUOw2y2SYry3lKf9IT+Kzv+hcuLoof9fXaN68Fnn7xagzBnDLxf0mvG/PU2ebQ4hgrBOxTKNu71E21+g+rYYuAXKdIRkXGwbiKuB7tfwZAXkeolTXpQBeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741339609; c=relaxed/simple;
	bh=YihU/VGmbdMazouW8EV29bRZyDiZkUASt2I6B/jPrvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MpLs+eEpTc68nU6XUuJj9kcVQ1lp18R/NiSU8QbTjHV7lin+JMyA5e299685fCqbC0pVswoTK7C7gp4ypXpMvuHDV7Uw8UJUXQZLgUGHq0l0sIh6KlSKPwoH0yOHUwde9LgamDv3IVxuDfkB03ur08M4tqfHtNeHrsFFH9Dmm5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L1pNZwiN; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L1pNZwiN"
Date: Fri, 7 Mar 2025 10:26:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741339603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dNUnJWlbS9rgqW3yQ0YrZ/sda6IpS12WvuMsHptUbjo=;
	b=L1pNZwiNqG9sxeIxMb8nLkh97efLnuz4rqqERIeDxqHx2DgCof5pH8SO6P8FcfE91i40Gb
	cnCf6Gygtos3X1sUCZccMq3KRsyL67Rz6q3aaDqIQyq68QU+UgcldA6ZwcIaO1C6P59wPZ
	pcn0kk8fzDJugnmsUOXkUYKqb+nFc2A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v4] arm64: Add basic MTE test
Message-ID: <20250307-075ecf870874c4c7e620809f@orel>
References: <20250227152240.118721-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227152240.118721-1-vladimir.murzin@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 03:22:40PM +0000, Vladimir Murzin wrote:
> Test tag storage access and tag mismatch for different MTE modes.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/Makefile.arm64            |   8 +
>  arm/cstart64.S                |   4 +-
>  arm/mte.c                     | 313 ++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg             |  19 +++
>  lib/arm64/asm/mmu.h           |   1 +
>  lib/arm64/asm/pgtable-hwdef.h |   3 +
>  lib/arm64/asm/sysreg.h        |  14 ++
>  7 files changed, 361 insertions(+), 1 deletion(-)
>  create mode 100644 arm/mte.c
>

I fixed up the inline assembly constraints and removed some superfluous
blank lines and applied to arm/queue

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew
