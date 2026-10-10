Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686DB3C0A07
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639597; cv=none; b=OIlE3+OF7EbdlUAWBvcNNMn5iAu1eM5T39/hEn0n7Kp9jO+xzlUkIZBud/O64GgTRe511z6gBQHqZQsIwBunke5uebL5INkgbRMR8Xyid/J8dWh64Q5pV0h40ymBnE22ypdANogVtfOjysYTd0ngffYEnAdu+YC4gZpbozMXKF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639597; c=relaxed/simple;
	bh=9Y6XB8RP9vVk99VeNTKazmAGD2zCYQaoP8zfrFlBws0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mYGtyfclMK8jhWD8vu6nauOqh3reVVCp+hfwaqtlZySSmOKN3dk/bP0ZUoYOqyeaOqbfVKaW7XaQmABMNbneQKK/0YWck6ixwSBqBDdD5DHIEH7GNYcXXDfm08XjLYNNHX+QS4a2tBnL4MdnMaMUnYAzr3M0wPxKZPozsR1YsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KeGm0v8A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeGm0v8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHlmM2OW8vBgTNNqS2W/Lyj0mc71XENMhVWORgeokPc=;
	b=KeGm0v8Am9Idymk6wT+O/SqFnt1yHVV2AwtkcbJ/W2fqHUKx71J9O5PeYL2sqlTwkTnmsr
	nDUibBg8m/Fpvp79I7xcfJfBFHmsij2Ujdb8ZWACz/z0ngo9In9zRb2cq+nBBGPGjBF4rd
	FsbWPhTSU8+MQrA6PgtF3lJy6kZhxxg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-eklHFRvkPgWBpJ2ToJv5QA-1; Sat,
 10 Oct 2026 13:39:51 +0000
X-MC-Unique: eklHFRvkPgWBpJ2ToJv5QA-1
X-Mimecast-MFC-AGG-ID: eklHFRvkPgWBpJ2ToJv5QA_1791639589
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00B931944B22;
	Sat, 10 Oct 2026 13:39:49 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7850630000E5;
	Sat, 10 Oct 2026 13:39:44 +0000 (UTC)
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
Subject: [PATCH v10 26/26] arm/cpu-features: Document ID reg properties
Date: Sat, 10 Oct 2026 15:36:30 +0200
Message-ID: <20261010133725.642498-27-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: p6QyMZlrzoTxceE3qmVzGYJaIJDh1HuWLjF_s-8i2Ns_1791639589
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Add some documentation for how individual ID registers can be
configured with the host cpu model.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

9 -> 10:
- document the fact some props may be willingly hidden because they
  conflict with legacy composite options
- mention max model too
---
 docs/system/arm/cpu-features.rst | 111 ++++++++++++++++++++++++++++---
 1 file changed, 102 insertions(+), 9 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 10b0eff27e..13454783cf 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -2,8 +2,11 @@ Arm CPU Features
 ================
 
 CPU features are optional features that a CPU of supporting type may
-choose to implement or not.  In QEMU, optional CPU features have
-corresponding boolean CPU proprieties that, when enabled, indicate
+choose to implement or not.  QEMU provides two different mechanisms
+to configure those features:
+
+1. For most CPU models, optional CPU features may have
+corresponding boolean CPU properties that, when enabled, indicate
 that the feature is implemented, and, conversely, when disabled,
 indicate that it is not implemented. An example of an Arm CPU feature
 is the Performance Monitoring Unit (PMU).  CPU types such as the
@@ -31,6 +34,34 @@ running guests in AArch32.
 CPU features that are inherently specific to KVM are
 prefixed with "kvm-" and are described in "KVM VCPU Features".
 
+2. Additionally, the ``host`` and ``max`` CPU models on KVM allow
+overwriting a subset of the ID register fields. Not all ID register
+fields are writable: this depends on the host. For those which are
+writable, and for those only, these models expose
+``SYSREG_<IDREG>_<FIELD>`` properties. IDREG and FIELD names are those
+used in the ARM Architecture Reference Manual. QEMU may still omit some
+writable fields that conflict with legacy composite options (for example
+EL3/secure, MTE, SVE, or pauth).
+
+Values set with those properties override the initial values retrieved
+from the vCPU after legacy composite property settings (``sve``,
+``pauth``, ...) have been applied, whether at machine level or at vCPU
+level.
+
+``SYSREG_<IDREG>_<FIELD>`` properties are applied at the end of the chain
+and do not substitute for legacy composite options. In other words, if
+you want to use pauth, you still need to set ``pauth=on``. Indeed legacy
+options do more than exposing a different value for ID registers. They
+may also interact with KVM to prepare the vCPU for this feature (for
+instance at vCPU init time). Whereas ``SYSREG_<IDREG>_<FIELD>`` properties
+only change the final value of the ID register. Inconsistent settings
+between legacy composite options (at machine level or CPU level) which
+impact the vCPU and low-level ``SYSREG_<IDREG>_<FIELD>`` properties are
+rejected. ``SYSREG_<IDREG>_<FIELD>`` properties are essentially used to
+tune the ``host``/``max`` vCPU model so that it allows migration between
+different hardware.
+
+
 CPU Feature Probing
 ===================
 
@@ -126,13 +157,21 @@ A note about CPU models and KVM
 
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
+In case some features need to be tuned for the guest, and the host kernel
+supports it, the ``host`` and ``max`` models can be instructed to change
+individual ID register field values. This is especially useful for
+migration purposes.
+However, this interface will not allow configuring an arbitrary set of
+features; the ID registers must describe a subset of the host's features,
+and all differences to the host's configuration must actually be supported
+by the kernel to be deconfigured.
 
 Enabling KVM also affects the ``query-cpu-model-expansion`` QMP command.  The
 affect is not only limited to specific features, as pointed out in example
@@ -169,6 +208,15 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
 properties have special semantics (see "SVE CPU Property Parsing
 Semantics").
 
+Additionally, if supported by KVM on the host kernel, the ``host`` and
+``max`` CPU models may be configured via individual ID register field
+properties, for example::
+
+  $ qemu-system-aarch64 -M virt -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
+
+This forces ID_AA64ISAR0_EL1 DP field to 0. The same property syntax works
+with ``-cpu max``.
+
 KVM VCPU Features
 =================
 
@@ -495,3 +543,48 @@ Legal values for ``S`` are 30, 34, 36, and 39; the default is 30.
 
 As with ``x-rme``, the ``x-l0gptsz`` property may be renamed or
 removed in some future QEMU release.
+
+Configuring CPU features via ID register fields
+===============================================
+
+Note that this is currently only supported under KVM, and with the
+``host`` or ``max`` CPU models.
+
+Querying available ID register fields
+-------------------------------------
+
+QEMU will create properties for ID register fields that are reported as
+being writable by the kernel, known to the QEMU instance, and not omitted
+because they conflict with legacy composite options. Therefore, the same
+QEMU binary may expose different properties when run under a different
+kernel.
+
+To find out the available ID register field properties, use the
+``query-cpu-model-expansion`` QMP command::
+
+  (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
+  {"return": {
+   "model": {"name": "host", "props": {
+   "SYSREG_ID_AA64PFR0_EL1_EL2": 1, "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
+   "SYSREG_CTR_EL0_L1Ip": 3, "SYSREG_CTR_EL0_DminLine": 4,
+   "SYSREG_ID_AA64MMFR0_EL1_BIGEND": 1, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0,
+   "SYSREG_ID_AA64MMFR2_EL1_CnP": 1, "SYSREG_ID_DFR0_EL1_PerfMon": 4,
+   "SYSREG_ID_AA64PFR0_EL1_DIT": 0, "SYSREG_ID_AA64MMFR1_EL1_HAFDBS": 2,
+   "SYSREG_ID_AA64ISAR0_EL1_FHM": 0, "SYSREG_ID_AA64ISAR2_EL1_CSSC": 0,
+   "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
+   }}}}
+
+If a certain field in an ID register does not show up in this list, it is
+either not writable with the specific host kernel, unknown to this QEMU
+build, or intentionally not exposed because it overlaps a legacy composite
+option.
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

