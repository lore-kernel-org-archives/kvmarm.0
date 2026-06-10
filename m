Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51012D0617
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052839; cv=none; b=hxt0gOBDYMs7K1QRVn2BezKuZKLN+NLi6MVjud/7WQaPacCAhJlC9Iwxus8VT5BM9tHJqziko+frQLNX5GRnU5YIIxlSO+98D+svfX9aqzpnE1EwYFHBpQr3De6JcbMzfvfpxXT+wHRJW9fmABlL4qs/L0ex0aSkn4+6+1LC4z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052839; c=relaxed/simple;
	bh=cK0u21533hQOp00QT4x7wZx/zixQd9DS3f8jAIahGlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CLE9qctt7um64v0UUW0UR4g85WopBqIY5BB7Bp+XaL8Fw/E6veKLo/ocs6Co5Tk4cXuRIkCckQXYqMpbpjK/1nnWMM8D7D7ExS9BWMgdIkXnU9JCgkTGfSbGICrEwQ9u2WC/dhtfYc+U9z6PHTNC5uCGRl8TT559U4ek76t5Eog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpDw4C3i; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpDw4C3i"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0c1e112dfso84645115ad.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052836; x=1781657636; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tqxmpm7d/JaqIgSqRfX3CyBlzjwL6Mz/tL0QEbP+aa4=;
        b=tpDw4C3i3aN+y67b3qGLUPipGgJkGYNc/aKblfAcBo1mWBh0UScic3XtmT/gLv0arz
         sAve9BcCGAoM2yrnmzZVwAl5Dgq8+0+e1TtRJwfE4SXuBxoEaqd2AxsRMTBJnpB246k/
         K1moKqVV+t9Aq2wPE6aRnmkhJuNJF9fhnQNgb84BtXA0RQIabJGDVYqP1ZMpRJ8MJ4d4
         5qdBB9allvCcz2aTY++kNodwg6PnERih9gQrEA2plm8h9cQ8HO9n+hUjd95QmNQGAugB
         JDNVQ8C0OZgKaauipgyO46e/Pn/aIZyVLSeo/X21Kimc53d/SKHt8VOpx0bKipv6EMGC
         f5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052836; x=1781657636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tqxmpm7d/JaqIgSqRfX3CyBlzjwL6Mz/tL0QEbP+aa4=;
        b=UDNAV6tArezyI2igSeMXdoTaNdJml+LlDb8FKf9QYmsULzTPyKxhlm6KA0vqaYt4rl
         1NiuESsVNkpuLlU7gzZ2VJX0xQcLyUhgAzhZaXzab6mk+PUhjSz/oLlOXLzcEV33hqTu
         Ys1nR3zWKjXXQ5dg38uwkGE1+IEQTcsdf3tLpiLMk6RGnJwbFQSgp92NHmQyhPffGaoO
         IP20g0FJqZoA+rGOVSYNDehaEKsYrrSHGc76csRfYgZUMf88yhBCEBx4Ov/HOgd0L+PI
         DrG/edTb9zH0Nu5IJ1w4i2+m54cOwy26YyAy6iMPlB6fRiUBAvofYkr9cRbAfzv29/hu
         KskA==
X-Forwarded-Encrypted: i=1; AFNElJ9BEzbMsBod61F9es0zuyUSWYji1KCtKGwddB6N1Ib1fj/OfQZxVqVhh3ePpUXkUrDyoCwNjew=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrKqsq6u8QTGK4PI0DrSXYB1/BhT0oJN4FjZlBY0VnIoD5mAFF
	abRKOHlzIOPnVJRO4Tx/NEc0adCkp6m1PnNB/ORI4LlsDQvNUMZjcu6nYUKjfx3NoiyzCtEzF6g
	s+UVR2g==
X-Received: from plsa5.prod.google.com ([2002:a17:902:b585:b0:2bd:4f41:fbf4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c946:b0:2c2:5446:30dd
 with SMTP id d9443c01a7336-2c254463670mr157005975ad.7.1781052835786; Tue, 09
 Jun 2026 17:53:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:31 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-12-seanjc@google.com>
Subject: [PATCH v6 11/18] KVM: selftests: Make number of IRQs configurable in
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
index 2ad9efd9abc7..15791ba0a2f9 100644
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
2.54.0.1099.g489fc7bff1-goog

