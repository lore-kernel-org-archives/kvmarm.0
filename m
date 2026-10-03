Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC7C2EBBA1;
	Sat,  3 Oct 2026 05:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791006826; cv=none; b=Z85PpifVaMwXhJAEHCnRbOZLb+/2yuAWZpnOEh7AR1r0nyN8Pbg2zvhTLbqlwT0T1EMLJgB5rhqpdpkRMZRAiihZt7+mNIyah4a3sUMLqdxmVtShiy5Xmf9IEYXkLdgz6cQloXIRATCOPqjzmBHdWVmygQFbL/00jfwnSSjT8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791006826; c=relaxed/simple;
	bh=Y/5WUAxYLssgu4Iz+g+/3NBSAG3D07mwZyV0pgPP1qU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DdjUiilC7M7N/3XFXfJVpD228hdKNdddZsTAAWGfI3jSyZxNKsR8kIYjjV9TddRVR7nZCvrdh1NghgnPLy/hpsz/VxYdKf8oi02Jyt2X3AantolsMtM8o6JQYV4TAztzbzHH5xGyG3gY4Y9WxUPK07F/LjPyAEuw244oj1uFrpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l2zLONPo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l2zLONPo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2A862F;
	Fri,  2 Oct 2026 22:53:38 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6D383F85F;
	Fri,  2 Oct 2026 22:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791006822; bh=Y/5WUAxYLssgu4Iz+g+/3NBSAG3D07mwZyV0pgPP1qU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l2zLONPof6gNkcOzAA4NcwT1p7hp3q0YKZisEyAbUksNskY75KsVsFtdpWNBcPDwQ
	 AHC0wncAulPsibkhe2v1hdDo9fSjgHlahQlDCc5zmMcWZUjVZEXP1kf4J9FU/ILqUv
	 sjI866VD2ar0oJ+Vqeolkz9ZrKqc3O76UrB2FEhE=
Message-ID: <83e79119-b331-4640-b2c7-cc8135d71c77@arm.com>
Date: Sat, 3 Oct 2026 06:53:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com>
 <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org>
 <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
 <86pkxs2npx.wl-maz@kernel.org>
 <CA+EHjTy4rb+6z0bqh7sPqACES0EDpURdeoyiFGmdw3p0PENcOQ@mail.gmail.com>
 <86o6dc2ka1.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86o6dc2ka1.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 16:29, Marc Zyngier wrote:
> On Fri, 02 Oct 2026 15:37:00 +0100,
> Fuad Tabba <tabba@google.com> wrote:
>>
>> Hi Marc,
>>
>> On Fri, 02 Oct 2026 15:15:06 +0100, Marc Zyngier <maz@kernel.org> wrote:
>> [...]
>>> Honestly, we introduce the flavor stuff to make it easy to match
>>> things on a particular VM type in a readable way. So why isn't this
>>> reading:
>>>
>>>          if (vcpu->kvm->arch.vm_flavor != VM_PROTECTED_PKVM)
>>>                  return;
>>
>> I know this is a sketch, but just in case: that's inverted. The sync
>> only applies to non-protected pKVM VMs (EL2 ignores it for protected
>> ones), so it would be != VM_PKVM.
> 
> See what I meant about this stuff being completely intractable? I
> still have no idea what it means! ;-)
> 

Just to be clear: unprotected_pkvm() != (vm_flavor != VM_PROTECED_PKVM).
Rather, unprotected_pkvm => (vm_flavor == VM_PKVM).

And the code wanted to bail out early for !unprotected_pkvm(). We can
stick in "is_protected_kvm_enabled()" for unprotected_pkvm predicate

But, I can drop the helper and use the vm_flavor check.

Cheers
Suzuki

> 	M.
> 

