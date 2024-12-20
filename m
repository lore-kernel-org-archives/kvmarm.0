Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD505588F
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 09:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734686927; cv=none; b=MG1OEUxnOHcT4ein/4OvcIzvSqlW3nJLROoJwpnRDEidnTUjmhyrnkYKed2S4Tdnd9NcNRtOGelxvdXlGnpagNgxJTYJvGhU2XwgjW8Ntq+9QNYAdox7J7XIwbXzlgW3XceyOht/B1ukwtlhStYWQUyUhLjsgABax7IJVEeWGkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734686927; c=relaxed/simple;
	bh=nQNr0PCt88SZt0GbeRrdGhF8b4BlGoTpw1l4YFvqd4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KpjICtkO/K7O0Hqz73+TpZkl0KWNf7y6U9qoKdxUlnvCFgKRiiZy5X+1+oVnP7o1KEEAlS3UJngBq150NjQvLduZjOlca3zxF7d0+J8pYFD0YB1w59Mqrgeb08ddj5uaKlIB+B1B2e7/J2GOz2as331cVMKtyBp3C6Khl9aRHvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9NjVjsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9NjVjsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC53DC4CECD;
	Fri, 20 Dec 2024 09:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734686926;
	bh=nQNr0PCt88SZt0GbeRrdGhF8b4BlGoTpw1l4YFvqd4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9NjVjszihFlyjhyQkVfyQdwZLUgMdZvZgGEuZndXvBE6MdJ7mGceMfDiYtfU6q1x
	 sfpjtxBAinnqC86oUgrYb86HiONkBY+i87HyKxUC9UM7s1GUAVIXr/dnCMpoviR6BT
	 YEkEjfD61DjyzO2Z6+F8zVXUU8P9M9HgA3WGfZUK2lEorSgzTtKjnS9JhUlfIfLeFU
	 AUfkgu9cw5tbUxKpII1iByo77BTzjJ5nkq1BYnCFPosPwJiWQh7IhfVqKKiEoFSFAd
	 +mio2E57uLI3VZxq9kZUTKHl6nKnQPne6AnQZ96lZS48nO5pjm16TxzSlBCa9Dtx4l
	 z+9EooeA+hxUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tOZJM-005aa7-7U;
	Fri, 20 Dec 2024 09:28:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>
Subject: Re: [PATCH v4 00/19] KVM: arm64: Debug cleanups
Date: Fri, 20 Dec 2024 09:28:40 +0000
Message-Id: <173468686466.1175703.9483191148768498409.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, mizhang@google.com, coltonlewis@google.com, rananta@google.com, james.clark@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 19 Dec 2024 14:40:57 -0800, Oliver Upton wrote:
> Hopefully the last spin! Addressed some review comments, and snuck in
> one more cleanup to the sysreg handlers since that was quite a mess too.
> 
> v3 -> v4:
>  - Collect Tested-by tags from James (thanks!)
>  - Delete stray if condition, second attempt (Marc)
>  - Hoist writes to MDCR_EL2 into kvm_arm_setup_mdcr_el2()
>  - Get rid of the sysreg accessor mess for DBGxVR/DBGxCR
> 
> [...]

Applied to next, with a couple of intermediate changes to make
it bisect without errors or warnings.

[01/19] KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
        commit: 8ca19c40c47d80af369c222662445bbf593666b1
[02/19] KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
        commit: 2417218f2f234fd7880fb193ebf3ae5fcccfa29b
[03/19] KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of vCPU
        commit: 38131c02a53ff691e4c496d65d2d087a5ed42bbf
[04/19] KVM: arm64: Move host SME/SVE tracking flags to host data
        commit: d381e53384a69e35aac417cd6e66afc6c8c11583
[05/19] KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
        commit: b47ffd13fda8275733d573e5799e63e66b5f5361
[06/19] KVM: arm64: Evaluate debug owner at vcpu_load()
        commit: cd9b10102ae38bf0e10b13dbb98c3ead42cf8e1b
[07/19] KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
        commit: 4cefbec97d80247083b84ccc86e32a78c119f705
[08/19] KVM: arm64: Select debug state to save/restore based on debug owner
        commit: 58db67e9accca6d146916203a943568f63754697
[09/19] KVM: arm64: Remove debug tracepoints
        commit: 3b7780945cc8494793040ab0a9805b77b7826abb
[10/19] KVM: arm64: Remove vestiges of debug_ptr
        commit: 803602b0d94168bd25f5ff6eafdfd9388a6dd2ec
[11/19] KVM: arm64: Use debug_owner to track if debug regs need save/restore
        commit: beb470d96cec8dd8f4e05b2135c74d828f7b114b
[12/19] KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
        commit: 06d22a9c1b94006ebfa67693a38baed86b9a75e8
[13/19] KVM: arm64: Compute MDCR_EL2 at vcpu_load()
        commit: 75a5fbaf6623328d3ac69719145c2247f7b4e299
[14/19] KVM: arm64: Don't hijack guest context MDSCR_EL1
        commit: 4ad3a0b87f2ec4714fdfa6bd5de57b4c30e15753
[15/19] KVM: arm64: Manage software step state at load/put
        commit: 2ca3f03bf524c98afa421c479689f1e7dc030bf0
[16/19] KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
        commit: b0ee51033ae35461ae98c465426f0002b8370679
[17/19] KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
        commit: 8c02c2bbd64375e603df79449f0eb2c57e1a597c
[18/19] KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
        commit: 3ce9f3357e9e099f02feaa002769eb99ef1138cd
[19/19] KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads
        commit: c4a6ed85455979ef3fbadc2f1bdf18734b0ecea6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


