Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE263016E0;
	Tue, 19 May 2026 06:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173676; cv=none; b=Lt9ger3Rhj7bliswCLLm9P4O+1I3S4mnPx4EErqDQb07GSXe9HEeYGrBcmHot97fN1FUePFqqz3RIcE/xgSaq2qUDewpKdbdbfta1Bdq02/cIjDzOcEWuqPhOVxlLyzgCyWtzBnKEeWKYKnTDzVccnccMNfolrdnQQ3rWfj0o2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173676; c=relaxed/simple;
	bh=WTulWk0fdJsYN4VDWBS3LAugunVY3PrhUqz2mvZt/Fw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kD/Dux202GRg2yOWZcXoChReWvW3PwrJUicLh7Y9VlNAJPI9izN+KWlp4alqFe4RsBrq2t/5KeL/wIVFzpHbyn8ueajxWmT+R+sCh1lROReEaMrZtM9+JlBnlDwfrEIKw03FHME1BgWy4ffzSyKAHq2HdbO/u6KUIHPcwINtvVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSxdtMhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSxdtMhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB720C2BCB3;
	Tue, 19 May 2026 06:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779173676;
	bh=WTulWk0fdJsYN4VDWBS3LAugunVY3PrhUqz2mvZt/Fw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uSxdtMhTYbo8vA/rS1evCTJW7BFfc4cZ9/tQPleeIUwcXo8myxlf78qlAuxCzWtkD
	 tBmy+pTVVxODiJBiq+9FY3caN9vYALV+porHWp7dOLbCJjY5UEDay1YYCDJ4MQbYn/
	 G/8RbcTGCJJOFWMqQItxyghbiZnq96UF4EtzAlX/zCJw08HF0nVw8f5dRAzFZGYq33
	 2p0Q9V1/0Gccpqoczx/1RxlVbo3hsU9rpmPz86x/IQgTUqiDp7ahzb9jKSgSLbMV3R
	 94v7n1MO5uWG0MYhQHkZfWJTpmaEKBUb60y46Nwb1JIGCszsqEbE8jQRv/QExHo0p5
	 GfjyRqyPPl4Aw==
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
Subject: Re: [PATCH v14 17/44] arm64: RMI: RTT tear down
In-Reply-To: <20260513131757.116630-18-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-18-steven.price@arm.com>
Date: Tue, 19 May 2026 12:24:26 +0530
Message-ID: <yq5a1pf7ubx9.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:
> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_ACTIVE)
> +		return;
> +
> +	write_lock(&kvm->mmu_lock);
> +	kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), true);
> +	write_unlock(&kvm->mmu_lock);
> +	kvm_realm_destroy_rtts(kvm);
> +}
> +

We also call kvm_stage2_unmap_range in kvm_destroy_realm()

void kvm_destroy_realm(struct kvm *kvm)
{
...
	write_lock(&kvm->mmu_lock);
	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
			       BIT(realm->ia_bits - 1), true);
	write_unlock(&kvm->mmu_lock);
        
-aneesh
