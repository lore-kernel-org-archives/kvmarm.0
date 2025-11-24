Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208712D6E66
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 22:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024246; cv=none; b=HWX44BHShMML5NR7scYbf9rqUu7jtEjVJTZEO+vNIx0h1L3xEUk3j6hgIilo7JVK/yZ2L9SEWfSEX3N3KIhXSxnFS2F3iDdLmTTg2SpzgfFsuEZuFZOaYoPoDZvypLFUNaa816mB3npzh0lnyCLO/kRRAd4vFrCvrVP7VIOaUCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024246; c=relaxed/simple;
	bh=W9E8SMMPtwCPuFuI+wUgwEpemPEn2K9WKaDfhUGXDdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGwo653eakTDYstKY7caIVqVohbb+lD0Uw1TJiRWP7aeH2BO+B8Ipw7wEofzmaM9StP2K/+msf2XHn2tg3likrFuDTCsXDMP52m36RiVLlwIpP2CSxwdl/vSVPEzuY3PxH91wQ0gV593sRj79kIXXgCWwlA1hAX2BAjW8MEjmUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sH5RlLUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sH5RlLUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EDCC19422;
	Mon, 24 Nov 2025 22:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764024245;
	bh=W9E8SMMPtwCPuFuI+wUgwEpemPEn2K9WKaDfhUGXDdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sH5RlLUO6R/yWsi9u2lOF9wyFB4lVwfd+l3qJlHiKrTCSBZWSGT88rN88Pp3TQHV8
	 qcVyueOUCyvPxlkuW/ujSLx9y84wxhdStx1saPt6km+yebw7eoMqnLrQ2/5P88eDfq
	 XzzbLDP739H5Yk4uTyLlnmkYv3NIMvQlTvDx5cuB8jMQjsbc9mJ7YdD3n/b28GjTH3
	 VOZK/O0ud7w31sixxOBt2Nc+rrpC8K8Weg8ec0uNV3cRvOs9FGyrq4GaR/aeNhRPta
	 06MwPPi80mGkfAlmuPdHm6MKBx0RF1iF7U7ThByaFgFIfhixd6cM5Tp9smS99j+Gen
	 PSLeQqoxcdMkw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 00/15] KVM: arm64: nv: Implement FEAT_XNX and FEAT_HAF
Date: Mon, 24 Nov 2025 14:44:02 -0800
Message-ID: <176402422338.855688.4340599660395610973.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 24 Nov 2025 11:01:42 -0800, Oliver Upton wrote:
> Fixes all the issues Marc found in v2:
> 
> v2: https://lore.kernel.org/kvmarm/20251117224325.2431848-1-oupton@kernel.org/
> 
> v2 -> v3:
>  - Don't use uninitialized XN value in kvm_pgtable_stage2_relax_perms()
>  - Pass vcpu pointer directly in the stage-2 PTW
>  - Ensure LL/SC swap implementation correctly handles compare failures
>  - Fix SRCU imbalance
> 
> [...]

Applied to next, thanks!

[01/15] arm64: Detect FEAT_XNX
        https://git.kernel.org/kvmarm/kvmarm/c/dc31124379b6
[02/15] KVM: arm64: Add support for FEAT_XNX stage-2 permissions
        https://git.kernel.org/kvmarm/kvmarm/c/2608563b466b
[03/15] KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
        https://git.kernel.org/kvmarm/kvmarm/c/d93febe2ed2e
[04/15] KVM: arm64: Teach ptdump about FEAT_XNX permissions
        https://git.kernel.org/kvmarm/kvmarm/c/81e9fe5c6f25
[05/15] KVM: arm64: nv: Advertise support for FEAT_XNX
        https://git.kernel.org/kvmarm/kvmarm/c/5aef6974ec47
[06/15] KVM: arm64: Call helper for reading descriptors directly
        https://git.kernel.org/kvmarm/kvmarm/c/e218981560f6
[07/15] KVM: arm64: nv: Stop passing vCPU through void ptr in S2 PTW
        https://git.kernel.org/kvmarm/kvmarm/c/c2c5d3b248e3
[08/15] KVM: arm64: Handle endianness in read helper for emulated PTW
        https://git.kernel.org/kvmarm/kvmarm/c/a1b8922186f8
[09/15] KVM: arm64: nv: Use pgtable definitions in stage-2 walk
        https://git.kernel.org/kvmarm/kvmarm/c/0a610d2056c2
[10/15] KVM: arm64: Add helper for swapping guest descriptor
        https://git.kernel.org/kvmarm/kvmarm/c/9020b38e23db
[11/15] KVM: arm64: Propagate PTW errors up to AT emulation
        https://git.kernel.org/kvmarm/kvmarm/c/15e996ef9dc5
[12/15] KVM: arm64: Implement HW access flag management in stage-1 SW PTW
        https://git.kernel.org/kvmarm/kvmarm/c/c59ca4b5b0c3
[13/15] KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
        https://git.kernel.org/kvmarm/kvmarm/c/39db933ba67f
[14/15] KVM: arm64: nv: Expose hardware access flag management to NV guests
        https://git.kernel.org/kvmarm/kvmarm/c/6774884fabf0
[15/15] KVM: arm64: selftests: Add test for AT emulation
        https://git.kernel.org/kvmarm/kvmarm/c/662d0d6cccba

--
Best,
Oliver
