Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024780;
	b=Q+0hfE7TVoV1uQHyReRPVd8jIs81uqZr+cCvDKw+PzF7EgHm4l7LSlPPWDgbO9KJHfAA
	 TGcfxau97P1vyp7WbPxsjQsTqd+hQW9RmOitSnpZBQeMQcw9la9zf0J76ig2olNksqXIJ
	 WDGeUS6iYzyq8zVpU9JN2KQ0tH58Y0fw+y3XOPAZTrRISk0FaMwNEF+6NxeAaD+SQOoGw
	 /9QEaEdlWKWfn3cU+7HDOkxNXjpI8CY3E5BB4QlMBL9xU5XKA3gv6S+SuW5SxNGZXP67b
	 eD0WbCJ9nAKzTrcxfblhSyd9pF5XKuHsSo6ZtL3m9+LaYJOG0mx9wze4VOV+RbPszEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024780;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FGWOfYwVcmMVR/wlYDFuHY+4Vl32fUFqmZceclAp0Fs=;
	b=F6xdG8QrPiFP+zuvVsb5xLVrV38ZARLW+Za5w0nQQC3QuTSdt0yYFlwzLdd4VVN3D562
	 +RwMQ+YDnnfTmAHGUOSPYOVETriNXmdn/lwoI+WBm0Ro5MBYsMJfkQGWLVHamv5kvrT0I
	 zS6i7ugZNJljDEnJxDKIQR/5CD+E4oocNy5gBFCM9ElAHxFo4HOdJEvJDdmxxxhYfubCi
	 mfV/YcW+T6mDJqIe3hmK0RidzPu19yq0eEjrBebvJwjUwAIiBaLB+KMygVTWKYQ5FEopK
	 3eYwt8+l0bZi1GZc0Qhag781PtErDRXkzQeVyXc2iLNnCLr/7jt++h3tQ9/Agc4fYFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=o3wPS081;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA861606A332
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA861606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=o3wPS081
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58E5F1596;
	Wed, 18 Nov 2026 09:59:36 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3642C3F632;
	Wed, 18 Nov 2026 09:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024779; bh=ZzySrxLCRitFJJvJhs98l8CuQeyaY78BvXRM1jH99/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3wPS081Z0jerLCLK7t6nCXeg3J1lDrUHAMvAqFgY3H7aVh/8kkFnhJxC0NQSF94y
	 6EfYKzFUsiD5LFkaXPFPITxII/qyZfeeFrdKtYgU6zghwP03coM1KOvRW3wDs7bp5K
	 9cae4+IkvD6lmlf/Z+7rU0jmc25PnxLGnBmFSyS4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 23/23] arm64: Expose the GICv5 ITS irqchip option
Date: Wed, 18 Nov 2026 17:57:55 +0000
Message-Id: <20261118175755.1946977-24-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow --irqchip=gicv5-its now that the ITS DT nodes and PCI MSI
requester mapping are in place. Start automatic irqchip selection at
GICv5 ITS so it is preferred ahead of base GICv5 and older models.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                         | 4 +++-
 arm64/include/kvm/kvm-config-arch.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 1f837049..774a503b 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -81,6 +81,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV3_ITS;
 	} else if (!strcmp(arg, "gicv5")) {
 		*type = IRQCHIP_GICV5;
+	} else if (!strcmp(arg, "gicv5-its")) {
+		*type = IRQCHIP_GICV5_ITS;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -415,7 +417,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_AUTO:
-		for (try = IRQCHIP_GICV5; try >= IRQCHIP_GICV2; try--) {
+		for (try = IRQCHIP_GICV5_ITS; try >= IRQCHIP_GICV2; try--) {
 			err = gic__create(kvm, try);
 			if (!err)
 				break;
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index 46130663..936b142d 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -59,7 +59,7 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
 	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
-		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5]",			\
+		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5|gicv5-its]",		\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-- 
2.34.1

