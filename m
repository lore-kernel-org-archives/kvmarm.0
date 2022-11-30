Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EB4C352A1
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C324D40397;
	Wed, 30 Nov 2022 18:10:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ar8vBPSVdw5L; Wed, 30 Nov 2022 18:10:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC11E4B62C;
	Wed, 30 Nov 2022 18:10:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEDE4B3E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f2AhXXxwWBhb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:20 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A4BA4B4D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:15 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 38-20020a630b26000000b004773803dda1so62817pgl.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
 :message-id:reply-to;
 bh=uj+BMG24gpugAApyuMjfHhGTokqhj/HfOHcPzx/7Ixc=;
 b=rXveYksPcbHAdLQWx0Se3mgCcQvIusgWV2YBwsk350kO+gwstaEEoshUZTFpuvac++
 pLds7vX8HQyFV+EXcCsNs4Huph1CvEcQOXAAAxG85uCm3rCCbxscdft2ZxjRveL1foHX
 Lrax89MRhf3bE1bAwMOLphkpziYLo/XzKTjZtkj0KrWsaZWT2gVodfm1c5joltsrB5eF
 W0icMxnX0hgljPZjSz6UkymZcq3fcWnGh4feMzJb8fuOAJykHj0A+tcjteTkrK4SYiHc
 +b7l66OJ0teH4JUbB2xCLD5wxFKLZ8CELPJsM7W7cN4l69kYm6xFX8ZvCrFTJGzWVhEq
 HM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=uj+BMG24gpugAApyuMjfHhGTokqhj/HfOHcPzx/7Ixc=;
 b=bhKGdX/QxiOblSEsqmTo3DUU1xjkxd6y8gyriWcWSEO/5MbZakjlNXTxrexlpQqvSp
 aYn43ULlIKma0aszIPo/d3+qMDi7QkYY9J/0I3gl0MEIYcX7UkbAcB9bbcp0UY0Ub2mR
 Zv24Ngel9I3Weq1kGC0eHQFvKyAv0RmEzwUnmNjIg6aZnQK68vR0J4boPero3RsO3tVv
 JG57OtmpHhYzC//do6UkAsKuuUCywokr+8fTPPHQw6SJjikOdmG1mEyJSyUS+2Ap90DH
 eynBxEKKieiPIAmZi/cuacEEUvODhswIqKEZhE8Mtf9bx4Y2apXWL4lm1WhYZdfvdTeQ
 I12g==
X-Gm-Message-State: ANoB5pmZcFiuHZ8kdeL3NMEWWHTwXQptxixwGtb4KkXXsgOOedCqRn0R
 D8qq7Sm9mESWuGmk7Fg5JRLc2b89Wmg=
X-Google-Smtp-Source: AA0mqf4xYnJCkXbWk/N31ZRo5enbQfT7p8hAsoCQiyumsmQYs6alw3yUJytbRmVQwuUcUkB1fPIndjJ7nUc=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1624:b0:573:993b:ea6d with SMTP id
 e4-20020a056a00162400b00573993bea6dmr46050829pfc.10.1669849814934; Wed, 30
 Nov 2022 15:10:14 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:06 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-23-seanjc@google.com>
Subject: [PATCH v2 22/50] KVM: MIPS: Setup VZ emulation? directly from
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

SW52b2tlIGt2bV9taXBzX2VtdWxhdGlvbl9pbml0KCkgZGlyZWN0bHkgZnJvbSBrdm1fbWlwc19p
bml0KCkgaW5zdGVhZApvZiBib3VuY2luZyB0aHJvdWdoIGt2bV9pbml0KCk9Pmt2bV9hcmNoX2lu
aXQoKS4gIEZ1bmN0aW9uYWxseSwgdGhpcyBpcwphIGdsb3JpZmllZCBub3AgYXMgaW52b2tpbmcg
a3ZtX2FyY2hfaW5pdCgpIGlzIHRoZSB2ZXJ5IGZpcnN0IGFjdGlvbgpwZXJmb3JtZWQgYnkga3Zt
X2luaXQoKS4KCkVtcHR5aW5nIGt2bV9hcmNoX2luaXQoKSB3aWxsIGFsbG93IGRyb3BwaW5nIHRo
ZSBob29rIGVudGlyZWx5IG9uY2UgYWxsCmFyY2hpdGVjdHVyZSBpbXBsZW1lbnRhdGlvbnMgYXJl
IG5vcHMuCgpObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4KClNpZ25lZC1vZmYtYnk6IFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgpSZXZpZXdlZC1ieTogUGhpbGlw
cGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPgotLS0KIGFyY2gvbWlwcy9rdm0v
bWlwcy5jIHwgNiArKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL21pcHMva3ZtL21pcHMuYyBiL2FyY2gvbWlwcy9r
dm0vbWlwcy5jCmluZGV4IGYwYTZjMjQ1ZDFmZi4uNzU2ODEyODFlMmRmIDEwMDY0NAotLS0gYS9h
cmNoL21pcHMva3ZtL21pcHMuYworKysgYi9hcmNoL21pcHMva3ZtL21pcHMuYwpAQCAtMTAxMiw3
ICsxMDEyLDcgQEAgbG9uZyBrdm1fYXJjaF92bV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwgdW5z
aWduZWQgaW50IGlvY3RsLCB1bnNpZ25lZCBsb25nIGFyZykKIAogaW50IGt2bV9hcmNoX2luaXQo
dm9pZCAqb3BhcXVlKQogewotCXJldHVybiBrdm1fbWlwc19lbXVsYXRpb25faW5pdCgpOworCXJl
dHVybiAwOwogfQogCiB2b2lkIGt2bV9hcmNoX2V4aXQodm9pZCkKQEAgLTE2MzYsNiArMTYzNiwx
MCBAQCBzdGF0aWMgaW50IF9faW5pdCBrdm1fbWlwc19pbml0KHZvaWQpCiAJaWYgKHJldCkKIAkJ
cmV0dXJuIHJldDsKIAorCXJldCA9IGt2bV9taXBzX2VtdWxhdGlvbl9pbml0KCk7CisJaWYgKHJl
dCkKKwkJcmV0dXJuIHJldDsKKwogCXJldCA9IGt2bV9pbml0KE5VTEwsIHNpemVvZihzdHJ1Y3Qg
a3ZtX3ZjcHUpLCAwLCBUSElTX01PRFVMRSk7CiAKIAlpZiAocmV0KQotLSAKMi4zOC4xLjU4NC5n
MGYzYzU1ZDRjMi1nb29nCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
