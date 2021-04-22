Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4138C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 14:09:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04B1E613DC
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 14:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04B1E613DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 504294B370;
	Thu, 22 Apr 2021 10:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yW75OkPDPlOp; Thu, 22 Apr 2021 10:09:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A58914B434;
	Thu, 22 Apr 2021 10:09:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4494B425
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 03:00:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NG4zI8kvsJK1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 03:00:29 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 880B64B417
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 03:00:28 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FQpCV628sz7vy7;
 Thu, 22 Apr 2021 14:57:58 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 22 Apr 2021 15:00:20 +0800
Subject: Re: [PATCH v2 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, <linux-arm-kernel@lists.infradead.org>
References: <20210421065108.1987-1-rppt@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
Date: Thu, 22 Apr 2021 15:00:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210421065108.1987-1-rppt@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 22 Apr 2021 10:09:27 -0400
Cc: David Hildenbrand <david@redhat.com>, Catalin
 Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>
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

Ck9uIDIwMjEvNC8yMSAxNDo1MSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiBGcm9tOiBNaWtlIFJh
cG9wb3J0IDxycHB0QGxpbnV4LmlibS5jb20+Cj4KPiBIaSwKPgo+IFRoZXNlIHBhdGNoZXMgYWlt
IHRvIHJlbW92ZSBDT05GSUdfSE9MRVNfSU5fWk9ORSBhbmQgZXNzZW50aWFsbHkgaGFyZHdpcmUK
PiBwZm5fdmFsaWRfd2l0aGluKCkgdG8gMS4KPgo+IFRoZSBpZGVhIGlzIHRvIG1hcmsgTk9NQVAg
cGFnZXMgYXMgcmVzZXJ2ZWQgaW4gdGhlIG1lbW9yeSBtYXAgYW5kIHJlc3RvcmUKPiB0aGUgaW50
ZW5kZWQgc2VtYW50aWNzIG9mIHBmbl92YWxpZCgpIHRvIGRlc2lnbmF0ZSBhdmFpbGFiaWxpdHkg
b2Ygc3RydWN0Cj4gcGFnZSBmb3IgYSBwZm4uCj4KPiBXaXRoIHRoaXMgdGhlIGNvcmUgbW0gd2ls
bCBiZSBhYmxlIHRvIGNvcGUgd2l0aCB0aGUgZmFjdCB0aGF0IGl0IGNhbm5vdCB1c2UKPiBOT01B
UCBwYWdlcyBhbmQgdGhlIGhvbGVzIGNyZWF0ZWQgYnkgTk9NQVAgcmFuZ2VzIHdpdGhpbiBNQVhf
T1JERVIgYmxvY2tzCj4gd2lsbCBiZSB0cmVhdGVkIGNvcnJlY3RseSBldmVuIHdpdGhvdXQgdGhl
IG5lZWQgZm9yIHBmbl92YWxpZF93aXRoaW4uCj4KPiBUaGUgcGF0Y2hlcyBhcmUgb25seSBib290
IHRlc3RlZCBvbiBxZW11LXN5c3RlbS1hYXJjaDY0IHNvIEknZCByZWFsbHkKPiBhcHByZWNpYXRl
IG1lbW9yeSBzdHJlc3MgdGVzdHMgb24gcmVhbCBoYXJkd2FyZS4KPgo+IElmIHRoaXMgYWN0dWFs
bHkgd29ya3Mgd2UnbGwgYmUgb25lIHN0ZXAgY2xvc2VyIHRvIGRyb3AgY3VzdG9tIHBmbl92YWxp
ZCgpCj4gb24gYXJtNjQgYWx0b2dldGhlci4KCkhpIE1pa2XvvIxJIGhhdmUgYSBxdWVzdGlvbiwg
d2l0aG91dCBIT0xFU19JTl9aT05FLCB0aGUgcGZuX3ZhbGlkX3dpdGhpbigpIAppbiBtb3ZlX2Zy
ZWVwYWdlc19ibG9jaygpLT5tb3ZlX2ZyZWVwYWdlcygpCndpbGwgYmUgb3B0aW1pemVkLCBpZiB0
aGVyZSBhcmUgaG9sZXMgaW4gem9uZSwgdGhlICdzdHJ1Y2UgcGFnZScobWVtb3J5IAptYXApIGZv
ciBwZm4gcmFuZ2Ugb2YgaG9sZSB3aWxsIGJlIGZyZWUgYnkKZnJlZV9tZW1tYXAoKSwgYW5kIHRo
ZW4gdGhlIHBhZ2UgdHJhdmVyc2UgaW4gdGhlIHpvbmUod2l0aCBob2xlcykgZnJvbSAKbW92ZV9m
cmVlcGFnZXMoKSB3aWxsIG1lZXQgdGhlIHdyb25nIHBhZ2XvvIwKdGhlbiBpdCBjb3VsZCBwYW5p
YyBhdCBQYWdlTFJVKHBhZ2UpIHRlc3QsIGNoZWNrIGxpbmtbMV0sCgoiVGhlIGlkZWEgaXMgdG8g
bWFyayBOT01BUCBwYWdlcyBhcyByZXNlcnZlZCBpbiB0aGUgbWVtb3J5IG1hcCIsIEkgc2VlIAp0
aGUgcGF0Y2gyIGNoZWNrIG1lbWJsb2NrX2lzX25vbWFwKCkgaW4gbWVtb3J5IHJlZ2lvbgpvZiBt
ZW1ibG9jaywgYnV0IGl0IHNlZW1zIHRoYXQgbWVtYmxvY2tfbWFya19ub21hcCgpIGlzIG5vdCBj
YWxsZWQobWF5YmUgCkkgbWlzc2VkKSwgdGhlbiBtZW1tYXBfaW5pdF9yZXNlcnZlZF9wYWdlcygp
IHdvbid0CndvcmssIHNvIHNob3VsZCB0aGUgSE9MRVNfSU5fWk9ORSBzdGlsbCBiZSBuZWVkZWQg
Zm9yIGdlbmVyaWMgbW0gY29kZT8KClsxXSAKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
YXJtLWtlcm5lbC81NDExOTNhNi0yYmNlLWYwNDItNWJiMi04ODkxM2Q1ZjEwNDdAYXJtLmNvbS8K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
