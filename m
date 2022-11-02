Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CDAC4321E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:19:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5834B79B;
	Wed,  2 Nov 2022 19:19:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uVqQk9yPhR3m; Wed,  2 Nov 2022 19:19:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5404B803;
	Wed,  2 Nov 2022 19:19:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54CD84B7A9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2YxTnwsz4qcc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:25 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C854C4B7D8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:21 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 e125-20020a636983000000b0046ed15a8212so78854pgc.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=c745/GhVAupZOShsaNtc5Y0Jm7uB9ydr3S2itBPefjM=;
 b=pj8ZAUMzpQAWjfpeZGv/CFSzOSSwAiDNlmMCeDtMJXA3Ia6uRvLVcV16Cymca0aHXC
 PM6wRe31jjgcVPugCvX2WsyNtqvMLIJF0v+Ys/n5Nq2k4svZOYnhn3INYaYp+USpd+G1
 514pS4WDUrP9flgT5BLdl+/qUHO2eNFQZVTslZCWnmYA53yd76i4Ah4L5OS7bjh89Kxd
 agD1FqGzCkHp/1xQ5FePUye1+JugXCV19Z37h3h0SVTeBVE4gWePoOlMN/4jX90JcqtQ
 h9Xz7vnqCR6lnYHkhGhaSKxff5kFMXnt6v8GUJMP6nlzvcT1qM4okUu+0Q4ETJu9vS+7
 8iTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=c745/GhVAupZOShsaNtc5Y0Jm7uB9ydr3S2itBPefjM=;
 b=ajepJPa5RiYfcMsTDv0Dr33XaI0w7mqBA2/TWqrCOLGAKfdcOkSlDv4Zc5Pc8C6B/Q
 iMSU6HYoxZovE/xc9pCYQNRwMKbB8yTS1zzo2dmW6sA/zxQTNTkUQ5DzrXG+Io3Bq0w9
 7zAfe/ERt1ivuHVFfYHhyy/TqSZbxpduJNk6sNVzaucC1Mmr9mWQQFW9zO7rpGxkr0uH
 FbsjcTGy/MNgSSchxvxPd+gAp2Fr9QBHYTwuXom5SkDHVavobGVRbhl79NcRb69O1HEm
 2ak3zMNxt5Vs8DB8AeG3NsSXW4bo2fBt6/l/zMrL0SqJXj6smv61ipuxqWJUY/Q+hq4v
 JQOw==
X-Gm-Message-State: ACrzQf1eOBGl/Be3BgrhAIIC08EpDckBB51R1NA949PYQqVPYFpsDDto
 JDyC7AYl0TBmq4/riUumjrYibNd4Ex0=
X-Google-Smtp-Source: AMsMyM50bKDX4r1Ac7K4343Hy6JzbUn/G7PmXwa6NG1xDlxuMg48/hoXRC8GNkJYnpu6i2NofBL/D0pMfb0=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8a97:b0:178:1939:c721 with SMTP id
 p23-20020a1709028a9700b001781939c721mr27564226plo.108.1667431161027; Wed, 02
 Nov 2022 16:19:21 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:31 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-5-seanjc@google.com>
Subject: [PATCH 04/44] KVM: Teardown VFIO ops earlier in kvm_exit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Move the call to kvm_vfio_ops_exit() further up kvm_exit() to try and
bring some amount of symmetry to the setup order in kvm_init(), and more
importantly so that the arch hooks are invoked dead last by kvm_exit().
This will allow arch code to move away from the arch hooks without any
change in ordering between arch code and common code in kvm_exit().

That kvm_vfio_ops_exit() is called last appears to be 100% arbitrary.  It
was bolted on after the fact by commit 571ee1b68598 ("kvm: vfio: fix
unregister kvm_device_ops of vfio").  The nullified kvm_device_ops_table
is also local to kvm_main.c and is used only when there are active VMs,
so unless arch code is doing something truly bizarre, nullifying the
table earlier in kvm_exit() is little more than a nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b7534cc953b..f592dd4ce8f2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5961,6 +5961,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5970,7 +5971,6 @@ void kvm_exit(void)
 	free_cpumask_var(cpus_hardware_enabled);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
