Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9572533998
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 13:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787491116; cv=none; b=ra89KXu09zS8oGt/1fLnUQFAoEKfqR3Anm6b9KiQ21SyL+wuv3cOORv9Tn19YjwWaSTzBStl7cipIC15T55/VBorfuk2lR0+61Ven4W09emSlbiH4ZVEbtJ+MLWKiMkV2vOhSffTS3z6MjKBGTBC9IoJnoZV5Jj3jNNiAymG7HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787491116; c=relaxed/simple;
	bh=VtrB+tX93grPnj6d2CSLEWBTBQOnedeDYuFdQkZ60cI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ae7WAnR9RraclWtuX9KvSuBAeHeIpSfH6Afz1s+fxF2927MSWcxMpd10TdoZ1idGCdaHnQBtcFw1eOufB1CzMI7M8NiYmVqLRlNJ2tSIRJspjVGOG3w2rp/DN3lsVD4BD0M2rjT3TqNXa0oTVKhj82eEGqnKWUR5To7QE7Ot3oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=htxiSmdH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="htxiSmdH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E666B175D;
	Sun, 23 Aug 2026 06:18:23 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 288613F763;
	Sun, 23 Aug 2026 06:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787491107; bh=VtrB+tX93grPnj6d2CSLEWBTBQOnedeDYuFdQkZ60cI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=htxiSmdHXY9n2ilLyyinVePwU2QLn+Lzm0KN3K3uSw1BBX5/GbZ/Qp8cSwl4wHpCk
	 6Cpoya7S2PEjOFukTGXB+uZXqyl07LLOOMqkm2Z7RbxGebp+0YvwFYN+MQTGZCrQ9K
	 QqdC7a2k3ct9wFPCiysNZBX74ljLKk0j6oG5Dyuo=
Date: Sun, 23 Aug 2026 14:18:15 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Message-ID: <q3lxbu2palhkejnkvncs2iili6vvkcl7boftn4snf4fjy6fhvg@ehrwmqt6eh3m>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-6-9105afd828ac@kernel.org>
 <vdmz43ogvmwu4liilfqzdrgsf5v765bucl7mybhfdxj7yrywkd@5mssukdegdwg>
 <02b970b2-dbd9-490f-bfc0-be10708e0f9b@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b970b2-dbd9-490f-bfc0-be10708e0f9b@sirena.org.uk>

On Fri, Aug 21, 2026 at 11:19:30PM +0100, Mark Brown wrote:
> On Fri, Aug 21, 2026 at 03:32:58PM +0100, Wei-Lin Chang wrote:
> > On Wed, Aug 12, 2026 at 08:12:05PM +0100, Mark Brown wrote:
> 
> > > +/*
> > > + * A subset of the pseudocode ELFromSPSR(), validity checks are
> > > + * assumed to have been done in code that is not GCS specific.
> > > + */
> > > +static inline int exlock_el_from_spsr(u64 spsr)
> > > +{
> > > +	return FIELD_GET(GENMASK(3, 2), spsr);
> > > +}
> 
> > It feels a bit odd to me to have this function named exlock specific, as
> > it's just spsr_to_el, right?
> 
> As the comment mentions it's not quite that - ELFromSPSR() in the
> pseudocode has rather more going on in it that I'd managed to convince
> myself wasn't relevant in this specific context.  I didn't want to give
> it a name that would cause someone to think it did the full thing and
> trip them up using it in a different context where those things do
> matter.  I do agree that this results in awkward naming.

Right sorry, I missed the pseudocode part. ELFromSPSR pseudocode is
doing more than what its name indicates...

If we want to stick with the pseudocode then what do you think about
el_from_spsr_nocheck/el_from_spsr_raw?

> 
> Please delete unneeded context from mails when replying.  Doing this
> makes it much easier to find your reply in the message, helping ensure
> it won't be missed by people scrolling through the irrelevant quoted
> material.

Ok, thanks for the reminder!

Thanks,
Wei-Lin Chang
