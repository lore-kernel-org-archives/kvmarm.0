Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377D6A2C
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 10:45:40 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C1211FB;
	Thu,  2 Mar 2023 02:46:22 -0800 (PST)
Received: from [10.1.29.164] (e121487-lin.cambridge.arm.com [10.1.29.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 267113F67D;
	Thu,  2 Mar 2023 02:45:34 -0800 (PST)
Message-ID: <6d407882-c34e-16f1-1662-2af588e982f7@arm.com>
Date: Thu, 2 Mar 2023 10:45:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 12/12] KVM: arm64: Use local TLBI on permission
 relaxation
Content-Language: en-US
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-13-ricarkol@google.com>
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20230301210928.565562-13-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 21:09, Ricardo Koller wrote:
> Second, KVM does not set the VTTBR_EL2.CnP bit, so each
> PE has its own TLB entry for the same page. KVM could tolerate that when
> doing permission relaxation (i.e., not having changes broadcasted to all
> PEs).

I'm might be missing something, but it seems that we do set CnP bit, at
least in v6.2 we have

arch/arm64/include/asm/kvm_mmu.h

static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
{
        struct kvm_vmid *vmid = &mmu->vmid;
        u64 vmid_field, baddr;
        u64 cnp = system_supports_cnp() ? VTTBR_CNP_BIT : 0;

        baddr = mmu->pgd_phys;
        vmid_field = atomic64_read(&vmid->id) << VTTBR_VMID_SHIFT;
        vmid_field &= VTTBR_VMID_MASK(kvm_arm_vmid_bits);
        return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
}

Cheers
Vladimir
