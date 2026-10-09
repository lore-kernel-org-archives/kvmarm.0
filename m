Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20C53AD51F;
	Fri,  9 Oct 2026 07:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791532455; cv=none; b=scPEy/a/JcCbzwP6mzLuyhoee4i6k1Lbt1sRtPQtwe7jmEmnDqt+2UggSwffC1zycGAzZXM3+Ud3H1Oj6RQl7TGhPuyppHLumukAqP8K54LIlXo+MOcFLcqv9GN8fCzpVjyUuAJyi393Nyq7OK1q/J1ZTuN1Y3e1nQTjNE9U6BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791532455; c=relaxed/simple;
	bh=tE3GOa1bzQYmLci/uinKcz9hq53UUxXOStqlM98g8ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4GMEh5BaYP9Ds1QxQxn18myhkisVflXhGPwgMV31FMuEEXLUSLmkf9iLo3JihEK8jOf5P7l0su6CnZ8kdmNyoNL5FH85zyzkjeg76xNk8nPvHw9vBJ1Li7/K0rewpWbafqiHfaXBLkHLTPvyTvx2kUe3Tk0r6QxjKw8L8C7Po4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+h+Soyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+h+Soyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9EC1F000FF;
	Fri,  9 Oct 2026 07:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791532452;
	bh=tE3GOa1bzQYmLci/uinKcz9hq53UUxXOStqlM98g8ME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g+h+Soyw+HgmIxzntY/594uEIbgmuEFV+tmD9csdsQad1z9b+YaY02BZdfcFsD9f+
	 KMGpoqtSVXb1PWsSLXbQZCmMXVZwDIjjYn1cYV20oP5OPcVTj3PNShJx52ZIJoYtpb
	 VXzQJtlcNKbztVX9eqP4mZUKpkbUvtc0HdsiOOhGydOAMG6H8YzKvx7klVFpMvxMWW
	 cqHmWY58o+Leznpc1Nj5REb1fQSL1DmRh0nupH55y+hBOMOZwgYeA9DOp2l507ll0j
	 GI1Anx3LJiStqxZryfZ4EZqad42vufbRnmuA4vziyjvdi839Cz/vCwUlnABGd6BM82
	 SRNivJ/yhaiyw==
Date: Fri, 9 Oct 2026 08:54:07 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 0/5] Fix diagnostics and capability probes for
 protected VMs
Message-ID: <asidn0tpusz-MZRp@willie-the-truck>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <CA+EHjTwBXEVp_fJp+SvXqrfab2NGdnCXy6L9n=aW2yeTUUOniQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwBXEVp_fJp+SvXqrfab2NGdnCXy6L9n=aW2yeTUUOniQ@mail.gmail.com>

On Fri, Oct 09, 2026 at 08:10:55AM +0100, Fuad Tabba wrote:
> Gentle ping on this series. Marc has merged the pKVM core series into
> kvmarm/next, including the KVM_GET_ONE_REG -EPERM that patch 1
> handles, and all five patches have Suzuki's Reviewed-by.

I usually wait for the patches to land in Linus' tree before I update
kvmtool (although I may be fishing when that happens).

Will
