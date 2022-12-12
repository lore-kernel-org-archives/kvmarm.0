Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1B5C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 23:43:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B9654B893;
	Mon, 12 Dec 2022 18:43:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7DSV57VnDC9q; Mon, 12 Dec 2022 18:43:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A334B89E;
	Mon, 12 Dec 2022 18:43:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 297CD4B88B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:43:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yV14Z6WWpFPR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 18:43:23 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07FEA4B880
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:43:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670888602;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jEA/kHTqeoXaUaGcLLLnYDpNScpRzske2CPEB3QlR58=;
 b=OJWd8riMYOf3gpz8fE3e/NTDqI2oiArAxhdCaK3uB1u840ldYj1ANtvpV+l0jBPiHZRvzR
 Cpo2/kdPnL2fRV9dQvF/q4gYdiowmsNFc78yxHNwI63PwQ/i16hdmqmJVr84xZYEglDzHC
 p+5kuA8RuLmHBvAX1p0Ifye4Y7iPerw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-JmGc8-nIP1GievcdX_OgUA-1; Mon, 12 Dec 2022 18:43:21 -0500
X-MC-Unique: JmGc8-nIP1GievcdX_OgUA-1
Received: by mail-wm1-f70.google.com with SMTP id
 h9-20020a1c2109000000b003cfd37aec58so4018912wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 15:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=jEA/kHTqeoXaUaGcLLLnYDpNScpRzske2CPEB3QlR58=;
 b=RrkgYq+PDKhZqZMuNrPVJ3tjXK1Z6TmqiTGc4yOK8VJKNoIrNP7Zr0eQa5bSdEti3l
 lmhYfho/6eBwQ3CiHYwUM6yPO+9Df0xR/Y0m6LiCpQdBVkOMCqijafPiIlLeOg+WfAX3
 in+RgL20RD7nLMQQACBNLMxj2srDB2VfZY3ZPdCtugkn0E26XiLh9BIZ3WTxVCVrIdlO
 qXILjRXFT2Hgoq2uKxC3DhoGxqWLlGIpu1EXMqFWv4hmgf8F6ofhX3BT0V0rsCqFSrs5
 RkpP81ptRjrz7RsQZ25BoSI9Jpw36qfmFmP+8+0W2i77Zsb/wGEE2R/PDwRHbzk/OPcf
 XB5g==
X-Gm-Message-State: ANoB5pmChU1CtwH4+fRVqEjhkX/mHe2N3TjGNC1Ztsa+qHObJi+xKMbA
 kR5jybZBAdkGOJBX4SlQnWY3cWkrFDcKjJw/nL/vMgdvcCttjOE7lKgwDUl146rGO0U9ZuqIH12
 Ff3s3KJZF5dadipZIOuMOI9Vu
X-Received: by 2002:a05:6000:1a41:b0:232:be5d:4896 with SMTP id
 t1-20020a0560001a4100b00232be5d4896mr11068875wry.10.1670888600340; 
 Mon, 12 Dec 2022 15:43:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6FE6NAMqQtmSlBoZgWlaFymznZFcQYb9/qLkdQoBRkq0uuA5oTNuN3c0LKnzZL0EytBO3qiw==
X-Received: by 2002:a05:6000:1a41:b0:232:be5d:4896 with SMTP id
 t1-20020a0560001a4100b00232be5d4896mr11068853wry.10.1670888600068; 
 Mon, 12 Dec 2022 15:43:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 j18-20020a5d5652000000b002427bfd17b6sm12017830wrw.63.2022.12.12.15.43.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 15:43:19 -0800 (PST)
Message-ID: <f1026204-1895-1a7e-5bf8-3527223f3778@redhat.com>
Date: Tue, 13 Dec 2022 00:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
To: Sean Christopherson <seanjc@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <Y5OHVzBSHPmAq2FO@google.com>
 <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
 <Y5e4qxjHWoMt8YGs@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5e4qxjHWoMt8YGs@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, David Matlack <dmatlack@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

T24gMTIvMTMvMjIgMDA6MjYsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+PiBJIHdvdWxk
IHN0cm9uZ2x5IGJlIGluIGZhdm9yIG9mIGRpc2NhcmRpbmcgdGhlIHNoYWRvdyBwYWdpbmcgcmVz
aWR1ZSBpZgo+Pj4geDg2IGZvbGtzIGFyZSB3aWxsaW5nIHRvIHBhcnQgd2F5cyB3aXRoIGl0IPCf
mIQKPj4gWWVzLCBhYnNvbHV0ZWx5LiAgU29tZXRoaW5nIGxpa2UgdG9fc2hhZG93X3BhZ2UtPnRv
X21tdV9kYXRhLCBzcC0+bWQsCj4+IHNwdC0+aHB0LCBzcHRlLT5zcHRlLCBzcHRlcC0+aHB0ZXAu
Cj4gImhvc3QiIHdpbGwgYmUgY29uZnVzaW5nIGlmIHdoZW4gdGhlIHByaW1hcnkgTU1VIGlzIGlu
dm9sdmVkIHRob3VnaCwgZS5nLiBJIGFsd2F5cwo+IHRoaW5rIG9mIHRoZSBwcmltYXJ5IE1NVSdz
IHBhZ2UgdGFibGVzIGFzIHRoZSAiaG9zdCBwYWdlIHRhYmxlcyIuCj4gCj4gV2hhdCBpZiB3ZSBr
ZWVwIHRoZSAiUyIgZm9yIFNQVChFKSBhbmQgcmVwdXJwb3NlIGl0IHRvIG1lYW4gU2Vjb25kYXJ5
IFBURT8KCk1ha2VzIHNlbnNlLCBzbyBqdXN0IHRvX3NoYWRvd19wYWdlLT50b19zZWNtbXVfcGFn
ZT8KClBhb2xvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
