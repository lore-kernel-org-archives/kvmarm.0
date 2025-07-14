Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BFA243964
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 09:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752487109; cv=none; b=SitEUB/HrFyvYZSPBU3Pd31LUuFoUmFTahbqCQQMQh8q2gTB73UlQM5eQ/Wc4k0uzaXcN6D2lM5T3zob+lPUizUsTwjTMa+zpVjMbuiLFs96kf9BWenJPAauNzbAChOFOoh+zbwDKC/T3PwS7aXGIRCgQn/OfZlXOsbRrt75+kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752487109; c=relaxed/simple;
	bh=6QNF2IYiYqPBBrAD5MOXPmWbh+lwfMKKPRRBenmPnKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lg+NR4X4o61PfdWHtraBWwOIzxrwW6Aw+dJ23SGUVFxCiY76CpVat1gAQ+WDkc/3ici+oV6+rUnehJpNxkJtPAsH3ZwhqRrGtr4iQx/H7teUHyg3CNctJG9wPEooH4BKVJm+EjcLs56/FoaqFlv9uOo15vUZkaIk4bS/GSBVAKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ums9ayJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ums9ayJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E74C4CEED;
	Mon, 14 Jul 2025 09:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752487109;
	bh=6QNF2IYiYqPBBrAD5MOXPmWbh+lwfMKKPRRBenmPnKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ums9ayJN5n832EVbsV69MWCMFHIkAtW87SJM8xhoU99WdXpmOoi01pg9sXFG35BQS
	 aemOss8YmGLTKcVZME8JuPe0FdkYnSVBD1HdZecjl2w2e7vKAKutLFr3E7F3bicd5+
	 9avX8BMP5vaoKP+RN35dD7u12iVolLIZDw4tpncBqTA7E/v7xxgFzTq7yaqVan8JTP
	 aiU4E6arkoWr1hRxCAVVg+HPdswYptXzXyA6cSqLZZDPSSszrgttAO5Y1iHpF4pQHQ
	 UN7wUd2CHCpbhrA9HFwRNP9EDFwfGeKyhjzoB2IzipZUDUkeBEAUBDNmPkrtlaguFS
	 Jjw/Am5jCSaZA==
Date: Mon, 14 Jul 2025 10:58:23 +0100
From: Will Deacon <will@kernel.org>
To: DaeRo Lee <skseofh@gmail.com>
Cc: alexandru.elisei@arm.com, james.morse@arm.com, kernel-team@android.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	sebastianene@google.com, sudeep.holla@arm.com,
	suzuki.poulose@arm.com, tabba@google.com
Subject: Re: [PATCH v3 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the
 host
Message-ID: <aHTUv5kOE4z8tlEK@willie-the-truck>
References: <aHQQiJr2xLe9KotP@willie-the-truck>
 <20250714021400.631762-1-skseofh@naver.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714021400.631762-1-skseofh@naver.com>

On Mon, Jul 14, 2025 at 11:14:00AM +0900, DaeRo Lee wrote:
> Is it pKVM's policy to not manage Non-secure memory using FF-A, while the FF-A
> specification supports memory management between Host/Guest within Non-secure
> hypervisors?
> 
> Then, how does someone lend memory to a Guest from the Host/Guest via FF-A? Can
> pKVM prevent this? Or should Host/Guest developers use it with caution?


Perhaps you could read the code and find out.

Will
