Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8665C4734FA;
	Thu,  1 Oct 2026 16:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872667; cv=none; b=YEHQWrpk74XD3ELWUQA99IGbKvuTvezmQMVi1TCSQ1fRr+i4NlD20agQ4Bz0x9Ag3vSN6BX9QoBQxCUNCmobdLXp/3/zKf5SQm3+1DS/dY11KZX9dlAP0X1Fzvthcil5rs4p+/BESxt+4aQ4tk0tXG8/Tv140Cb1zYvg0rDcjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872667; c=relaxed/simple;
	bh=K9BrYtciJGkSxMEbrXtvHk2FbFP0IJ/JnLlba9Tczjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dEJbNnqeo/Jrv9hFQyn9Y912VY1kpr43bp7YU4Oa9RFdPg/9gdpE2VFTHK4jxYF2/uAxK6BlyJaEbG6CsPDDFNmdWq0vCDa8L6//gxXv83J7tKD2KZ3mvQD8rHQuO47C+5NhcJgUTOpLdYJ8dL58NOxgu+E/Qh+EK7FGuRw83O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BsV62LOq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BsV62LOq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A8D7497;
	Thu,  1 Oct 2026 09:37:41 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8C683F85F;
	Thu,  1 Oct 2026 09:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790872664; bh=K9BrYtciJGkSxMEbrXtvHk2FbFP0IJ/JnLlba9Tczjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BsV62LOqI5ja68sCQcFyb5ijD1CAgATdMGzmBFi4PPZQ2Nl1po/USPeOyjARfB1hR
	 4IW2nKeALWQxil1hxMsJbWCTmjfJWwrfaJRQWTlMxqg8rSgve5w/QmYdvcMHIJ7CR0
	 apDR+U8DfZ9vBePkOCIe3Wvt8ZYFIpX+pUeF5fiY=
Message-ID: <c8ea1847-0a92-46b2-a038-37a9d581e8b2@arm.com>
Date: Thu, 1 Oct 2026 17:37:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 22/22] KVM: arm64: CCA: Control user register access
 for Realms
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
 <20260924160504.853911-23-suzuki.poulose@arm.com> <ar6CEXfo-AIYtq1J@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ar6CEXfo-AIYtq1J@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/10/2026 16:53, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 05:05:04PM +0100, Suzuki K Poulose wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> The RMM restricts the access to the register states that the host can
>> read/modify for a given Realm.
>>
>> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>>        While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>>        requests.
>>        MMIO emulation in the unprotected space.
>>
>> Additionally we use the sysreg configuration to advertise/configure the
>> following Realm parameters, which are required before the Realm Descriptor
>> :w
> 
> Should use Emacs ;)
> 

Dang it ;-) I have fixed it in v21. Thanks

Cheers
Suzuki

