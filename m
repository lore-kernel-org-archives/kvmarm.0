Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2511C76026
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756137134; cv=none; b=jIRIyyCyE4D0lkRDM5MxQE/udYyxW6y7z/VLg0USlSZYW7RC1uAUUtNEkSnRCt1asDpZwKPq/gYTRq4yY8wpXak65fURkAIzmQw564e0kPq610COmNS781rEj2cDV6ofq+i4d3mZprDOlY39NJ5uq0bkalxVcdUeByTb/RjzViY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756137134; c=relaxed/simple;
	bh=KZkhA/kQOmp5Oy93QMxfpEXKqa6Fo2q74cwH7XYOoXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=JHP+CjG/4SWOlpKB7n6HrV16gQEoqs66fu/MYOU1CdB6QPCYejtOSqA+8Kpt9iJCpIo04xARZvAomtaEzQivhkCr4RyQck5eNDhnYiJOZ9JpoJ4U2F8FmoF851RgaNwL9Ydlf7OhS8wGfYIMNSegmc+p+l4gWuV4s/gnxJhJC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OPCBtIBg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OPCBtIBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756137132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ed6qfTFHMUqyUn8kqjL4nj7yM5M0u0oh4hNGYHbww5c=;
	b=OPCBtIBgbbPpWnlUqiNTfGcjkKnbrBL1ShPg0cmIpqaRl+SXNM4WwayfxdvnqytsiaUa6f
	34kJ4oVplFatvfD8oic8ucvOywuuMxe4HJpWDL03N8OqLmn0CaoUiaf7NqOY4bLcRw+73w
	McRuiRpkAjx/Go4+DeR8Zea5VSfsw/Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-PCYMmeMyPWW7dRxEesKhoA-1; Mon, 25 Aug 2025 11:52:10 -0400
X-MC-Unique: PCYMmeMyPWW7dRxEesKhoA-1
X-Mimecast-MFC-AGG-ID: PCYMmeMyPWW7dRxEesKhoA_1756137129
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso32699115e9.1
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 08:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756137129; x=1756741929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ed6qfTFHMUqyUn8kqjL4nj7yM5M0u0oh4hNGYHbww5c=;
        b=MNlmsd5cS3RGMUrVBAmwZh5ibOYz/lsFtJEicVL35/gPsAwC14EOWot0mV433arRfG
         A/vDkjL+ICWh7n4w3DzuLDV2Q1BFpv7AeDnFXcoNPjWSj75F4HAtQy1F7802IDiCYLA3
         66RV2iTpQ+KdiQB04MDkr67gdq7zw1eLDR69Y1rglwr25ZoXKxVSMVDJqBkVGu8NDHbz
         ezm27V1JwxFLzEwnMs5lBTjC45PWO7VWT57WhAmXNgPC1zhcCtUVYnhAIBgKEQsHgJbG
         M5plKzTj7sAZiPUXto51jhdlPXdO0YktLTa7rqqMbmxWItLNRHFuEX/1JHsQGY909r6X
         i5uA==
X-Forwarded-Encrypted: i=1; AJvYcCVEkFwaukNEhNN87S01qdudqsR1+Xo/R/sSPJf4aQorZ3idXHNQRVoAOUWXxS78iBSbydxrh6c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCjHigf6cVtcF6WeEiT3j9rU4LRAZxwNIvcJbXCVyY/xXYDKL+
	nTe2fL5rmFgZBw52xxBvrZNvAoxURq2CxdVPiTdp+9cl4CdS26pXCW20e2sd6+/iuQI3LCr9qHK
	R5hzJUahq/kPRequTgAfWpoSJtwsk15VoaBJZgneYlzKCciLqVwzKBk9v069OhPkII0OE
X-Gm-Gg: ASbGncv2V86D+pqeRnplJCNiklzBCjUHVr50pvAJBMrllDSii8spZzYyvx/f5rgt+5v
	1WM6IqS2+xcOqKpd+apZlnADfIZoLy3e8WMlzy54ZVHyDIMm22NbgILnvu8Z26dV42B9ovhQLHP
	S0n2/K6c6WpiYfgisHWOwS2k5yPpOeslzvDAYthiM708f/iJpP7gwZOkucyJ0N6Gt7SekdwcuWu
	GKooHTVb22qzlcEwgLiOSHHbND5hlXJ/c0b6tk565RqlA9VqATIrCSyJgRPEd8F+wZs6ydWey4k
	KRbdO6KUY/bVGhruI87+H4/vwV1bDHy+vE/pQrHc1TP4qGdPQAVAJL1eH/sfr8rQAkpNNIDrREm
	tM1pjDP6EQQynUUkLnCyx/PtTU4k=
X-Received: by 2002:a05:6000:2404:b0:3b8:d30c:885f with SMTP id ffacd0b85a97d-3c5dcefe32fmr10599038f8f.53.1756137128980;
        Mon, 25 Aug 2025 08:52:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXEz5g23IvWuo/ydVi6QeOhq8AK8ymIKqhjfE0JE8EYTvGus+zqYsHwn1w6Z++sXaw7/PNcA==
X-Received: by 2002:a05:6000:2404:b0:3b8:d30c:885f with SMTP id ffacd0b85a97d-3c5dcefe32fmr10599010f8f.53.1756137128539;
        Mon, 25 Aug 2025 08:52:08 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70f237fefsm12155436f8f.30.2025.08.25.08.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 08:52:08 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH] KVM: selftests: fix irqfd_test on arm64
Date: Mon, 25 Aug 2025 17:52:03 +0200
Message-ID: <20250825155203.71989-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kAycSKlFWYRkUiSPWaV-AjdGbVxkWSEhlS4GnQLfnDE_1756137129
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

irqfd_test on arm triggers the following assertion:
==== Test Assertion Failure ====
  include/kvm_util.h:527: !ret
  pid=3643 tid=3643 errno=11 - Resource temporarily unavailable
     1  0x00000000004026d7: kvm_irqfd at kvm_util.h:527
     2  0x0000000000402083: main at irqfd_test.c:100
     3  0x0000ffffa5aab587: ?? ??:0
     4  0x0000ffffa5aab65f: ?? ??:0
     5  0x000000000040236f: _start at ??:?
  KVM_IRQFD failed, rc: -1 errno: 11 (Resource temporarily unavailable)

Fix this by setting up a vgic for the vm.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/irqfd_test.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/irqfd_test.c b/tools/testing/selftests/kvm/irqfd_test.c
index 7c301b4c7005..f7b8766e9d42 100644
--- a/tools/testing/selftests/kvm/irqfd_test.c
+++ b/tools/testing/selftests/kvm/irqfd_test.c
@@ -8,7 +8,11 @@
 #include <stdint.h>
 #include <sys/sysinfo.h>
 
+#include "processor.h"
 #include "kvm_util.h"
+#ifdef __aarch64__
+#include "vgic.h"
+#endif
 
 static struct kvm_vm *vm1;
 static struct kvm_vm *vm2;
@@ -86,14 +90,30 @@ static void juggle_eventfd_primary(struct kvm_vm *vm, int eventfd)
 	kvm_irqfd(vm, GSI_BASE_PRIMARY + 1, eventfd, KVM_IRQFD_FLAG_DEASSIGN);
 }
 
+static struct kvm_vm *test_vm_create(void)
+{
+#ifdef __aarch64__
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	gic_fd = vgic_v3_setup(vm, 1, 64);
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
+
+	return vm;
+#endif
+	return vm_create(1);
+}
+
 int main(int argc, char *argv[])
 {
 	pthread_t racing_thread;
 	int r, i;
 
 	/* Create "full" VMs, as KVM_IRQFD requires an in-kernel IRQ chip. */
-	vm1 = vm_create(1);
-	vm2 = vm_create(1);
+	vm1 = test_vm_create();
+	vm2 = test_vm_create();
 
 	WRITE_ONCE(__eventfd, kvm_new_eventfd());
 
-- 
2.51.0

