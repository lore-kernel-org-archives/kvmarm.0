Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039325F99F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.167.222.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227479; cv=none; b=fqJ1qQEaYr2+waRT7n0zNO97zIfrbW8/SE2WxtF7mifg8ZAcj8vdN5jIm5x9qVlqcXZ6QDMGpTnPaueFV7/GBLEXZ/OdeKfrrrCUbDCfA0gq8CMMLZMzJ/puYNB+gOUCYbj7RH+fvuYS9OYSyyXZ6edghbdjOrYtr+hRhrGUOMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227479; c=relaxed/simple;
	bh=G5cPsnETvCj14DcFYSwq1OMuUzQ2VsZ8aM4u4muRn3o=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=sOMl3at3oOD9pWlF5NQWU7E/xmBD4GM8IGGt1p80RzYi1L7WRE1UGZ6qdCSRnQBleQthneFYkTPVP7X90sSvhJ2NlhHy/3gcq7iLpaPoh+WfKuuG/UcaK7rlQbrUD+6nLEoGRU2Y8kP2d7QvJuRrOsm1rMNPrYmP4LeJzpDL2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=S0p0bHhF; arc=none smtp.client-ip=198.167.222.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="S0p0bHhF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782227468;
	bh=mKKmQLguZ8CX+dAbSlBru+T3jTbu7nsx2GjEfP1Duls=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=S0p0bHhFU5PcCzVHSc3ZdIrK14xvaTPGQPAkRN5N0ilzKgf/xIlAPClRGx3ehSdKt
	 jTTCSLBISlj5wpRUMXwo4Q+NF5sAkYpbC76bNb3KwnttYG1jSG4o/3JwC0OnvxhWuf
	 f2zd4j9cpsGdw8Xfy0h2DhziJhssdSS8ZHxhMn/8=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4gl7n85KxJz6vC6;
	Tue, 23 Jun 2026 15:11:08 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4gl7n820wGz4y2q;
	Tue, 23 Jun 2026 15:11:08 +0000 (UTC)
Date: Tue, 23 Jun 2026 16:11:07 +0100
From: Bradley Morgan <include@grrlz.net>
To: Fuad Tabba <fuad.tabba@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
In-Reply-To: <CA+EHjTz+oNerTD3Ygj3EzOA4zm4BKfQYM45ydwVO=2amErkBAQ@mail.gmail.com>
References: <20260621213155.6019-1-include@grrlz.net> <178222278590.523236.18181071715501850418.b4-ty@kernel.org> <CE64C9AC-32D5-495E-B713-552921468FB9@grrlz.net> <CA+EHjTz+oNerTD3Ygj3EzOA4zm4BKfQYM45ydwVO=2amErkBAQ@mail.gmail.com>
Message-ID: <54A2BB77-5E81-4730-82A1-DB457118784C@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On June 23, 2026 4:03:30 PM GMT+01:00, Fuad Tabba <fuad.tabba@linux.dev>
wrote:
>On Tue, 23 Jun 2026 at 16:01, Bradley Morgan <include@grrlz.net> wrote:
>>
>> On June 23, 2026 2:53:11 PM GMT+01:00, Marc Zyngier <maz@kernel.org>
>wrote:
>> >On Sun, 21 Jun 2026 21:31:55 +0000, Bradley Morgan wrote:
>> >> Protected guest faults charge long term pins to the VM's mm. Teardown
>> >> can run later from file release, where current->mm may be unrelated.
>> >>
>> >> Drop the charge from kvm->mm instead.
>> >>
>> >>
>> >
>> >Applied to fixes, thanks!
>> >
>> >[1/1] KVM: arm64: account pKVM reclaim against the VM mm
>> >      commit: d098bb75d14fde2f12155f1a95ec0168160867ce
>> >
>> >Cheers,
>> >
>> >       M.
>> >
>>
>>
>> Hey, which tree did you apply it to?
>
>https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?h=fixes
>
>/fuad
>
>>
>>
>> Thanks!
>

Thanks fuad.

May I ask if this would be put onto ACK?

Since this affects pixel devices.

(E.g, my pixel 7....)

Thanks!
