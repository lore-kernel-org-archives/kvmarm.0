Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7DDC43217
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B28514B285;
	Thu,  3 Nov 2022 12:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r-qD-tyJQ07k; Thu,  3 Nov 2022 12:58:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD3E4B6C8;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 201DB4B653
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:14:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lX2h-pLRDpGH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 03:14:19 -0400 (EDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E52B14B640
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:14:18 -0400 (EDT)
Received: by mail-wm1-f44.google.com with SMTP id
 m29-20020a05600c3b1d00b003c6bf423c71so2707403wms.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 00:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=6Pdpi+9UoXFmBx6WS1nIzeC5GAA4ErfSd67Sd5AqWcg=;
 b=H1aAZTt5omn1creuvv0ovxmACFg4pOnVWmYHZn4E4lfgT71L/+bkBqMdS2VJqi5qOj
 YmATL6SnR5o+XQBpr5Zki/b3eg+7a33Y6+MAjm8hsgmFIym9xbyYuh0hkg0prpG2xE5F
 PuLR8pBfv6BBbgXz9sU9CedCiJ2OZly1K4pMrBC8+JOwPT599bO9tsyb8SJGk4MzThPL
 1kCqwm334cbHc7nOfuU0bDlyQDVQIepbwXFRhrNPfzdSZaSvyNIoq33No6jykj/v3m8W
 r8ppiNCB0xs+LOISHZCIqL+1GiXCOzslnZH2Bev57sQnF5H5kmf2+UwyKku2qWO1cQWO
 MoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=6Pdpi+9UoXFmBx6WS1nIzeC5GAA4ErfSd67Sd5AqWcg=;
 b=8BbR8l8tGRMhksKIPjN8zAJFYccB8VYiutKUM6WMc68SWOUc77WgIaodiAYXWmL2P4
 wIxKRTJsRzeu7Zz34MFxIthUrpMPMH2Sc3AH6pYC1KP/hJdcstABScTCiezI6kZ7ANsw
 u7zj4Gcj2aQSUrQ0wZnvOo22wS5kd6Tjc2DIOO2lr+wj3Po57+/oiHidSKBn/+iLYkqe
 VRGWXd7+99fBocEmZXtOxRNF+goyt8z2aHDUZjLS+nDTgykBHr/hKN822AIzXVKqMZYR
 Utna98H0Ghqs6FXv1HzSlsMpw9XulszkMtkPAsoI1wBgFbrIjDvWf7ZSoVK9vQiXnmig
 lXkA==
X-Gm-Message-State: ACrzQf1DKRraVH70xIfMl1L8yiAO6wWqQ+yoSfIm7DcdXLmp1320Y97i
 czc5GjLOsx+RcteogD+wPEXK/w==
X-Google-Smtp-Source: AMsMyM5MQbAO6gubSSNJTg2fBstLeZi84Spz6yMzRnw+j7KRE9PRabE8XztmxDtlM/M+GTvsQ9gWSw==
X-Received: by 2002:a05:600c:5127:b0:3c6:47ff:5d33 with SMTP id
 o39-20020a05600c512700b003c647ff5d33mr19212651wms.68.1667459657899; 
 Thu, 03 Nov 2022 00:14:17 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net.
 [88.29.181.216]) by smtp.gmail.com with ESMTPSA id
 e7-20020a5d5007000000b00236644228besm34910wrt.40.2022.11.03.00.14.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:14:17 -0700 (PDT)
Message-ID: <cb935198-e2f3-bc9e-a13c-2fa2bf8ea46b@linaro.org>
Date: Thu, 3 Nov 2022 08:14:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 22/44] KVM: RISC-V: Do arch init directly in
 riscv_kvm_init()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-23-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-23-seanjc@google.com>
X-Mailman-Approved-At: Thu, 03 Nov 2022 12:58:44 -0400
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
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMy8xMS8yMiAwMDoxOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBGb2xkIHRoZSBn
dXRzIG9mIGt2bV9hcmNoX2luaXQoKSBpbnRvIHJpc2N2X2t2bV9pbml0KCkgaW5zdGVhZCBvZgo+
IGJvdW5jaW5nIHRocm91Z2gga3ZtX2luaXQoKT0+a3ZtX2FyY2hfaW5pdCgpLiAgRnVuY3Rpb25h
bGx5LCB0aGlzIGlzIGEKPiBnbG9yaWZpZWQgbm9wIGFzIGludm9raW5nIGt2bV9hcmNoX2luaXQo
KSBpcyB0aGUgdmVyeSBmaXJzdCBhY3Rpb24KPiBwZXJmb3JtZWQgYnkga3ZtX2luaXQoKS4KPiAK
PiBNb3Zpbmcgc2V0dXAgdG8gcmlzY3Zfa3ZtX2luaXQoKSwgd2hpY2ggaXMgdGFnZ2VkIF9faW5p
dCwgd2lsbCBhbGxvdwo+IHRhZ2dpbmcgbW9yZSBmdW5jdGlvbnMgYW5kIGRhdGEgd2l0aCBfX2lu
aXQgYW5kIF9fcm9fYWZ0ZXJfaW5pdC4gIEFuZAo+IGVtcHR5aW5nIGt2bV9hcmNoX2luaXQoKSB3
aWxsIGFsbG93IGRyb3BwaW5nIHRoZSBob29rIGVudGlyZWx5IG9uY2UgYWxsCj4gYXJjaGl0ZWN0
dXJlIGltcGxlbWVudGF0aW9ucyBhcmUgbm9wcy4KPiAKPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBp
bnRlbmRlZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNA
Z29vZ2xlLmNvbT4KPiAtLS0KPiAgIGFyY2gvcmlzY3Yva3ZtL21haW4uYyB8IDE4ICsrKysrKysr
Ky0tLS0tLS0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlv
bnMoLSkKClJldmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFy
by5vcmc+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
