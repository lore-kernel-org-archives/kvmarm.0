Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE73C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23A5F4B6B7;
	Thu,  3 Nov 2022 12:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6PXa0c20ypHb; Thu,  3 Nov 2022 12:58:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A482E4B712;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35404B63E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KwGL0yinyfqf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 03:20:08 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF44E4B630
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:20:08 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id k8so1342037wrh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 00:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=yWamQQEiXwuUaXnbl6PlP555HrcaEY3+l7Gw0jB534c=;
 b=eMrmoHwsidAITYv+vZDTWUffj0xdVr6f9Irj4fYthgmDb2BtaKGEsFELQu2H6bnkWP
 kvYw40kYqV8j7+KID6Jv8TSwG2Jdrk3L2i6NZZnW1qKtWYQv3oDxv2zGF+cGC9qJEynl
 Q3HGYurZ4Dh8OnDMCMVGhftsWYYclQysAxS0McddFHROl75oHtCo1tssLi3inAUUaVcx
 fUR6nDRn+ryNrHgMilhwWNuUUGNT/fA+7xVLj81AQOwbU9CL+I5tsAtyXoOgw2iEFCeq
 61/G+FvjBXJZUKkwTCZRxbrU1QIQmLSBOvOReMSizUzMvu13QKzBhMJ0mgPECH0jRV1d
 jpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=yWamQQEiXwuUaXnbl6PlP555HrcaEY3+l7Gw0jB534c=;
 b=AMMdDy+SMlYczL31B+F4HrE+jOzVRM2mqh/C2NoG8QkzWaHR3oWTXZCd4sLnVLSDeu
 gEtmRH7V7KUmQytuNcWbdt3TRM+ZSNiQBuV8CyVZPTh9hVkrwxpBbcHm1hIxC7HP3iGq
 NIkuv6qp3/xhaRYSnkBp0FhA/wNLD29sIuw+HHPY0U6LJ2/DhluUQZS8+7o/EhtyOx7i
 tmgZcPByFVcEGkOqgptBOja/EvsUs+JNLsCPhH7lP0Gh07K/twmOFRnY937Y8XV3ZBLl
 9u3G5RlMQTaI1tT4LR46mPS0UZq2g6x/Gyfv9Q0eozCfG5d8GzQsuufn01mQo6USd9fN
 oBag==
X-Gm-Message-State: ACrzQf3XRXf2+4a5ouzwIhm33u9iwvIyH9ik8DzICJdaH6/xHiDFSbBl
 Irt2qH5EnxanCqn798ZSfYdf1w==
X-Google-Smtp-Source: AMsMyM6CSjH/RTBpmDd/QhMZZkOx7oc3nNeJrTJLnMoKwCsW0evNR4jvL0bJpuI6uqT433DOly9rxA==
X-Received: by 2002:a5d:5744:0:b0:236:5c21:177f with SMTP id
 q4-20020a5d5744000000b002365c21177fmr17331121wrw.449.1667460007685; 
 Thu, 03 Nov 2022 00:20:07 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net.
 [88.29.181.216]) by smtp.gmail.com with ESMTPSA id
 fc19-20020a05600c525300b003cf57329221sm5884991wmb.14.2022.11.03.00.20.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:20:07 -0700 (PDT)
Message-ID: <3a2d1d5e-b105-11ed-413b-4ad2dbba058e@linaro.org>
Date: Thu, 3 Nov 2022 08:20:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 30/44] KVM: Drop kvm_arch_check_processor_compat() hook
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
 <20221102231911.3107438-31-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-31-seanjc@google.com>
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

T24gMy8xMS8yMiAwMDoxOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBEcm9wIGt2bV9h
cmNoX2NoZWNrX3Byb2Nlc3Nvcl9jb21wYXQoKSBhbmQgaXRzIHN1cHBvcnQgY29kZSBub3cgdGhh
dCBhbGwKPiBhcmNoaXRlY3R1cmUgaW1wbGVtZW50YXRpb25zIGFyZSBub3BzLgo+IAo+IFNpZ25l
ZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgo+IC0tLQo+
ICAgYXJjaC9hcm02NC9rdm0vYXJtLmMgICAgICAgfCAgNyArLS0tLS0tCj4gICBhcmNoL21pcHMv
a3ZtL21pcHMuYyAgICAgICB8ICA3ICstLS0tLS0KPiAgIGFyY2gvcG93ZXJwYy9rdm0vYm9vazNz
LmMgIHwgIDIgKy0KPiAgIGFyY2gvcG93ZXJwYy9rdm0vZTUwMC5jICAgIHwgIDIgKy0KPiAgIGFy
Y2gvcG93ZXJwYy9rdm0vZTUwMG1jLmMgIHwgIDIgKy0KPiAgIGFyY2gvcG93ZXJwYy9rdm0vcG93
ZXJwYy5jIHwgIDUgLS0tLS0KPiAgIGFyY2gvcmlzY3Yva3ZtL21haW4uYyAgICAgIHwgIDcgKy0t
LS0tLQo+ICAgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jICAgfCAgNyArLS0tLS0tCj4gICBhcmNo
L3g4Ni9rdm0vc3ZtL3N2bS5jICAgICB8ICA0ICsrLS0KPiAgIGFyY2gveDg2L2t2bS92bXgvdm14
LmMgICAgIHwgIDQgKystLQo+ICAgYXJjaC94ODYva3ZtL3g4Ni5jICAgICAgICAgfCAgNSAtLS0t
LQo+ICAgaW5jbHVkZS9saW51eC9rdm1faG9zdC5oICAgfCAgNCArLS0tCj4gICB2aXJ0L2t2bS9r
dm1fbWFpbi5jICAgICAgICB8IDI0ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgMTMgZmls
ZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNjcgZGVsZXRpb25zKC0pCgpSZXZpZXdlZC1i
eTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
