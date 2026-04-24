Received: from the.earth.li (the.earth.li [93.93.131.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7A236D500
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.93.131.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037040; cv=none; b=Tx5InrSpt00ZVK9HFiibwHJVhuutDv3Uo2RFQIgM0CWvwmepcVM+NEklwplkonNvNGWODM+vqgwJnWMq6OFySkDK0ME6prew000zd/rJyJBJuLFbqnwvG3UHpihyvIah0GyCTIcV8vC3P89xj8Q24BxR+9/pFQFeVSQTH2M/wr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037040; c=relaxed/simple;
	bh=1HJ+/OiLY73OfdlVSwbhrZdHIc9dHR6DAd4V97ElNTY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Pw0CmMDicmGBnbtF4+dlYmljvViDj0WI9AecPYhxoG6oRdu6Zr9uMRA1kYWl06Ux5EcwLbD1Z9bchYKMv36LvwUtITzfXuyVAhLNdtghBEWno4CN39+z9UtR2an/pLFdzKsAylMP+LgHF0T//XqwsKQlKDLef3i0ZGbGprXCG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li; spf=pass smtp.mailfrom=earth.li; dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b=sv4a7879; arc=none smtp.client-ip=93.93.131.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earth.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b="sv4a7879"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
	s=the; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:
	Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
	:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
	References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
	List-Owner:List-Archive; bh=JmF0qibZtKOHXTwdjY+VV0OSRsvAx+RxlsILPiao7RI=; b=s
	v4a78795KOSH9KoUfXxgxQi/ESnPuimjFA8bBIWOOVlybU1uicTvPznFO0//UI3POT8JPIpHz4hkT
	7u/UClrD/yH38ufAx9Qvo0hH3rtRis3VxNl/68qsKOKg60KShhIRPKASvARiobeDjoIaOnj0PDSD/
	ydCRBMMR1VFnZuzZP7ycoFaaVfA0M5b7cGkkXs/BXMaPexlfMfM+kbxaum1HXwugfDGzTgVYeWb43
	TMBnC8kOVhe1XP5//No4iJCyq26FZzJ5/eYCVew1xPEs5KDwvFszuNnjhG/9rdTxiMTQveVxHTLEu
	TudIgyHxY7RJJaXbddM8kB2wwHoXlv1mg==;
Received: from noodles by the.earth.li with local (Exim 4.98.2)
	(envelope-from <noodles@earth.li>)
	id 1wGGVV-0000000551k-3EYt;
	Fri, 24 Apr 2026 14:23:45 +0100
Date: Fri, 24 Apr 2026 14:23:45 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	jarkko@kernel.org, jgg@ziepe.ca, sudeep.holla@kernel.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH v3 0/4] Fix IMA + TPM initialisation ordering issue
Message-ID: <cover.1777036497.git.noodles@meta.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a slight reworking of the series from Yeoreum Yun, adding
functionality for IMA initialisation during the late_initcall_sync
stage. This solves the situation where the TPM is not fully registered
at the point IMA wants to initialise, avoiding a failure to correctly
extend TPM measurements from IMA. This has been observed on both Arm
FF-A and SPI attached TPM setups.

As part of this series we also revert the original changes made to the
FF-A driver to try and solve this problem.

(I have left Yeoreum credited in all the diffs except my rework of the
 IMA piece. Yeoreum, please yell if you're not happy with this.)

Patch history
=============
from v2 to v3:
  - Drop ff-a/pKVM diff (this seems to have a separate set of
    discussion)
  - Rework IMA delayed initialisation to avoid delaying when unnecessary
  - Ensure IMA log clearly indicates when we've initialised late

from v1 to v2:
  - add notifier to make ffa-driver pkvm initialised.
  - modify to try initailisation again when IMA coudln't find proper TPM device.
  - https://lore.kernel.org/all/20260417175759.3191279-1-yeoreum.yun@arm.com/#t


Jonathan McDowell (1):
  security: ima: call ima_init() again at late_initcall_sync for defered
    TPM

Yeoreum Yun (3):
  lsm: Allow LSMs to register for late_initcall_sync init
  Revert "tpm: tpm_crb_ffa: try to probe tpm_crb_ffa when it's built-in"
  Revert "firmware: arm_ffa: Change initcall level of ffa_init() to
    rootfs_initcall"

 drivers/char/tpm/tpm_crb_ffa.c            | 19 ++----------
 drivers/firmware/arm_ffa/driver.c         |  2 +-
 include/linux/lsm_hooks.h                 |  2 ++
 security/integrity/ima/ima.h              |  3 +-
 security/integrity/ima/ima_init.c         | 25 ++++++++-------
 security/integrity/ima/ima_main.c         | 37 ++++++++++++++++++++---
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/lsm_init.c                       | 13 ++++++--
 8 files changed, 67 insertions(+), 37 deletions(-)

-- 
2.53.0

