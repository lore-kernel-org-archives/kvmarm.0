Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38C14A0908;
	Fri,  2 Oct 2026 13:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790947952; cv=none; b=qSuYSfV4yg3/yNCHfdx5PmGyA7KaK2ld8eSWI2tdcdITCqcYFtTzrEpB/IvtrerLUwSaZs+FUguEsGsVfPcJIHBvwk0GAoTL7mVS4qAcXEsQw3AyylX0m2spNvOTOBXJKVEOQJ2cnn4oABTYA/2w9UMNdGKhVoseQ93o1PC8Eno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790947952; c=relaxed/simple;
	bh=QHruVCMoFYTNklV6Hc6Pj2xtU7OQpN+0VZLqbsT7pgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RD5DQPG5Ynga61jxDkDxPV0PY3IEH8w9SW7jKGe/xVQ9QJs8uXcD+nRaRvmH5O1cwHA83QxMd1yEBCGPqu9rwW6YKyLEFW7BRQPgf2qtFWcqbvWEY6zd6n5jIIA51CvSzgA5q+mw8fwsNDYXGWQRQa1jTI8NCTN7JlbFYxJSoUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwG7mW8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwG7mW8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A81F000FF;
	Fri,  2 Oct 2026 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790947951;
	bh=5CS+1WddC9LU2dBRnyvoTVR6p6QDTIjDWTeJO+ovyZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GwG7mW8qhr86CaqjYE/Yd2RsfCqwMsCXI1iDGRoNkU4pgH6lUy+JL0qRaqhYUBG6E
	 zl1APCpFBz4sEk0HnkVUwCVe1/xIrU7ttHBmyJ6P4B5SorjsGlEFBNe6193ibDRnnU
	 j6nUHNrUC3NQCJS5fFiDDEyjyP1heho25GZBHmlyAjzJdeJI4iVbh3WP8e6mdRDH6B
	 fmktOK6KbL/vwdzmLlp7dkWpn6MeJ3Y/7RcoE0Ft3eTFc5jaCl8r8P/Fm80rO41m1U
	 Su3Pmj/VsRAGHjDwyCaduNE0dHjvSg5nTjpt2K3texfLOytpg0mSoBamivZMOo+b8Y
	 FVGaLt7RCr3VQ==
Date: Fri, 2 Oct 2026 14:32:25 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, will@kernel.org,
	catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	jonathan.cameron@oss.qualcomm.com,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v22 07/10] kernel: hibernate: Add an arch hook for
 preventing hiberation
Message-ID: <20261002-sloppy-tremendous-guan-30cbe5@sudeepholla>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-8-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002061507.1600269-8-suzuki.poulose@arm.com>

On Fri, Oct 02, 2026 at 07:15:03AM +0100, Suzuki K Poulose wrote:
> Add a hook to allow arch code disable hibernation. On arm64, with an RMM active,
> there could be pages that are delegated to the "Realm" security state. Any
> access to them are fatal (e.g., hibernate save image or restoring an image to
> a delegated page). pKVM host also has its restrictions on enabling hibernation.
> 
> Add a weak arch hook to let the architectures have a say.
> 
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Machek <pavel@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Cc: Sudeep Holla <sudeep.holla@kernel.org>

FWIW, it makes sense for this RMM use case:

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

-- 
Regards,
Sudeep
