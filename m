Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C141494812;
	Tue, 15 Sep 2026 22:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511148; cv=none; b=BdOTDYG9mv7Ctn+4u1QH01gdiUG7DSMYdTMkAWp3MKKy7/PAnLtRnE7fIRn/eTI6jOL82yvdcq7SlabUGkaqgrCu82i1NbLPhMuxrQfBd6/7JZKJbaAeFD74aLs37QjkF8vONCL9XtFGNTjTYEPZC1t2b8yPjhyxaFsuOIzCC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511148; c=relaxed/simple;
	bh=gdQY3EMZEOfWheafQ/uuEwATT2U3LRWRuoQraGDoBoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WC5mKBeaJIyED9TGrbq2/pE6Elc9YRCnA+uqRpF99Lw0TszY+MfZr0L9oz/kws+xbtB7sKNTF6vVlnhSUpCst2zFtp6RJ9hV9BohP9cKuaphx02IwWQlekaS7M3yM6l0DHWvkxAE6XSJMwKrv1K8qlE+ZRl+RTP8ZqR6PAWRad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWeWHJPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWeWHJPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005591F0089B;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511147;
	bh=E/lBbhtTE2HQN9x+xVp3jc8ZwjbTlxs/8mbmhmvVWeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWeWHJPumUljTcS9NiLuZBiYB9NAYMhX1qlg8GwqdgqQeB5XeqVmEScLsiOaJVtxe
	 6wAY6MOfFlgXKj2O59kPOKqw4cWF9Ci/27xm5YK35yYKdOsDWSFBMaFW8fCbV1Ohue
	 F3u3Jd4MMs9Aiv8iAcDcocxC5y0gw3tH7jvtfzqj25GyM2BXQFBLSCdLqkSFkKs/91
	 EsK5ENL+IPqQSs9UUNxOwDDUM6X60fAMoJOsFvQOMf50gj0fQVIgqqxp/37xYLB0UJ
	 c6g0eiGuKIjq5HIsHPGGDdM1ExwLYkAUIsOfgrVCJW/dulm/xzYhNcJX+aVYeIv6ck
	 o22wrnObxKOCw==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
Date: Tue, 15 Sep 2026 15:25:37 -0700
Message-ID: <178951103699.10790.2965757289938875509.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260829054856.70549-1-kmehltretter@gmail.com>
References: <20260829054856.70549-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 29 Aug 2026 07:48:54 +0200, Karl Mehltretter wrote:
> KVM_ARM_VM_SMCCC_FILTER rejects an empty range (nr_functions == 0) with
> -EINVAL for every base except 0. kvm_smccc_set_filter() only rejects a
> range if its inclusive end, base + nr_functions - 1, is below base; for
> base 0 that end wraps to U32_MAX, and KVM then tries to insert
> [0, U32_MAX], which overlaps the reserved Arm Architecture Calls
> ranges, so the attribute returns -EEXIST instead of -EINVAL.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
      https://git.kernel.org/kvmarm/kvmarm/c/64dc6f1db7e6
[2/2] KVM: arm64: selftests: Test empty SMCCC filter range at base 0
      https://git.kernel.org/kvmarm/kvmarm/c/0a46eb5719fa

--
Best,
Oliver
