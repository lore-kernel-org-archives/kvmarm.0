Return-Path: <SRS0=uL1D=U6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF46CC0650E
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 08:18:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BB09208C4
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 08:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BB09208C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2153F4A332;
	Mon,  1 Jul 2019 04:18:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WwuuqPMTBwdR; Mon,  1 Jul 2019 04:18:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43804A4BE;
	Mon,  1 Jul 2019 04:18:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 547704A49F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 04:18:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NELoqRSQvtCa for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jul 2019 04:18:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C23E340A52
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 04:18:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FF132B;
 Mon,  1 Jul 2019 01:18:24 -0700 (PDT)
Received: from [10.1.35.148] (James-iPhone8.cambridge.arm.com [10.1.35.148])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0C583F718;
 Mon,  1 Jul 2019 01:18:23 -0700 (PDT)
Subject: Re: KVM works on RPi4
To: Jan Kiszka <jan.kiszka@web.de>, Marc Zyngier <marc.zyngier@arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why> <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
 <cbbeb948-23e5-97d9-2410-ef804ae2b80d@web.de>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <3fa336f7-0089-ae4a-a616-a000214fc1d1@arm.com>
Date: Mon, 1 Jul 2019 09:18:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cbbeb948-23e5-97d9-2410-ef804ae2b80d@web.de>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

T24gNi8zMC8xOSAxMTo0OSBBTSwgSmFuIEtpc3prYSB3cm90ZToKPiBPbiAzMC4wNi4xOSAxMjox
OCwgSmFuIEtpc3prYSB3cm90ZToKPj4gT24gMzAuMDYuMTkgMTE6MzQsIEphbiBLaXN6a2Egd3Jv
dGU6Cj4+PiBPbiAzMC4wNi4xOSAwMDo0MiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IE9uIFNh
dCwgMjkgSnVuIDIwMTkgMTk6MDk6MzcgKzAyMDAKPj4+PiBKYW4gS2lzemthIDxqYW4ua2lzemth
QHdlYi5kZT4gd3JvdGU6Cj4+Pj4+IEhvd2V2ZXIsIGFzIHRoZSBSYXNwYmVycnkga2VybmVsIGlz
IG5vdCB5ZXQgcmVhZHkgZm9yIDY0LWJpdCAoYW5kCj4+Pj4+IHVwc3RyZWFtIGlzIG5vdCBpbiBz
aWdodCksIEkgaGFkIHRvIHVzZSBsZWdhY3kgMzItYml0IG1vZGUuIEFuZCB0aGVyZSB3ZQo+Pj4+
PiBzdHVtYmxlIG92ZXIgdGhlIGNvcmUgZGV0ZWN0aW9uLiBUaGlzIGxpdHRsZSBwYXRjaCBtYWRl
IGl0IHdvcmssIHRob3VnaDoKPj4+Pj4KPj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2t2bS9n
dWVzdC5jIGIvYXJjaC9hcm0va3ZtL2d1ZXN0LmMKPj4+Pj4gaW5kZXggMmI4ZGU4ODViMmJmLi4w
MTYwNmFhZDczY2MgMTAwNjQ0Cj4+Pj4+IC0tLSBhL2FyY2gvYXJtL2t2bS9ndWVzdC5jCj4+Pj4+
ICsrKyBiL2FyY2gvYXJtL2t2bS9ndWVzdC5jCj4+Pj4+IEBAIC0yOTAsNiArMjkwLDcgQEAgaW50
IF9fYXR0cmlidXRlX2NvbnN0X18ga3ZtX3RhcmdldF9jcHUodm9pZCkKPj4+Pj4gwqDCoMKgwqDC
oCBjYXNlIEFSTV9DUFVfUEFSVF9DT1JURVhfQTc6Cj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0E3Owo+Pj4+PiDCoMKgwqDCoMKgIGNhc2UgQVJN
X0NQVV9QQVJUX0NPUlRFWF9BMTU6Cj4+Pj4+ICvCoMKgwqAgY2FzZSBBUk1fQ1BVX1BBUlRfQ09S
VEVYX0E3MjoKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBLVk1fQVJNX1RBUkdFVF9D
T1JURVhfQTE1Owo+Pj4+PiDCoMKgwqDCoMKgIGRlZmF1bHQ6Cj4+Pj4+IMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVJTlZBTDsKPj4+Pj4KPj4+Pj4gVGhhdCByYWlzZXMgdGhlIHF1ZXN0aW9u
IGlmIHRoaXMgaXMgaGFjayBvciBhIHZhbGlkIGNoYW5nZSBhbmQgaWYgdGhlcmUKPj4+Pj4gaXMg
Z2VuZXJhbCBpbnRlcmVzdCBpbiBtYXBwaW5nIDY0LWJpdCBjb3JlcyBvbiAzMi1iaXQgaWYgdGhl
eSBoYXBwZW4gdG8KPj4+Pj4gcnVuIGluIDMyLWJpdCBtb2RlLgo+Pj4+Cj4+Pj4gVGhlIHJlYWwg
dGhpbmcgdG8gZG8gaGVyZSB3b3VsZCBiZSB0byBtb3ZlIHRvIGEgZ2VuZXJpYyB0YXJnZXQsIG11
Y2gKPj4+PiBsaWtlIHdlIGRpZCBvbiB0aGUgNjRiaXQgc2lkZS4gQ291bGQgeW91IGludmVzdGln
YXRlIHRoYXQgaW5zdGVhZD8gSXQKPj4+PiB3b3VsZCBhbHNvIGFsbG93IEtWTSB0byBiZSB1c2Vk
IG9uIG90aGVyIDMyYml0IGNvcmVzIHN1Y2ggYXMKPj4+PiBBMTIvQTE3L0EzMi4KPj4+Cj4+PiBZ
b3UgbWVhbiBzb21ldGhpbmcgbGlrZSBLVk1fQVJNX1RBUkdFVF9HRU5FUklDX1Y4PyBOZWVkIHRv
IHN0dWR5IHRoYXQuLi4KPj4+Cj4+Cj4+IEhtbSwgbG9va2luZyBhdCB3aGF0IEtWTV9BUk1fVEFS
R0VUX0NPUlRFWF9BNyBhbmQgLi4uX0ExNSBkaWZmZXJlbnRpYXRlcywgSQo+PiBmb3VuZCBub3Ro
aW5nIHNvIGZhcjoKPj4KPj4ga3ZtX3Jlc2V0X3ZjcHU6Cj4+IMKgwqDCoMKgwqDCoMKgwqAgc3dp
dGNoICh2Y3B1LT5hcmNoLnRhcmdldCkgewo+PiDCoMKgwqDCoMKgwqDCoMKgIGNhc2UgS1ZNX0FS
TV9UQVJHRVRfQ09SVEVYX0E3Ogo+PiDCoMKgwqDCoMKgwqDCoMKgIGNhc2UgS1ZNX0FSTV9UQVJH
RVRfQ09SVEVYX0ExNToKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVzZXRf
cmVncyA9ICZjb3J0ZXhhX3JlZ3NfcmVzZXQ7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHZjcHUtPmFyY2gubWlkciA9IHJlYWRfY3B1aWRfaWQoKTsKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+Cj4+IEFuZCBhcmNoL2FybS9rdm0vY29wcm9j
X2ExNS5jIGxvb2tzIGxpa2UgYSBjb3B5IG9mIGNvcHJvY19hNy5jLCBqdXN0IHdpdGggc29tZQo+
PiBzeW1ib2xzIHJlbmFtZWQuCj4gCj4gT0ssIGZvdW5kIGl0OiBUaGUgcmVzZXQgdmFsdWVzIG9m
IFNDVExSIGRpZmZlciwgaW4gb25lIGJpdC4gQTE1IHN0YXJ0cyB3aXRoCj4gYnJhbmNoIHByZWRp
Y3Rpb24gKDExKSBvZmYsIEE3IHdpdGggdGhhdCBmZWF0dXJlIGVuYWJsZWQuIFF1aXRlIHNvbWUg
Ym9pbGVycGxhdGUKPiBjb2RlIGZvciBtYW5hZ2luZyBhIHNpbmdsZSBiaXQuCj4gCj4gRm9yIGEg
Z2VuZXJpYyB0YXJnZXQsIGNhbiB3ZSBzaW1wbHkgYXNzdW1lIEExNSByZXNldCBiZWhhdmlvdXI/
CgpJSVVDLCBpdCdkIHdvcmsgb25seSBmb3IgQVJDSF9WSVJUIGd1ZXN0LCB3aGljaCBpcyBrbm93
biBub3QgdG8gdG91Y2ggSU1QX0RFRgpyZWdpc3RlcnMuIFVuZm9ydHVuYXRlbHksIG90aGVyIHZh
cmlhbnRzIG9mIGd1ZXN0cyAoQVJDSF9WRVhQUkVTUz8pIG1pZ2h0IHRvdWNoCnN1Y2ggcmVnaXN0
ZXJzLCBmb3IgaW5zdGFuY2UsIGwyY3RsciBpcyBvZnRlbiB1c2VkIGZvciBxdWVyeWluZyBudW1i
ZXIgb2YgcG9wdWxhdGVkCmNwdXMsIGFuZCBpdCBtaWdodCBub3QgYmUgcHJlc2VudCBhdCBhbGwg
b24gdjguIEFsc28sIGNvbnRlbnQgb2YgSU1QX0RFRiByZWdpc3RlcgppcyBub3QgZml4ZWQgYW5k
IG1lYW5pbmcgb2YgdGhlIGJpdHMgbWF5IHdhcnkgYmV0d2VlbiBkaWZmZXJlbnQgaW1wbGVtZW50
YXRpb25zLCBzbwpndWVzdHMgbWF5IHJlYWN0IGRpZmZlcmVudGx5LgoKSnVzdCBteSAycC4KCkNo
ZWVycwpWbGFkaW1pcgoKPiAKPiBKYW4KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwo+IGt2bWFybSBtYWlsaW5nIGxpc3QKPiBrdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cj4gaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
