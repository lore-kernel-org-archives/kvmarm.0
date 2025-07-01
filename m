Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE035306DA2;
	Tue,  1 Jul 2025 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407607; cv=none; b=bqATU7dDgGwtpPD5iQZPQ0kctL3K0G+sKNfx4QBMEGn6d+fhQDYB72FIVZQJD61trQi9KaUc0IsPJoFxKIn1/MZdvXjTQgj2xRTKkQCsFHTLodHXAQGc/lHwH3CV+ggAEqXQ7QxM6EJCRugCRkE4Ym+X3iJGVs02oTuwhPACA7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407607; c=relaxed/simple;
	bh=43NY+bSRhhxrEVankUIT3L/lBrk/enLMCS3BGcN1ccs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lzJ3U6n2NFcpfWa46kwtYnEDwH/3mcqZVG3bV4OOHWTtMColnFbL30DbxJViHqyUrBzggygtU/w6XrrauQsVUsOj91onuUZipt8cCFv6KRs6e3qZ94SMhaaNBzviPgtjDopoG9h4NDXPgxcgQNffaTq2odvVwhODe3tTQOlshCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbH3fMvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbH3fMvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57F6BC4CEEB;
	Tue,  1 Jul 2025 22:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751407607;
	bh=43NY+bSRhhxrEVankUIT3L/lBrk/enLMCS3BGcN1ccs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=JbH3fMvJzqXep0BUBXCHEUrODtBIrRsLKawPnOUp0LCNqC1EUSdjVLqKjnqjemcXe
	 RZBMxvyQyQ1hrskJ8ZvVSUgah94/SslreYO7CrYgDyBYhlJgto8aCc0sfi3qRHQz62
	 fZl+bTunt497HewR1aQVPoFBJmVCUKnOe+MLT9g/owgLZvBvht4TEK6Zmqc7YC/ul8
	 k9erj/1uhs9b1DlUDlomw5Z9dtYFKX/CMZHFAVhqVo93i3c/r2yJhqmJgumg8Quikw
	 R/v3I0vDNi5gK31XbAy7AvUwt0D+1QSRobTFd7nbWXYad749rxggkeN5Y6a8kvbBK/
	 uHLHyL0XYh13A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F3DC8303A;
	Tue,  1 Jul 2025 22:06:47 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Subject: [PATCH v7 0/5] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
Date: Tue, 01 Jul 2025 22:06:33 +0000
Message-Id: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOlbZGgC/2XQTW7DIBCG4atErEsEw6+zyj2qLigeHKTYRNhFr
 SLfvdhSVbcsZ/G8+jRPMmOOOJPL6UkyljjHNNXDvJyIv7lpQBr7ehNgoJhimpaYl5joOA80BEc
 BXDDgO+CKkYoeGUP83IOvb/UOOY10uWV0xwywCpg9CwApJKecPjDfr3EcPyY3LWefxi12i/OS8
 tc+rsCW/AnY/zsKUEaxtzJYpkSn1XVIabjjntqGFHHwXDReVN9r7Y0Ogb+Db7w8+uYPRVavLEM
 0DOs+3nj16zXvGq+ql7x+0iplLTON1wcPpvG6eusZhL6T2Lu/+9d1/Qbf1se+6gEAAA==
X-Change-ID: 20250506-virtio-msg-ffa-22af72c92150
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1751407606; l=4826;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=43NY+bSRhhxrEVankUIT3L/lBrk/enLMCS3BGcN1ccs=;
 b=Qgpxzv+DgnfrsxQCvMNmnx3G57BbKoi+b3bENsB7/bxqi1aBzL7rU949iVXZFfjZTezXJiBCW
 wFGOpbgzwZbC+oskhHyOXp/R4tnZxEiaI5hZeM7v6DODM5H7rLfKT7S
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
addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. Notably,
this patch updates all smc calls to use SMCCC 1.2 as it makes it simpler
to support interfaces that need to accept more than 8 arguments and/or
return more than 4 values. The list of optional/unsupported interfaces
was updated to reflect additions in FF-A 1.2.

Tested by booting Android under QEMU and loading Trusty as the guest
VM and observing the SEND_DIRECT2 ABI being used successfully during
guest boot.

Changes in v7:
- 0/6:        Revised cover letter slightly
- 4/6:        ffa_call_supported: Clarify optional interfaces
              hyp_ffa_post_init: Sanitize MBZ bits in x2 and x3
              address nit: use GENMASK
- Link to v6: https://lore.kernel.org/r/20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com 

Changes since v5:
- 3/6 -> 2/5: Merged with parent patch as they were closely related
              Don't rename variables from "res" to "regs" to avoid churn
              Update and clarify reasoning for condition added to ffa_set_retval
              Adopt style suggested by Marc when passing regs to arm_smccc_1_2_smc
              Fix inadvertent duplicate statements in ffa_{map,unmap}_hyp_buffers
- Link to v5: https://lore.kernel.org/r/20250619-virtio-msg-ffa-v5-0-412c98558807@google.com

Changes since v4:
- 1/5 -> 1/6: Added Acked-by: Will Deacon <will@kernel.org>
              Reworded patch subject and description
- 2/5:        Dropped patch: zero x4-x7 in ffa_set_retval
-        2/6: New: use SMCCC 1.2 during hyp init
-        3/6: New: use SMCCC 1.2 in host FF-A handler
- 3/5 -> 4/6: No change; can revisit denylist design in later patchset
              Added Acked-by: Will Deacon <will@kernel.org>
- 4/5 -> 5/6: No change
- 5/5 -> 6/6: No change
- Link to v4: https://lore.kernel.org/r/20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com

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
Per Larsen (5):
      KVM: arm64: Correct return value on host version downgrade attempt
      KVM: arm64: Use SMCCC 1.2 for FF-A initialization and in host handler
      KVM: arm64: Mark FFA_NOTIFICATION_* calls as unsupported
      KVM: arm64: Bump the supported version of FF-A to 1.2
      KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 244 +++++++++++++++++++++++++++------------
 include/linux/arm_ffa.h          |   3 +
 3 files changed, 175 insertions(+), 73 deletions(-)
---
base-commit: 66701750d5565c574af42bef0b789ce0203e3071
change-id: 20250506-virtio-msg-ffa-22af72c92150

Best regards,
-- 
Per Larsen <perlarsen@google.com>


