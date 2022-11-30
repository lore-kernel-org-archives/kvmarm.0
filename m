Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90926C47088
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFBB4B5F4;
	Wed, 30 Nov 2022 18:10:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gi5PWDp0szue; Wed, 30 Nov 2022 18:10:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4112A4B602;
	Wed, 30 Nov 2022 18:10:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A04E94079D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 64ABZuHHrRlo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:22 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8557A40A93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:19 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 h185-20020a636cc2000000b0046fc6e0065dso97441pgc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
 :message-id:reply-to;
 bh=5yXQhNujyCn0BKG7v31c4OGaNv+fuibQffzvzfRXOMY=;
 b=h6rsUUCphQInF8YIuJSydp7y3K+kWTxAbyRCfeyJQKJ+Y6qbtiTSAEs1qGlDllqT/J
 MMyCWI1z6QQ9M7p7Zu6QpSl/9m1uIwFhUqPqC0VY2dNxBAtSmKEBK4CCdgkZqO6Ul8Kx
 fACOhEYDJb6v1xuMAezabk8g2ZSsJuhT+lDS/T3ozQuYyR/lRYpg7LUF046Tas5T+NY5
 CeL2ERbYxquxucrniWQA910RogetkvuImYcNKj0ET57pNLum/MqlKCc6KP+V5OUAEk8P
 PnX37vQ/dZrpTC3Oabzm833Uf9cuKd5yhE1OeJVb9W6pQwUrjh0B5ijm+gc3WgDVn+HL
 6XjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=5yXQhNujyCn0BKG7v31c4OGaNv+fuibQffzvzfRXOMY=;
 b=7l/LoJjSErkdXtcZHFbkLo59Pn8hu7kv3zBRzyV0nfg+hsMCnqdFZBIr3iUPT5KAYr
 ruBZwek7xtzg5DNRzqBpKYnEF1GvGZd7nZiaMJseVuhTUTC+kC13azZQGKVIG/3lOGVJ
 HnLwDM8ygAdRXP7tVuPK2VPE17nSbzjpkyl0bi95ib3NHZ4wHZnVbmP3fyXQKYC5Y9Ud
 TIqE1KFk4RDCv/BteGEL7mZaqS1H2kJ8AegkPwAZ1xUo6m63zm5eDtULCc5+gxk/DS0B
 VVZVv8EFQEXYWFSx46wP0h23fMPITfyZdMR87pi0JEP0yi1J9aOQm6n5Uh9gCUvlmyDq
 9jFg==
X-Gm-Message-State: ANoB5pmps7rGI1QoSME3c/FEf8kVby9xS3e3/T+pUf2wQakeMwBebcQw
 bqaTqAiZlDNsZTAT2YhpoNOT6Ac8SPU=
X-Google-Smtp-Source: AA0mqf4uayK8uJVSnmaHjmcUzYqE9zwUJpBZYJxTpzlvsNbotM7JFJFGgIIUFhNbqetWZOK5ykPGKeuQP1w=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8a:b0:188:640f:f400 with SMTP id
 x10-20020a170902ec8a00b00188640ff400mr45576276plg.143.1669849818577; Wed, 30
 Nov 2022 15:10:18 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:08 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-25-seanjc@google.com>
Subject: [PATCH v2 24/50] KVM: RISC-V: Do arch init directly in
 riscv_kvm_init()
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

Rm9sZCB0aGUgZ3V0cyBvZiBrdm1fYXJjaF9pbml0KCkgaW50byByaXNjdl9rdm1faW5pdCgpIGlu
c3RlYWQgb2YKYm91bmNpbmcgdGhyb3VnaCBrdm1faW5pdCgpPT5rdm1fYXJjaF9pbml0KCkuICBG
dW5jdGlvbmFsbHksIHRoaXMgaXMgYQpnbG9yaWZpZWQgbm9wIGFzIGludm9raW5nIGt2bV9hcmNo
X2luaXQoKSBpcyB0aGUgdmVyeSBmaXJzdCBhY3Rpb24KcGVyZm9ybWVkIGJ5IGt2bV9pbml0KCku
CgpNb3Zpbmcgc2V0dXAgdG8gcmlzY3Zfa3ZtX2luaXQoKSwgd2hpY2ggaXMgdGFnZ2VkIF9faW5p
dCwgd2lsbCBhbGxvdwp0YWdnaW5nIG1vcmUgZnVuY3Rpb25zIGFuZCBkYXRhIHdpdGggX19pbml0
IGFuZCBfX3JvX2FmdGVyX2luaXQuICBBbmQKZW1wdHlpbmcga3ZtX2FyY2hfaW5pdCgpIHdpbGwg
YWxsb3cgZHJvcHBpbmcgdGhlIGhvb2sgZW50aXJlbHkgb25jZSBhbGwKYXJjaGl0ZWN0dXJlIGlt
cGxlbWVudGF0aW9ucyBhcmUgbm9wcy4KCk5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLgoK
U2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+ClJl
dmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+CkFj
a2VkLWJ5OiBBbnVwIFBhdGVsIDxhbnVwQGJyYWluZmF1bHQub3JnPgotLS0KIGFyY2gvcmlzY3Yv
a3ZtL21haW4uYyB8IDE4ICsrKysrKysrKy0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS9t
YWluLmMgYi9hcmNoL3Jpc2N2L2t2bS9tYWluLmMKaW5kZXggYTE0NmZhMGNlNGQyLi5jYjA2M2I4
YTlhMGYgMTAwNjQ0Ci0tLSBhL2FyY2gvcmlzY3Yva3ZtL21haW4uYworKysgYi9hcmNoL3Jpc2N2
L2t2bS9tYWluLmMKQEAgLTY2LDYgKzY2LDE1IEBAIHZvaWQga3ZtX2FyY2hfaGFyZHdhcmVfZGlz
YWJsZSh2b2lkKQogfQogCiBpbnQga3ZtX2FyY2hfaW5pdCh2b2lkICpvcGFxdWUpCit7CisJcmV0
dXJuIDA7Cit9CisKK3ZvaWQga3ZtX2FyY2hfZXhpdCh2b2lkKQoreworfQorCitzdGF0aWMgaW50
IF9faW5pdCByaXNjdl9rdm1faW5pdCh2b2lkKQogewogCWNvbnN0IGNoYXIgKnN0cjsKIApAQCAt
MTEwLDE1ICsxMTksNiBAQCBpbnQga3ZtX2FyY2hfaW5pdCh2b2lkICpvcGFxdWUpCiAKIAlrdm1f
aW5mbygiVk1JRCAlbGQgYml0cyBhdmFpbGFibGVcbiIsIGt2bV9yaXNjdl9nc3RhZ2Vfdm1pZF9i
aXRzKCkpOwogCi0JcmV0dXJuIDA7Ci19Ci0KLXZvaWQga3ZtX2FyY2hfZXhpdCh2b2lkKQotewot
fQotCi1zdGF0aWMgaW50IF9faW5pdCByaXNjdl9rdm1faW5pdCh2b2lkKQotewogCXJldHVybiBr
dm1faW5pdChOVUxMLCBzaXplb2Yoc3RydWN0IGt2bV92Y3B1KSwgMCwgVEhJU19NT0RVTEUpOwog
fQogbW9kdWxlX2luaXQocmlzY3Zfa3ZtX2luaXQpOwotLSAKMi4zOC4xLjU4NC5nMGYzYzU1ZDRj
Mi1nb29nCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
