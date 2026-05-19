Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32633305665;
	Tue, 19 May 2026 06:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779172326; cv=none; b=D7iRfKDQYOCvKUyEyLklNcDGzD3hq3/eatwBdGfRbEoWtcItieUEMB8twEIZGWN6KZPvm3es6RTlQ62JbjpPEG2jRAzTVJ6Aeivj7t48CBPTOATDaGevDXJMUjsij0DsyIJv3G+FajmO6GiGsNa5OPXvD1C0qTnFLm7icXRSFNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779172326; c=relaxed/simple;
	bh=WsOs4HwWty+XwcBl+4eEJMq3peZJCA4ScKvm6Okeq1k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WdtRiIw6LPJWsnvjO+4x5Ik/M42Y8GRLg4NRLqmbmw2emJ7ObGM6ZJkwcgxjloYqZ9jx1jtsAvfOGhx7AKVTlt2GWIiQpio9WsonDp9FK+I66LO/MhpOYLE95sR78c95dwzzJgnlPvD95bIyb4j3jgcAOs+FUxNFsbV5F3xacHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9Br/NoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9Br/NoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722BEC2BCB3;
	Tue, 19 May 2026 06:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779172325;
	bh=WsOs4HwWty+XwcBl+4eEJMq3peZJCA4ScKvm6Okeq1k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=M9Br/NoA7Y13k6DOUvKorOyDhgW8WdjCWD17N5yJmk27gZb5O/BWKB8rT+ky1N2um
	 mtmkt+IFTPOlZIjM35+k0o40++AtEup79dyN8FRqOSz0RqzIIAF+AeLyy+F74gkPpn
	 ekRVw0CiNP/Hc/ZwUbV/SMQnn0FCLFQwhFYECsNGcNe9DT02frdwsL7+G1zMQ2U0uK
	 /i2YEU595u8uNDp29E+rNMST4dFLN8g8uFolWCUcX0nDBcEdnHc4yh8W0vEzt1LjHA
	 /EVnPPPFabaQsYVplnaj6NtpCat1kKjzzYR36z7PRDaEyphkJLK8+Ot0PbrrfQyyWG
	 2mJhlaWoNpD8w==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 14/44] arm64: RMI: Basic infrastructure for creating
 a realm.
In-Reply-To: <20260513131757.116630-15-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-15-steven.price@arm.com>
Date: Tue, 19 May 2026 12:01:55 +0530
Message-ID: <yq5a4ik3ucys.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> @@ -1114,7 +1119,10 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	write_unlock(&kvm->mmu_lock);
>  
>  	if (pgt) {
> -		kvm_stage2_destroy(pgt);
> +		if (!kvm_is_realm(kvm))
> +			kvm_stage2_destroy(pgt);
> +		else
> +			kvm_pgtable_stage2_destroy_pgd(pgt);
>  		kfree(pgt);
>  	}
>  }

Maybe add a comment here explaining the difference.

We now have:

kvm_arch_destroy_vm()
  -> kvm_uninit_stage2_mmu()
       -> kvm_realm_uninit_stage2()
            -> unmap_range(0, max_ipa)        // for Realm VMs
       -> kvm_free_stage2_pgd()
            -> unmap and free PGD             // for non-Realm VMs
  -> kvm_destroy_realm()                      // for Realm VMs
       -> kvm_free_stage2_pgd()
            -> free PGD                       // for Realm VMs

I wonder whether this can be simplified using different functions names?
(can we call kvm_pgtable_stage2_destroy_pgd() from kvm_destroy_realm()? )

-aneesh
