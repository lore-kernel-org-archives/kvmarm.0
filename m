Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0E03F65E1
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057345; cv=none; b=mGMaJsr01El+wM94wXraPs7PlC4dBTXTRJz2W4z5wRUImVePoOIB10JzwbZv6gsDfMicu3cFKSSUD1vJRebE0CHb4m1bIXDpAxx572Rxmel9h8t9scXdJKHRExxZX15k51lIdQfIJwql5SxY9cUi/s7B1MxehIJKBkQURF2lZV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057345; c=relaxed/simple;
	bh=IaCA/kZ80YYXWVDTy6lh/1UaevH/FmkPA5jaCCQnUis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPWfc8IhhTRVY35vcRouCWENZHs2Ps9+nXVGEXBKwcfOMV0D8n617uU4ynVQmF68nQY85ZE2x8Yyfcdcs8V46AENrBnEF6RkYl36MehHKWNHMKdoEybtqGFlJQT0dbEBHHFbba648Uds2khGLik5DSGrcHYwp07xI4u0B/WaiGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMWcaQsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMWcaQsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769AEC4CEF7;
	Wed,  1 Apr 2026 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775057345;
	bh=IaCA/kZ80YYXWVDTy6lh/1UaevH/FmkPA5jaCCQnUis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMWcaQskzytX1U7u06gePZeJndGPhO1wrbeObnA9DOXPtxAu1TJF1Z6fWCAMpyHvi
	 0OYEMRfiTFRnwM5NkahyfkT6gS/n5hulpEWHJT1PnfJsTQPw+dIJwTL4uFJkgOTGCV
	 OnjQ5JLltn3N3g9N0UP8GeQSOWWdv1NZRXGzE+/pN7XNarCg0hgOLEhPmdNcrBuFPD
	 /Mji1zbxqHLNLejWu/w4RzELO37rjR/lF6TW5fNn8MmKxu58D8Ke3rAd5458AjB6Jo
	 oU7g99TcewP7PaXqTTptXkMHyeAxk0ZohboatOlWDSrhuMkDaMkm+SoKvEKsB5ZZG8
	 L1V+DWh67npkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7xV9-00000007v9s-1Gdj;
	Wed, 01 Apr 2026 15:29:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 00/38] KVM: arm64: Add support for protected guest memory with pKVM
Date: Wed,  1 Apr 2026 16:28:55 +0100
Message-ID: <177505732748.363663.16964917665296494635.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-arm-kernel@lists.infradead.org, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, qperret@google.com, tabba@google.com, vdonnefort@google.com, smostafa@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 30 Mar 2026 15:48:01 +0100, Will Deacon wrote:
> As promised on Friday, here's v5 of the pKVM protected memory patches
> previously posted here:
> 
>   v1: https://lore.kernel.org/kvmarm/20260105154939.11041-1-will@kernel.org/
>   v2: https://lore.kernel.org/kvmarm/20260119124629.2563-1-will@kernel.org/
>   v3: https://lore.kernel.org/r/20260305144351.17071-1-will@kernel.org
>   v4: https://lore.kernel.org/r/20260327140039.21228-1-will@kernel.org
> 
> [...]

Applied to next, thanks!

[01/38] KVM: arm64: Remove unused PKVM_ID_FFA definition
        commit: 660b208e8b5ea0f5a68a8333e18960d89d484a27
[02/38] KVM: arm64: Don't leak stage-2 page-table if VM fails to init under pKVM
        commit: 5e66f723d4de432a5acb481293d81dc88c7f61a4
[03/38] KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
        commit: 9f02deef471e1b6637a6641ce6bf9e2a1dd7d2c1
[04/38] KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
        commit: ff1e7f9897947ea79ece7eb587c8d93957af5ee8
[05/38] KVM: arm64: Don't advertise unsupported features for protected guests
        commit: be3473c338d23c87485d7728818005f32b58009f
[06/38] KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected guests
        commit: 3a81a814437d187ac893b3d937985d6503ff3841
[07/38] KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls
        commit: 733774b5204553ab5524c0330f262184d9d573f6
[08/38] KVM: arm64: Ignore MMU notifier callbacks for protected VMs
        commit: 7250533ad2c1f0e49567077e9b0f66b0349b357e
[09/38] KVM: arm64: Prevent unsupported memslot operations on protected VMs
        commit: f0877a1455cc6a93be14e4da741ce26ac0d6ca6d
[10/38] KVM: arm64: Ignore -EAGAIN when mapping in pages for the pKVM host
        commit: 73c55be08932a348f8b0a44f561c33eaa2cf1ad2
[11/38] KVM: arm64: Split teardown hypercall into two phases
        commit: 6c58f914eb9c4ce5225d03183ae1290d72b5f639
[12/38] KVM: arm64: Introduce __pkvm_host_donate_guest()
        commit: 1e579adca1774b3713d1efa67d92a88ec86c04fa
[13/38] KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
        commit: 5fef16ef49126b0f71fb3e401aae4dca1865e6f9
[14/38] KVM: arm64: Handle aborts from protected VMs
        commit: ea03466e806fea942841a41cfaab8db8c851aa71
[15/38] KVM: arm64: Introduce __pkvm_reclaim_dying_guest_page()
        commit: 0bf5f4d400cd11ab86b25a56b101726e35f3e7cb
[16/38] KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
        commit: 4e6e03f9eaddb6be5ca8477dc5642e94ddece47e
[17/38] KVM: arm64: Factor out pKVM host exception injection logic
        commit: 90c59c4d920f3ea6e7b4dd8702b87b38c7162755
[18/38] KVM: arm64: Support translation faults in inject_host_exception()
        commit: be9ed3529e0599f036a425d83ecc6dd4a085c9d2
[19/38] KVM: arm64: Inject SIGSEGV on illegal accesses
        commit: 9ff714a09222128da16900fc7c15dea65692fc26
[20/38] KVM: arm64: Avoid pointless annotation when mapping host-owned pages
        commit: 664d61690357ac2154cd01d859d97455aa49a81d
[21/38] KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
        commit: c6ba94640cf7b6da902d1d8a1383c7cf2303ca1f
[22/38] KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
        commit: afa72d207e6b5d49ac597fcd04f0865af63cf589
[23/38] KVM: arm64: Change 'pkvm_handle_t' to u16
        commit: 44887977ab0fdaa0af4d1cc97cda413884c0ef86
[24/38] KVM: arm64: Annotate guest donations with handle and gfn in host stage-2
        commit: 70346d632b4d98dd33391fa263ab8bed7d9d934f
[25/38] KVM: arm64: Introduce hypercall to force reclaim of a protected page
        commit: 56080f53a6ad779b971eb7f4f7a232498805d867
[26/38] KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
        commit: 281a38ad2920b5ccfbbc2a0ca0caeee110ad5d6b
[27/38] KVM: arm64: Return -EFAULT from VCPU_RUN on access to a poisoned pte
        commit: 5991916392d844ba6ed6c0d320ac6578f52e39b6
[28/38] KVM: arm64: Add hvc handler at EL2 for hypercalls from protected VMs
        commit: 94c525051542c54907e2d3e9d2b008575829cdc8
[29/38] KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs
        commit: 03313efed5e2ca55e862bf514b907a431ebf642a
[30/38] KVM: arm64: Implement the MEM_UNSHARE hypercall for protected VMs
        commit: 246c976c370de9380660e2bb641758dc0aae8c5c
[31/38] KVM: arm64: Allow userspace to create protected VMs when pKVM is enabled
        commit: 8800dbf6614aad1013ea5f348520a2ce5ba4b6c8
[32/38] KVM: arm64: Add some initial documentation for pKVM
        commit: 287c6981f12a008bafc46f18a3e48540a1172a52
[33/38] KVM: arm64: Extend pKVM page ownership selftests to cover guest donation
        commit: c290df5278fe8c9844b93751620664c3ca3b6e00
[34/38] KVM: arm64: Register 'selftest_vm' in the VM table
        commit: 8972a991606bc021249ae53a95c131a79fdeda4a
[35/38] KVM: arm64: Extend pKVM page ownership selftests to cover forced reclaim
        commit: f4a5a6770af9b87a8e87717e1b97af052979f4ec
[36/38] KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
        commit: feae58b6ee45096b1d8c29076f0d8098d9788e57
[37/38] KVM: arm64: Rename PKVM_PAGE_STATE_MASK
        commit: 5bae7bc6360a7297e0be2c37017fe863b965646d
[38/38] drivers/virt: pkvm: Add Kconfig dependency on DMA_RESTRICTED_POOL
        commit: 61135967fa76d37883d90ccccc5a1cb73e90b94d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


