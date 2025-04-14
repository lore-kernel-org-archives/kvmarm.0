Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE427FD5B
	for <kvmarm@lists.linux.dev>; Mon, 14 Apr 2025 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744648763; cv=none; b=TCRY9tNOZ0/b06P7eBk+BZg1A3Qoakg6n+IEp3FZJYj05dkCeM89X1ETeFtaestA5Oo1QbakWgOogBnWKMdvtw1DkR7uwuJZvlEk+8JJTq8A9cD3dRRIoYK4WLrj0U/SLsuridxFOt5sodyuylokpOyCfcsxTJuewyocvdO0KQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744648763; c=relaxed/simple;
	bh=uR9a2Cp2AY6D+HuB8Sq+AsdWO5sC7EFgI/HSEPSbS64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=YzYMjmjnTB+g0mk6K6DRZe1f2gS2u0i0lDFtR4uVHrrAOKG2HHCJEnnwNcacRY7q+N/4LNVV9xdfIXR70aBVYoqaGwVaQJJyAZclmY5Aa1ikd5UIvB+HP7PukoYBwL89UCWxYNUMWEY1/ldEFFH/jVmk2SQulVduDZqTih2At/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iR8SkmLf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iR8SkmLf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744648761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MJ3tEqi3ZCbAiO+OZfOCuOpqRnEVT5qjZbMbDcAVLR4=;
	b=iR8SkmLftM8+GCbmOYyKCPIOxXakcbpk6fARMtwisskTxRcyK4q4NPRXBdPxIKPAimXrO2
	13iRNIKO/I2Z0bITSIEjbuDlo06Pqd6DKN6BaXNI//hIl48yvQXnHcn/iJINQo8EzTt3y2
	6ggvkulsQM3mwFH64A7h8a1hKgJLz6I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-RO9kshBMO-ywWWohjCR3sw-1; Mon,
 14 Apr 2025 12:39:17 -0400
X-MC-Unique: RO9kshBMO-ywWWohjCR3sw-1
X-Mimecast-MFC-AGG-ID: RO9kshBMO-ywWWohjCR3sw_1744648755
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73E46180AF4F;
	Mon, 14 Apr 2025 16:39:13 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1977E180B487;
	Mon, 14 Apr 2025 16:38:56 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: agraf@csgraf.de,
	shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM host model
Date: Mon, 14 Apr 2025 18:38:39 +0200
Message-ID: <20250414163849.321857-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

[This is on top of v5 of the ID register storage rework:
https://lore.kernel.org/qemu-devel/20250409144304.912325-1-cohuck@redhat.com/T/#t]

It's been a while, but here's finally a respin of the series to make ID
registers configurable directly via the command line.

Major changes from v2 include:
- split out the rework of ID register storage (see above) and rebased on top
  of that
- hopefully improved the documentation
- fixed some bugs along the way (including output of the cpu model expansion
  command, and compilation with HVF on)

Decided against zeroing unknown registers; it's mostly a "dammed if you do,
dammed if you don't" situation as one case or the other will not quite work
as desired, even disregarding fields like AA64PFR1_EL1.MTE_frac where 0
might indicate things we do not support. You'll need to be careful when
doing kernel updates and be explicit with configuring fields.

The current cpu properties stay as they are; we can work on converting them
to compatibility props once we have support for configuring the ID register
fields on the command line for the other accelerators (this is still KVM only.)

The FEAT_xxx features only support a subset of what we need to configure in
real life; for example, different AltraMax machines differ in CTR_EL0, which
is not covered by any FEAT_. It might make sense to provide them as syntactic
sugar on top.

We still have to deal with MIDR/REVIDR/AIDR differences by exploiting
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=d300b0168ea8fd5022a1413bd37ab63f4e5a7d4d
(in a different series.)

I have not ignored the issue of named models on Arm, I just wanted to get the
base infrastructure into place first :)

Real world example (migration Graviton 3 -> 4, thx to Sebastian):

-cpu host,pauth=off,SYSREG_ID_AA64PFR0_EL1_SEL2=0,SYSREG_ID_AA64PFR0_EL1_EL0=1,
 SYSREG_ID_AA64ISAR0_EL1_TLB=0,SYSREG_ID_AA64ISAR0_EL1_TS=0,
 SYSREG_ID_AA64ISAR0_EL1_SM4=0,SYSREG_ID_AA64ISAR0_EL1_SM3=0,
 SYSREG_ID_AA64ISAR1_EL1_SPECRES=0,SYSREG_ID_AA64ISAR1_EL1_SB=0,
 SYSREG_ID_AA64ISAR1_EL1_FRINTTS=0,SYSREG_ID_AA64MMFR0_EL1_TGRAN4_2=1,
 SYSREG_ID_AA64MMFR0_EL1_TGRAN16_2=1,SYSREG_ID_AA64MMFR0_EL1_TGRAN64_2=1

(not including handling MIDR differences, which is out of scope for this series)

Code also available at
https://gitlab.com/cohuck/qemu/-/tree/arm-cpu-model-rfcv3?ref_type=heads


Cornelia Huck (5):
  arm/cpu: Add generated sysreg properties
  kvm: kvm_get_writable_id_regs
  arm/cpu: accessors for writable id registers
  arm-qmp-cmds: introspection for ID register props
  arm/cpu-features: document ID reg properties

Eric Auger (5):
  arm/cpu: Add infra to handle generated ID register definitions
  arm/cpu: Add sysreg properties generation
  arm/kvm: Allow reading all the writable ID registers
  arm/kvm: write back modified ID regs to KVM
  arm/cpu: more customization for the kvm host cpu model

 docs/system/arm/cpu-features.rst      | 104 +++-
 scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++
 scripts/update-aarch64-sysreg-code.sh |   5 +-
 target/arm/arm-qmp-cmds.c             |  19 +
 target/arm/cpu-custom.h               |  60 +++
 target/arm/cpu-sysreg-properties.c    | 713 ++++++++++++++++++++++++++
 target/arm/cpu-sysregs.h              |   2 +
 target/arm/cpu.c                      |  12 +
 target/arm/cpu.h                      |  47 ++
 target/arm/cpu64.c                    |  24 +-
 target/arm/kvm.c                      | 289 ++++++++++-
 target/arm/kvm_arm.h                  |  26 +-
 target/arm/meson.build                |   1 +
 target/arm/trace-events               |   6 +
 14 files changed, 1617 insertions(+), 16 deletions(-)
 create mode 100755 scripts/gen-cpu-sysreg-properties.awk
 create mode 100644 target/arm/cpu-custom.h
 create mode 100644 target/arm/cpu-sysreg-properties.c

-- 
2.49.0

