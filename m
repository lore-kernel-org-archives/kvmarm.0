Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70705C4708E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D3B64B642;
	Wed, 30 Nov 2022 18:10:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JIx35Rgt6rBS; Wed, 30 Nov 2022 18:10:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A23774B647;
	Wed, 30 Nov 2022 18:10:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2975340B80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04-Lahfy2slj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:29 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BBE14B3CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:25 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 r126-20020a632b84000000b004393806c06eso100078pgr.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oZ/AA3AN9yZfFS+Yz2Hj0GA1Db97x+XE1LjIfmdmS/w=;
 b=luHLl3WdRQNdBhH/vZv/hfYOmt9Q6vwep+qjtUAST73H1MF3LqvzoF2Ukv7UaDUlgb
 fXELwkqnEzgBN1h88nvzTImTYOnZGPEMito85bT2cMG/Dw2lvuyXP8zeBz8U2jGVs5tj
 pSDhoig8xe+6jwKUzsQZ0HNL6W7uKODl2j0YOlmoXogdfyORLlX0GkBhzBuT5EaiKGr7
 PCHzZt497tY3kEsEdxjbaw0LnCs8v3tH39skbarsReDUyuZOdzK6YVSLerydaPGb/0Z5
 eHv7VqvGcSRs3JMgPsz9Bq5kCqCHy9eUbAeqCz5po17CqSrTsXQffsEYVsh38nZQAmal
 lJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=oZ/AA3AN9yZfFS+Yz2Hj0GA1Db97x+XE1LjIfmdmS/w=;
 b=25R9E1JG6Xpr/Of2GVssG6Dze0WPvHNpudvjIK2ew4fpT1t62KICfFiMVYV48sJBQi
 oV3tKkJm1zRT+g91oEHN13AdSvlPXKjB1tu0sBxFzjdgqJzMQUWmTqQ+x1VqL8JWTP16
 raNKh4KVCDzX5TV/+DNDaZ3jiYLVgslTOacYgirPDbGC97I0ltYywDXU6rOVhZIFOv1G
 CxrKmAHH6zKjRcdEKMXHuvwFSGtBy8AnBrFp7xtp4yu55JHN4ZGwWP+FbNaB1ZThy7py
 Ed0ATNydI7SGk1QDs5pan/A3j8j4gptWk8uwiv1nXUwy6dvVLKG3dp1phrXt5wNrpT1o
 s6yQ==
X-Gm-Message-State: ANoB5pmeiS2hI5ublYj/bxhV2nljrCYbVfKcJjPOfX1BRbtjgt1AZrs2
 nn6yHDxGBQKN/urij/fA7nHNHv+1Lvk=
X-Google-Smtp-Source: AA0mqf70Xm5b73dwbCTmumj9PiXG1e+aKYb1a7npTh2VM+OaIt1Kg/9NwT12H0mJEQDQr8PRUFC8axppjXM=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f1c5:b0:189:39e4:c0ed with SMTP id
 e5-20020a170902f1c500b0018939e4c0edmr41790703plc.108.1669849824265; Wed, 30
 Nov 2022 15:10:24 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:11 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-28-seanjc@google.com>
Subject: [PATCH v2 27/50] KVM: s390: Do s390 specific init without bouncing
 through kvm_init()
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
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

TW92ZSB0aGUgZ3V0cyBvZiBrdm1fYXJjaF9pbml0KCkgaW50byBhIG5ldyBoZWxwZXIsIF9fa3Zt
X3MzOTBfaW5pdCgpLAphbmQgaW52b2tlIHRoZSBuZXcgaGVscGVyIGRpcmVjdGx5IGZyb20ga3Zt
X3MzOTBfaW5pdCgpIGluc3RlYWQgb2YKYm91bmNpbmcgdGhyb3VnaCBrdm1faW5pdCgpLiAgSW52
b2tpbmcga3ZtX2FyY2hfaW5pdCgpIGlzIHRoZSB2ZXJ5CmZpcnN0IGFjdGlvbiBwZXJmb3JtZWQg
Ynkga3ZtX2luaXQoKSwgaS5lLiB0aGlzIGlzIGEgZ2xvcmlmaWVkIG5vcC4KCk1vdmluZyBzZXR1
cCB0byBfX2t2bV9zMzkwX2luaXQoKSB3aWxsIGFsbG93IHRhZ2dpbmcgbW9yZSBmdW5jdGlvbnMg
YXMKX19pbml0LCBhbmQgZW1wdHlpbmcga3ZtX2FyY2hfaW5pdCgpIHdpbGwgYWxsb3cgZHJvcHBp
bmcgdGhlIGhvb2sKZW50aXJlbHkgb25jZSBhbGwgYXJjaGl0ZWN0dXJlIGltcGxlbWVudGF0aW9u
cyBhcmUgbm9wcy4KCk5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLgoKU2lnbmVkLW9mZi1i
eTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+ClJldmlld2VkLWJ5OiBF
cmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+ClJldmlld2VkLWJ5OiBQaGlsaXBwZSBN
YXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+Ci0tLQogYXJjaC9zMzkwL2t2bS9rdm0t
czM5MC5jIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAyNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvczM5
MC9rdm0va3ZtLXMzOTAuYyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYwppbmRleCA4MjllNmUw
NDYwMDMuLjhjNGZjYWYyYmQzNiAxMDA2NDQKLS0tIGEvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5j
CisrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYwpAQCAtNDY5LDcgKzQ2OSw3IEBAIHN0YXRp
YyB2b2lkIGt2bV9zMzkwX2NwdV9mZWF0X2luaXQodm9pZCkKIAkgKi8KIH0KIAotaW50IGt2bV9h
cmNoX2luaXQodm9pZCAqb3BhcXVlKQorc3RhdGljIGludCBfX2t2bV9zMzkwX2luaXQodm9pZCkK
IHsKIAlpbnQgcmMgPSAtRU5PTUVNOwogCkBAIC01MjcsNyArNTI3LDcgQEAgaW50IGt2bV9hcmNo
X2luaXQodm9pZCAqb3BhcXVlKQogCXJldHVybiByYzsKIH0KIAotdm9pZCBrdm1fYXJjaF9leGl0
KHZvaWQpCitzdGF0aWMgdm9pZCBfX2t2bV9zMzkwX2V4aXQodm9pZCkKIHsKIAlnbWFwX3VucmVn
aXN0ZXJfcHRlX25vdGlmaWVyKCZnbWFwX25vdGlmaWVyKTsKIAlnbWFwX3VucmVnaXN0ZXJfcHRl
X25vdGlmaWVyKCZ2c2llX2dtYXBfbm90aWZpZXIpOwpAQCAtNTQxLDYgKzU0MSwxNiBAQCB2b2lk
IGt2bV9hcmNoX2V4aXQodm9pZCkKIAlkZWJ1Z191bnJlZ2lzdGVyKGt2bV9zMzkwX2RiZl91dik7
CiB9CiAKK2ludCBrdm1fYXJjaF9pbml0KHZvaWQgKm9wYXF1ZSkKK3sKKwlyZXR1cm4gMDsKK30K
Kwordm9pZCBrdm1fYXJjaF9leGl0KHZvaWQpCit7CisKK30KKwogLyogU2VjdGlvbjogZGV2aWNl
IHJlbGF0ZWQgKi8KIGxvbmcga3ZtX2FyY2hfZGV2X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLAog
CQkJdW5zaWduZWQgaW50IGlvY3RsLCB1bnNpZ25lZCBsb25nIGFyZykKQEAgLTU2OTYsNyArNTcw
Niw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBub25oeXBfbWFzayhpbnQgaSkKIAog
c3RhdGljIGludCBfX2luaXQga3ZtX3MzOTBfaW5pdCh2b2lkKQogewotCWludCBpOworCWludCBp
LCByOwogCiAJaWYgKCFzY2xwLmhhc19zaWVmMikgewogCQlwcl9pbmZvKCJTSUUgaXMgbm90IGF2
YWlsYWJsZVxuIik7CkBAIC01NzEyLDEyICs1NzIyLDIzIEBAIHN0YXRpYyBpbnQgX19pbml0IGt2
bV9zMzkwX2luaXQodm9pZCkKIAkJa3ZtX3MzOTBfZmFjX2Jhc2VbaV0gfD0KIAkJCXN0ZmxlX2Zh
Y19saXN0W2ldICYgbm9uaHlwX21hc2soaSk7CiAKLQlyZXR1cm4ga3ZtX2luaXQoTlVMTCwgc2l6
ZW9mKHN0cnVjdCBrdm1fdmNwdSksIDAsIFRISVNfTU9EVUxFKTsKKwlyID0gX19rdm1fczM5MF9p
bml0KCk7CisJaWYgKHIpCisJCXJldHVybiByOworCisJciA9IGt2bV9pbml0KE5VTEwsIHNpemVv
ZihzdHJ1Y3Qga3ZtX3ZjcHUpLCAwLCBUSElTX01PRFVMRSk7CisJaWYgKHIpIHsKKwkJX19rdm1f
czM5MF9leGl0KCk7CisJCXJldHVybiByOworCX0KKwlyZXR1cm4gMDsKIH0KIAogc3RhdGljIHZv
aWQgX19leGl0IGt2bV9zMzkwX2V4aXQodm9pZCkKIHsKIAlrdm1fZXhpdCgpOworCisJX19rdm1f
czM5MF9leGl0KCk7CiB9CiAKIG1vZHVsZV9pbml0KGt2bV9zMzkwX2luaXQpOwotLSAKMi4zOC4x
LjU4NC5nMGYzYzU1ZDRjMi1nb29nCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
