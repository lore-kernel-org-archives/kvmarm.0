Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C643A1D05;
	Wed, 25 Mar 2026 10:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774433947; cv=none; b=RUEsKrl/24EMjiFAqy2vLBrzB/amXTJmEVeqGYDSzLGh2CZlISMQep/nq9dA4+rLq9g4hLE6FmCdThsbGZGo27KVb4RJmIcU8utkmB2KkzfazfbMS2ODK8n4eLO7YC4wN+xhJ/l7Hf96hNfCecI62dZAfjjpGITnya+5t0pm8SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774433947; c=relaxed/simple;
	bh=z7tv9NcJS0qO3APJoE8vhUUNkvrk5Nt5zInLK2D4mxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z/kBk/WncIjMyU0IBz+1JKpuxHs/dCdVtFZT3MdFKfLYoGCdMilVNTgDi8OrpbnIFcOBFv7h/moC0nAPDdXZJe6fWKzWOVuoJBbJISyLRqC7U65RHx0QLJgH7r0maZm8FgGpORXHf63G8k4OtnMNnRFK26RbTjnYqsA7eEJ8lUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hANLq+ze; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hANLq+ze"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDCCB16F2;
	Wed, 25 Mar 2026 03:18:58 -0700 (PDT)
Received: from [10.57.19.213] (unknown [10.57.19.213])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 053C03F836;
	Wed, 25 Mar 2026 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774433944; bh=z7tv9NcJS0qO3APJoE8vhUUNkvrk5Nt5zInLK2D4mxQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hANLq+zeBzW+3wlPHL7ZX55WYoA/35oe2P20QMKE0DqDwN8qkCD34iOnCidV/ru/K
	 iDJdcWPHt+TYLnTqwg22RAFzI4GKNAGHp/qwEJag+ejsQereYzujsOBJkYBawlvnyB
	 F0yaIm3DAJukfM+r+aoPQTlT0zV4Siz/r8dpQviA=
Message-ID: <21441277-b13a-4736-a268-f6e913d71779@arm.com>
Date: Wed, 25 Mar 2026 10:19:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <779079e1-7193-46e9-b18c-9ab5e69bb077@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <779079e1-7193-46e9-b18c-9ab5e69bb077@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin

On 25/03/2026 04:07, Gavin Shan wrote:
> Hi Steven,
> 
> On 3/19/26 1:53 AM, Steven Price wrote:
>>
>> This series is based on v7.0-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
>>
>> Work in progress changes for kvmtool are available from the git
>> repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v11
>>
> 
> Could you please share if we have a working qemu repository on top of this
> (v13) series? The previous qemu repository [1] seems out of dated for long
> time. I heard Jean won't be able to continue his efforts on QEMU part, who
> is going to pick it up in this case.
> 
> [1] https://git.codelinaro.org/linaro/dcap/qemu.git    (branch: cca/latest)

Unfortunately not at the moment. We have moved on to a simpler UABI,
which drops most of the previous configuration steps.

> 
>> Note that the kvmtool code has been tidied up (thanks to Suzuki) and
>> this involves a minor change in flags. The "--restricted_mem" flag is no
>> longer recognised (or necessary).
>>
>> The TF-RMM has not yet merged the RMMv2.0 support, so you will need to
>> use the following branch:
>>
>> https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc
>>
> 
> I'm seeing error to initialize RMM with the suggested RMM branch 
> (topics/rmm-v2.0-poc)
> and the upstream TF-A [1]. It seems the problem is compatible issue in the
> RMM-EL3 interface. RMM requires verion 2.0 while TF-A only supports 0.8. So
> I guess I must be using a wrong TF-A repository. Could you please share 
> which
> TF-A repository you use for testing?

See the other thread with Mathieu.

Kind regards
Suzuki
