Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A6C30ACEE
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.167.222.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782139768; cv=none; b=Z7YTp9nbxwlnhvI5aMOgPkOFROrnti8hNsBewW1gD1B0gu5YdS3gI+sK2uHrvcuuORtLwZWA/UaTkeCuNsFYMQINpoALtJ6QUAoRRHXnSaiucSsuvgLeTlGP/5o2shkG4C6DdQG6DQAQKu6mb3qtNHFL5kV7cqny3eDsIJqTUIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782139768; c=relaxed/simple;
	bh=kiFn/Z6U/Co86VDJWDFxrcvGA+BqjKXbBLscXt1dY8U=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=b+fr3hIBtcJ1motg3JL1vrmyyVSgrToqHCgonIyh+fGynUd9EYmOnzhlePQ9u/5m3xLBVhEtxjjrr2SDoFUzpUzpmsDFCu6C3B+0yTH0qe25HjvMPY4REhFF4tNuAEdsQxUN+zBIhp2Jcn1JTSmhYALClTjTpqSxoWnXntXubbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=UCugRXiA; arc=none smtp.client-ip=198.167.222.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="UCugRXiA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782139762;
	bh=L1zc6fACDY3A5wvHcbvKcOrTOihcoi6Hpp6cktnrlbI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=UCugRXiAHVZcaACZntQUfgXH2WAXOAXe+P+PJZHJBy74IX7aqqX6IDQxE0jFPEyiO
	 b7vyQbeLgyIbYlgr/ZrWOgWB8tWlrNqjG+X0/Ld3BhQztuUs03jj8+c186wSOow5Ii
	 yw5UcNuD4pWDghs2CxYgd3rVJ+hFbinZ/RKliE3Q=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4gkWLV4MCsz6vKF;
	Mon, 22 Jun 2026 14:49:22 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4gkWLV1J44z4y2q;
	Mon, 22 Jun 2026 14:49:22 +0000 (UTC)
Date: Mon, 22 Jun 2026 15:49:23 +0100
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
CC: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
In-Reply-To: <86y0g7q6jh.wl-maz@kernel.org>
References: <20260621213155.6019-1-include@grrlz.net> <CA+EHjTztL4O6NH-sNpPywchgER6SswetOCgmaaSGjtKaRtL8XA@mail.gmail.com> <86y0g7q6jh.wl-maz@kernel.org>
Message-ID: <9826F145-3592-4769-A200-3BE8102A6D3A@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On June 22, 2026 10:16:18 AM GMT+01:00, Marc Zyngier <maz@kernel.org>
wrote:
>On Mon, 22 Jun 2026 09:32:45 +0100,
>Fuad Tabba <fuad.tabba@linux.dev> wrote:
>> 
>> On Sun, 21 Jun 2026 at 22:32, Bradley Morgan <include@grrlz.net> wrote:
>> >
>> > Protected guest faults charge long term pins to the VM's mm. Teardown
>> > can run later from file release, where current->mm may be unrelated.
>> >
>> > Drop the charge from kvm->mm instead.
>> >
>> > Fixes: 4e6e03f9eadd ("KVM: arm64: Hook up reclaim hypercall to
>pkvm_pgtable_stage2_destroy()")
>> > Signed-off-by: Bradley Morgan <include@grrlz.net>
>> 
>> Reproduced by creating a protected VM, running the vCPU to fault in a
>> page, then forking and having the child close the last fd reference.
>> Without the fix, the parent's VmLck leaks (the reclaim decrements the
>> child's mm, which is freed on exit). With the fix the parent's VmLck
>> returns to zero.
>> 
>> One minor observation: account_locked_vm() also passes `current` as
>> the task pointer to __account_locked_vm(), but on the decrement path
>> that is only used in the pr_debug log line, so it is technically wrong
>> but functionally harmless.

I agree with marc here. Maybe awkward.


I tested it on my pixel 7! :)

>I don't think this is wrong. Awkward, maybe. It is just that the
>rlimit check and the accounting may be different contexts, and the
>pr_debug() call covers both inc and dec.
>
>>
>> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
>> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Thanks for the review! :)

Cheers!

>Thanks,
>
>	M.
>
>
