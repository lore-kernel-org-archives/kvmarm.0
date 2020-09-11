Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFD8C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 16:25:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B78022208
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 16:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B78022208
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8224B2C5;
	Fri, 11 Sep 2020 12:25:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h+fdd17HnKDt; Fri, 11 Sep 2020 12:25:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39434B2C7;
	Fri, 11 Sep 2020 12:25:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C6A4B2B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 12:25:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0pM-eQEsi8vT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 12:25:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 447754B1D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 12:25:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE2951045;
 Fri, 11 Sep 2020 09:25:15 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D20163F73C;
 Fri, 11 Sep 2020 09:25:14 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Try PMD block mappings if PUD mappings are
 not supported
To: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
References: <20200910133351.118191-1-alexandru.elisei@arm.com>
 <87363oogp2.fsf@kokedama.swc.toshiba.co.jp>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2850b4d3-4399-c44c-0e5e-b01906c80ec7@arm.com>
Date: Fri, 11 Sep 2020 17:26:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87363oogp2.fsf@kokedama.swc.toshiba.co.jp>
Content-Language: en-US
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgUHVuaXQsCgpUaGFuayB5b3UgZm9yIGhhdmluZyBhIGxvb2shCgpPbiA5LzExLzIwIDk6MzQg
QU0sIFB1bml0IEFncmF3YWwgd3JvdGU6Cj4gSGkgQWxleGFuZHJ1LAo+Cj4gQWxleGFuZHJ1IEVs
aXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPiB3cml0ZXM6Cj4KPj4gV2hlbiB1c2Vyc3Bh
Y2UgdXNlcyBodWdldGxiZnMgZm9yIHRoZSBWTSBtZW1vcnksIHVzZXJfbWVtX2Fib3J0KCkgdHJp
ZXMgdG8KPj4gdXNlIHRoZSBzYW1lIGJsb2NrIHNpemUgdG8gbWFwIHRoZSBmYXVsdGluZyBJUEEg
aW4gc3RhZ2UgMi4gSWYgc3RhZ2UgMgo+PiBjYW5ub3QgdGhlIHNhbWUgYmxvY2sgbWFwcGluZyBi
ZWNhdXNlIHRoZSBibG9jayBzaXplIGRvZXNuJ3QgZml0IGluIHRoZQo+PiBtZW1zbG90IG9yIHRo
ZSBtZW1zbG90IGlzIG5vdCBwcm9wZXJseSBhbGlnbmVkLCB1c2VyX21lbV9hYm9ydCgpIHdpbGwg
ZmFsbAo+PiBiYWNrIHRvIGEgcGFnZSBtYXBwaW5nLCByZWdhcmRsZXNzIG9mIHRoZSBibG9jayBz
aXplLiBXZSBjYW4gZG8gYmV0dGVyIGZvcgo+PiBQVUQgYmFja2VkIGh1Z2V0bGJmcyBieSBjaGVj
a2luZyBpZiBhIFBNRCBibG9jayBtYXBwaW5nIGlzIHN1cHBvcnRlZCBiZWZvcmUKPj4gZGVjaWRp
bmcgdG8gdXNlIGEgcGFnZS4KPiBJIHRoaW5rIHRoaXMgd2FzIGRpc2N1c3NlZCBpbiB0aGUgcGFz
dC4KPgo+IEkgaGF2ZSBhIHZhZ3VlIHJlY29sbGVjdGlvbiBvZiB0aGVyZSBiZWluZyBhIHByb2Js
ZW0gaWYgdGhlIHVzZXIgYW5kCj4gc3RhZ2UgMiBtYXBwaW5ncyBnbyBvdXQgb2Ygc3luYyAtIGNh
bid0IHJlY2FsbCB0aGUgZXhhY3QgZGV0YWlscy4KCkknbSBub3Qgc3VyZSB3aGF0IHlvdSBtZWFu
IGJ5IHRoZSB0d28gdGFibGVzIGdvaW5nIG91dCBvZiBzeW5jLiBJJ20gbG9va2luZyBhdApEb2N1
bWVudGF0aW9uL3ZtL3VuZXZpY3RhYmxlLWxydS5yc3QgYW5kIHRoaXMgaXMgd2hhdCBpdCBzYXlz
IHJlZ2FyZGluZyBodWdldGxiZnM6CgoiVk1BcyBtYXBwaW5nIGh1Z2V0bGJmcyBwYWdlIGFyZSBh
bHJlYWR5IGVmZmVjdGl2ZWx5IHBpbm5lZCBpbnRvIG1lbW9yeS7CoCBXZQpuZWl0aGVyIG5lZWQg
bm9yIHdhbnQgdG8gbWxvY2soKSB0aGVzZSBwYWdlcy7CoCBIb3dldmVyLCB0byBwcmVzZXJ2ZSB0
aGUgcHJpb3IKYmVoYXZpb3Igb2YgbWxvY2soKSAtIGJlZm9yZSB0aGUgdW5ldmljdGFibGUvbWxv
Y2sgY2hhbmdlcyAtIG1sb2NrX2ZpeHVwKCkgd2lsbApjYWxsIG1ha2VfcGFnZXNfcHJlc2VudCgp
IGluIHRoZSBodWdldGxiZnMgVk1BIHJhbmdlIHRvIGFsbG9jYXRlIHRoZSBodWdlIHBhZ2VzCmFu
ZCBwb3B1bGF0ZSB0aGUgcHRlcy4iCgpQbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcsIGJ1
dCBteSBpbnRlcnByZXRhdGlvbiBpcyB0aGF0IG9uY2UgYSBodWdldGxiZnMKcGFnZSBoYXMgYmVl
biBtYXBwZWQgaW4gYSBwcm9jZXNzJyBhZGRyZXNzIHNwYWNlLCB0aGUgb25seSB3YXkgdG8gdW5t
YXAgaXQgaXMgdmlhCm11bm1hcC4gSWYgdGhhdCdzIHRoZSBjYXNlLCB0aGUgS1ZNIG1tdSBub3Rp
ZmllciBzaG91bGQgdGFrZSBjYXJlIG9mIHVubWFwcGluZwpmcm9tIHN0YWdlIDIgdGhlIGVudGly
ZSBtZW1vcnkgcmFuZ2UgYWRkcmVzc2VkIGJ5IHRoZSBodWdldGxiZnMgcGFnZXMsIHJpZ2h0PwoK
Pgo+IFB1dHRpbmcgaXQgb3V0IHRoZXJlIGluIGNhc2UgYW55Ym9keSBlbHNlIG9uIHRoZSB0aHJl
YWQgY2FuIHJlY2FsbCB0aGUKPiBkZXRhaWxzIG9mIHRoZSBwcmV2aW91cyBkaXNjdXNzaW9uIChv
ZmZsaXN0KS4KPgo+IFRob3VnaCB0aGluZ3MgbWF5IGhhdmUgY2hhbmdlZCBhbmQgaWYgaXQgcGFz
c2VzIHRlc3RpbmcgLSB0aGVuIG1heWJlIEkKPiBhbSBtaXMtcmVtZW1iZXJpbmcuIEknbGwgdGFr
ZSBhIGNsb3NlciBsb29rIGF0IHRoZSBwYXRjaCBhbmQgc2hvdXQgb3V0Cj4gaWYgSSBub3RpY2Ug
YW55dGhpbmcuCgpUaGUgdGVzdCBJIHJhbiB3YXMgdG8gYm9vdCBhIFZNIGFuZCBydW4gbHRwICh3
aXRoIHByaW50aydzIHNwcmlua2xlZCBpbiB0aGUgaG9zdAprZXJuZWwgdG8gc2VlIHdoYXQgcGFn
ZSBzaXplIGFuZCB3aGVyZSBpdCBnZXRzIG1hcHBlZC91bm1hcHBlZCBhdCBzdGFnZSAyKS4gRG8g
eW91Cm1pbmQgcmVjb21tZW5kaW5nIG90aGVyIHRlc3RzIHRoYXQgSSBtaWdodCBydW4/CgpUaGFu
a3MsCkFsZXgKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
