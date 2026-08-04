Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BEA4570F1;
	Tue,  4 Aug 2026 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785850584; cv=none; b=MxqdqgeI3zFtfzu1TWy/d/fJlaXXF7KhUw+mBZZG1KyTCFE8YzYQpNS6cLS+kyctY5wFPeZUzk5/tka4/5N6oRe9GZk+u1qRrfRghszhB0BprHLvd5PE/Ukdww19FqPvjSLIwGueVNmAaeDQ97f+jI1w6Kh1kfTq1Dl0c6Mkg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785850584; c=relaxed/simple;
	bh=PebHIYsVElhaCptEOULZFRNdYfD0yY8/sreWI1zEZ3c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Z2QfQrN7CtXFMkZ4haZ32rd20q4FeWNAmoQKa8jJEmGx2kgxFm+Rd/+nb3WF7oswVFcBV3SZ9oqGuzQRrMHcZU8DPsugZBxIWfjIIhY3KtKbNcl7WCTb4FD/ok6hVRlZd8R+FjeptubQ2LAemBlIInFxHA1V8IjZqbkgkTVB0rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjQAj0nc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjQAj0nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7509A1F000E9;
	Tue,  4 Aug 2026 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785850583;
	bh=Dea4THFr48jtnlZZX7EhhaJ5BcsAaX2rlq8oEbGTUAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VjQAj0ncxpu4IWoTIW4w+cBw5cvfEASTVME2PUMHKOftPqHktjAJmUuFgewEnw3h4
	 5iV/heJ0Nm1LVPY9AxoAKAbqYwiT0sjNVzBc44c9JCDKfKHyk8iTD/LeUdxKZVZVtZ
	 yc/C+zQjax0fPHXL5QgphM6BM+RPyCwokyaTdIYhVS/nZ7pX/SQJJm00O4QGGFQBaO
	 md6DKGHakfd3Jn+LODutreCHJdP/tSPVGYMLCVCmGbXC8rRszzB323v/i/lQ7Gyxs3
	 cAAZZfStqZQAs9SlTlgcZfIOEmjcBLhajKMZ+UjmJns7jjwzJe4SzWuR2eOQfnj9MJ
	 g34a0hLZOTXsw==
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 21/45] KVM: arm64: CCA: Handle realm enter/exit
In-Reply-To: <20260803134403.80630-22-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-22-steven.price@arm.com>
Date: Tue, 04 Aug 2026 19:06:11 +0530
Message-ID: <yq5a33wu3t4k.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_SYNC:
> +		/*
> +		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
> +		 * see __get_fault_info()
> +		 */
> +		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
> +		rec_exit_sync(vcpu);
> +		return ARM_EXCEPTION_TRAP;
> +	case RMI_EXIT_IRQ:
> +	case RMI_EXIT_FIQ:
> +		return ARM_EXCEPTION_IRQ;
> +	case RMI_EXIT_SERROR:
> +		return ARM_EXCEPTION_EL1_SERROR;
> +	case RMI_EXIT_PSCI:
> +		rec_exit_hvc(vcpu);
> +		kvm_make_request(KVM_REQ_RMI, vcpu);
>

I'm also wondering whether we can move the kvm_make_request() call until
after the PSCI/HOST_CALL handling is complete. I tried a quick hack, but
it did not look particularly clean, since we would end up adding
RMM-specific checks in handle_hvc():

ret = kvm_smccc_call_handler(vcpu);

if (vcpu_is_rec(vcpu) &&
    (vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_PSCI ||
     vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_HOST_CALL))
	kvm_make_request(KVM_REQ_RMI, vcpu);

That said, having rec_exit_hvc(vcpu) and kvm_make_request() back-to-back
is also somewhat confusing. Perhaps we could at least add a comment
explaining why the request must always be made here.


> +		return ARM_EXCEPTION_TRAP;
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		rec_exit_hvc(vcpu);
> +		return ARM_EXCEPTION_TRAP;
> +	}
> +
> +	return rec_exit_fatal(vcpu, "Unsupported Realm exit reason",
> +			      rec->run->exit.exit_reason);
> +}

-aneesh
