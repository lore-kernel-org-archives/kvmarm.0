Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794227837;
	b=fP+fvFq75V2837RJcHwKTnNqqeDvx8jhsMdmpjImdUmxxXzVl6lUYjXki/Q/ygQnt/uz
	 nX/vDdfjCZBpjdXOQKoW2tfHIEyJF8jXUKNPwMj20JR/Yc5nD6Hez+txhJ5ZdpNU9zvpN
	 KTOBY+pPVpJSB3qop//1lAGTyIDCdD1gF9OMAE1+pnqZgnWWY9pUdHPIO+My2rNO11u0z
	 RYG9vlJK35eWeQECVq99ByqCBtCip1cyRO+tveYVKDEvcG8+3on6+rQRPWt75H0ewrvJP
	 C19nGsKIOhvqLpp7j5yevD+RXCesigTSAc9GiABfaoBc3gH7Xr90fuvAOVaMDdDs0aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794227837;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=4M2Ug6+sc3RFSzmdaYcK0tVL/sc44GoFVdqmCKfk9+E=;
	b=vG5+jD0eLk1f08TBHg3lKZJnaBP4uuIQFL1sR3UQJI1EPRbS7nIMS11Wu4eMHb41NWjJ
	 z3Xl2OnFxSH3r6ZZFfjZFB1hLarInsWsxy33cMA/0Lg+Fv0civA3wtd/GXyARUaEli9sU
	 3bHrnd0gTpXwDaGYNvapQ7EH1aCbATUsE5QAzADtRst/WDkuKwOIILWjQP4kPIpI8HwFb
	 cYsa9WCiIaq9Q7Bk6R1po9Zda9KWo8a0IrEeJNrN43etGlbnomU1CEj9CXdqDx/z35JgC
	 lynq1uYfSX3zQL1SNwuj76lRfLnqWO11Pr7KMt3C+uf9NBWXVi/0TKkW/8JTMpVDoaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="rDSi/ksB";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CE8606A322
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 12:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3CE8606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rDSi/ksB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E34681576;
	Mon,  9 Nov 2026 04:37:12 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 143713F632;
	Mon,  9 Nov 2026 04:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227835; bh=bbU8vjk3/U/uslDQYyD+xxGnVcFZAPPAtmds4JD+P4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDSi/ksBFxCLASk9AcTB0iEcKrNeruGI3aeDjEnni3Ll2nyX78bS/2RQUsOeLiogC
	 6noVyfuAVurAtfJkSiWzuTr/kuvNwafUx09qib8u4b/a/bB3NU/fJy4Gr79EEGdZBd
	 zd34niL1ZGlio//dyJ34QCEDhf3hjFI6ISrNJReQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v4 1/3] KVM: arm64: Avoid re-testing walk_continue
Date: Mon,  9 Nov 2026 12:37:11 +0000
Message-ID: <avG-dw9Pa_94CxA6@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <1639d961-1092-4a47-8825-55c1647a115b@arm.com>
References: <20261106161240.1345126-1-leo.bras@arm.com> <20261106161240.1345126-2-leo.bras@arm.com> <1639d961-1092-4a47-8825-55c1647a115b@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 06, 2026 at 04:59:05PM +0000, Suzuki K Poulose wrote:
> On 06/11/2026 16:12, Leonardo Bras wrote:
> > __kvm_pgtable_visit() performs a bunch of calls to
> > kvm_pgtable_walk_continue() to find out whether the walk can continue
> > further, and if not, 'goto out', which retests the possibility of
> > continuing the walk before exiting.
> > 
> > Given that it's testing the same ret variable again, there is no reason
> > the result of kvm_pgtable_walk_continue() would have changed since the
> > previous check. So turn this goto into an early return, simplifying the
> > code and paving the way for further rework."
> 
> Looks sensible to me.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> 


Thanks Suzuki!
Leo
