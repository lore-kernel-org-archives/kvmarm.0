Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D7CC54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 15:59:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7A54B13D;
	Thu, 22 Sep 2022 11:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1fX-tD5kHFB3; Thu, 22 Sep 2022 11:59:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C254F49DE3;
	Thu, 22 Sep 2022 11:59:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BACD4120D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 09:18:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bwCEEUOxnr1p for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 09:18:09 -0400 (EDT)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com
 [209.85.221.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D25D040BC0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 09:18:09 -0400 (EDT)
Received: by mail-vk1-f171.google.com with SMTP id k9so4904345vke.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 06:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date;
 bh=FmC3Wnd/dYfP2uqwVfxKzutzBThKJES4nPc9HEeo7QQ=;
 b=Nxe2XdnhzBm22I39ltFpO7PcVhHvILN9vHlt4j5fqdD2cMxlt5zjZsMfE45jfUuLxR
 nJ+Pn7k6IhsR01gpHCbkfofPJVSiXR1G2T6naU6s650j8ZN3BY27edhGUSH/ARiQXgRQ
 1oPTciwgBdPrbmnaWHPv3UEm+NF5ChNqmma4ptCUM2q9vS8jr4BGBjDUVvdSstDJPe9+
 rqEDWaKLK9ld1u+wLgJ1Oq+7df59XV1CyBCjaoppxumTNrvtN74pe+7ANxpIzPKfcykw
 n33KFhwGvWqqCoJnTM607RYYO3HBHNta4avh/Jp//D16ES11dJceNnMXeJqpHFlQnNDV
 K5sQ==
X-Gm-Message-State: ACrzQf16uLjm/GqmIk3U0KtHW6YZsrULcDb9YgdhdAj5Uzs0nBAMq7GY
 8F3ftn1MleADz4aokuRfUEIp/tkJtyvYEFEbVEs=
X-Google-Smtp-Source: AMsMyM5hAS5sGeCyGhDs3JB8ybhSoe0SBFugJqR9UWsYlOLvGt3tSKkrbx2I2RYfB9/ZOUlHboLppHif1VOrjItnvws=
X-Received: by 2002:a05:6122:10dc:b0:3a3:4904:2941 with SMTP id
 l28-20020a05612210dc00b003a349042941mr1265866vko.24.1663852689165; Thu, 22
 Sep 2022 06:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
 <20220921003201.1441511-12-seanjc@google.com>
In-Reply-To: <20220921003201.1441511-12-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date: Thu, 22 Sep 2022 15:17:56 +0200
Message-ID: <CAAdtpL4yFdh3V0Be05OKxUFBTSgFs6oTy9U5FjSRGwOhi=tDMQ@mail.gmail.com>
Subject: Re: [PATCH v4 11/12] KVM: mips, x86: do not rely on KVM_REQ_UNHALT
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Thu, 22 Sep 2022 11:59:00 -0400
Cc: kvm <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 open list <linux-kernel@vger.kernel.org>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Atish Patra <atishp@atishpatra.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

T24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMjozNCBBTSBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPgo+Cj4gS1ZNX1JFUV9VTkhBTFQgaXMgYSB3ZWlyZCByZXF1ZXN0IHRoYXQgc2lt
cGx5IHJlcG9ydHMgdGhlIHZhbHVlIG9mCj4ga3ZtX2FyY2hfdmNwdV9ydW5uYWJsZSgpIG9uIGV4
aXQgZnJvbSBrdm1fdmNwdV9oYWx0KCkuICBPbmx5Cj4gTUlQUyBhbmQgeDg2IGFyZSBsb29raW5n
IGF0IGl0LCB0aGUgb3RoZXJzIGp1c3QgY2xlYXIgaXQuICBDaGVjawo+IHRoZSBzdGF0ZSBvZiB0
aGUgdkNQVSBkaXJlY3RseSBzbyB0aGF0IHRoZSByZXF1ZXN0IGlzIGhhbmRsZWQKPiBhcyBhIG5v
cCBvbiBhbGwgYXJjaGl0ZWN0dXJlcy4KPgo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVk
LCBleGNlcHQgZm9yIGNvcm5lciBjYXNlcyB3aGVyZSBhbgo+IGV2ZW50IGFycml2ZSBpbW1lZGlh
dGVseSBhZnRlciBhIHNpZ25hbCBiZWNvbWUgcGVuZGluZyBvciBhZnRlcgo+IGFub3RoZXIgc2lt
aWxhciBob3N0LXNpZGUgZXZlbnQuCj4KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256aW5pIDxw
Ym9uemluaUByZWRoYXQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPgo+IC0tLQo+ICBhcmNoL21pcHMva3ZtL2VtdWxhdGUuYyB8IDcg
KysrLS0tLQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICB8IDkgKysrKysrKystCj4gIDIgZmls
ZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKClJldmlld2VkLWJ5
OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8ZjRidWdAYW1zYXQub3JnPgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
