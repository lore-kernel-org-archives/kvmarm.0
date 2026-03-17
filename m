Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5695372B2B
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773751910; cv=none; b=ICZutBnwBj7XMQWLwzAFlHTx64gyi8cGNYL10SupuUcF/ZYiHi2OwSRiBQIlmNwpiMJhrhv39tjKy8jDksbbfZogZxOYy+xoieShxn9yDmx+doDGOpNbSmDdKtFUpdYFSrf9jkr+q0CJDrIR8MQmebA9IriHOdjt3Rbln6lERuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773751910; c=relaxed/simple;
	bh=YC46SfyxmxtHFqibcYbffXHjn36o3MLsszUe0gKYg/M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=TdB6iTfURppGaeuM+9anuMk7Ggh/+T0eyEBj66kl5+YSjtmVcnzr8NHfBz5/x9bQu/SeDZiUK4uLgAlP0rcj9Ctd6ImFjhKqrXgUPt5jU0nuvp3szUQQnAioZLgZyvdj2qRSpQ4RRtoTyug5urbBK4uF6GtNjtjXYb2ErLM10/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bj7vqRDD; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bj7vqRDD"
Message-ID: <d58819b9-c745-4551-8ea4-e15af3fe63be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773751907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ui7M1dZyJrqdJcmITvPOBmOk3VnZnVkNJuxoUwKYgI=;
	b=Bj7vqRDD3prMtzIC2aY5I04juux1TKvUnp8JYe4Fcls9vzYW7zthzKFb94FzKi/aFzR3f6
	ymS5DxQa7lDZfSDkkyhBdygiWfJTNL0L8sFAPSjnqaUeRalsFlk0GlftHCmzMT+k6HSsQM
	FxtOOqWMeEh8r11j3z4iuFwa2laazvE=
Date: Tue, 17 Mar 2026 20:51:34 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/15] KVM: arm64: selftests: Add test for AT emulation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251124190158.177318-1-oupton@kernel.org>
 <20251124190158.177318-16-oupton@kernel.org>
 <b951dcfb-0ad1-4d7b-b6ce-d54b272dd9be@linux.dev>
Content-Language: en-US
In-Reply-To: <b951dcfb-0ad1-4d7b-b6ce-d54b272dd9be@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2/28/26 5:43 PM, Zenghui Yu wrote:
> Hi Oliver,
> 
> On 11/25/25 3:01 AM, Oliver Upton wrote:
> > +static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
> > +{
> > +	switch (uc->args[1]) {
> > +	case CLEAR_ACCESS_FLAG:
> > +		/*
> > +		 * Delete + reinstall the memslot to invalidate stage-2
> > +		 * mappings of the stage-1 page tables, forcing KVM to
> > +		 * use the 'slow' AT emulation path.
> 
> Once the guest continues executing instructions, we would get a stage 2
> translation fault (on a S1 PTW) immediately and re-build the stage 2
> mappings for the S1 page tables. Depends on how much we have re-built
> for S1 page tables, the "forcing KVM to use the 'slow' AT emulation
> path" may not always be true.
> 
> I tested it in a QEMU guest (with "-machine virt,virtualization=on \
> -cpu max -accel tcg", so it's essentially a NV2 capable HW!) and it
> failed at the first test_at_insn(S1E2R, expect_fault):
> 
> [root@localhost arm64]# getconf PAGESIZE
> 65536
> [root@localhost arm64]# ./at
> Random seed: 0x6b8b4567
> __vm_create: mode='PA-bits:40,  VA-bits:48,  4K pages' type='0', pages='672'
> ==== Test Assertion Failure ====
>   arm64/at.c:58: (expect_fault) == fault
>   pid=824 tid=824 errno=4 - Interrupted system call
>      1	0x0000000000402d8f: run_test at at.c:137
>      2	0x00000000004020e3: main at at.c:162
>      3	0x0000ffffb07daf3b: ?? ??:0
>      4	0x0000ffffb07db007: ?? ??:0
>      5	0x000000000040222f: _start at ??:?
>   AT S1E2R: expected fault (par: ff00000080000b80)1
> 
> because in my test, the S1 page tables used to translate TEST_ADDR are
> located at
> 
> 	level 0: 0x180000
> 	level 1: 0x181000
> 	level 2: 0x187000
> 	level 3: 0x188000
> 
> All of them had already been re-mapped in stage 2 [*] (in the same 64KB
> physical page) before KVM started to emulate AT S1E2R. The AT_S1E1R
> (fast path) will successfully get the translation result and it's IMP
> DEF that whether an access flag fault will be triggered (QEMU chooses to
> not fault).

Fix myself up: an access flag fault should be taken in this case (with
AF bit is 0 and HA is not enabled). I've just sent a fix to QEMU for
that [*].

Given that we can't force the slow emulation path, we should still avoid
testing the IMP DEF behavior (i.e., TEST_ACCESS_FLAG). I will send a
patch to remove it.

[*] https://lore.kernel.org/r/20260317122517.47627-1-zenghui.yu@linux.dev

Thanks,
Zenghui
