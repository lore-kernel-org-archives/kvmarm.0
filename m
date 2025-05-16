Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14801361;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397650; cv=none; b=UT7ZxIw8EBtLDXxn0PVyhY/fwxPZI9HHoCT++3gtpj+8t7BW3wARnH6YnTH4cyV2j5Rk6uoG8r1CS3a6NhMhln/g2kaRL8I5TRYMmjXbX8kctKiTpVCTPr6hqwoD+HeqCvNsShqeRSvFw9q1wm2jjP5N4zeAE6G/FiLpEfBvp0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397650; c=relaxed/simple;
	bh=y+mm5weWo+9kNZUrNcHd1yv3c9QMyVj137bK/yu+2IQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NWA9PmSJwRQnr5DbQiQJVKiTUjAnqgLgEy+4hpmJEdwS8/ryRpNwS3NDRV0t1jdg+RiGFRXdDA6YFpLVyZzCgLPn/7wLHhrExN4x1bFG2fFBdhSYX/BxP9TQU8W6v32xwzVZKyaiqtDCpkGDJbkW2t5o93RjNK65NLed1UkzFsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcQkNwe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcQkNwe1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A77F7C4CEE4;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747397650;
	bh=y+mm5weWo+9kNZUrNcHd1yv3c9QMyVj137bK/yu+2IQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=NcQkNwe1hRAblU0y/Z8KxQG3iGYAn8ePBhZwT6u6ClIzUdOSsusdpIvBJWKPkuriw
	 a6eKE+D6vMBXeUdXmt7JeZc1NHS0XxbxY8Bz+wnCjadFGhUal8eyt3NZxmJ/NOYimv
	 adnXTTbdFbIFobwr2fhPHrzlwzKy3EDIcAjE2v2ATLY20RMkUIFHhxgvIyG/Q3y1Y+
	 6rL/J7+tCuhnWQWwIT5YsHtl02uxa+ePePqOPCW1TlLw8P4pkwS5jpukQuULEV99FK
	 6KQbO6wYsM17culeW9Qz/dzsoQ6zA+QMa5bsi7uSeXfxDrkjCM7k9fb4prHSpAQ4JU
	 FhzLCnoKivR9w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94302C3ABC9;
	Fri, 16 May 2025 12:14:10 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v4 0/5] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
Date: Fri, 16 May 2025 12:13:59 +0000
Message-Id: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAgsJ2gC/2WOQW7DIBAAvxJx7kawGOLklH9UPVC82CsFE4GLW
 kX+e7GlSml7nMOM5iEKZaYiLoeHyFS5cJobdC8H4Sc3jwQ8NBYo0UgjLVTOCyeIZYQQHCC6cEJ
 /RmWkaNI9U+DPPfj61jjkFGGZMrnnDMomyP6oETvdKVBwp3y7cowfs5uXo09xi01clpS/9rmKW
 /In0P/9qAgSaOi70Eujz9Zcx5TGG+2pbaTqJ1/pf75u/mCtP9kQ1Dv6X/66rt/O9UQQKgEAAA=
 =
X-Change-ID: 20250506-virtio-msg-ffa-22af72c92150
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, sebastianene@google.com, qperret@google.com, 
 qwandor@google.com, arve@android.com, perl@immunant.com, 
 lpieralisi@kernel.org, kernel-team@android.com, tabba@google.com, 
 james.morse@arm.com, armellel@google.com, jean-philippe@linaro.org, 
 ahomescu@google.com, Per Larsen <perlarsen@google.com>, 
 Ayrton Munoz <ayrton@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1747397650; l=3725;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=y+mm5weWo+9kNZUrNcHd1yv3c9QMyVj137bK/yu+2IQ=;
 b=YzR/YMJmP2O7HT5umZO1tXDefZXVOIPW3ZjT4X/487ou9ZmBRtFIlzlCHKeURiH7NXnrHvjh+
 AAqajWtMT4DDZqFxrcC7Cys3ubzFbX+mFNYnYzaTAfcbfXtEPsWX6Ic
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

Hi,

The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
allows registers x4-x17 to be used for the message payload. This patch
set prevents the host from using a lower FF-A version than what has
already been negotiated with the hypervisor. This is necessary because
the hypervisor does not have the necessary compatibility paths to
translate from the hypervisor FF-A version to a previous version.

Support for FF-A 1.2 in the hypervisor is added as a precursor to the
addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. The bulk
of this change has to do with the upgrade to SMCCC 1.2 required by
FF-A 1.2. Additionally, unimplemented FF-A 1.2 interfaces are added to
the list of unsupported functions.

Tested by booting Android under QEMU and loading Trusty as the guest
VM and observing the SEND_DIRECT2 ABI being used successfully during
guest boot.

Changes since v3:
- all:        Remove Signed-off-by: Per Larsen <perl@immunant.com>
- 2/5:        Split out from 2/3, zero x4-x7 in set_ffa_retval
- 3/5:        Split out from 2/3, Mark FFA_NOTIFICATION_* calls as
              unsupported
- 2/3 -> 4/5: Drop ffa_get_hypervisor_version, access hyp_ffa_version
              directly when version negotiation is complete.
- 3/3 -> 5/5: Call ffa_to_smccc_1_2_error directly in
              do_do_ffa_direct_msg2
              Push call to ffa_call_needs_smccc_1_2 lower down by adding
              ffa_get_func_id and ffa_set_retval_smccc_1_x.
              Drop ffa_to_smccc_1_2_regs and ffa_to_smccc_1_2_regs_prop
              as they are no longer used.
- Link to v3: https://lore.kernel.org/r/20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com 

Changes since v2:
- 2/3: Removed files added by mistake.
       Add and use ffa_get_hypervisor_version to access hyp_ffa_version
- 3/3: Use ffa_get_hypervisor_version to access hyp_ffa_version safely
- Link to v2: https://lore.kernel.org/r/20250508-virtio-msg-ffa-v2-0-ed84f8053965@google.com

Changes since v1:
- 1/3: Simplify commit message; drop long comment in do_ffa_version
- 2/3: Correct use of Co-developed-by: footer
       s/arm_smccc_1_2_smc_fallback/arm_smccc_1_x_smc/
       Always access hyp_ffa_version w/lock held
       Remove superfluous comments in ffa_call_supported
       Add and use FFA_FEAT_RXTX_MIN_SZ_MASK instead of constant
       Add FFA_PARTITION_INFO_GET_REGS to calls that require SMCCC 1.2
- 3/3: Always access hyp_ffa_version w/lock held
       Correct formatting

Thanks,
Per Larsen

--
2.49.0

---
To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org

---

---
Per Larsen (5):
      KVM: arm64: Restrict FF-A host version renegotiation
      KVM: arm64: Zero x4-x7 in ffa_set_retval
      KVM: arm64: Mark FFA_NOTIFICATION_* calls as unsupported
      KVM: arm64: Bump the supported version of FF-A to 1.2
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 186 +++++++++++++++++++++++++++++++++++++--
 include/linux/arm_ffa.h          |   3 +
 3 files changed, 182 insertions(+), 8 deletions(-)
---
base-commit: fee3e843b309444f48157e2188efa6818bae85cf
change-id: 20250506-virtio-msg-ffa-22af72c92150

Best regards,
-- 
Per Larsen <perlarsen@google.com>


