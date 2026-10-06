Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1453BE174;
	Tue,  6 Oct 2026 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791283030; cv=none; b=TpFS00NGg4r7jUx7p3I9pjePPp8DNyYlvWxIpgdEA31V6UnEFAD0jtc53LtE15ohhuu1aOMUAEX5zZgxbueP773SdH6iwbv9xGhnSNgU/GvP4o/JYGdbUuoJIwScXCI75mWzwKf+u1wTR6BIMPtgF1TmWVlUs7sRTIkYivAi/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791283030; c=relaxed/simple;
	bh=7jQqKnJQRfynsLC1aLrSuAZ0vQikfppkGJpYclmeve0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2awDK+oUEUdHtpX8xKxriZeSFv462GjXNbn7WbvxeJhrndABjFx0qXJZUiDBVO0HfJVsQ7zB/VcOp3NiZEZl5oupiIfps1LYAWLcgPaZOySA3+Gyd3n01ZzE9Zbzn2Nzg8Xq9PMY/v1dS87hgYV/+U/qqAiot/BHuMzoj7ilVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xz9tE7q5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xz9tE7q5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C230A1477;
	Tue,  6 Oct 2026 03:37:02 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DE943F86F;
	Tue,  6 Oct 2026 03:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791283026; bh=7jQqKnJQRfynsLC1aLrSuAZ0vQikfppkGJpYclmeve0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xz9tE7q5AFb2q7YDljNnLJhAaMfmi7qbHlKxdcj2W2QWIC3a1xdwr/frfvgrqAfhj
	 yUkgGEXCKFTTVhnDSEJ041O6z+ZilugTOb/LapASebPgbTEvEE/5XpAtbx+fJ+J0BB
	 D3KxfHP0S+TOvDAbmomOdsNdUmD8SvCT8+EKLsDo=
Message-ID: <089e57c8-93ee-4384-a6d6-978bde917650@arm.com>
Date: Tue, 6 Oct 2026 12:36:59 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 11/23] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-12-suzuki.poulose@arm.com>
 <87a4or2nd5.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <87a4or2nd5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/10/2026 10:24, Marc Zyngier wrote:
> On Mon, 05 Oct 2026 10:07:42 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> Add VM type specific S2 MMU operation backends which can be initialized per
>> VM flavor, to keep the handling cleaner.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Change since v21:
>>   - Define all vm_s2_ops call back. All calls are mandatory.
>>   - Define callback for each flavor, disjointing the non-protetcted pKVM and
>>     normal KVM (VHE & nVHE) and remove the KVM_PGT_FN() hacks.
> 
> It is a bit annoying that we still have part of the operations being
> indirected by kvm_vm_s2_ops, and others by KVM_PGT_FN(), which is
> still there. I was hoping that we'd have only one indirection. after
> this patch.

I agree and I did think about it. The issue is, some of these calls are
deep burried from the higher leve dispatcher callbacks (e.g.,
user_mem_abort->kvm_pgtable_stage2_map). We could go all in and remove
all of them if you are happy with that change. Also, some of the call
paths aren't valid for certain VM types, that adds quite a lot of dummy
callbacks (now that they all are mandatory. e.g., pVM or Realms).


Cheers
Suzuki

> 
> 	M.
> 

