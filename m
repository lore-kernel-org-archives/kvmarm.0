Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B57C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA97E207EA
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UAsXxZ4P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA97E207EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C57244B14F;
	Wed,  2 Sep 2020 13:38:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mQ9w5Y9qhnQx; Wed,  2 Sep 2020 13:38:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF2FC4B110;
	Wed,  2 Sep 2020 13:38:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EED724B110
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 13:38:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vhS9CWhwYp2i for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 13:38:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E608F4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 13:38:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599068291;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aOmWrC7rRflbYUp0TuE0qB8x7VgsarJGGeD88NXkp7Q=;
 b=UAsXxZ4Pt769M7qsGfvW3Xpd6j0Q75agOh7DyDRr0MusfG3TaFayp5F8p8TznFNHaYofTp
 53tQ/Mt7hUnY8FFxG9i3PlYZ6XgLKggSl6BwbH9idNrXsIfEsE99OVt+G0BONxIOaBZXn9
 tR4LiNysm3EY3cNe8eLQhZVtx9KSaNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-5mVcElYoMIWqUzM7w198Hg-1; Wed, 02 Sep 2020 13:38:08 -0400
X-MC-Unique: 5mVcElYoMIWqUzM7w198Hg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F5F11006705;
 Wed,  2 Sep 2020 17:38:07 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ABC578B3C;
 Wed,  2 Sep 2020 17:38:05 +0000 (UTC)
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
To: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
 <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <bbd2ac55-0992-3e70-1270-1c37b68bf1d0@redhat.com>
Date: Wed, 2 Sep 2020 19:38:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com
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

SGkgTWFyYywKCk9uIDkvMi8yMCAxOjEwIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAy
MC0wOS0wMiAxMTo1OSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gSGksCj4+Cj4+IE9uIDgv
MjIvMjAgMzo0NCBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4+IERlcGVuZGluZyBvbiB0aGUga2Vy
bmVsIGNvbmZpZ3VyYXRpb24sIFBVRF9TSVpFIGNvdWxkIGJlIGVxdWFsIHRvCj4+PiBQTURfU0la
RS4gRm9yIGV4YW1wbGUsIGJvdGggb2YgdGhlbSBhcmUgNTEyTUIgd2l0aCB0aGUgZm9sbG93aW5n
Cj4+PiBrZXJuZWwgY29uZmlndXJhdGlvbi4gSW4gdGhpcyBjYXNlLCBib3RoIFBVRCBhbmQgUE1E
IGFyZSBmb2xkZWQKPj4+IHRvIFBHRC4KPj4+Cj4+PiDCoMKgIENPTkZJR19BUk02NF82NEtfUEFH
RVPCoMKgIHkKPj4+IMKgwqAgQ09ORklHX0FSTTY0X1ZBX0JJVFPCoMKgwqDCoCA0Mgo+Pj4gwqDC
oCBDT05GSUdfUEdUQUJMRV9MRVZFTFPCoMKgwqAgMgo+Pj4KPj4+IFdpdGggdGhlIGFib3ZlIGNv
bmZpZ3VyYXRpb24sIHRoZSBzdGFnZTIgUFVEIGlzIHVzZWQgdG8gYmFja3VwIHRoZQo+Pj4gNTEy
TUIgaHVnZSBwYWdlIHdoZW4gdGhlIHN0YWdlMiBtYXBwaW5nIGlzIGJ1aWx0LiBEdXJpbmcgdGhl
IG1hcHBpbmcsCj4+PiB0aGUgUFVEIGFuZCBpdHMgc3Vib3JkaW5hdGUgbGV2ZWxzIG9mIHBhZ2Ug
dGFibGUgZW50cmllcyBhcmUgdW5tYXBwZWQKPj4+IGlmIHRoZSBQVUQgaXMgcHJlc2VudCBhbmQg
bm90IGh1Z2UgcGFnZSBzZW5zaXRpdmUgaW4KPj4+IHN0YWdlMl9zZXRfcHVkX2h1Z2UoKS4KPj4+
IFVuZm9ybmF0ZWx5LCB0aGUgQGFkZHIgaXNuJ3QgYWxpZ25lZCB0byBTMl9QVURfU0laRSBhbmQg
d3JvbmcgcGFnZSB0YWJsZQo+Pj4gZW50cmllcyBhcmUgemFwcGVkLiBJdCBldmVudHVhbGx5IGxl
YWRzIHRvIFBVRCdzIHByZXNlbnQgYml0IGNhbid0IGJlCj4+PiBjbGVhcmVkIHN1Y2Nlc3NmdWxs
eSBhbmQgaW5maW5pdGUgbG9vcCBpbiBzdGFnZTJfc2V0X3B1ZF9odWdlKCkuCj4+Pgo+Pj4gVGhp
cyBmaXhlcyB0aGUgaXNzdWUgYnkgY2hlY2tpbmcgd2l0aCBTMl97UFVELCBQTUR9X1NJWkUgaW5z
dGVhZCBvZgo+Pj4ge1BVRCwgUE1EfV9TSVpFIHRvIGRldGVybWluZSBpZiBzdGFnZTIgUFVEIG9y
IFBNRCBpcyB1c2VkIHRvIGJhY2sgdGhlCj4+PiBodWdlIHBhZ2UuIEZvciB0aGlzIHBhcnRpY3Vs
YXIgY2FzZSwgdGhlIHN0YWdlMiBQTUQgZW50cnkgc2hvdWxkIGJlCj4+PiB1c2VkIHRvIGJhY2t1
cCB0aGUgNTEyTUIgaHVnZSBwYWdlIHdpdGggc3RhZ2UyX3NldF9wbWRfaHVnZSgpLgo+Pgo+PiBJ
IGNhbiByZXByb2R1Y2UgdGhpcyBvbiBteSByb2NrcHJvNjQgdXNpbmcga3ZtdG9vbC4KPj4KPj4g
SSBzZWUgdHdvIGlzc3VlcyBoZXJlOiBmaXJzdCwgUFVEX1NJWkUgPSA1MTJNQiwgYnV0IFMyX1BV
RF9TSVpFID0gNFRCCj4+IChjaGVja2VkCj4+IHVzaW5nIHByaW50ayksIGFuZCBzZWNvbmQsIHN0
YWdlMl9zZXRfcHVkX2h1Z2UoKSBoYW5ncy4gSSdtIHdvcmtpbmcgb24KPj4gZGVidWdnaW5nIHRo
ZW0uCj4gCj4gSSBoYXZlIHRoaXMgYXMgYW4gaW1tZWRpYXRlIGZpeCBmb3IgdGhlIHNldF9wdWRf
aHVnZSBoYW5nLCB0ZXN0ZWQKPiBvbiBTZWF0dGxlIHdpdGggNjRrLzQyYml0cy4KPiAKPiBJIGNh
bid0IHdhaXQgdG8gc2VlIHRoZSBiYWNrIG9mIHRoaXMgY29kZS4uLgo+IAo+IMKgwqDCoMKgwqDC
oMKgIE0uCj4gCj4gRnJvbSAyYTM0NWE4MjZhNDdmOTA2MWJiMzcwNDVhMWQ4OWVhNTRiNTFmYjgw
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQo+IEZyb206IE1hcmMgWnluZ2llciA8bWF6QGtlcm5l
bC5vcmc+Cj4gRGF0ZTogV2VkLCAyIFNlcCAyMDIwIDExOjE4OjI5ICswMTAwCj4gU3ViamVjdDog
W1BBVENIXSBLVk06IGFybTY0OiBEbyBub3QgdHJ5IHRvIG1hcCBQVURzIHdoZW4gdGhleSBhcmUg
Zm9sZGVkCj4gaW50bwo+IMKgUE1ECj4gCj4gRm9yIHRoZSBvYnNjdXJlIGNhc2VzIHdoZXJlIFBN
RCBhbmQgUFVEIGFyZSB0aGUgc2FtZSBzaXplCj4gKDY0a0IgcGFnZXMgd2l0aCA0MmJpdCBWQSwg
Zm9yIGV4YW1wbGUsIHdoaWNoIHJlc3VsdHMgaW4gb25seQo+IHR3byBsZXZlbHMgb2YgcGFnZSB0
YWJsZXMpLCB3ZSBjYW4ndCBtYXAgYW55dGhpbmcgYXMgYSBQVUQsCj4gYmVjYXVzZSB0aGVyZSBp
cy4uLiBlcm0uLi4gbm8gUFVEIHRvIHNwZWFrIG9mLiBFdmVyeXRoaW5nIGlzCj4gZWl0aGVyIGEg
UE1EIG9yIGEgUFRFLgo+IAo+IFNvIGxldCdzIG9ubHkgdHJ5IGFuZCBtYXAgYSBQVUQgd2hlbiBp
dHMgc2l6ZSBpcyBkaWZmZXJlbnQgZnJvbQo+IHRoYXQgb2YgYSBQTUQuCj4gCj4gQ2M6IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcKPiBGaXhlczogYjhlMGJhN2M4YmVhICgiS1ZNOiBhcm02NDogQWRk
IHN1cHBvcnQgZm9yIGNyZWF0aW5nIFBVRCBodWdlcGFnZXMKPiBhdCBzdGFnZSAyIikKPiBSZXBv
cnRlZC1ieTogR2F2aW4gU2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4KPiBSZXBvcnRlZC1ieTogRXJp
YyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnlu
Z2llciA8bWF6QGtlcm5lbC5vcmc+Cj4gLS0tCj4gwqBhcmNoL2FybTY0L2t2bS9tbXUuYyB8IDIg
Ky0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+IAo+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9tbXUuYyBiL2FyY2gvYXJtNjQva3ZtL21tdS5j
Cj4gaW5kZXggYmEwMGJjYzBjODg0Li5jM2E5MmZhNTM3ZmQgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9h
cm02NC9rdm0vbW11LmMKPiArKysgYi9hcmNoL2FybTY0L2t2bS9tbXUuYwo+IEBAIC0xOTcwLDcg
KzE5NzAsNyBAQCBzdGF0aWMgaW50IHVzZXJfbWVtX2Fib3J0KHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwKPiBwaHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4gwqDCoMKgwqDCoMKgwqDCoCAoZmF1bHRfc3Rh
dHVzID09IEZTQ19QRVJNICYmCj4gwqDCoMKgwqDCoMKgwqDCoMKgIHN0YWdlMl9pc19leGVjKG1t
dSwgZmF1bHRfaXBhLCB2bWFfcGFnZXNpemUpKTsKPiAKPiAtwqDCoMKgIGlmICh2bWFfcGFnZXNp
emUgPT0gUFVEX1NJWkUpIHsKPiArwqDCoMKgIGlmIChQVURfU0laRSAhPSBQTURfU0laRSAmJiB2
bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUpIHsKPiDCoMKgwqDCoMKgwqDCoMKgIHB1ZF90IG5ld19w
dWQgPSBrdm1fcGZuX3B1ZChwZm4sIG1lbV90eXBlKTsKPiAKPiDCoMKgwqDCoMKgwqDCoMKgIG5l
d19wdWQgPSBrdm1fcHVkX21raHVnZShuZXdfcHVkKTsKYWxzbyB3b3JrcyBmb3IgbWUKClRlc3Rl
ZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKVGhhbmtzCgpFcmljCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
