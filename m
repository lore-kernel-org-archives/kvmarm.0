Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C5231830
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310054; cv=none; b=dhk7NDRKSvvPcR3GbRoh0zp6DGibpyhPn8qp9OACNcQygmhUakYSB6RBrBAkVmB1HAG1w7jEqGXSMI2Wx4iqxImORKocu2ZGE6H/ybVgfChEz75P9MSGqK/GAUupaoMOCfbNXQWDhdiEma6bjvujclDUGIyTkSwT4TVQ8ctuelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310054; c=relaxed/simple;
	bh=IiGZmkWT3WPoZ6HausMiysXDwCuAXCHgmfEkSM2GYJY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hb5CgxgdMaGHdarrvIMDnCn7MBdoJrNmFCyHZb6Ckcepatx0+3nhRf6fw6VC/GfYJa9wmL7K/yGHNUVhqy9LtU1q7O2rRszefDaUxct7/mgrOaZCFlLVUdT298DWKEx/lNF9vXTO32bDVSAWOisfOzromg4AFIRuDlQZm3pYIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ld1nfJFt; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ld1nfJFt"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8596e4272aso1547999a12.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310052; x=1781914852; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q9sUY/ENZfo/yRx5ubG6cRB6yRWSUsHWXW31a/Wy3XI=;
        b=Ld1nfJFt1LyU7tSD/WrAlvxqdJQlCesvHsIICKgj2VhEv/1/8EmgyzlDSYtIWDBFg9
         uRtXCsR2hO7ONzPFGWMa4ESm5/xx7NpqaV+ym2AkGZWZ6eDsvJ7+BCstwOhR3BxoQPHc
         eXUFBt4IE/a3prRMvRuluX+GW26L46SIb6EcQ4wlCtVGNyKlf4mgpZYEtRBSEZb6z07h
         twwxNsdH7SHfyu4TfcQMfyF4O7q5aEU6WGflzJlWxU0ocWaxSZHwYiqNp6PASG+fGtfQ
         1ZQJKW1eqI3igUG5PU8QWI1T44mSK7dkNYz0wpfEKME1RreH0f5prchsbp7x65bunSC/
         MA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310052; x=1781914852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9sUY/ENZfo/yRx5ubG6cRB6yRWSUsHWXW31a/Wy3XI=;
        b=e79MDxA1IgkUV+STdqQfDWRh3i0ijzLZzvTfR0bVICrBEQSJtlC2io8xY56BjsTEHt
         xLttgd4YlnQPY4lPUb4NleDqKmMNtmUHnwdjUDWpDWcWx/VJiDnXBICE/0LpAIfEJXge
         oh3u1rKiVYq14uleKJUWyMDk8zn4lZHbiqTwSUZVtASJHRe3GRrO1GEjj5IbdKx52rN/
         ougfa2lh3mkKCUTOT5UH1u46jvKwtlI5APf33LH01WgFmy92ZsIcS6z9iWJ0wRHHFfx3
         buI3rInn4Dqz5McFeSZFv5u3RpbHisaYRHuu0kaiMX6EIcMw4n8gEMPps/whH0wIG3xm
         yfAg==
X-Forwarded-Encrypted: i=1; AFNElJ9HkqckPxKaZP1JwrpZIxZ97UJRtDzgt95k0NaWzQ34RcdUgH8ND07+S2u2hdq3ZAyNcDQkaHs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYq1X1JpD66SWx5SYc191CsCfVTLE/xa4ms/a61do1sLv3PHWi
	JznsBDgZrERR03gyPEUrelK3vfi4toTMPxoEQymY0lQpLaCqcORpjeKSlT9YPiPtrqeJaCE+zQy
	cr7n7VQ==
X-Received: from pgpd17.prod.google.com ([2002:a63:bd51:0:b0:c86:13dc:1ee6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f87:b0:3b5:6b5a:4f29
 with SMTP id adf61e73a8af0-3b784012441mr6057241637.30.1781310051467; Fri, 12
 Jun 2026 17:20:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:24 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-14-seanjc@google.com>
Subject: [PATCH v7 13/20] KVM: selftests: Make number of IRQs configurable in
 IRQ test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Extend the eventfd IRQ test with a '-i' flag to let the user specify the
the number of IRQs to generate (instead of hardcoding the test to always
generate 1000 interrupts).

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/irq_test.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 2356912e2272..2cfb6c24e8d6 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -134,12 +134,13 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-t iommu_type]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-t iommu_type]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
 	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
 	printf("-d	Use a VFIO device to send MSI-X interrupts instead of manually signaling the eventfd\n");
 	printf("-e	Set empty GSI routing in-between some interrupts\n");
+	printf("-i	The number of IRQs to generate during the test\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
 	printf("\n");
 	exit(KSFT_FAIL);
@@ -174,7 +175,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:eht:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ehi:t:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -185,6 +186,9 @@ int main(int argc, char **argv)
 		case 'e':
 			set_empty_routing = true;
 			break;
+		case 'i':
+			nr_irqs = atoi_positive("Number of IRQs", optarg);
+			break;
 		case 't':
 			iommu_type = optarg;
 			break;
-- 
2.54.0.1136.gdb2ca164c4-goog

