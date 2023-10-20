Received: from out-206.mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF91DDC8
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 19:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UuGnDEPc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697829449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJIDp3kn3J9YYqvI7e1P1Uh08vnn+UrS9mMpb3yPd6Q=;
	b=UuGnDEPcvOoDcHuVVctCpYwXIpYG4p4fFch3ajCp9SJC1XZtdlum8UjoLQnLhQR8t7DwYD
	zDdqL4SendwJ8cr58LzgBiOgxK0VEiBAXsJVYGDevHC17K5OvYzKYr0B6t6UKxKxZoimnd
	PYSDr78UrJOiL86tCwix34r6vn8VaZo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Load stage-2 in vcpu_load() on VHE
Date: Fri, 20 Oct 2023 19:16:53 +0000
Message-ID: <169782936475.237746.6910655136004742028.b4-ty@linux.dev>
In-Reply-To: <20231018233212.2888027-1-oliver.upton@linux.dev>
References: <20231018233212.2888027-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 18 Oct 2023 23:32:07 +0000, Oliver Upton wrote:
> Thanks Zenghui for the review, I've addressed your feedback.
> 
> v2: https://lore.kernel.org/kvmarm/20231012205422.3924618-1-oliver.upton@linux.dev/
> 
> v2 -> v3:
>  - Save the right context in __tlb_switch_to_guest()
>  - Drop stale declarations from kvm_hyp.h
>  - Fix typo in changelog
> 
> [...]

Applied to kvmarm/next, thanks!

[1/5] KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
      https://git.kernel.org/kvmarm/kvmarm/c/38ce26bf2666
[2/5] KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
      https://git.kernel.org/kvmarm/kvmarm/c/4288ff7ba195
[3/5] KVM: arm64: Reload stage-2 for VMID change on VHE
      https://git.kernel.org/kvmarm/kvmarm/c/5eba523e1e5e
[4/5] KVM: arm64: Rename helpers for VHE vCPU load/put
      https://git.kernel.org/kvmarm/kvmarm/c/27cde4c0fe28
[5/5] KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
      https://git.kernel.org/kvmarm/kvmarm/c/934bf871f011

--
Best,
Oliver
