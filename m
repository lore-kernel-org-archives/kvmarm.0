Received: from out-220.mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D87A4E26F
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 18:18:42 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695320320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESi6WCBz3OcaqeHi98zUfJuzlX+aJShGsyp1e4x2WAo=;
	b=nc+IU8ws3v0fKGEvdOjh+9eclrG3oseb4BTozEvJFAu7EQZoT9TP39KHIoK4TxYmEHb5qT
	uj1EqJaYMzwur6Dmig4qb3MpZTUT+bkK7RD1d7gSUKSVR0fiYw1LSCc/BbalF2oQZxiDSg
	dBW48jpwPZenKHf8Kwrxe64vw5nX/wA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/8] KVM: arm64: Cleanup + fix to vCPU reset, feature flags
Date: Thu, 21 Sep 2023 18:18:28 +0000
Message-ID: <169532025748.1287192.9601319237389431113.b4-ty@linux.dev>
In-Reply-To: <20230920195036.1169791-1-oliver.upton@linux.dev>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 20 Sep 2023 19:50:28 +0000, Oliver Upton wrote:
> The way we do vCPU feature flag checks is a bit of a scattered mess
> between the KVM_ARM_VCPU_INIT ioctl handler and kvm_reset_vcpu(). Let's
> move all the feature flag checks up into the ioctl() handler to
> eliminate failure paths from kvm_reset_vcpu(), as other usage of this
> function no not handle returned errors.
> 
> Nobody screamed about the VM-wide feature flag change, so its also a
> good time to rip out the vestiges of the vCPU-scoped bitmap.
> 
> [...]

Applied to kvmarm/next, with the change to use cpus_have_final_cap() per
Marc's suggestion.

[1/8] KVM: arm64: Add generic check for system-supported vCPU features
      https://git.kernel.org/kvmarm/kvmarm/c/ef150908b6bd
[2/8] KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
      https://git.kernel.org/kvmarm/kvmarm/c/9116db11feb5
[3/8] KVM: arm64: Hoist SVE check into KVM_ARM_VCPU_INIT ioctl handler
      https://git.kernel.org/kvmarm/kvmarm/c/be9c0c018389
[4/8] KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
      https://git.kernel.org/kvmarm/kvmarm/c/baa28a53ddbe
[5/8] KVM: arm64: Prevent NV feature flag on systems w/o nested virt
      https://git.kernel.org/kvmarm/kvmarm/c/12405b09926f
[6/8] KVM: arm64: Hoist NV+SVE check into KVM_ARM_VCPU_INIT ioctl handler
      https://git.kernel.org/kvmarm/kvmarm/c/d99fb82fd35e
[7/8] KVM: arm64: Remove unused return value from kvm_reset_vcpu()
      https://git.kernel.org/kvmarm/kvmarm/c/3d4b2a4cddd7
[8/8] KVM: arm64: Get rid of vCPU-scoped feature bitmap
      https://git.kernel.org/kvmarm/kvmarm/c/1de10b7d13a9

--
Best,
Oliver
