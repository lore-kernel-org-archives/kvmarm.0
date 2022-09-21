Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DCEC6FA93
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 00:32:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B8D4B7A7;
	Tue, 20 Sep 2022 20:32:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7u7DbWe8HtAo; Tue, 20 Sep 2022 20:32:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBC34B75D;
	Tue, 20 Sep 2022 20:32:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 438A84B74E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JX-oFPusjqi0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:32:52 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 794E84B731
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:32:51 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 66-20020a251145000000b006a7b4a27d04so3690426ybr.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date;
 bh=MOTPXqlRM/VeyDMLdvanelesLQo1zQAim2hnWRvX5Ck=;
 b=YBqAHda81cZL+XoxjJlGZuZuboXTXgUC0z4uqSgz7QVH6dpNmadTy2MF1qyxWTzse+
 Bm4tIE92SduAzP3ZIMtRF2tHutR8pP7xlWpK1ArY4DnG03povI4wausutZUl5/iFFjm4
 TVHVZG9uLcywTpZWMGs36ucGtqVhhGObHn0VVjekmG1+dp+mNh3xufw2ncJL/mts4ZIh
 7z9P/A8X9TowwqnweXUdspRxboWu77JnECKkB3W0l/4PI0O4qSiM4m96bzkM3yIhCnUQ
 IS3oC/wRtMwluha1XcW0DRroQd63c6ike/sLIVwGS1L4peBPZN+rGOVKwA2aeOQ8Ropo
 ukqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
 bh=MOTPXqlRM/VeyDMLdvanelesLQo1zQAim2hnWRvX5Ck=;
 b=TJxZ4EzLOVh1DmUXrJ/BD0OFAFmvRAkt6nmRi8Xfp8CMoxMgKaiyLRHfMPpxqTgIcL
 roZ6Jb9Zxpmq5N4Mrh2HalinICnF/VM0aVTQLEkn4xLYe8SMdsanIvnzrWfRXCEhb347
 BkEatIZMRLCK+dhS7+gj+uvE7yE5ssm2/CuTccCYln1EtJZ8yhjLFF72lyBjWLeiGfHH
 9spewh+eSTgzP79uanhOKDVdOF03oE9DDDPrBpCLBtTYJ0ehD3yLuyXI4OnBjvc/YBEy
 n8WVzi+kBpUN6RFgDP3cGsvXBodBeefUGOiQ3qfI7Ip6SQYjhYkNzYW65Jy1vEXWlXBs
 z5EQ==
X-Gm-Message-State: ACrzQf21YOPFw8VD/sLYjPq3Csxmin+X31YGHh1fSWDy8ieLwpJWtAUU
 Zh/ycMljqgSkelHC99Cc1CnLLDm7tQA=
X-Google-Smtp-Source: AMsMyM6m3bS7RPF5fQr/eH5ncPqvFCJtkoDqyUevH+R4X807matv5uzc8TD1ePhtwCCU0OlXVNBl8o1DpUw=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9256:0:b0:349:e25e:9bfe with SMTP id
 j83-20020a819256000000b00349e25e9bfemr22039190ywg.111.1663720371023; Tue, 20
 Sep 2022 17:32:51 -0700 (PDT)
Date: Wed, 21 Sep 2022 00:31:51 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-3-seanjc@google.com>
Subject: [PATCH v4 02/12] KVM: nVMX: Make an event request when pending an MTF
 nested VM-Exit
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
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
through inject_pending_event() and thus vmx_check_nested_events() prior
to re-entering the guest.

MTF currently works by virtue of KVM's hack that calls
kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
be removed in the near future.  Until that call is removed, the patch
introduces no real functional change.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 arch/x86/kvm/vmx/vmx.c    | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 85318d803f4f..3a080051a4ec 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6632,6 +6632,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto error_guest_mode;
 
+	if (vmx->nested.mtf_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	return 0;
 
 error_guest_mode:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94c314dc2393..9dba04b6b019 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1665,10 +1665,12 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	    (!vcpu->arch.exception.pending ||
 	     vcpu->arch.exception.vector == DB_VECTOR) &&
 	    (!vcpu->arch.exception_vmexit.pending ||
-	     vcpu->arch.exception_vmexit.vector == DB_VECTOR))
+	     vcpu->arch.exception_vmexit.vector == DB_VECTOR)) {
 		vmx->nested.mtf_pending = true;
-	else
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	} else {
 		vmx->nested.mtf_pending = false;
+	}
 }
 
 static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
