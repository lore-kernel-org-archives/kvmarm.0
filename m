Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D373C8BE1
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 09:52:14 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BFD3AD7;
	Tue, 21 Mar 2023 02:52:58 -0700 (PDT)
Received: from [10.57.53.10] (unknown [10.57.53.10])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A110E3F766;
	Tue, 21 Mar 2023 02:52:12 -0700 (PDT)
Message-ID: <089c844b-e3ab-c41b-e96a-e0d1fcc9dfd8@arm.com>
Date: Tue, 21 Mar 2023 09:52:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH 04/11] KVM: arm64: Rename SMC/HVC call handler to reflect
 reality
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
 Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-5-oliver.upton@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230320221002.4191007-5-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/03/2023 22:09, Oliver Upton wrote:
> KVM handles SMCCC calls from virtual EL2 that use the SMC instruction
> since commit bd36b1a9eb5a ("KVM: arm64: nv: Handle SMCs taken from
> virtual EL2"). Thus, the function name of the handler no longer reflects
> reality.
> 
> Normalize the name on SMCCC, since that's the only hypercall interface
> KVM supports in the first place. No fuctional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

