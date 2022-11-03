Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC0AC43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96FB64B286;
	Thu,  3 Nov 2022 12:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2EKaU9nr9UDb; Thu,  3 Nov 2022 12:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CBD04B64A;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD8E4B653
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ckowAY0ODhHn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 03:12:10 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFBC64B640
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:12:10 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id g12so1256093wrs.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 00:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=OBfEswiMsti3OjaKbPQcyAca5te7/jZ5jHcc8SlAT9E=;
 b=EOYmqRt+/NXugZnlIP4em6mI3EQkzvGwpLXhzORTBxBkCP2uHtj6EIHrWTEowCV0gy
 LjLxmy1kx2FmBqwAXMu8s7YUEChDsUQy5qxfdkx40NZii0vXZu9Y5+E9WIQ98im7w2Qz
 aOc+G9yXO8FMp2gmsGVhL5vc6lj4hdeRWLBju/dhOwwfhZrxP6JKghml+WEnDzleKfR2
 xT+vK0HSOhR2frMY/9x+44r4Scku2Y/ouh8iYDp71I/Bsog0PelRVmfpSZ0wxjqL2jqd
 o6DVxRPDxt5z1+9lDTnQ22y8cNKN7oK+0fUhVvCWoxg4QyLcgrLA6TLc/Hs3GkkFsCs4
 skXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=OBfEswiMsti3OjaKbPQcyAca5te7/jZ5jHcc8SlAT9E=;
 b=2Zlr6b8HGBccE81UtH1MD1gc/oJXBtPOfhyjPnfWpAVphllkU18vMfqHhpCh54OGHn
 zY86Lbb/48hoYpv1fDnFYfXxGZqBt0MNkkdJkfCLs1dIKXvjNhwdAiQHV2OKAiwar4uw
 q4VN7voclGSo4AcO3iRMcXA44dxG6zNpb6WJMTeUP8iKXZ/Gehfl4bcjGVPkqsSeSHGv
 K6zptU0hj6x1XyMWNO0nlhH/3+/zUbbRtuDT37iHHvEF/E69LwdJhybJrkHTJApAHYwN
 w7EZhiws72qazchhwd6TZRQ0WFaArbNYkxGZa2h+eBRjip+LU7nSf7Pv7OWtTrR7u3VQ
 Yj9A==
X-Gm-Message-State: ACrzQf0GMwOCzoXBtDhWhx+ME958wAm2T/WqfK9z3wxmfI1zcwuHrze5
 heP12hCOOebR5zmia0PrXPMGlg==
X-Google-Smtp-Source: AMsMyM6cHSUzeR4K9K8x56LNKCrmIwrY3rn7gLNAI0DHx5P8Dkfz8OPY8ArcGxqxO2wWVx+YIs8sgw==
X-Received: by 2002:a5d:644d:0:b0:236:8330:a5bf with SMTP id
 d13-20020a5d644d000000b002368330a5bfmr17103381wrw.125.1667459529624; 
 Thu, 03 Nov 2022 00:12:09 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net.
 [88.29.181.216]) by smtp.gmail.com with ESMTPSA id
 k15-20020adff28f000000b00236740c6e6fsm1599wro.100.2022.11.03.00.12.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:12:09 -0700 (PDT)
Message-ID: <9cec1cc6-5050-9fc6-46ec-a8984b8266a8@linaro.org>
Date: Thu, 3 Nov 2022 08:12:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 21/44] KVM: MIPS: Register die notifier prior to kvm_init()
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
 <20221102231911.3107438-22-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-22-seanjc@google.com>
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

T24gMy8xMS8yMiAwMDoxOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBDYWxsIGt2bV9p
bml0KCkgb25seSBhZnRlciBfYWxsXyBzZXR1cCBpcyBjb21wbGV0ZSwgYXMga3ZtX2luaXQoKSBl
eHBvc2VzCj4gL2Rldi9rdm0gdG8gdXNlcnNwYWNlIGFuZCB0aHVzIGFsbG93cyB1c2Vyc3BhY2Ug
dG8gY3JlYXRlIFZNcyAoYW5kIGNhbGwKPiBvdGhlciBpb2N0bHMpLgo+IAo+IFNpZ25lZC1vZmYt
Ynk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgo+IC0tLQo+ICAgYXJj
aC9taXBzL2t2bS9taXBzLmMgfCA5ICsrKysrLS0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5z
ZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKClJldmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1
LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
