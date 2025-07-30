Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECDD22068F
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 21:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753911630; cv=none; b=bdY5N8ZLKfuBB9t9x7KdeiGJPgsdAuwRYSdVr+fsAc7EKvV++qpqxDK0NVcrdGo8bszfXfR2ffQreG+8v9Bmev/SlSnircyVJ5ivk13rBgWdZRtekevrnQvaKeYpKFrtolZantVv4TnTHEX0oa/w582bO+Vcqb8b1NLuQ/fMKKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753911630; c=relaxed/simple;
	bh=EqNTguNzzyHbty71kWmNAoeehUysv/QpSqDH0n/jKZQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Q604pyy2XmfJspqQFhit5pBC2uc1aqxjOxluD6VOP4GNOxAhuW5oH5MOPYMHcFwJopbs8vsnz1d8RgqLuOUCUYjBw0ImqcUHQAcSbuuKZ6DmrprPIf00t6/fuyP3AM83f6yikLtXj7eVYNHpsSsJkq8D0Y+v3kWtbBY9uC82bqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T1X1luLh; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T1X1luLh"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753911625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwoUYLD79wmrTWozxSEkOrFeJeo57/yFz1Jai3d4Dqc=;
	b=T1X1luLheWKT/5Ie/RgvKDsGGc7yn/AWQVBgOwjhxowODYHuOJ1gO45ZHXYnMfUSJyToAf
	NFDePW9hREL47eH3/SAFXE6WG3LJvIxJD0tlzW0ulnQLJ9UCHIUgYUGtOrdG2GDc71+XQj
	y8aVPumm8iollypu9X512JtgiEXiUbI=
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: KVM selftest for L2 guest execution fails  
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
In-Reply-To: <861ppx9893.wl-maz@kernel.org>
Date: Thu, 31 Jul 2025 06:40:05 +0900
Cc: kvmarm@lists.linux.dev
Content-Transfer-Encoding: 7bit
Message-Id: <62C3AF76-E7B5-491E-AD1C-A8F9BF8C153F@linux.dev>
References: <C37BCE4D-0958-4C74-BEFC-F3A7A689A848@linux.dev>
 <861ppx9893.wl-maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi Marc,

> On Jul 30, 2025, at 21:24, Marc Zyngier <maz@kernel.org> wrote:
> 
> On Wed, 30 Jul 2025 07:44:48 +0100,
> Itaru Kitayama <itaru.kitayama@linux.dev> wrote:
>> 
>> Hi,
>> My small kvm sefltest tested on the kvmarm/next with NV2+VHE on FVP fails:
>> 
>> # ./arm64/test5
>> Random seed: 0x6b8b4567
>> ==== Test Assertion Failure ====
>>  lib/kvm_util.c:1746: !ret
>>  pid=257 tid=257 errno=11 - Resource temporarily unavailable
>> sh: line 1: addr2line: command not found
>>  KVM_RUN failed, rc: -1 errno: 11 (Resource temporarily unavailable)
>> 
>> Below is the test code, am I doing still wrong?
> 
> Quite a lot is wrong there.
> 
>> 
>> Thanks,
>> Itaru.
>> 
>> // SPDX-License-Identifier: GPL-2.0-only
>> 
>> #include "test_util.h"
>> #include "kvm_util.h"
>> #include "processor.h"
>> #include "ucall.h"
>> 
>> #define GUEST_SYNC_VAL 0x1234
>> #define UCALL_GPA 0x500000
>> 
>> static void l1_guest_code(void)
>> {
>>        /*
>>        * Set up HCR_EL2 to enable virtualization and nested support:
>>        *   - HCR_EL2.VM  = 1 (enable stage-2 translation)
>>        *   - HCR_EL2.NV  = 1 (trap to EL2 on guest HVC, SMC, WFI, etc.)
>>        *   - HCR_EL2.TGE = 1 (trap general exceptions in EL1 to EL2)
> 
> You really want to read the spec again -- this is not what this means.
> 
>>        */
>>       uint64_t hcr = (1UL << 0)   |  // VM
>>                      (1UL << 27)  |  // TGE
>>                      (1UL << 31);    // NV
> 
> - You enable S2 translation, and yet don't setup anything related to it
> 
> - You have TGE set, and yet (try to) return to EL1
> 
> - You set NV, and yet don't have a VNCR_EL2 populated
> 
> I don't know what you are trying to do here, but this is pretty badly
> thought out.
> 
> I'd suggest you start by having a simple L2, without making use of NV
> at all in the guest. You will still have to have a stage-2 and a
> correct HCR_EL2 configuration -- none of which is as trivial as this
> test suggests.
> 
> Once that is actually working, you can go wild and enable NV. But not
> before.

Thanks for your comments. Will follow your suggestions.

Itaru. 

> 
> M.
> 
> -- 
> Without deviation from the norm, progress is not possible.


