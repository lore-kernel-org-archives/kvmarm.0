Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EB8C433E9
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 00:30:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C85764FF7
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 00:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C85764FF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA2E4B5EC;
	Tue,  9 Mar 2021 19:30:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lNC+jHdqlazL; Tue,  9 Mar 2021 19:30:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 015DF4B5D9;
	Tue,  9 Mar 2021 19:30:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 423344B39A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 19:30:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RdpjwYyuhADl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 19:30:45 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A22764B590
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 19:30:45 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id c11so11591036ilq.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Mar 2021 16:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HYwIHVMurXa3R6as3OvUxWmJFUBMLjiRzzhIiiKP4ME=;
 b=KlgzRB+CEZgxcFGOn//lNka3ixGNj1ZMzKq7WAvbwDFq3xRkgAS3kYK/JIV4nIxm/u
 1FfbdecWvmBbdiWVheE3wUNE32IOWAGMhu8MeFMpPUxkNG6Ic6IXrOYz15juiE5W+eN/
 UwufP8xnomHHhYJZizlFxCzJtMQMPP3AGyXKTMDhs5E9C0vskRVTcj7UvkXA1PH14ykl
 ft27CoJWrjGy2SvqG2c1AGionh3n73Ki0G54VqY7GeECtpHBPlD1in+kzQ+UDi+3daXg
 fS/ssqaH/09kuWnDkSliepIZRP1LHJvuV+kQD5aXzLq5vN3FattwTAMNMi+qTW2bJSmf
 Tddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HYwIHVMurXa3R6as3OvUxWmJFUBMLjiRzzhIiiKP4ME=;
 b=ix7WsPpeuDioOLzPKbkBkQe7oemGrX7X9YJ/EJfBJ8jtzLwcS7p4FUmko39rO08GTh
 OR+GCBVEwW7XPo5XtBL+5T0XnG58jbkAKNIZSqUC9QenX2Y5mRobqQHO+vwMVF6f4yud
 0xzSvr9k+/ULnWedqO4snqm4w6xZTieIcry7JSBf0KYkbfO8ZpLLSO+gJZXZu6f9oEC+
 /p8Uzka6ZZO8mkozMbmFguQBNGBPEipmQGmab2TdUYgwNtMq0hEEk+OdTdzkR5Pok/ZU
 XmmlYQaat95Mwe64LIzRdtwmcWfvPrOi0Tvd0+6U/nUDjLNckmwu1NGzTc1pUutCqW2E
 1CvA==
X-Gm-Message-State: AOAM5330nDyQ+aCxXhV7RWnFfb+UyQRt7oNUg8AOqsyuABBerJN6uXG8
 we2FSreJ1mbImpGwZS4wvIwr1yzLlEBSF7DCnw==
X-Google-Smtp-Source: ABdhPJza+jn+PY8flshTTgOAKq9hoAYgUHER9XS+P4s7skBsrShHEuKgzkWZTeYGcckPt9nBzOg82EPVRau5TPgGJA==
X-Received: from jingzhangos.c.googlers.com
 ([fda3:e722:ac3:10:2b:ff92:c0a8:513])
 (user=jingzhangos job=sendgmr) by 2002:a6b:6f14:: with SMTP id
 k20mr642440ioc.52.1615336245163; Tue, 09 Mar 2021 16:30:45 -0800 (PST)
Date: Wed, 10 Mar 2021 00:30:23 +0000
In-Reply-To: <20210310003024.2026253-1-jingzhangos@google.com>
Message-Id: <20210310003024.2026253-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics in
 binary format
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>, 
 Linux MIPS <linux-mips@vger.kernel.org>, KVM PPC <kvm-ppc@vger.kernel.org>, 
 Linux S390 <linux-s390@vger.kernel.org>, 
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>, 
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Three ioctl commands are added to support binary form statistics data
retrieval. KVM_STATS_GET_INFO, KVM_STATS_GET_NAMES, KVM_STATS_GET_DATA.
KVM_CAP_STATS_BINARY_FORM indicates the capability.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 virt/kvm/kvm_main.c | 115 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 383df23514b9..87dd62516c8b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3464,6 +3464,51 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, fpu);
 		break;
 	}
+	case KVM_STATS_GET_INFO: {
+		struct kvm_stats_info stats_info;
+
+		r = -EFAULT;
+		stats_info.num_stats = VCPU_STAT_COUNT;
+		if (copy_to_user(argp, &stats_info, sizeof(stats_info)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_STATS_GET_NAMES: {
+		struct kvm_stats_names stats_names;
+
+		r = -EFAULT;
+		if (copy_from_user(&stats_names, argp, sizeof(stats_names)))
+			goto out;
+		r = -EINVAL;
+		if (stats_names.size < VCPU_STAT_COUNT * KVM_STATS_NAME_LEN)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_to_user(argp + sizeof(stats_names),
+				kvm_vcpu_stat_strings,
+				VCPU_STAT_COUNT * KVM_STATS_NAME_LEN))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_STATS_GET_DATA: {
+		struct kvm_stats_data stats_data;
+
+		r = -EFAULT;
+		if (copy_from_user(&stats_data, argp, sizeof(stats_data)))
+			goto out;
+		r = -EINVAL;
+		if (stats_data.size < sizeof(vcpu->stat))
+			goto out;
+
+		r = -EFAULT;
+		argp += sizeof(stats_data);
+		if (copy_to_user(argp, &vcpu->stat, sizeof(vcpu->stat)))
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
@@ -3695,6 +3740,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+	case KVM_CAP_STATS_BINARY_FORM:
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
@@ -3825,6 +3871,40 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	}
 }
 
+static long kvm_vm_ioctl_stats_get_data(struct kvm *kvm, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kvm_vcpu *vcpu;
+	struct kvm_stats_data stats_data;
+	u64 *data = NULL, *pdata;
+	int i, j, ret = 0;
+	size_t dsize = (VM_STAT_COUNT + VCPU_STAT_COUNT) * sizeof(*data);
+
+
+	if (copy_from_user(&stats_data, argp, sizeof(stats_data)))
+		return -EFAULT;
+	if (stats_data.size < dsize)
+		return -EINVAL;
+	data = kzalloc(dsize, GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	for (i = 0; i < VM_STAT_COUNT; i++)
+		*(data + i) = *((ulong *)&kvm->stat + i);
+
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		pdata = data + VM_STAT_COUNT;
+		for (i = 0; i < VCPU_STAT_COUNT; i++, pdata++)
+			*pdata += *((u64 *)&vcpu->stat + i);
+	}
+
+	if (copy_to_user(argp + sizeof(stats_data), data, dsize))
+		ret = -EFAULT;
+
+	kfree(data);
+	return ret;
+}
+
 static long kvm_vm_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4001,6 +4081,41 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_STATS_GET_INFO: {
+		struct kvm_stats_info stats_info;
+
+		r = -EFAULT;
+		stats_info.num_stats = VM_STAT_COUNT + VCPU_STAT_COUNT;
+		if (copy_to_user(argp, &stats_info, sizeof(stats_info)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_STATS_GET_NAMES: {
+		struct kvm_stats_names stats_names;
+
+		r = -EFAULT;
+		if (copy_from_user(&stats_names, argp, sizeof(stats_names)))
+			goto out;
+		r = -EINVAL;
+		if (stats_names.size <
+			(VM_STAT_COUNT + VCPU_STAT_COUNT) * KVM_STATS_NAME_LEN)
+			goto out;
+		r = -EFAULT;
+		argp += sizeof(stats_names);
+		if (copy_to_user(argp, kvm_vm_stat_strings,
+				VM_STAT_COUNT * KVM_STATS_NAME_LEN))
+			goto out;
+		argp += VM_STAT_COUNT * KVM_STATS_NAME_LEN;
+		if (copy_to_user(argp, kvm_vcpu_stat_strings,
+				VCPU_STAT_COUNT * KVM_STATS_NAME_LEN))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_STATS_GET_DATA:
+		r =  kvm_vm_ioctl_stats_get_data(kvm, arg);
+		break;
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
