Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07AA39EF25
	for <kvmarm@lists.linux.dev>; Sat, 25 Jul 2026 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784999825; cv=none; b=TcwQv4aRleIVdo97kHIRG4ZT2avudVKzsoEmkn77ab+DxgSIQduYkdceWQFQOvKnxg5+ONppb+5j5fCA4DgFSV5vGbox8jhljqlHGu58zBHKPczOPjZ6E2mF8NNK2XVgQyvhPKChHXyyZz/y7Z5GzpvqxvyeMXrnwpNWiL2WK/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784999825; c=relaxed/simple;
	bh=+omX/Tl/a3q8wWs0/af+Q2F7EKuxKZ0L0Z4YWQFCw5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwtBBYCpMxHpCbrkVmC4aKXDId0Hmt9cWgpCcyPvHMB+tYR/DoehOG0rxBmE4gaMHjwXOu6l1DZK0OnRsXS5spkY+vmIfnKFO/ghbOzCuSvLzHdsB2/IY7CnCZ+bCgwN0SC1oYB/te1g750o1W8cwT96EtCok8YfEOTgVndAysc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Rd95tlal; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Rd95tlal"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8C131476;
	Sat, 25 Jul 2026 10:16:51 -0700 (PDT)
Received: from [10.163.131.227] (unknown [10.163.131.227])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48FBB3F9AB;
	Sat, 25 Jul 2026 10:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784999816; bh=+omX/Tl/a3q8wWs0/af+Q2F7EKuxKZ0L0Z4YWQFCw5I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rd95tlalpS7RDjQuSTC6ghjgE6h3pX1mN7C+5aPsmZ4bZifOdScIeoMZiD9sHma90
	 keWMVLOOFKrEZc+uUI088msUtDYJF1x0Sjx6+elNJ03fT1HsPVyzUUoif0bUqhrF7D
	 RVDiUTMJpkKHCE5zFohv/PFXn1SwYUK0ndD8yNik=
Message-ID: <a2548783-ee41-49c0-bfe3-80b3816dc6b2@arm.com>
Date: Sat, 25 Jul 2026 22:46:37 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: arm64: ptdump: Flush the last region
To: Wei-Lin Chang <weilin.chang@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ardb@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Sebastian Ene
 <sebastianene@google.com>, Vincent Donnefort <vdonnefort@google.com>,
 Sashiko AI <sashiko-bot@kernel.org>
References: <20260724185431.2990395-1-weilin.chang@arm.com>
 <20260724185431.2990395-3-weilin.chang@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260724185431.2990395-3-weilin.chang@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/07/26 12:24 am, Wei-Lin Chang wrote:
> Currently the stage-2 ptdump calls note_page() at each leaf entry visit.
> This simply misses the output of the last region, because note_page()
> only dumps output when it detects a change in level/prot, or when the
> walk enters a next marker section. The last region in the guest IPA
> space with the same level/prot is not dumped since there is no change
> after it.
> 
> Call note_page_flush() to dump the final region. note_page_flush()
> expects ptdump_state.range[] to be initialized to the range of the
> address space, so also do that.
> 
> Also change the second marker's start address to ULONG_MAX so we never
> cross it. This avoids dumping redundant marker names (which are NULL),
> and advancing beyond the end of the marker array.
> 
> Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
> Reported-by: Sashiko AI <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/kvmarm/20260630122758.891011F00A3A@smtp.kernel.org/
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/kvm/ptdump.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index c9140e22abcf..222577163d2b 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -130,7 +130,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu
>  	}
>  
>  	st->ipa_marker[0].name		= "Guest IPA";
> -	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
> +	st->ipa_marker[1].start_address = ULONG_MAX;
>  
>  	st->mmu				= mmu;
>  	return st;
> @@ -148,18 +148,26 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
>  		.flags	= KVM_PGTABLE_WALK_LEAF,
>  	};
>  
> +	guard(write_lock)(&kvm->mmu_lock);
>  	st->parser_state = (struct ptdump_pg_state) {
>  		.marker		= &st->ipa_marker[0],
>  		.level		= -1,
>  		.pg_level	= &st->level[0],
>  		.seq		= m,
> +		.ptdump		= {
> +			.range = (struct ptdump_range[]){
> +				{0, BIT(mmu->pgt->ia_bits)},
> +				{0, 0}
> +			}

I am having a real hard time reading that indentation :) you
could make it look like what we have currently in ptdump_walk().

The code looks sensible to me. I have also tested by booting a
Linux VM inside a Linux VM on a Mac, and I see the stage2 ptdump
prints the last range upto the ia_bits correctly. So with the
nit addressed above:

Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>




> +		}
>  	};
>  
> -	write_lock(&kvm->mmu_lock);
>  	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> -	write_unlock(&kvm->mmu_lock);
> +	if (ret)
> +		return ret;
> +	note_page_flush(&st->parser_state.ptdump);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)

