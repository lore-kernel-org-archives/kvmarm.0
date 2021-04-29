Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10044C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 09:11:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A2E161073
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 09:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A2E161073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8636D4B334;
	Thu, 29 Apr 2021 05:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kJQGqIg+yH5V; Thu, 29 Apr 2021 05:11:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B4B64B335;
	Thu, 29 Apr 2021 05:11:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD644B2C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 20:48:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4y+6c+aB26AU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 20:48:36 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83EB14B2C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 20:48:36 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FVxcN65dqzlVyx;
 Thu, 29 Apr 2021 08:45:24 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 08:48:27 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
To: Mike Rapoport <rppt@kernel.org>
References: <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
 <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
Date: Thu, 29 Apr 2021 08:48:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YIj5zcbHBHt7CC8B@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 29 Apr 2021 05:11:50 -0400
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will
 Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Ck9uIDIwMjEvNC8yOCAxMzo1OSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiBPbiBUdWUsIEFwciAy
NywgMjAyMSBhdCAwNzowODo1OVBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90ZToKPj4gT24gMjAy
MS80LzI3IDE0OjIzLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+Pj4gT24gTW9uLCBBcHIgMjYsIDIw
MjEgYXQgMTE6MjY6MzhQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6Cj4+Pj4gT24gMjAyMS80
LzI2IDEzOjIwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+Pj4+PiBPbiBTdW4sIEFwciAyNSwgMjAy
MSBhdCAwMzo1MTo1NlBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90ZToKPj4+Pj4+IE9uIDIwMjEv
NC8yNSAxNToxOSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPj4+Pj4+Cj4+Pj4+PiAgICAgICAgT24g
RnJpLCBBcHIgMjMsIDIwMjEgYXQgMDQ6MTE6MTZQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6
Cj4+Pj4+Pgo+Pj4+Pj4gICAgICAgICAgICBJIHRlc3RlZCB0aGlzIHBhdGNoc2V0KHBsdXMgYXJt
MzIgY2hhbmdlLCBsaWtlIGFybTY0IGRvZXMpCj4+Pj4+PiAgICAgICAgICAgIGJhc2VkIG9uIGx0
cyA1LjEw77yMYWRkIHNvbWUgZGVidWcgbG9nLCB0aGUgdXNlZnVsIGluZm8gc2hvd3MKPj4+Pj4+
ICAgICAgICAgICAgYmVsb3csIGlmIHdlIGVuYWJsZSBIT0xFU19JTl9aT05FLCBubyBwYW5pYywg
YW55IGlkZWEsCj4+Pj4+PiAgICAgICAgICAgIHRoYW5rcy4KPj4+Pj4+Cj4+Pj4+PiAgICAgICAg
QXJlIHRoZXJlIGFueSBjaGFuZ2VzIG9uIHRvcCBvZiA1LjEwIGV4Y2VwdCBmb3IgcGZuX3ZhbGlk
KCkgcGF0Y2g/Cj4+Pj4+PiAgICAgICAgRG8geW91IHNlZSB0aGlzIHBhbmljIG9uIDUuMTAgd2l0
aG91dCB0aGUgY2hhbmdlcz8KPj4+Pj4+Cj4+Pj4+PiBZZXMsIHRoZXJlIGFyZSBzb21lIEJTUCBz
dXBwb3J0IGZvciBhcm0gYm9hcmQgYmFzZWQgb24gNS4xMCwKPj4+IElzIGl0IHBvc3NpYmxlIHRv
IHRlc3QgNS4xMj8KPiBEbyB5b3UgdXNlIFNQQVJTTUVNPyBJZiB5ZXMsIHdoYXQgaXMgeW91ciBz
ZWN0aW9uIHNpemU/Cj4gV2hhdCBpcyB0aGUgdmFsdWUgaWYgQ09ORklHX0ZPUkNFX01BWF9aT05F
T1JERVIgaW4geW91ciBjb25maWd1cmF0aW9uPwoKWWVzLAoKQ09ORklHX1NQQVJTRU1FTT15CgpD
T05GSUdfU1BBUlNFTUVNX1NUQVRJQz15CgpDT05GSUdfRk9SQ0VfTUFYX1pPTkVPUkRFUiA9IDEx
CgpDT05GSUdfUEFHRV9PRkZTRVQ9MHhDMDAwMDAwMApDT05GSUdfSEFWRV9BUkNIX1BGTl9WQUxJ
RD15CkNPTkZJR19ISUdITUVNPXkKI2RlZmluZSBTRUNUSU9OX1NJWkVfQklUUyAgICAyNgojZGVm
aW5lIE1BWF9QSFlTQUREUl9CSVRTICAgIDMyCiNkZWZpbmUgTUFYX1BIWVNNRU1fQklUUyAgICAg
MzIKCgo+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
