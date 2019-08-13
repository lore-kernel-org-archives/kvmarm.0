Return-Path: <SRS0=Pedm=WJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4845C32750
	for <kvmarm@archiver.kernel.org>; Tue, 13 Aug 2019 08:53:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E7892063F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Aug 2019 08:53:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E7892063F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4954A50F;
	Tue, 13 Aug 2019 04:53:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bD3mz8yTKSaZ; Tue, 13 Aug 2019 04:53:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 801EF4A4F4;
	Tue, 13 Aug 2019 04:53:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A035B4A4F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Aug 2019 04:53:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0yn3wmGSu5UT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Aug 2019 04:53:00 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA1724A4EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Aug 2019 04:52:59 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 124E0E3933AC374F08C4;
 Tue, 13 Aug 2019 16:52:57 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 13 Aug 2019
 16:52:48 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <qemu-arm@nongnu.org>
Subject: Can we boot a 512U kvm guest?
Message-ID: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
Date: Tue, 13 Aug 2019 16:50:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi folks,

Since commit e25028c8ded0 ("KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to
512"), we seemed to be allowed to boot a 512U guest.  But I failed to
start it up with the latest QEMU.  I guess there are at least *two*
reasons (limitations).

First I got a QEMU abort:
	"kvm_set_irq: Invalid argument"

Enable the trace_kvm_irq_line() under debugfs, when it comed with
vcpu-256, I got:
	"Inject UNKNOWN interrupt (3), vcpu->idx: 0, num: 23, level: 0"
and kvm_vm_ioctl_irq_line() returns -EINVAL to user-space...

So the thing is that we only have 8 bits for vcpu_index field ([23:16])
in KVM_IRQ_LINE ioctl.  irq_type field will be corrupted if we inject a
PPI to vcpu-256, whose vcpu_index will take 9 bits.

I temporarily patched the KVM and QEMU with the following diff:

---8<---
diff --git a/arch/arm64/include/uapi/asm/kvm.h 
b/arch/arm64/include/uapi/asm/kvm.h
index 95516a4..39a0fb1 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -325,10 +325,10 @@ struct kvm_vcpu_events {
  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1

  /* KVM_IRQ_LINE irq field index values */
-#define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_SHIFT		28
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
  #define KVM_ARM_IRQ_VCPU_SHIFT		16
-#define KVM_ARM_IRQ_VCPU_MASK		0xff
+#define KVM_ARM_IRQ_VCPU_MASK		0xfff
  #define KVM_ARM_IRQ_NUM_SHIFT		0
  #define KVM_ARM_IRQ_NUM_MASK		0xffff

---8<---

It makes things a bit better, it also immediately BREAKs the api with
old versions.


Next comes one more QEMU abort (with the "fix" above):
	"Failed to set device address: No space left on device"

We register two io devices (rd_dev and sgi_dev) on KVM_MMIO_BUS for
each redistributor. 512 vcpus take 1024 io devices, which is beyond the
maximum limitation of the current kernel - NR_IOBUS_DEVS (1000).
So we get a ENOSPC error here.


I don't know if the similar problems have been discussed before in ML.
Is it time to really support the 512U guest?


Thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
