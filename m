Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFF034BA42
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570198; cv=none; b=OxecWedLrIS8dUivCoPbhPm7O32dCHDso/HuioXAZc57myKkFKDlpc2LWwUQtUQj+2klPFIX41EVhTyEH0NKJpRudOiifx/dfmIwtveAy9jL3jLqhwtJQZFzdIjmQ3wO+9ERDzFWxbivHnUY/fNtSfFBXJZOyTdJ6DthxfU8b+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570198; c=relaxed/simple;
	bh=K7TsinJBeFRDz79yuKIVbPkbAgAcXq01EUz2GHsso7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=R9d0+BPLazHC/b36Egi9ApJslyyRbqMPF9zQxKuz23OTKBhhX8APF6EfRbWv1/DnbrebMexKs7bTv3Kh1UEQ09ARSbW3AxM4E3/Lm9yK5WXal+h0Wc9AuFXVPL8wapD7WgsAD1WYY/xrWcw0QL9KS9ypK6xjsIb38gfNaSnc5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVWw6bem; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVWw6bem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21aU7UhXnHgR/6w5hwgjYgtJnBBg+5g7CRArB90PO+E=;
	b=GVWw6bem7HKyzrTuWcHk5g03Z13B7xHO00J1mg2fju1KGW85xHXvVD4b0pxFLK3RODUfkj
	i9nYY5FU7JRz5g4DmFSilmzACzrC4Cxf/DLvn5vFI3E7pXVAeXZCIrddTmY8wANFNA/Po7
	7XuEqhUf4zpBHhl3pWOzLGkaC7P5ZgY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-711-E1qQf1r2OxKltG9UghULZw-1; Wed,
 16 Sep 2026 10:49:50 -0400
X-MC-Unique: E1qQf1r2OxKltG9UghULZw-1
X-Mimecast-MFC-AGG-ID: E1qQf1r2OxKltG9UghULZw_1789570188
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6B3F185589F;
	Wed, 16 Sep 2026 14:49:48 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ACF9919560AB;
	Wed, 16 Sep 2026 14:49:43 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v9 26/26] arm/cpu-features: document ID reg properties
Date: Wed, 16 Sep 2026 16:45:49 +0200
Message-ID: <20260916144721.751810-27-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: zeMWK9_VoOQONFWkcWuWIb6GsA3U6oUB7gLB8zG7-IM_1789570188
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Add some documentation for how individual ID registers can be
configured with the host cpu model.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 docs/system/arm/cpu-features.rst | 100 ++++++++++++++++++++++++++++---
 1 file changed, 92 insertions(+), 8 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 10b0eff27e..e298e3f503 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -2,7 +2,10 @@ Arm CPU Features
 ================
 
 CPU features are optional features that a CPU of supporting type may
-choose to implement or not.  In QEMU, optional CPU features have
+choose to implement or not.  QEMU provides two different mechanisms
+to configure those features:
+
+1. For most CPU models, optional CPU features may have
 corresponding boolean CPU proprieties that, when enabled, indicate
 that the feature is implemented, and, conversely, when disabled,
 indicate that it is not implemented. An example of an Arm CPU feature
@@ -31,6 +34,31 @@ running guests in AArch32.
 CPU features that are inherently specific to KVM are
 prefixed with "kvm-" and are described in "KVM VCPU Features".
 
+2. Additionally, the ``host`` CPU model on KVM allows to overwrite
+a subset of the ID register fields. Not all ID register fields are
+writable: this depends on host. For those which are writable, and for
+those only, the host model exposes SYSREG_<IDREG>_<FIELD> properties.
+IDREG and FIELD names are those used in the ARM Architecture Reference
+Manual.
+
+Values set with those properties override the initial values retrieved
+from the vcpu after legacy composite property settings (sve, pauth, ...)
+have applied, would it be at machine level of vcpu level.
+
+SYSREG_<IDREG>_<FIELD> properties are applied at the end of the chain
+and do not substitute to legacy composite options. In other words, if
+you want to use pauth, you still need to set pauth=on. Indeed legacy
+options do more than exposing a different value for ID registers. They
+may also interact with KVM to prepare the VCPU for this feature (for
+instance at VCPU init time). Whereas SYSREG_<IDREG>_<FIELD> properties
+only change the final value of the ID register. Inconsistent settings
+between legacy composite options (at machine level of cpu level) which
+impact vcpu and low level SYSREG_<IDREG>_<FIELD> are forbidden and are
+rejected at best. SYSREG_<IDREG>_<FIELD> properties are essentially used
+to tune the host vcpu model so that it allows migration between different
+hardware.
+
+
 CPU Feature Probing
 ===================
 
@@ -126,13 +154,20 @@ A note about CPU models and KVM
 
 Named CPU models generally do not work with KVM.  There are a few cases
 that do work, e.g. using the named CPU model ``cortex-a57`` with KVM on a
-seattle host, but mostly if KVM is enabled the ``host`` CPU type must be
-used.  This means the guest is provided all the same CPU features as the
-host CPU type has.  And, for this reason, the ``host`` CPU type should
-enable all CPU features that the host has by default.  Indeed it's even
-a bit strange to allow disabling CPU features that the host has when using
-the ``host`` CPU type, but in the absence of CPU models it's the best we can
-do if we want to launch guests without all the host's CPU features enabled.
+seattle host, but mostly if KVM is enabled, the ``host`` CPU model must be
+used.
+
+Using the ``host`` type means the guest is provided all the same CPU
+features as the host CPU type has.  And, for this reason, the ``host``
+CPU type should enable all CPU features that the host has by default.
+
+In case some features need to be hidden from the guest, and the host kernel
+supports it, the ``host`` model can be instructed to disable individual
+ID register values. This is especially useful for migration purposes.
+However, this interface will not allow configuring an arbitrary set of
+features; the ID registers must describe a subset of the host's features,
+and all differences to the host's configuration must actually be supported
+by the kernel to be deconfigured.
 
 Enabling KVM also affects the ``query-cpu-model-expansion`` QMP command.  The
 affect is not only limited to specific features, as pointed out in example
@@ -169,6 +204,13 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
 properties have special semantics (see "SVE CPU Property Parsing
 Semantics").
 
+Additionally, if supported by KVM on the host kernel, the ``host`` CPU model
+may be configured via individual ID register field properties, for example::
+
+  $ qemu-system-aarch64 -M virt -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
+
+This forces ID_AA64ISAR0_EL1 DP field to 0.
+
 KVM VCPU Features
 =================
 
@@ -495,3 +537,45 @@ Legal values for ``S`` are 30, 34, 36, and 39; the default is 30.
 
 As with ``x-rme``, the ``x-l0gptsz`` property may be renamed or
 removed in some future QEMU release.
+
+Configuring CPU features via ID register fields
+===============================================
+
+Note that this is currently only supported under KVM, and with the
+``host`` CPU model.
+
+Querying available ID register fields
+-------------------------------------
+
+QEMU will create properties for all ID register fields that are
+reported as being writable by the kernel, and that are known to the
+QEMU instance. Therefore, the same QEMU binary may expose different
+properties when run under a different kernel.
+
+To find out all available writable ID register fields, use the
+``query-cpu-model-expansion`` QMP command::
+
+  (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
+  {"return": {
+   "model": {"name": "host", "props": {
+   "SYSREG_ID_AA64PFR0_EL1_EL3": 1, "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
+   "SYSREG_CTR_EL0_L1Ip": 3, "SYSREG_CTR_EL0_DminLine": 4,
+   "SYSREG_ID_AA64MMFR0_EL1_BIGEND": 1, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0,
+   "SYSREG_ID_AA64MMFR2_EL1_CnP": 1, "SYSREG_ID_DFR0_EL1_PerfMon": 4,
+   "SYSREG_ID_AA64PFR0_EL1_DIT": 0, "SYSREG_ID_AA64MMFR1_EL1_HAFDBS": 2,
+   "SYSREG_ID_AA64ISAR0_EL1_FHM": 0, "SYSREG_ID_AA64ISAR2_EL1_CSSC": 0,
+   "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
+   }}}}
+
+If a certain field in an ID register does not show up in this list, it
+is not writable with the specific host kernel.
+
+A note on compatibility
+-----------------------
+
+A common use case for providing a defined set of ID register values is
+to be able to present a fixed set of features to a guest, often referred
+to as "stable guest ABI". This may take the form of ironing out differences
+between two similar CPUs with the intention of being able to migrate
+between machines with those CPUs, or providing the same CPU across Linux
+kernel updates on the host.
-- 
2.53.0

