Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75EF455626;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511147; cv=none; b=rgKAqGly8IwbLi+6zU+2+hWxef/fHTw5iyB+qVobza6w4Hxw+onNwoIgaYzIp+vkjAKMSJXY0aR4ZVK4swMjStkP5z5JlaJMm7fVywmQ/S7xI+AtpFtTThJUF5+NEQrJgkeL4NyUIQuFn1t18Xk4um89aYt9sKfsHCc8WuwOiwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511147; c=relaxed/simple;
	bh=/jffp0z7UwwzC1uxVIh84z1DXsm+kdBB6hnRe3FP3fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcPuduQu37p8zAxO24KbeXTH5cQ8j4JAFwLIiMISAWngkCjlhucms4odql/Sq/inmmlFyNsG7ZN9QXn/xjMmxTv5RQPBvjSZarI7GmfCHxJO0k7l8cRIzgOWNZLO/+Y23bwjwiDvd4kPlby7mAwYvzGktHovLRpisFqJCp0WDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfA4ZVLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfA4ZVLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABC91F00893;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511146;
	bh=RzbNWZ8TFIHeY8QtO5t5YQsgg2SPGjQY6QoCB/NWVow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfA4ZVLW8tvxWuCKYaVYsUau/0DpqInwAIrAq4bElIHA6tnZFTT1Ae4ogsIepzgdt
	 7OQQIUslTABAz+o6gDciJrZJabDdjoeUYfrijg8BbOlPzMO4wHzaGl7dlVDxWjJDuZ
	 rxjzRaXOb6UXmTSK7G89MrlvxdfVn6fQfhY7RxLXjfVKJXr7R/0s65kIhkdkRtHDHC
	 l3JXCKJY1B16OVHMb/tIDLSe10Cq43+V5j9JXxGtPmQla4x3jwK3iQOTiILKos7CWh
	 rYAMub7uxIREDt2UglcSc7J35RCgDUM0VI2oDEghFnzjF+MP5lSjVRH1dXt5Mo7c/G
	 /XV+mTBfwoQbA==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Don't WARN on an unknown VM ioctl in protected mode
Date: Tue, 15 Sep 2026 15:25:35 -0700
Message-ID: <178951103692.10790.7627884400333495166.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914093838.1082637-1-fuad.tabba@linux.dev>
References: <20260914093838.1082637-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 14 Sep 2026 10:38:38 +0100, Fuad Tabba wrote:
> kvm_pkvm_ioctl_allowed() WARNs when kvm_get_cap_for_kvm_ioctl() doesn't
> find the ioctl number in vm_ioctl_caps[], and kvm_arch_vm_ioctl() calls
> it for every number the generic code doesn't handle, so
> ioctl(vm_fd, 0xdeadbeef) from userspace taints a pKVM host and panics it
> under panic_on_warn. The lookup is fed userspace input: return false,
> and userspace gets the -EINVAL kvm_arch_vm_ioctl() returns for that
> number on a host without pKVM.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't WARN on an unknown VM ioctl in protected mode
      https://git.kernel.org/kvmarm/kvmarm/c/49d9d295d69d

--
Best,
Oliver
