Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DF75A875
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwvaZe5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D48C433C7;
	Mon, 18 Dec 2023 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702919485;
	bh=ZN3qCC+crw3AxMo4UmJwN32CbBMr9OG1JnGcavCGaCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwvaZe5J4ag6p35k1u+sB8edPDlBSIjIrlsMjKpSb55Rt+DE4Mem+zxhWx11Raelv
	 MkWZE/EOabnAen9YmpwdWMJZaz2K8f3Hh0mLdCWKBFYOZpKjYJZrrFkyIBw9n1Ybiz
	 PIhcMa06MhrEyNzs4CPsPvA9XhsGWC5DxP6a3FxQL/+40gWQNrAn6xS3WAjoQosxup
	 WohitbpwVrHUNsz2Demm0WTE6FImfAJE1viK25V5zDtZx/MMOMbZRs5aVWXluMC9BR
	 27IFLGhhg2kyohhaRnpux4vucqAbyRsMFd0tcTjFvwj1JomXg8S1TD7rSf1i2c4smc
	 Y+SRn0GHAYmig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rFH9G-0057qG-KQ;
	Mon, 18 Dec 2023 17:11:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>
Cc: jingzhangos@google.com,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	joey.gouly@arm.com,
	eric.auger@redhat.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: (subset) [PATCH v3 00/17] KVM: arm64: Fixes to fine grain traps and pKVM traps
Date: Mon, 18 Dec 2023 17:11:19 +0000
Message-Id: <170291942595.3349022.748097050325200963.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
References: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, tabba@google.com, jingzhangos@google.com, broonie@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, eric.auger@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 14 Dec 2023 10:01:40 +0000, Fuad Tabba wrote:
> Changes from v2:
> - Rebased on arm64/for-next/sysregs, which includes new system
>   register definitions (Mark, Joey)
> - Explicitly trap unsupported HFGxTR_EL2 features rather than
>   relying on its nMASK (Joey)
> - Add new system registers to the auto-generated sysreg rather
>   than hardcoding them (Mark)
> - Drop patch that was meant as RFC
> - Added missing system registers, fields, and  system
>   instructions
> - Split patches that make system register changes
> - Fixes to patches defining allowed features for protected VMs
> - Other minor fixes and tidying up
> 
> [...]

Applied to next with the changes agreed on the list.

[05/17] KVM: arm64: Explicitly trap unsupported HFGxTR_EL2 features
        commit: 1565c881c3df053447309ff69ec7fd5dee2085e4
[06/17] KVM: arm64: Add missing HFGxTR_EL2 FGT entries to nested virt
        commit: 9d400eb722bd1be712b007149ff1d8fb2d6470db
[07/17] KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt
        commit: 863ac38984a822ff9f4337d70853d771dcf7aae5
[08/17] KVM: arm64: Add bit masks for HAFGRTR_EL2
        commit: f9d6ed0213021ea00af30efbfa33e9a06c0610f2
[09/17] KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
        commit: 676f482354886caa9b0cfa9236f5d20ac78f8c6a
[10/17] KVM: arm64: Update and fix FGT register masks
        commit: fc04838f9c00fcbc90a8926bbd46928d6fb36477
[11/17] KVM: arm64: Add build validation for FGT trap mask values
        commit: 6c4abbea6d9c09df448b43624074a208c38e68e0
[12/17] KVM: arm64: Use generated FGT RES0 bits instead of specifying them
        commit: 9ff67dd26a9eed9d73dc23aa63e87b16b3382184
[13/17] KVM: arm64: Define FGT nMASK bits relative to other fields
        commit: 5f6bd3f3daaaab8559ad7d2266ba38345231b7ae
[14/17] KVM: arm64: Macros for setting/clearing FGT bits
        commit: 0ccd901da1886cf9dc53ab36ad8f1160b65e41f1
[15/17] KVM: arm64: Fix which features are marked as allowed for protected VMs
        commit: 73e3ce3f4a0e561e24ca71b20de00f03b427981e
[16/17] KVM: arm64: Mark PAuth as a restricted feature for protected VMs
        commit: 21de26dbc5170dde8e4dfbfa1ecb77804ed6a377
[17/17] KVM: arm64: Trap external trace for protected VMs
        commit: 9d52612690985fc0ee1ae1fbad61530a4f6bbb53

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


