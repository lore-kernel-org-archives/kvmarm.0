Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0363CA49A
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509754; cv=none; b=usORt9yyejgoUi7vt8Pf/SxXovBPMHG7qWKuWIsjbVVhC5kYQwt6MkLUDG7uPVh4cyVmQWpgo8Kz8i6rHHc/1Kp2+aybJ1aSvJO1+kiHpIXVa1VOTgHUqtnRcp/kKo/sW0D2uTQNvQFxV4IyVj7Zf/tRIqbQo6sY1rzOryqN1t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509754; c=relaxed/simple;
	bh=2uyOYEokTiVVIUDBjPDyg1aZa20yup9XuSi/76mLVaY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CWMIXXqNsL46eAD1HSi5/sA6rSXdIHLFqOe1a+DFpTORvP9Ez9yIoWDIEjBATZxhMGrY1YRuEqeyLMvuARnLhxDYpYIQifRv93rU5pusO76lXdMzCvTMds2ZyKaKK6tT1wgjU4jLh5noNylROHo0iFBO7HaxYOZEV7sbHy6njJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vU+zp/q7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vU+zp/q7"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-37c9d82cd57so1032665a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509752; x=1783114552; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MgDHYDGdp3s1Dejk8hKBifIQkaWCPHBgxY5F3+CDVvM=;
        b=vU+zp/q7REnZRbk/G2jTc2NzVMBk9NaYQEoZZDkvEk2JcfC51ljFzwvc1VopC6/HM1
         6Ow+VCJ9PQUtY6l6qcNC1KK2VfXtydSgwhGAR8Dd96+IC1DzEPXsw6/v2zcCzHQ6l8LR
         J0Ii+EGuPKBGjD7RMeXkU3TaCyAodq9/3BNM4II12Uag9B4pgubGWpVq1MPgQsk1Ei75
         nWdagVoFcBSbjsTT7QM7vbXVAQP/RWtxjvi6eysidswXItZyuuUyVD15YTSXBEgIji4D
         sWRega9aHqnk0h6hoP4EoqvxDLobXr7cL8ah0deC/mFSkpxiVHsTgcOk9iRj/AapdEYf
         OKtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509752; x=1783114552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgDHYDGdp3s1Dejk8hKBifIQkaWCPHBgxY5F3+CDVvM=;
        b=QYq3nbILgWDSl58Apw3YbRxXW3taIQLzV3ZoPzv3NVIaBQskgUBGL+blTMNAByXbO6
         F3IKbW4Csc9a86Axt2SKHhmIVSxT/XEg/a8ch2dWGZEAJ6PjKD7UgbjuVLqzrmu+ref6
         IvN7oUDyIrQazxLrCDEWnUYxD0MIT/Qo7emLgHFEf47k4QMiGmGojDjS7TF+TzFD4Lsq
         uEMeXKaAY6e3DOnkVoQN3NwRZcl45++JsvuNulJCHCO5DFNSDlNjuigoHbn7skcQHED5
         PzHPqf5JrHII9rdrQJ8L3iI9x3A1vobJ8CF2vO2Zv934nDz443xZt+8otcHYS/Zh5lip
         FnBA==
X-Forwarded-Encrypted: i=1; AHgh+RrLs+KnYDsRNkXOuR8TGJK2tJBDrMvD/rasRe2wU2ZjVngkTBJkhDuxQwGULuP1AMXahkMUsYY=@lists.linux.dev
X-Gm-Message-State: AOJu0YynO+hQvbv+fsqZkNPxyOfvecUTkgpl/xCF0Qq+ipulpFWZBpFK
	fFyXRC1mQ9egOX6ClpqtEg4+NB1gqAjvnMaTgzSVcTZKQLxM4v/imDsOTviHr+ekUaKKJDoQuI3
	mC5SLOA==
X-Received: from pjbch13.prod.google.com ([2002:a17:90a:f40d:b0:37d:c9ac:4621])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:46:b0:37e:1ff4:44c0
 with SMTP id 98e67ed59e1d1-37e1ff4463cmr2659910a91.12.1782509751839; Fri, 26
 Jun 2026 14:35:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:26 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-14-seanjc@google.com>
Subject: [PATCH v8 13/20] KVM: selftests: Make number of IRQs configurable in
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
index fd03ec940362..bb20bb81e930 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -146,12 +146,13 @@ static const char *probe_iommu_type(void)
 
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
@@ -186,7 +187,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:eht:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ehi:t:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -197,6 +198,9 @@ int main(int argc, char **argv)
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
2.55.0.rc0.799.gd6f94ed593-goog

