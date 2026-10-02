Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F82E3C2775;
	Fri,  2 Oct 2026 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790956533; cv=none; b=kCaNf8T+/kYzp1QR6ByRkvX4O11aGpn+OOK0R8S2/pAAr3NN3oJCzTCbWZrYifsxDOHOWFlWFiF384YKuU7NApO6EmFpfYKZlSDzR2ynGNBYk3F2CfyerZJBqWBI7TPSfOtjtI8kPfrgz4ltWIlDbp4ZoWfkdiczg2VbeB70WxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790956533; c=relaxed/simple;
	bh=v5xjyPMr7ysn1m26/wEJM6h5VhbBpaS/jh2iVTImae0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQ4cj+M3EGMnqD8g2wneLjFyxjOPXpDRqSZEWCq/rcRCh298NmYi/wvMD50tE8bjiAraPXem766f5lL8s9cgeFfxNVYPJIzliNNM0CrfZZDHHfJZef4L55z/iE/tUTGv0Bwdm9ThwD7szDvZ/2VsF/uBItoJhLx/RLljAqRwNfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMDrC6gW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMDrC6gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392FD1F000FF;
	Fri,  2 Oct 2026 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790956532;
	bh=pkuZWiE4qwA3AlHHyYAOQAj4r7NKq77EKJ2Yz3Nylho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMDrC6gW0jVNVl43vTuE5BYV7hMbFMI9Qg9b+KFodnvgGStg9YSOcn+uEpW/FzuZE
	 hmChMav3VuJN/ZzkKsaFpFAl5aXQ2MMRCwWusztLVXx5MkLP7SeysXicPcNSFCug4q
	 tQXpuTdaUTw0rjWRpbWMCC2SPBnpsXRdiEHtrb2I8pXRB8HdCKOLQhLkRqUYERRjLC
	 zOj34Q7pHOsHcJUVKh3QybkZvczzocsr7B/nu+TXFylfKMn9UotVLyDUAMOqfEOyuI
	 9AQUjWD0PLQlvzhZvKRelyx0IAdkMWYGYn0e0FlCDYuUijUrbe/fUZlQjrd1CTSMmx
	 Suak45OaUKmmg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xCfbe-0000000GIMo-0HnW;
	Fri, 02 Oct 2026 15:55:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com
Subject: Re: [PATCH v4 00/18] KVM: arm64: Confine protected VM vCPU state to EL2
Date: Fri,  2 Oct 2026 16:55:26 +0100
Message-ID: <179095643711.351883.2924159912626438826.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 01 Oct 2026 14:56:53 +0100, Fuad Tabba wrote:
> Changes since v3 [1]:
>   - A protected vCPU that EL2 holds powered off reads as
>     KVM_MP_STATE_UNINITIALIZED, in place of a new bool. (Marc)
>   - The marshalling and PSCI patches access the host copy through the
>     vCPU accessors, with every assignment on one line. (Marc)
>   - The PC adjustment pair is kvm_adjust_pc_get()/put() and tests for
>     the hyp vCPU directly. (Marc)
>   - CPU_OFF clears the reset flag before its release of OFF, CPU_ON's
>     relaxed cmpxchg is ordered by its control dependency, and the
>     CPU_ON rollback stores OFF with a release. pkvm_reset_vcpu()
>     carries the CPU_ON/CPU_OFF sequence as a comment and drops its
>     WARN_ON(). (Vincent, Will)
>   - Collected Reviewed-bys.
> 
> [...]

Applied to next, thanks!

[01/18] KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
        commit: 3708f6342f010d66a767b587dc881f18d95ceb3e
[02/18] KVM: arm64: Validate the host vCPU's VM before reading it under pKVM
        commit: cf533b4d3630b229d78ad55567c5db2f365052a2
[03/18] KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
        commit: a2bb5f5c67a95ac97fcd6859dab51be421cf26fe
[04/18] KVM: arm64: Disable steal time for protected VMs
        commit: a5b0f36a045e0e96f8e2e044403ff8e6464995e1
[05/18] KVM: arm64: Introduce per-EC entry handlers for pKVM
        commit: 66a5e82d2a8d113d5953d04e008447d6b779e03e
[06/18] KVM: arm64: Skip fixed-feature state flush for protected vCPUs
        commit: 06499de8f998e0ec975cb73adde936c12a8a1200
[07/18] KVM: arm64: Add {flush,sync}_hyp_timer_state() primitives
        commit: a8b2a7d0fe9c0eb493542bb1d306b68313e6a828
[08/18] KVM: arm64: Add system register reset framework for protected VMs
        commit: ceaf9e57f88711fa3c7775ee4fea4f6731f1a71c
[09/18] KVM: arm64: Implement HVC handling for protected guests at EL2
        commit: fe40ff87ead5c541ac4b42aa149b98052a1abca1
[10/18] KVM: arm64: Handle PSCI calls for protected VMs at EL2
        commit: 9d4ec80be2eb4745d877c6989f1e59c62a2e4da4
[11/18] KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected VMs
        commit: 0b7d843ef3bf0a791d9e92c8a85178fe2a5ee9ff
[12/18] KVM: arm64: Prevent host PC adjustments for protected vCPUs
        commit: fc519dabd86b07b7f7e285ce68b2993d370f64d3
[13/18] KVM: arm64: Inject an UNDEF at EL2 for unhandled protected guest exits
        commit: 3cfbad49ededd985555820d97b62a27f92506b52
[14/18] KVM: arm64: Add per-EC entry/exit state marshalling for protected guests
        commit: 872383bd12e116fc79cb4487b1740c84f23c4c23
[15/18] KVM: arm64: Reject host access to protected VM private state
        commit: ad4ebc3decaa19fad2c00868e237561b6ac004c6
[16/18] KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
        commit: 25d726dddc237043327aed9a2b51a5b6336bc31a
[17/18] KVM: arm64: Advertise the capabilities that protected VMs support
        commit: 4957c24559e90592cfb60b6d4425296c2a7cd0e0
[18/18] KVM: arm64: Document the protected VM userspace API
        commit: 61ace86519fb830a7b271c2a1037c8db5f2f3333

Given how busy this merge window is, there were plenty of conflicts, most
of them with your own patches. Please have a look at the way I resolved
them and let me know if anything is on the bogus side of wrong...

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


