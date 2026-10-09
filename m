Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BDB1A2545;
	Fri,  9 Oct 2026 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552490; cv=none; b=ID0qT0BB48iybArCOzIZlhOCosIJl3IHTk/Sz6GSAhs1DD5NnKNiZ0N/YlsgpS9mrJfJbSYvWvAry8XDwTLM8tMFhD20kImLwjd+J8mAnaue5U6zWt6huQyYZPdrG4dD1/6h1rESmYKqwfiWtrPnBkZchaLHLJ6TzT3I2KLArH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552490; c=relaxed/simple;
	bh=qzhNhLe6iKtk1HTEiboaXIMGu0mlnyagHwlCN1tVzRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kbg/u1yACZLURTbKP5l3+1e+m52Qfo+4O7gfFo/2H2p7oeHHhz3bKkdEFBBIG78ibS+jj9IfqnUbLqfrRCMKPXte7rXzduCG/T734Sv5DFDuDISxJERYnSvxX8VPGLPOVEMn7cuXC3k+OFhBdxY7PvKfI7m0CfK9wMj95bnSAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpVVbJo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpVVbJo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A221F000FF;
	Fri,  9 Oct 2026 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552489;
	bh=ssvjJnzGgYY6LCenFj5kMursu0y4wTQOtcvA+OHJhM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpVVbJo8KPnVDzW8Jo0dSP0/W8OB9yaicomwY1PZNXH2uBybGHoy9EmH8CeJp/sMI
	 zrEmi24Aq0xrHX6qtGWSxbb/oer9MaJaBSv2XrtGOlvrl30/JyOqGrRUb7AWPKHHLR
	 BiMhSmX2FaqIfNVfLqU7r1JMfQkKiE8xIqAEAbPWxY8x6u7GVIAWKKa2TlSAGl+lm5
	 wsgvSRci0xHVEdOwwwaXedS8NA7RJTMpvWpLsrS0nT5BjO54PeVz4Lp5YxgGvEJ1RZ
	 PnUg9aN0jlK5a/lB+80ysB3V4iTnmOQf6HaKZpsrYqRu88lfMFtBJDljeUZOY82yOl
	 Wy8/EvMpI16hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xFAdr-00000001179-0PYe;
	Fri, 09 Oct 2026 13:28:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	jonathan.cameron@oss.qualcomm.com,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH v23 00/14] KVM: arm64: CCA: Add basic plumbing for Realms
Date: Fri,  9 Oct 2026 14:28:03 +0100
Message-ID: <179155224299.829527.1733164520192309991.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007073537.2454351-1-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com, jonathan.cameron@oss.qualcomm.com, fuad.tabba@linux.dev, sudeep.holla@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 07 Oct 2026 08:35:23 +0100, Suzuki K Poulose wrote:
> This is a trimmed down and updated version of the v22 of Arm CCA basic
> plumbing series [0]. I have dropped the CCA specific bits for the sake keeping
> them separate. This series now only contains the framework for handling
> different VM types and lay down the path for adding Realm as one of the
> protected VMs. The full support for running Realms under KVM is available as
> an integration branch at [1].
> 
> [...]

Applied to next, thanks!

[01/14] KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
        commit: 3d736a339e9cbeec3841da1a821f56fb3230fd68
[03/14] KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
        commit: 22adb9c3543cc702516c18f0a28e3a8dfcdbeecc
[04/14] KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
        commit: 0c4063f89bfdf204112651f45620ef0c5a691e6b
[05/14] KVM: arm64: Track the type of VM in kvm_arch
        commit: 762ad274c03a13686192d75ef9a354b96114b503
[06/14] KVM: arm64: Don't call vcpu_set_pauth_traps for pKVM host
        commit: 42a4026b435e49af4d5eaae58afe7103ca740c30
[07/14] KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
        commit: 8252f74f9188b9148ec93438e53b8e1b865ffb7b
[08/14] KVM: arm64: Add vcpu load/put call backs for flavors
        commit: 0cb16544ccaceba4c5e8beb2e8ae896278dcf018
[09/14] KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
        commit: fb3926af9d0d5e2e2f58a1f4b2252f529fbe23bf
[10/14] KVM: arm64: Add VM specific callback for S2 MMU operations
        commit: 68933203edddc092b30dd1039167b3262a40a326
[11/14] KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
        commit: 4ee1b583589781bfd47b28da3ce216b2fb51dac5
[12/14] KVM: arm64: Abstract out memory abort handling
        commit: b44a8c32f0116aba0a934c3068628bacda3cd3a3
[13/14] KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
        commit: 37d7ea3f81bbe61f1e895b6c87decadbfe8799eb
[14/14] KVM: arm64: Prevent unsupported vcpu features for VM types
        commit: a467f39afc2a149f9f5efbb7238fb531ade8a86e

FWIW: I've dropped patch #2, which was a duplicate of an equivalent pKVM
change, kept patch #13 (we can simplify things down the line), and hacked
the patch #14 merge so that we don't have to describe things twice.

Of course, mmu.c is where the crap happens, so anyone with any interest
in this stuff being halfway sane, please review the conflict resolution.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


