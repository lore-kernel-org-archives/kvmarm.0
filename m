Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031B6C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:04:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9C5661AD2
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9C5661AD2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD464B0C5;
	Tue, 16 Nov 2021 11:04:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jk+FYTt-fepe; Tue, 16 Nov 2021 11:04:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B97AD4B186;
	Tue, 16 Nov 2021 11:04:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B90E4B086
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:04:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EoBOs4cjM754 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 11:04:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB75F4B131
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:04:13 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1DD2D619FA;
 Tue, 16 Nov 2021 16:04:13 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mn0wN-005sTB-4l; Tue, 16 Nov 2021 16:04:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 2/7] KVM: mips: Use kvm_get_vcpu() instead of open-coded
 access
Date: Tue, 16 Nov 2021 16:03:58 +0000
Message-Id: <20211116160403.4074052-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211116160403.4074052-1-maz@kernel.org>
References: <20211116160403.4074052-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
 anup.patel@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, imbrenda@linux.ibm.com, jgross@suse.com, npiggin@gmail.com,
 seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au, f4bug@amsat.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Anup Patel <anup.patel@wdc.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

QXMgd2UgYXJlIGFib3V0IHRvIGNoYW5nZSB0aGUgd2F5IHZjcHVzIGFyZSBhbGxvY2F0ZWQsIG1h
bmRhdGUKdGhlIHVzZSBvZiBrdm1fZ2V0X3ZjcHUoKSBpbnN0ZWFkIG9mIG9wZW4tY29kaW5nIHRo
ZSBhY2Nlc3MuCgpSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPGY0YnVnQGFt
c2F0Lm9yZz4KU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KLS0t
CiBhcmNoL21pcHMva3ZtL2xvb25nc29uX2lwaS5jIHwgNCArKy0tCiBhcmNoL21pcHMva3ZtL21p
cHMuYyAgICAgICAgIHwgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL2t2bS9sb29uZ3Nvbl9pcGkuYyBi
L2FyY2gvbWlwcy9rdm0vbG9vbmdzb25faXBpLmMKaW5kZXggMzY4MWZjOGZiYTM4Li41ZDUzZjMy
ZDgzN2MgMTAwNjQ0Ci0tLSBhL2FyY2gvbWlwcy9rdm0vbG9vbmdzb25faXBpLmMKKysrIGIvYXJj
aC9taXBzL2t2bS9sb29uZ3Nvbl9pcGkuYwpAQCAtMTIwLDcgKzEyMCw3IEBAIHN0YXRpYyBpbnQg
bG9vbmdzb25fdmlwaV93cml0ZShzdHJ1Y3QgbG9vbmdzb25fa3ZtX2lwaSAqaXBpLAogCQlzLT5z
dGF0dXMgfD0gZGF0YTsKIAkJaXJxLmNwdSA9IGlkOwogCQlpcnEuaXJxID0gNjsKLQkJa3ZtX3Zj
cHVfaW9jdGxfaW50ZXJydXB0KGt2bS0+dmNwdXNbaWRdLCAmaXJxKTsKKwkJa3ZtX3ZjcHVfaW9j
dGxfaW50ZXJydXB0KGt2bV9nZXRfdmNwdShrdm0sIGlkKSwgJmlycSk7CiAJCWJyZWFrOwogCiAJ
Y2FzZSBDT1JFMF9DTEVBUl9PRkY6CkBAIC0xMjgsNyArMTI4LDcgQEAgc3RhdGljIGludCBsb29u
Z3Nvbl92aXBpX3dyaXRlKHN0cnVjdCBsb29uZ3Nvbl9rdm1faXBpICppcGksCiAJCWlmICghcy0+
c3RhdHVzKSB7CiAJCQlpcnEuY3B1ID0gaWQ7CiAJCQlpcnEuaXJxID0gLTY7Ci0JCQlrdm1fdmNw
dV9pb2N0bF9pbnRlcnJ1cHQoa3ZtLT52Y3B1c1tpZF0sICZpcnEpOworCQkJa3ZtX3ZjcHVfaW9j
dGxfaW50ZXJydXB0KGt2bV9nZXRfdmNwdShrdm0sIGlkKSwgJmlycSk7CiAJCX0KIAkJYnJlYWs7
CiAKZGlmZiAtLWdpdCBhL2FyY2gvbWlwcy9rdm0vbWlwcy5jIGIvYXJjaC9taXBzL2t2bS9taXBz
LmMKaW5kZXggY2VhY2NhNzRmODA4Li42MjI4YmYzOTZkNjMgMTAwNjQ0Ci0tLSBhL2FyY2gvbWlw
cy9rdm0vbWlwcy5jCisrKyBiL2FyY2gvbWlwcy9rdm0vbWlwcy5jCkBAIC00NzksNyArNDc5LDcg
QEAgaW50IGt2bV92Y3B1X2lvY3RsX2ludGVycnVwdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJ
aWYgKGlycS0+Y3B1ID09IC0xKQogCQlkdmNwdSA9IHZjcHU7CiAJZWxzZQotCQlkdmNwdSA9IHZj
cHUtPmt2bS0+dmNwdXNbaXJxLT5jcHVdOworCQlkdmNwdSA9IGt2bV9nZXRfdmNwdSh2Y3B1LT5r
dm0sIGlycS0+Y3B1KTsKIAogCWlmIChpbnRyID09IDIgfHwgaW50ciA9PSAzIHx8IGludHIgPT0g
NCB8fCBpbnRyID09IDYpIHsKIAkJa3ZtX21pcHNfY2FsbGJhY2tzLT5xdWV1ZV9pb19pbnQoZHZj
cHUsIGlycSk7Ci0tIAoyLjMwLjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
