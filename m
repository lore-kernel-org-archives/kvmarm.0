Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F74E204C10
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991678; cv=none; b=e1mxve2ZxH1owsksfSERNlPvrtffxTNami8AZ9lgs5jiLqSl0y6RNPJhjsFKUjAifSLZ6CqK42wFgyjhewg00LaTmEaYkOROltjtX6gYqqIL9MhjyuKPeo4ZE8gkI2Gdpsu57ydAq8as3IigYiuNYGPChjSlHr5b2Rj7LEXzZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991678; c=relaxed/simple;
	bh=7ZkxuYgBAPSTA8UIkF7DxMT9dm+DRBpOXVzjn4tF5Oc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lxAifMdEGKXEOf2OZeQ5DqLuXot1Dl5xvIHnMNAfJPeXfmYAmkLRcXM6v1Ycb57hHdfrnWfhBLV8h7D+MSIF9cckrrd2QsbwVolmxj10uwqnNdJdUuaOhhNctU/medk8sPhWwsiEmmAEhlbAbPqSPyVBkskyenM9f3R57wS9QVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kO73ufB4; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kO73ufB4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mdcsKu6oz+eQ+VXuJVJzqkDX7QnLA3MavMcKH3UYZWg=;
	b=kO73ufB4BDVEomcJEKsjyHbi1C5BwR801uLG2nXSkdodpiZv9qpZYqlFq3vVDfDXRL+jfi
	NIHLpW8RLDP314bHAFQBim3tEg0UtKJ9RtSDR/0TCfzfqjf9Bu5aGAmViby4rtE7sY8THe
	VKw+TQAYEUOkWot+uje/BtJRWAdhiNI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 5/9] arm64: Combine kvm-config-arch.h
Date: Fri, 14 Mar 2025 15:25:12 -0700
Message-Id: <20250314222516.1302429-6-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

You get the point...

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-config-arch.h     | 29 -------------------
 .../{arm-common => kvm}/kvm-config-arch.h     | 24 +++++++++++++--
 2 files changed, 22 insertions(+), 31 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/kvm-config-arch.h
 rename arm/include/{arm-common => kvm}/kvm-config-arch.h (54%)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
deleted file mode 100644
index 642fe67..0000000
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/kvm/kvm-config-arch.h
similarity index 54%
rename from arm/include/arm-common/kvm-config-arch.h
rename to arm/include/kvm/kvm-config-arch.h
index 4722d8f..ee031f0 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/kvm/kvm-config-arch.h
@@ -18,17 +18,37 @@ struct kvm_config_arch {
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
+int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
+int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 
 #define OPT_ARCH_RUN(pfx, cfg)							\
 	pfx,									\
-	ARM_OPT_ARCH_RUN(cfg)							\
+	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,			\
+			"Run AArch32 guest"),					\
+	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,				\
+			"Create PMUv3 device. The emulated PMU will be" 	\
+			" set to the PMU associated with the"			\
+			" main thread, unless --vcpu-affinity is set"),		\
+	OPT_BOOLEAN('\0', "disable-mte", &(cfg)->mte_disabled,			\
+			"Disable Memory Tagging Extension"),			\
+	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  			\
+			"Specify the CPU affinity that will apply to "		\
+			"all VCPUs", vcpu_affinity_parser, kvm),		\
+	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,				\
+			"Specify random seed for Kernel Address Space "		\
+			"Layout Randomization (KASLR)"),			\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"		\
+			" stolen time"),					\
+	OPT_CALLBACK('\0', "sve-max-vl", NULL, "vector length",			\
+		     "Specify the max SVE vector length (in bits) for "		\
+		     "all vCPUs", sve_vl_parser, kvm),				\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,			\
 		   ".dtb file", "Dump generated .dtb to specified file"),	\
 	OPT_UINTEGER('\0', "override-bad-firmware-cntfrq", &(cfg)->force_cntfrq,\
 		     "Specify Generic Timer frequency in guest DT to "		\
 		     "work around buggy secure firmware *Firmware should be "	\
 		     "updated to program CNTFRQ correctly*"),			\
-	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, "",			\
+	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, "",				\
 			   "Force virtio devices to use PCI as their default "	\
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
-- 
2.39.5

