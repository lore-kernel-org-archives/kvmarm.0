Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FDFC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 401604B164;
	Thu,  3 Nov 2022 12:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uWnLFsgnXlSR; Thu,  3 Nov 2022 12:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CF74B63B;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DE6F4B653
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:11:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e2SKqNKqJlFy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 03:11:02 -0400 (EDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C52F64B640
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:11:02 -0400 (EDT)
Received: by mail-wm1-f53.google.com with SMTP id
 m7-20020a05600c090700b003cf8a105d9eso529564wmp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 00:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=CvhsZshQWEcVMeUTUtOp+ihfqDRpu56SkXuVG8Len34=;
 b=kHZDPyIo8df19dqlQHWniGoyDch8A+hISU8X6gd7fp1VbScHETGhbytjJYmkhLQHKf
 fwi1nthEtQPwse9uctHll81mNdW31rmNNRadEcJOVs4CiYzIp2cFwfJ+eDzavRkFrV7o
 df5jmaTAaQvLc9v1sSmbABx4C5Rzw1nTgw7iXi1sO9xpDPFNsNp3LKzpz90wTIQNwZ1t
 Ho+YhWAPx1xMmOMWNMoEs/sIV1YU/vXuH0Fvy5rAwr8dsko79NvLMAybJkyUdKsceRMO
 iXCBxeebKyqxkZinLCfgL7TweGZd1asuEGHKg2vBla0voczqpexKdljfuec7O93BtHaM
 wjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=CvhsZshQWEcVMeUTUtOp+ihfqDRpu56SkXuVG8Len34=;
 b=QDDnvmaIqbJD7lR4jHzbtUVnaChimRw7XsxC0Lxz7Lf+er0+U8GZoLMOL6Kc1jruYZ
 itkPLB0HQN8IFb33m6+Gb5AAinzRSPMPF+7YIkV9BMrVr4r3eyB3b5j4+nhU2wMQH8rn
 wt2tbysPGIEwnFoKVjHSFP/YxKJToL5bLHbdWXzbT5dCpu7iGswrWjsNQld9yc1W6BGO
 Vzj0cykl61Eni4JvUADT6hucH2ZpCprUG6glpvMj90vRseNYTvB4PMl8lZy1sjERC2p7
 EObYHQuaMpGm5pHbOqD473TKcjdw/bn0GsdLPiNkyBG49kq5lO70QAmU4YO0PabrrZ4e
 r9ig==
X-Gm-Message-State: ACrzQf010Cll/4z/eqyrTpSxoYrR5soZXkChffQjl5dpIKwfCZxr5S1b
 udH+sAv0+2H27m7RQbY1wHMeBg==
X-Google-Smtp-Source: AMsMyM6OzoP+QUJ8ptlTPBD8IHWudpkYNFjUBgo6cbOLfKoB/+Q6j9ksVTjQt2XeCIsVj6BjOQ3zrw==
X-Received: by 2002:a05:600c:1:b0:3c6:c456:f07a with SMTP id
 g1-20020a05600c000100b003c6c456f07amr18797697wmc.158.1667459461681; 
 Thu, 03 Nov 2022 00:11:01 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net.
 [88.29.181.216]) by smtp.gmail.com with ESMTPSA id
 y16-20020adff6d0000000b0023647841c5bsm17017wrp.60.2022.11.03.00.10.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:11:01 -0700 (PDT)
Message-ID: <e844905b-3775-b89d-8b19-0a1c2e916432@linaro.org>
Date: Thu, 3 Nov 2022 08:10:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 20/44] KVM: MIPS: Setup VZ emulation? directly from
 kvm_mips_init()
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
 <20221102231911.3107438-21-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-21-seanjc@google.com>
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

T24gMy8xMS8yMiAwMDoxOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBJbnZva2Uga3Zt
X21pcHNfZW11bGF0aW9uX2luaXQoKSBkaXJlY3RseSBmcm9tIGt2bV9taXBzX2luaXQoKSBpbnN0
ZWFkCj4gb2YgYm91bmNpbmcgdGhyb3VnaCBrdm1faW5pdCgpPT5rdm1fYXJjaF9pbml0KCkuICBG
dW5jdGlvbmFsbHksIHRoaXMgaXMKPiBhIGdsb3JpZmllZCBub3AgYXMgaW52b2tpbmcga3ZtX2Fy
Y2hfaW5pdCgpIGlzIHRoZSB2ZXJ5IGZpcnN0IGFjdGlvbgo+IHBlcmZvcm1lZCBieSBrdm1faW5p
dCgpLgo+IAo+IEVtcHR5aW5nIGt2bV9hcmNoX2luaXQoKSB3aWxsIGFsbG93IGRyb3BwaW5nIHRo
ZSBob29rIGVudGlyZWx5IG9uY2UgYWxsCj4gYXJjaGl0ZWN0dXJlIGltcGxlbWVudGF0aW9ucyBh
cmUgbm9wcy4KPiAKPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4KPiAKPiBTaWduZWQt
b2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4KPiAtLS0KPiAg
IGFyY2gvbWlwcy9rdm0vbWlwcy5jIHwgNiArKysrKy0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKClJldmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1
LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
