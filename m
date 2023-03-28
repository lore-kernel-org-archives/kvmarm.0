Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481E0187D
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 09:19:13 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8627C14;
	Tue, 28 Mar 2023 02:19:56 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9416D3F73F;
	Tue, 28 Mar 2023 02:19:11 -0700 (PDT)
Message-ID: <850ad3ea-068a-4dd6-b549-8daf7fadf737@arm.com>
Date: Tue, 28 Mar 2023 10:19:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 06/11] KVM: arm64: Refactor hvc filtering to support
 different actions
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
 Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-7-oliver.upton@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230320221002.4191007-7-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/03/2023 22:09, Oliver Upton wrote:
> KVM presently allows userspace to filter guest hypercalls with bitmaps
> expressed via pseudo-firmware registers. These bitmaps have a narrow
> scope and, of course, can only allow/deny a particular call. A
> subsequent change to KVM will introduce a generalized UAPI for filtering
> hypercalls, allowing functions to be forwarded to userspace.
> 
> Refactor the existing hypercall filtering logic to make room for more
> than two actions. While at it, generalize the function names around
> SMCCC as it is the basis for the upcoming UAPI.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


