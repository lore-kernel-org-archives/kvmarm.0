Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A23579C7
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 09:42:36 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1BA3AD7;
	Tue, 21 Mar 2023 02:43:14 -0700 (PDT)
Received: from [10.57.53.10] (unknown [10.57.53.10])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E4F53F766;
	Tue, 21 Mar 2023 02:42:29 -0700 (PDT)
Message-ID: <60fbd578-0391-98b1-d8d1-200a716e1500@arm.com>
Date: Tue, 21 Mar 2023 09:42:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH 02/11] KVM: arm64: Add a helper to check if a VM has ran
 once
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
 Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-3-oliver.upton@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230320221002.4191007-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 20/03/2023 22:09, Oliver Upton wrote:
> The test_bit(...) pattern is quite a lot of keystrokes. Replace
> existing callsites with a helper.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/pmu-emul.c         | 4 ++--

There is one more instance in arch/arm64/kvm/hypercalls.c at
kvm_arm_set_fw_reg_bmap(). Is there a reason why that can't be replaced ?

Otherwise, looks good to me.

Suzuki

