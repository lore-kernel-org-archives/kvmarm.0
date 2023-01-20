Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFBD20EF
	for <kvmarm@lists.linux.dev>; Fri, 20 Jan 2023 12:08:57 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62851106F;
	Fri, 20 Jan 2023 04:09:38 -0800 (PST)
Received: from [10.163.48.185] (unknown [10.163.48.185])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 733353F71A;
	Fri, 20 Jan 2023 04:08:55 -0800 (PST)
Message-ID: <34b65af4-0775-09a1-0f67-1c8c74caac1b@arm.com>
Date: Fri, 20 Jan 2023 17:38:51 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] KVM: arm64: Pass the actual page address to
 mte_clear_page_tags()
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230119170902.1574756-1-catalin.marinas@arm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20230119170902.1574756-1-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/19/23 22:39, Catalin Marinas wrote:
> Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
> initialisation") added a call to mte_clear_page_tags() in case a
> prior mte_copy_tags_from_user() failed in order to avoid stale tags in
> the guest page (it should have really been a separate commit).
> Unfortunately, the argument passed to this function was the address of
> the struct page rather than the actual page address. Fix this function
> call.
> 
> Fixes: d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5626ddb540ce..cf4c495a4321 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1079,7 +1079,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  
>  			/* uaccess failed, don't leave stale tags */
>  			if (num_tags != MTE_GRANULES_PER_PAGE)
> -				mte_clear_page_tags(page);
> +				mte_clear_page_tags(maddr);
>  			set_page_mte_tagged(page);
>  
>  			kvm_release_pfn_dirty(pfn);
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
