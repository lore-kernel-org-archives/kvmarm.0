Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE6C168D4
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3CA92F4;
	Mon, 27 Nov 2023 01:44:47 -0800 (PST)
Received: from [10.57.73.191] (unknown [10.57.73.191])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 662C53F6C4;
	Mon, 27 Nov 2023 01:43:58 -0800 (PST)
Message-ID: <5f305b03-c5d7-4f3c-b653-50f219b48ea6@arm.com>
Date: Mon, 27 Nov 2023 09:43:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/12] KVM: arm64: Use LPA2 page-tables for stage2 and
 hyp stage1
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
 <20231116142931.1675485-8-ryan.roberts@arm.com> <ZV0Uaoi-qBjX3j5i@linux.dev>
 <c89e4132-fedd-440d-8971-5e42969fc1e9@arm.com> <86fs0xzue7.wl-maz@kernel.org>
 <1ead7fa6-7085-4b95-a568-ece094721d34@arm.com> <86il5ncziy.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86il5ncziy.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/11/2023 09:32, Marc Zyngier wrote:
> On Fri, 24 Nov 2023 11:49:57 +0000,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> OK fair enough. I've made this change for the next rev.
> 
> Any chance you could post this new revision shortly? It looks ready to
> me, and I would really like this to simmer in -next for a while.

Yes; I was just rerunning the kvm selftests over the weekend. No new issues
there. But I want to rerun the boot tests too, which I will do this morning.
Assuming that's still good, I'll post later today.

> 
> Thanks,
> 
> 	M.
> 

