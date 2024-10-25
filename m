Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776CC1DE3C8
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 10:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729851756; cv=none; b=NSB9pq528nmdM1WiyZu831fdwQoZ462lsBawGsRyywKRxg26gO9g9EArfOZiLamXSkPVH1hv1lYiehTffh3eY/86NveZFQdq6oYvSWcIq+qn4qdXptRLogHWFJELLMzZTNxMyFZANV8uvu8frtNb/s7eVGkNqmlf7LGbL/T2FvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729851756; c=relaxed/simple;
	bh=dNFiLHiyWuscBbCZpQpwGu1fR36iwNRyngMLrY9Jc24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWEfNeP+AwIMb474v9QpfaRVl9WKYWIFNKMwEJblj6blXiblyhyiXEvo7CjOeGqMHjQvFDShnLuXLEo+hp0UJiMzPVX5kLrArmQM6CVQVMz5ouLedoOQu459ki9TEmtOOU7AYdkKXklJF1a3QlgOPRhbrOIbaXEkxeTuqP9W6dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPHQvQ8e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPHQvQ8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729851753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na/5decBOfjXjNm65+tQgO51fwBCM0ftC2cvCUNK2FU=;
	b=LPHQvQ8edD2ADIqpsFEkOwr0xDC2uR1NVTp9QPyGobUxNrVGWj+jVPu3R9LUKOeo0kMyja
	D5JIwt0V6F85t9ejdVP95haS6almfkVY2hueDZVMSjmA18w1gBIz4mPRCy+Cug86QrfMV3
	7yg20o0Hb1Nj0tuS/VehyBGQt/+RsaE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-V0zDiV5xMXC1QMg13lrBzg-1; Fri,
 25 Oct 2024 06:22:30 -0400
X-MC-Unique: V0zDiV5xMXC1QMg13lrBzg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5872A195608A;
	Fri, 25 Oct 2024 10:22:28 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CABCE196BB7D;
	Fri, 25 Oct 2024 10:22:22 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	cohuck@redhat.com,
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
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com
Subject: [RFC 21/21] arm/cpu-features: Document custom vcpu model
Date: Fri, 25 Oct 2024 12:17:40 +0200
Message-ID: <20241025101959.601048-22-eric.auger@redhat.com>
In-Reply-To: <20241025101959.601048-1-eric.auger@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Cornelia Huck <cohuck@redhat.com>

Add some documentation for the custom model.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index a5fb929243..962a2c6c26 100644
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
@@ -29,6 +32,16 @@ supports the feature.  While ``aarch64`` currently only works with KVM,
 it could work with TCG.  CPU features that are specific to KVM are
 prefixed with "kvm-" and are described in "KVM VCPU Features".
 
+2. Alternatively, the ``custom`` CPU model allows to configure optional
+CPU features via the corresponding ID registers. The host kernel allows
+to write a subset of ID register fields. The custom model exposes
+properties for each write ID register fields. Those options are named
+SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
+ARM ARM Reference Manual. They can also be found in the linux
+arch/arm64/tool/sysreg file which is used to automatically generate the
+description for those registers and fields. The custom model is currently
+only implemented for KVM.
+
 CPU Feature Probing
 ===================
 
@@ -106,6 +119,10 @@ As expected they are now all ``false``.
 
 Only the ``pmu`` CPU feature is available.
 
+Probing for the ``custom`` CPU model is working differently. CPU model
+expansion will return the list of available SYSREG properties (matching
+writable ID register fields)
+
 A note about CPU feature dependencies
 -------------------------------------
 
@@ -119,18 +136,30 @@ independently without error.  For these reasons callers should always
 attempt to make their desired changes all at once in order to ensure the
 collection is valid.
 
+When using the ``custom`` CPU model, the provided set of ID registers
+is always evaluated as a whole.
+
 A note about CPU models and KVM
 -------------------------------
 
 Named CPU models generally do not work with KVM.  There are a few cases
 that do work, e.g. using the named CPU model ``cortex-a57`` with KVM on a
-seattle host, but mostly if KVM is enabled the ``host`` CPU type must be
-used.  This means the guest is provided all the same CPU features as the
-host CPU type has.  And, for this reason, the ``host`` CPU type should
-enable all CPU features that the host has by default.  Indeed it's even
-a bit strange to allow disabling CPU features that the host has when using
-the ``host`` CPU type, but in the absence of CPU models it's the best we can
-do if we want to launch guests without all the host's CPU features enabled.
+seattle host, but mostly if KVM is enabled, either the ``host`` or the
+``custom`` CPU types must be used.
+
+Using the ``host`` type means the guest is provided all the same CPU
+features as the host CPU type has.  And, for this reason, the ``host``
+CPU type should enable all CPU features that the host has by default.
+
+In case some features need to be hidden to the guest, ``custom`` model
+shall be used instead. This is especially useful for migration purpose.
+
+The ``custom`` CPU model generally is the better choice if you want more
+flexibility or stability across different machines or with different kernel
+versions. However, even the ``custom`` CPU model will not allow configuring
+an arbitrary set of features; the ID registers must describe a subset of the
+host's features, and all differences to the host's configuration must actually
+be supported by the kernel to be deconfigured.
 
 Enabling KVM also affects the ``query-cpu-model-expansion`` QMP command.  The
 affect is not only limited to specific features, as pointed out in example
@@ -167,6 +196,16 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
 properties have special semantics (see "SVE CPU Property Parsing
 Semantics").
 
+The ``custom`` CPU model needs to be configured via individual ID register
+field properties, for example::
+
+  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
+
+This forces ID_AA64ISAR0_EL1 DP field to 0.
+
+Note that the other CPU feature properties are not supported when using
+this model.
+
 KVM VCPU Features
 =================
 
-- 
2.41.0

