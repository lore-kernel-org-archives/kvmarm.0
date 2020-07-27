Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5092C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 11:27:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C36320663
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 11:27:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C36320663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2E2D4B8C1;
	Mon, 27 Jul 2020 07:27:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zgkH9jvENsEW; Mon, 27 Jul 2020 07:27:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E1B4B8D1;
	Mon, 27 Jul 2020 07:27:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CB44B89D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 07:27:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id addF3alHAu8d for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 07:27:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1F194B899
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 07:27:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4641B30E;
 Mon, 27 Jul 2020 04:27:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A2F63F66E;
 Mon, 27 Jul 2020 04:27:02 -0700 (PDT)
Subject: Re: kvm-unit-tests: Question about the "no interrupt when timer is
 disabled" case
To: Zenghui Yu <yuzenghui@huawei.com>
References: <fd421647-6526-41dd-ef3a-c714f9d513d6@huawei.com>
 <195f5f7b-b1a4-8c82-c5e3-aac950737ff5@arm.com>
 <fea5457f-379d-4077-6b1d-022f13e16891@huawei.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <05f898af-632f-9ef9-86af-e73c35ef6746@arm.com>
Date: Mon, 27 Jul 2020 12:27:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fea5457f-379d-4077-6b1d-022f13e16891@huawei.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
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

SGkgWmVuZ2h1aSwKCk9uIDcvMjUvMjAgNTo1MCBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBB
bGV4LAo+Cj4gWytjYyBOaWFueWFvXQo+Cj4gT24gMjAyMC83LzI0IDE5OjA4LCBBbGV4YW5kcnUg
RWxpc2VpIHdyb3RlOgo+PiBIaSBaZW5naHVpLAo+Pgo+PiBJIGRvbid0IGJlbGlldmUgdGhpcyBp
c3N1ZSBjYW4gYmUgdHJpZ2dlcmVkIGJ5IGEgTGludXggZ3Vlc3QuIERldGFpbHMgYmVsb3cuCj4+
Cj4+IE9uIDcvMjMvMjAgOTo1NiBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4+IEhpIEFsZXhhbmRy
dSwKPj4+Cj4+PiBJJ3ZlIG5vdGljZWQgdGhhdCB0aGUgdGltZXIgY2FzZSB3aWxsIGZhaWwgaW4g
dGhlIC1zdGFibGUgNC4xOSBrZXJuZWwuCj4+PiBUaGUgbG9nIGlzIGFzIGZvbGxvd3M6Cj4+Pgo+
Pj4gRkFJTDogdnRpbWVyLWJ1c3ktbG9vcDogbm8gaW50ZXJydXB0IHdoZW4gdGltZXIgaXMgZGlz
YWJsZWQKPj4+IEZBSUw6IHZ0aW1lci1idXN5LWxvb3A6IGludGVycnVwdCBzaWduYWwgbm8gbG9u
Z2VyIHBlbmRpbmcKPj4+Cj4+PiBBbmQgaXQncyBiZWNhdXNlIHRoZSByZWxhdGVkIGZpeCBbMTZl
NjA0YTQzN2M4LCAiS1ZNOiBhcm0vYXJtNjQ6IHZnaWM6Cj4+PiBSZWV2YWx1YXRlIGxldmVsIHNl
bnNpdGl2ZSBpbnRlcnJ1cHRzIG9uIGVuYWJsZSJdIGhhc24ndCBiZWVuIGJhY2twb3J0ZWQKPj4+
IHRvIHRoZSBzdGFibGUgdHJlZS4KPj4KPj4gVGhpcyBpcyBub3QgYW4gYWN0dWFsIGZpeCAoaGVu
Y2Ugbm8gIkZpeGVzIiB0YWcpLCB0aGlzIGlzIG1vcmUgbGlrZSBhbiBpbXByb3ZlbWVudAo+PiBv
ZiB0aGUgYmVoYXZpb3VyIG9mIHRoZSBHSUMuIExpa2UgdGhlIHBhdGNoIGRlc2NyaXB0aW9uIHNh
eXMsIHRoaXMgY2FuIGhhcHBlbiBldmVuCj4+IG9uIGhhcmR3YXJlIGlmIHRoZSBHSUMgaGFzbid0
IHNhbXBsZWQgdGhlIGRldmljZSBpbnRlcnJ1cHQgc3RhdGUgKG9yIHRoZSBkZXZpY2UKPj4gaXRz
ZWxmIGhhc24ndCB1cGRhdGVkIGl0KSBiZWZvcmUgdGhlIENQVSByZS1lbmFibGVzIHRoZSBpbnRl
cnJ1cHQuCj4KPiBGYWlyIGVub3VnaC4KPgo+Pj4KPj4+IEp1c3Qgb3V0IG9mIGN1cmlvc2l0eSwg
X3dpdGhvdXRfIHRoaXMgZml4LCBoYWQgeW91IGFjdHVhbGx5IHNlZW4gdGhlCj4+PiBndWVzdCBn
ZXR0aW5nIGludG8gdHJvdWJsZSBkdWUgdG8gYW4gdW4tcmV0aXJlZCBsZXZlbC1zZW5zaXRpdmUK
Pj4+IGludGVycnVwdCBhbmQgeW91ciBwYXRjaCBmaXhlZCBpdD8gT3IgdGhpcyB3YXMgZm91bmQg
YnkgY29kZSBpbnNwZWN0aW9uPwo+Pgo+PiBUaGlzIGlzc3VlIHdhcyBmb3VuZCB3aGVuIHJ1bm5p
bmcga3ZtLXVuaXQtdGVzdHMgb24gdGhlIG1vZGVsLgo+Pgo+Pj4KPj4+IFRha2UgdGhlIGV4YWN0
IHZ0aW1lciBjYXNlIGFzIGFuIGV4YW1wbGUsIGlzIGl0IHBvc3NpYmxlIHRoYXQgdGhlIExpbnV4
Cj4+PiBndWVzdCB3b3VsZCBkaXNhYmxlIHRoZSB2dGltZXIgKHRoZSBpbnB1dCBpbnRlcnJ1cHQg
bGluZSBpcyBkcml2ZW4gdG8gMAo+Pj4gYnV0IHRoZSBvbGQgS1ZNIGRvZXNuJ3QgdGFrZSB0aGlz
IGludG8gYWNjb3VudCkgYW5kIHBvdGVudGlhbGx5IGhpdCB0aGlzCj4+PiBpc3N1ZT8gSSdtIG5v
dCBmYW1pbGlhciB3aXRoIGl0Lgo+Pgo+PiBUbyB0cmlnZ2VyIHRoaXMsIGEgZ3Vlc3QgaGFzIHRv
IGRvIHRoZSBmb2xsb3dpbmcgc3RlcHM6Cj4+Cj4+IDEuIERpc2FibGUgdGhlIHRpbWVyIGludGVy
cnVwdCBhdCB0aGUgUmVkaXN0cmlidXRvciBsZXZlbC4KPj4gMi4gVHJpZ2dlciB0aGUgdGltZXIg
aW50ZXJydXB0IGluIHRoZSB0aW1lci4KPj4gMy4gRGlzYWJsZSB0aGUgdGltZXIgZW50aXJlbHkg
KENOVHtQLFZ9X0NUTF9FTDAuRU5BQkxFID0gMCksIHdoaWNoIGFsc28gZGlzYWJsZXMKPj4gdGhl
IHRpbWVyIGludGVycnVwdC4KPj4gNC4gRW5hYmxlIHRoZSB0aW1lciBpbnRlcnJ1cHQgYXQgdGhl
IFJlZGlzdHJpYnV0b3IgbGV2ZWwuCj4+Cj4+IEkgYmVsaWV2ZSB0aGVyZSBhcmUgdHdvIHJlYXNv
bnMgd2h5IHRoaXMgd2lsbCBuZXZlciBoYXBwZW4gZm9yIGEgTGludXggZ3Vlc3Q6Cj4+Cj4+IC0g
VGhpcyBpc24ndCB0aGUgd2F5IExpbnV4IGhhbmRsZXMgaW50ZXJydXB0cy4gRnVydGhlcm1vcmUs
IEkgZG9uJ3QgYmVsaWV2ZSBMaW51eAo+PiB3aWxsIGV2ZXIgZGlzYWJsZSBhIHNwZWNpZmljIGlu
dGVycnVwdCBhdCB0aGUgaXJxY2hpcCBsZXZlbC4KPgo+IFRoaXMgY2FuIGF0IGxlYXN0IGhhcHBl
biBpbiBhcmNoX3RpbWVyX3N0b3AoKSBbYXJtX2FyY2hfdGltZXIuY10sIHdoZXJlCj4gdGhlIGRp
c2FibGVfcGVyY3B1X2lycSgpIEFQSSB3aWxsIGRpc2FibGUgdGhlIGludGVycnVwdCAodmlhIGly
cV9tYXNrKCkKPiBjYWxsYmFjayB3aGljaCB3aWxsIGluIHR1cm4gZGlzYWJsZSB0aGUgaW50ZXJy
dXB0IGF0IEdJQyBsZXZlbCBieQo+IHByb2dyYW1taW5nIHRoZSBJQ0VOQUJMRVIwKS4KClNvcnJ5
LCBJIG1pc3NlZCB0aGF0LiBEaWQgYSBncmVwIGZvciBhcmNoX3RpbWVyX3N0b3AoKSwgdGhlIGZ1
bmN0aW9uIGlzIGNhbGxlZApvbmx5IHdoZW4gYSBDUFUgaXMgb2ZmbGluZWQuCgo+Cj4gV2hhdCBJ
J20gd29ycmllZCBpcyBzb21ldGhpbmcgbGlrZToKPgo+IDEuIERpc2FibGUgdGhlIHRpbWVyIGlu
dGVycnVwdCAoYXQgUkRpc3QgbGV2ZWwgYnkgcG9raW5nIHRoZSBJQ0VOQUJMRVIwLAo+IMKgwqAg
b3IgYXQgQ1BVIGxldmVsIGJ5IG1hc2tpbmcgUFNUQVRFLkkpCgpBIENQVSBtYXNraW5nIGludGVy
cnVwdHMgd2l0aCBQU1RBVEUuSSB3aWxsIG5vdCB0cmlnZ2VyIHRoZSBzcHVyaW91cyBpbnRlcnJ1
cHQuCktWTSBkb2Vzbid0IGNhcmUgaWYgdGhlIGd1ZXN0IGlzIG1hc2tpbmcgaW50ZXJydXB0cyB3
aGVuIGl0IGZpbGxzIHRoZSBMUgpyZWdpc3RlcnMsIGFuZCB0aGUgaW50ZXJydXB0IHN0YXRlIGlz
IHVwZGF0ZWQgZm9yIGxldmVsLXNlbnNpdGl2ZSBoYXJkd2FyZQppbnRlcnJ1cHRzIHRoYXQgYXJl
IGluIHRoZSBMUiByZWdpc3RlcnMgb24gYSBndWVzdCBleGl0LiBBcyBsb25nIGFzIEtWTSBrZWVw
cyB0aGUKaW50ZXJydXB0IGluIGEgTFIgcmVnaXN0ZXIsIHRoZSBpbnRlcnJ1cHQgc3RhdGUgd2ls
bCBiZSB1cGRhdGVkIGF0IGd1ZXN0IGV4aXQKKHdyaXRpbmcgdG8gSXtDLFN9RU5BQkxFUjAgdHJp
Z2dlcnMgb25lKS4KCj4KPiDCoCBbIHRpbWVyIGludGVycnVwdCBpcyBtYWRlIHBlbmRpbmcsIGFu
ZCByZW1haW5zIHBlbmRpbmcgaW4gKHYpR0lDLiBdCj4KPiAyLiBEaXNhYmxlIHRoZSB0aW1lcgo+
IDMuIEVuYWJsZSB0aGUgdGltZXIgaW50ZXJydXB0IChhdCBSRGlzdCBsZXZlbCBieSBwb2tpbmcg
dGhlIElTRU5BQkxFUjAsCj4gwqDCoCBvciBhdCBDUFUgbGV2ZWwgYnkgdW5tYXNraW5nIFBTVEFU
RS5JKQo+Cj4gwqAgWyBUaGUgaW50ZXJydXB0IGlzIGZvcndhcmRlZCB0byAodilDUFUsIGFuZCB3
ZSBlbmQtdXAgcmUtZW5hYmxpbmcgdGhlCj4gwqDCoMKgIHRpbWVyIGluc2lkZSB0aGUgdGltZXIg
SVJRIGhhbmRsZXIsIHdoaWNoIG1heSBub3QgYmUgYXMgZXhwZWN0ZWQuIF0KPgo+IEknbSBqdXN0
IG5vdCBzdXJlIGlmIHRoaXMgd2lsbCBiZSBhIHBvc3NpYmxlIHNjZW5hcmlvIGluIHRoZSBMaW51
eCwgYW5kCj4gaXMgaXQgaGFybWZ1bCBpZiB0aGlzIHdvdWxkIGhhcHBlbi4KCkknbSBub3QgZmFt
aWxpYXIgd2l0aCBob3RwbHVnLCBidXQgSSBhc3N1bWUgdGhhdCBhIENQVSBpcyBvZmZsaW5lZCB3
aXRoIGEKUFNDSV9DUFVfT0ZGIGNhbGwuIEtWTSByZXNldCB0aGUgdmNwdSB3aGVuIGl0J3MgYnJv
dWdodCBvbmxpbmUgYWdhaW4sIGFuZCB0aGF0Cm1lYW5zIHVwZGF0aW5nIHRoZSB0aW1lciBzdGF0
ZSBpbiBrdm1fdGltZXJfdmNwdV9sb2FkKCkgLT4ga3ZtX3RpbWVyX3ZjcHVfbG9hZF9naWMoKS4K
CkkndmUgYmVlbiB0aGlua2luZyBhYm91dCBpdCwgYW5kIGdldHRpbmcgc3B1cmlvdXMgdGltZXIg
aW50ZXJydXB0cyBjYW4gaGFwcGVuIGluCmFub3RoZXIsIG1vcmUgY29tbW9uIGNhc2UsIHdoZW4g
dGhlIEdJQyByZXRpcmVzIHRoZSBwaHlzaWNhbCBpbnRlcnJ1cHQgYmV0d2VlbgpndWVzdCBleGl0
ICh3aGVuIHRoZSBpbnRlcnJ1cHQgc3RhdGUgaXMgc2FtcGxlZCBieSBLVk0pIGFuZCBndWVzdCBl
bnRyeS4gVGhlcmUncwpub3RoaW5nIHRoYXQgS1ZNIGNhbiBkbyBpbiB0aGlzIGNhc2UuCgo+Cj4+
IC0gVGhlIHRpbWVyIElSUSBoYW5kbGVyIGNoZWNrcyB0aGUgSVNUQVRVUyBmbGFnIGluIHRoZSB0
aW1lciBjb250cm9sIHJlZ2lzdGVyCj4+IGJlZm9yZSBoYW5kbGluZyB0aGUgaW50ZXJydXB0LiBU
aGUgZmxhZyBpcyB1bnNldCBpZiB0aGUgdGltZXIgaXMgZGlzYWJsZWQuCj4KPiBUaGlzIGFjdHVh
bGx5IGRvZXNuJ3QgbWF0Y2ggdGhlIHNwZWMuIEFybSBBUk0gRDEzLjguMjUgaGFzIGEgZGVzY3Jp
cHRpb24KPiBhYm91dCB0aGUgSVNUQVRVUyBmaWVsZCBhcyBiZWxvdywKPgo+ICJXaGVuIHRoZSB2
YWx1ZSBvZiB0aGUgRU5BQkxFIGJpdCBpcyAwLCB0aGUgSVNUQVRVUyBmaWVsZCBpcyBVTktOT1dO
LiIKCk15IGJhZCwgd2hlbiBJIGxvb2tlZCBhdCB0aGUgQXJtIEFSTSBJIG1pc3NlZCB0aGF0IHBh
cnQuCgo+Cj4gSSBndWVzcyB3aGF0IE5pYW55YW8gaGFkIHBvc3RlZCBbKl0gbWF5IGFkZHJlc3Mg
dGhlIGNvbmNlcm4gYWJvdmUuLi4KPgo+IFsqXQo+IGh0dHA6Ly9sb3JlLmtlcm5lbC5vcmcvci8x
NTk1NTg0MDM3LTY4NzctMS1naXQtc2VuZC1lbWFpbC16aGFuZ3NoYW9rdW5AaGlzaWxpY29uLmNv
bS8KCkkndmUgcmVhZCBNYXJjJ3MgZXhwbGFuYXRpb24sIGFuZCBJIHRlbmQgdG8gYWdyZWUuIFNw
dXJpb3VzIGludGVycnVwdHMgY2FuIGhhcHBlbgpvbiByZWFsIGhhcmR3YXJlIHRvbywgYW5kIHRo
ZXJlJ3MgcmVhbGx5IG5vdGhpbmcgdGhhdCBLVk0gY2FuIGRvIGFib3V0IGl0LgoKVGhhbmtzLAoK
QWxleAoKPgo+Pgo+PiBJIGhvcGUgbXkgZXhwbGFuYXRpb24gbWFkZSBzZW5zZSwgcGxlYXNlIGNo
aW1lIGluIGlmIEkgbWlzc2VkIHNvbWV0aGluZyBvciB5b3UKPj4gd2FudCBtb3JlIGRldGFpbHMu
Cj4KPiBUaGFua3MgQWxleCwKPiBaZW5naHVpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
