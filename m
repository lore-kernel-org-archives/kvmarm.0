Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A45C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:19:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 544EE4B7D8;
	Wed,  2 Nov 2022 19:19:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NRqChlbs6Xgk; Wed,  2 Nov 2022 19:19:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 628764B839;
	Wed,  2 Nov 2022 19:19:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 119244B7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UcoaJMQu4iNv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:49 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 789F34B813
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:48 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 p5-20020a170902e74500b001884ba979f8so212974plf.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=gDhPLBi4i5H6cHaf8a2jrjVYop+4Ek8Lw09caIJYwao=;
 b=TuudOMSXAL7adsZOBmgYh538VYcYhWF5nhP0M4YVJQfWwg0r4dUZ36mJ33yxVd2Fh8
 AhcLUX3yIkB9ibk1KInatQW3m5g/Xb1UjUv/pTYWyo/nNdUKM/jwJQkQp9VPPXPIpTse
 emwOM/6/Ktd+5NIL8TVzYVk2VxBsALjv/ypuxQqcHFi3jRRp2B55ZXqSfMnLEtC/HxSc
 stovQRZYEuaPtf2QjvJsPbzEyMHUcGd/vQxkSYwoxM9lz3prJOeJu1qYoXRdsdqvf9E7
 tjo5AfcasIg3m/lx8wa0nQ72JaxhhT6f9hdOGOiYZcTNcwLRRLBhpjRIkPPAdq+gGp5w
 JrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=gDhPLBi4i5H6cHaf8a2jrjVYop+4Ek8Lw09caIJYwao=;
 b=Ngu/9VzCKuNAkByU1B5XkF0MIF6IZxD2dJ60MGvKm7Ssx2yEvGV7LmgOZnGAkm/9lQ
 Vki+CjuDidxUhIzEdWTcN3Bpm8tFgM0qSYQhIQoRcXr7iYjRnjAZe2tO8+MC8Us5p8uD
 xKw72Q+nBJESMM4NXMPX9ZpVUBfokyOx8rGscFFzZc+js1ws4XUnTBP77u7ZldRrzYXc
 N5oAamRy1/OLi3bpGrCGJiiWke76xGNhMey3OW7VNzUIYYuVbz76aUZQcqI5ktOUsZFF
 2Oi2OkRJ+JXEuYOcKrfhXFOvY3fyhiSalYddWodUamkySaRJ8dCq06yhzChenT2JJcsi
 54Hg==
X-Gm-Message-State: ACrzQf2gtTCIbiDT8Ktxyh1o7cS0EZemzOhXmt0JGesOOURXUIBeuzzW
 ND25781eJIzxO0tLnwUcThlgizF8NNM=
X-Google-Smtp-Source: AMsMyM669E+APVVp8ZI0Da0e6lyqKNtrGNrgTK1Ki9ihR88cZjll+Sj6vtq7kMOQqNwb+vtNMKGRhrCtVeU=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f28b:b0:186:b069:63fc with SMTP id
 k11-20020a170902f28b00b00186b06963fcmr27593726plc.38.1667431187773; Wed, 02
 Nov 2022 16:19:47 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:47 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-21-seanjc@google.com>
Subject: [PATCH 20/44] KVM: MIPS: Setup VZ emulation? directly from
 kvm_mips_init()
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

Invoke kvm_mips_emulation_init() directly from kvm_mips_init() instead
of bouncing through kvm_init()=>kvm_arch_init().  Functionally, this is
a glorified nop as invoking kvm_arch_init() is the very first action
performed by kvm_init().

Emptying kvm_arch_init() will allow dropping the hook entirely once all
architecture implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mips.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index f0a6c245d1ff..75681281e2df 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1012,7 +1012,7 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 int kvm_arch_init(void *opaque)
 {
-	return kvm_mips_emulation_init();
+	return 0;
 }
 
 void kvm_arch_exit(void)
@@ -1636,6 +1636,10 @@ static int __init kvm_mips_init(void)
 	if (ret)
 		return ret;
 
+	ret = kvm_mips_emulation_init();
+	if (ret)
+		return ret;
+
 	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 
 	if (ret)
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
