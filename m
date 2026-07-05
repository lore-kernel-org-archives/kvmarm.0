Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38439FCDC
	for <kvmarm@lists.linux.dev>; Sun,  5 Jul 2026 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783279765; cv=none; b=kQWtsBwHrelQXuWxlrFEtjqp6ley2/+iHHkh5XHPRzJ53+gI0nufGlh6rTYtcV+r5xHPQnnOaS22GvQRLloQtQxQeb5cHrHuwzYa3j+JMTnc7UPh8QqjZPTlNcIsEPJWUD9UD3EyqDfIYEt6WmQ4MFCL6CYLbpIjoaN+mM5akOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783279765; c=relaxed/simple;
	bh=IQXpg0yly0rOvZsZNjf4agrD1LCFtN54yec4Ejg1cWw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=PX06YUsz6uYKifd3U8/lGlx0RK+k8QUs9I1YA4QrAc/q5begHfUro+obmCxOryjxGOTBaG0KED1L8EpKo0Ss+8wwNmoU9UWsyoWQ+hRrKPYKAJzk2QPxCqZdvnJFOEbYe5RxXn/2vO24VsHmoIpAKUexqs5WKXURuiD8cRCpCpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=jfSvwrCu; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="jfSvwrCu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1783279762;
	bh=/528zc0E/CxOWpqsrfY5ncWpT3yeI4bPE2VwXrAfvVU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=jfSvwrCu44Kz/MZhLbT65wAwu1+ZSHKvSB7I4xnRD2bF+ZdhgwEsCyt3HvyOzGVl8
	 LnuvhOwU26y1bBzUOYY9UBaocls9B0S4Cs/i8rv0V6ZNgXMSpcIcC6hi9ok+UszOw5
	 AmcvMk2mD4Ku7AvRVZgBLe9/eesL6Yq0pVN3KYuI=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4gtcxZ210rz10yK;
	Sun, 05 Jul 2026 19:29:22 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4gtcxY4HPdz10yF;
	Sun, 05 Jul 2026 19:29:21 +0000 (UTC)
Date: Sun, 05 Jul 2026 20:29:20 +0100
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>, Dev Jain <dev.jain@arm.com>
CC: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=5D_KVM=3A_arm64=3A_Record_whe?=
 =?US-ASCII?Q?ther_pKVM_stage_2_mapping_is_cacheable?=
In-Reply-To: <87echh6xuh.wl-maz@kernel.org>
References: <20260701192428.17430-1-include@grrlz.net> <a3b2423e-d8bc-4713-90ef-5bfac7079834@arm.com> <87echh6xuh.wl-maz@kernel.org>
Message-ID: <8D464B64-27CF-4430-8F7F-9E21B77CE4D3@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 5, 2026 8:27:34 PM GMT+01:00, Marc Zyngier <maz@kernel.org> wrote:
>On Sun, 05 Jul 2026 15:08:58 +0100,
>Dev Jain <dev.jain@arm.com> wrote:
>> 
>> 
>> 
>> On 02/07/26 12:54 am, Bradley Morgan wrote:
>> > pKVM keeps its own mapping list for stage 2 operations. Its flush path
>> > uses that list directly, so it lost the PTE attribute check done by
>the
>> > generic stage 2 walker.
>> > 
>> > Record whether a mapping is cacheable and skip cache maintenance for
>> > mappings that are not cacheable.
>> > 
>> > Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
>> 
>> Is Fixes tag required? If I am reading correctly, Arm ARM says this:
>> 
>> "For VA-based cache maintenance instructions, the instruction operates
>on the
>> caches regardless of the memory type and cacheability attributes marked
>for
>> the memory address in the VMSA translation table entries. This means
>that
>> the effects of the cache maintenance instructions can apply regardless
>of:
>>   Whether the address accessed:
>>     Is Normal memory or Device memory.
>>     Has the Cacheable attribute or the Non-cacheable attribute."
>> 
>> So nothing goes wrong if we do dcache clean for non-cacheable
>> memory.
>
>Two things:
>
>- having to perform CMOs for something that is not *expected* to be
>  cacheable is both pointless and a contradiction of the intent
>
>- what you quote is about the nature of the *mapping*, and not the
>  memory that is being mapped. Cleaning a dirty cache line on an
>  unsuspecting MMIO endpoint is never going to end nicely. Just have a
>  try.
>
>My reading of all this is that a fix indeed is required, and therefore
>a Fixes tag *must* be present.
>
>	M.
>
>


Well, fair enough.

It's kind of two things.

1: A fix
2: a optimization 

I say it's a fix, because it's not fun, no.

And I Also say it's a optimization because wasting cycles isn't a good
idea, trust me.

Thanks!
