Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C51C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE2FF61038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE2FF61038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0B384B15D;
	Fri,  8 Oct 2021 22:13:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AweC-JjfefHa; Fri,  8 Oct 2021 22:13:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E12D4B0D7;
	Fri,  8 Oct 2021 22:13:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC07D4B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id acTqwwmLmubW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:23 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE00E4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:23 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 c16-20020a05620a0cf000b0045f1d55407aso5547791qkj.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=w/H4oIWp6aPNo76SoohcXjeRifcTKNkaEcXswmTfvS8=;
 b=Awo1FqukPn/eCDkoZYrOLJ78QMIWErLo3T1JPAM+azHfyRwj0C0I0SMNEn5GIB2txU
 M8xcuGBE4Pj+vf0eSl8CB+c5E5sQbuIMe89aP9EQE621aganA5V6HDgjMAcaBpBwJFVX
 C3SGKwbSwf16LR8Vkae/cgYp5NG8CH1ijTNN50Rr4HoNERkD2EJxcY2vp85daVtbnuQv
 ioYQxPegF+Cfcf+3bUPz5AVa6rlii3Hi3Y38Qqp1tDmmH+PsFzX9zPNBKfVsQyV5sVUN
 4rGOba9XFbRiNbe1iaNvpJun8hhwygJEEzJPw9IjWbImWyRqKAUCmWW3EdcHL3Zmyd05
 +drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=w/H4oIWp6aPNo76SoohcXjeRifcTKNkaEcXswmTfvS8=;
 b=kCG0nw8yn3wwXRpKBwWc6V7E5uwnyLztbElPjzeNP+/J7x4SU+0lIvsPQ5kjqt7HSm
 EzZIyplGnDMrFGbh5Srh0rGh3DaAdsW2Lki6ljcLaei0Qx8JaDuXkwlUTryOtHV/Ici+
 ZLCYTx5eI6Prg0qhBeVQMH/wFBekvPRE2aAMIZHcNGCC293OwMcdN5LToLlM782I45dz
 3ECcwqFPH88hne05UaXz6CZgq2QibFy4HEZNbWBZd6QILy7MbPYEgemRhKO3uzc9JccW
 SG6sv3P3KzmkgRGE2mIbvI6eggF/Yx/oQfjpkBgqyF6cJLjm5wfEEJ+Nz4LGyizSrmta
 qAtQ==
X-Gm-Message-State: AOAM530c2RgCijzYk3E0WX7ozd+eTi0B4K9/Q8E5TYQEkNlhATM3n0Mp
 dqtF06CS6AtckmbzGg7IE7OaPgG1O4M=
X-Google-Smtp-Source: ABdhPJxfQ527bwjQfHI3Ui/hfU27INsXtrHgzCKRUD4Jie98v/tpcQf1vSHG80RTY51lGOqh4HTdLuZNSsA=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:4b57:: with SMTP id
 e23mr1849346qts.328.1633745603486; 
 Fri, 08 Oct 2021 19:13:23 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:10 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 17/43] KVM: x86: Directly block (instead of "halting")
 UNINITIALIZED vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

Go directly to kvm_vcpu_block() when handling the case where userspace
attempts to run an UNINITIALIZED vCPU.  The vCPU is not halted, nor is it
likely that halt-polling will be successful in this case.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6c17bbed25c..cd51f100e906 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10133,7 +10133,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
-		kvm_vcpu_halt(vcpu);
+		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
