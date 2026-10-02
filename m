Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B42497B7C;
	Fri,  2 Oct 2026 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946644; cv=none; b=py7xkSMXyOhuryA3tscZLrHfAM4WUGGBN8y9bqrqmF0R90XKL2ph4TbI+BSR0cnlBwc0Re9zCuL2p1pp2NojaWZPBWixGIOvH+Tr56VyYsGouwg4KWafdMlbAR/KnU/PU1Gu03vzMEPXFL+i/VVY9v5n/MSTIU3QHlBhPMTDMqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946644; c=relaxed/simple;
	bh=O9qAXfSNd9NNc6BfSIg0k7Umhi4nsbNeqt5uiHuVnJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XwRNtAHL61Ex3fVRbJD3OPewxBLBh/Y+1cikVKj7BS6lSUn5iW7KtGV70Yfm0/xm671jBLZfoxSkOFdNJfNOTiSS2LXuR7bui8+P/ClteEEM1kwMOiA6GIh9cpSiOLfAK1b/wA/cgKX3ieb/IPWeFYSPReux4bpPXlQaoIY2ys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TvUKc/n0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TvUKc/n0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52DC2497;
	Fri,  2 Oct 2026 06:10:32 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A46133F85F;
	Fri,  2 Oct 2026 06:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790946635; bh=O9qAXfSNd9NNc6BfSIg0k7Umhi4nsbNeqt5uiHuVnJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TvUKc/n0sjb4WDRQ07F+4BkYbOxgyiB2mxnuB8rQI06A3qAbwMiFuyCHfXf+hGr8M
	 n6H+4gjuzlBeOlfDwc06mQ7avohuIYjKggc9aVN3ReSU9UWVISWu/JuGK+DUZEar3R
	 00IYnRRT9wyCBGFAXQ9z+t6CLv8X0M2rcvfOqBYI=
Message-ID: <bda01f30-acd1-4b79-9e15-75e839c198b9@arm.com>
Date: Fri, 2 Oct 2026 14:10:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 14:05, Fuad Tabba wrote:
> Hi Marc,
> 
> On Fri, 02 Oct 2026 13:57:11 +0100, Marc Zyngier <maz@kernel.org> wrote:
> [...]
>> Just to make sure. Is that what you had in mind?
> 
> A diff is worth a thousand words :) Yes, that's it. With that, every
> remaining hyp user of vcpu_is_protected() only runs with pKVM, so the
> kern_hyp_va() case in the macro can go too.

Ack ! That does make things simpler. Marc beat me to it.

Cheers
Suzuki

> 
> Cheers,
> /fuad

