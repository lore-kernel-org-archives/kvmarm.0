Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED08CC07E96
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 10:07:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60F6B61178
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 10:07:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60F6B61178
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20EC40068;
	Thu, 15 Jul 2021 06:07:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DsEsvxvvrjTk; Thu, 15 Jul 2021 06:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AEBE4A19F;
	Thu, 15 Jul 2021 06:07:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6E04B081
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 06:07:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyN++5K8aFzK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 06:07:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC3649FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 06:07:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C29E531B;
 Thu, 15 Jul 2021 03:07:05 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.163])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EF843F694;
 Thu, 15 Jul 2021 03:07:04 -0700 (PDT)
Date: Thu, 15 Jul 2021 11:06:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Robin Murphy <robin.murphy@arm.com>
Subject: Re: Any way to disable KVM VHE extension?
Message-ID: <20210715100643.GA53188@C02TD0UTHF1T.local>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
 <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
 <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
 <6331dfe5-a028-4a71-6cc1-479003a58f47@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6331dfe5-a028-4a71-6cc1-479003a58f47@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 kvmarm@lists.cs.columbia.edu, Qu Wenruo <wqu@suse.com>, kvm@vger.kernel.org
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

T24gVGh1LCBKdWwgMTUsIDIwMjEgYXQgMTE6MDA6NDJBTSArMDEwMCwgUm9iaW4gTXVycGh5IHdy
b3RlOgo+IE9uIDIwMjEtMDctMTUgMTA6NDQsIFF1IFdlbnJ1byB3cm90ZToKPiA+IAo+ID4gCj4g
PiBPbiAyMDIxLzcvMTUg5LiL5Y2INToyOCwgUm9iaW4gTXVycGh5IHdyb3RlOgo+ID4gPiBPbiAy
MDIxLTA3LTE1IDA5OjU1LCBRdSBXZW5ydW8gd3JvdGU6Cj4gPiA+ID4gSGksCj4gPiA+ID4gCj4g
PiA+ID4gUmVjZW50bHkgSSdtIHBsYXlpbmcgYXJvdW5kIHRoZSBOdmlkaWEgWGF2aWVyIEFHWCBi
b2FyZCwgd2hpY2gKPiA+ID4gPiBoYXMgVkhFIGV4dGVuc2lvbiBzdXBwb3J0Lgo+ID4gPiA+IAo+
ID4gPiA+IEluIHRoZW9yeSwgY29uc2lkZXJpbmcgdGhlIENQVSBhbmQgbWVtb3J5LCBpdCBzaG91
bGQgYmUgcHJldHR5Cj4gPiA+ID4gcG93ZXJmdWwgY29tcGFyZWQgdG8gYm9hcmRzIGxpa2UgUlBJ
IENNNC4KPiA+ID4gPiAKPiA+ID4gPiBCdXQgdG8gbXkgc3VycHJpc2UsIEtWTSBydW5zIHByZXR0
eSBwb29yIG9uIFhhdmllci4KPiA+ID4gPiAKPiA+ID4gPiBKdXN0IGJvb3RpbmcgdGhlIGVkazIg
ZmlybXdhcmUgY291bGQgdGFrZSBvdmVyIDEwcywgYW5kIDIwcyB0bwo+ID4gPiA+IGZ1bGx5IGJv
b3QgdGhlIGtlcm5lbC4KPiA+ID4gPiBFdmVuIG15IFZNIG9uIFJQSSBDTTQgaGFzIHdheSBmYXN0
ZXIgYm9vdCB0aW1lLCBldmVuIGp1c3QKPiA+ID4gPiBydW5uaW5nIG9uIFBDSUUyLjAgeDEgbGFu
ZSBOVk1FLCBhbmQganVzdCA0IDIuMUdoeiBBNzIgY29yZS4KPiA+ID4gPiAKPiA+ID4gPiBUaGlz
IGlzIGRlZmluaXRlbHkgb3V0IG9mIG15IGV4cGVjdGF0aW9uLCBJIGRvdWJsZSBjaGVja2VkIHRv
IGJlCj4gPiA+ID4gc3VyZSB0aGF0IGl0J3MgcnVubmluZyBpbiBLVk0gbW9kZS4KPiA+ID4gPiAK
PiA+ID4gPiBCdXQgZnVydGhlciBkaWdnaW5nIHNob3dzIHRoYXQsIHNpbmNlIFhhdmllciBBR1gg
Q1BVIHN1cHBvcnRzCj4gPiA+ID4gVkhFLCBrdm0gaXMgcnVubmluZyBpbiBWSEUgbW9kZSBvdGhl
ciB0aGFuIEhZUCBtb2RlIG9uIENNNC4KPiA+ID4gPiAKPiA+ID4gPiBJcyB0aGVyZSBhbnl3YXkg
dG8gbWFudWFsbHkgZGlzYWJsZSBWSEUgbW9kZSB0byB0ZXN0IHRoZSBtb3JlCj4gPiA+ID4gY29t
bW9uIEhZUCBtb2RlIG9uIFhhdmllcj8KPiA+ID4gCj4gPiA+IEFjY29yZGluZyB0byBrZXJuZWwt
cGFyYW1ldGVycy50eHQsICJrdm0tYXJtLm1vZGU9bnZoZSIgKG9yIGl0cwo+ID4gPiBsb3ctbGV2
ZWwgZXF1aXZhbGVudCAiaWRfYWE2NG1tZnIxLnZoPTAiKSBvbiB0aGUgY29tbWFuZCBsaW5lIHNo
b3VsZAo+ID4gPiBkbyB0aGF0Lgo+ID4gCj4gPiBUaGFua3MgZm9yIHRoaXMgb25lLCBJIHN0dXBp
ZGx5IG9ubHkgc2VhcmNoZWQgbW9kaW5mbyBvZiBrdm0sIGFuZCBkaWRuJ3QKPiA+IGV2ZW4gYm90
aGVyIHRvIHNlYXJjaCBhcmNoL2FybTY0L2t2bS4uLgo+ID4gCj4gPiA+IAo+ID4gPiBIb3dldmVy
IEknZCBpbWFnaW5lIHRoZSBkaXNjcmVwYW5jeSBpcyBsaWtlbHkgdG8gYmUgc29tZXRoaW5nIG1v
cmUKPiA+ID4gZnVuZGFtZW50YWwgdG8gdGhlIHdpbGRseSBkaWZmZXJlbnQgbWljcm9hcmNoaXRl
Y3R1cmVzLiBUaGVyZSdzCj4gPiA+IGNlcnRhaW5seSBubyBoYXJtIGluIGdpdmluZyBub24tVkhF
IGEgZ28gZm9yIGNvbXBhcmlzb24sIGJ1dCBJCj4gPiA+IHdvdWxkbid0IGJlIHN1cnByaXNlZCBp
ZiBpdCB0dXJucyBvdXQgZXZlbiBzbG93ZXIuLi4KPiA+IAo+ID4gWW91J3JlIHRvdGFsbHkgcmln
aHQsIHdpdGggbnZoZSBtb2RlLCBpdCdzIHN0aWxsIHRoZSBzYW1lIHNsb3cgc3BlZWQuCj4gPiAK
PiA+IEJUVywgd2hhdCBkaWQgeW91IG1lYW4gYnkgdGhlICJ3aWxkbHkgZGlmZmVyZW50IG1pY3Jv
YXJjaCI/Cj4gPiBJcyBBUk12OC4yIGFyY2ggdGhhdCBkaWZmZXJlbnQgZnJvbSBBUk12OCBvZiBS
UEk0Pwo+IAo+IEkgZG9uJ3QgbWVhbiBBcm12OC54IGFyY2hpdGVjdHVyYWwgZmVhdHVyZXMsIEkg
bWVhbiB0aGUgYWN0dWFsCj4gaW1wbGVtZW50YXRpb24gb2YgTlZJRElBJ3MgQ2FybWVsIGNvcmUg
aXMgdmVyeSwgdmVyeSBkaWZmZXJlbnQgZnJvbQo+IENvcnRleC1BNzIgb3IgaW5kZWVkIG91ciBu
ZXdlciB2OC4yIENvcnRleC1BIGRlc2lnbnMuCj4gCj4gPiBBbmQgYW55IGV4dHJhIG1ldGhvZHMg
SSBjb3VsZCB0cnkgdG8gZXhwbG9yZSB0aGUgcmVhc29uIG9mIHRoZSBzbG93bmVzcz8KPiAKPiBJ
IGd1ZXNzIHRoZSBmaXJzdCBjaGVjayB3b3VsZCBiZSB3aGV0aGVyIHlvdSdyZSB0cmFwcGluZyBh
bmQgZXhpdGluZyB0aGUgVk0KPiBzaWduaWZpY2FudGx5IG1vcmUuIEkgYmVsaWV2ZSB0aGVyZSBh
cmUgc3RhdHMgc29tZXdoZXJlLCBidXQgSSBkb24ndCBrbm93Cj4gZXhhY3RseSB3aGVyZSwgc29y
cnkgLSBJIGtub3cgdmVyeSBsaXR0bGUgYWJvdXQgYWN0dWFsbHkgKnVzaW5nKiBLVk0gOikKPiAK
PiBJZiBpdCdzIG5vdCB0aGF0LCB0aGVuIGl0IG1pZ2h0IGp1c3QgYmUgdGhhdCBFREsyIGlzIGRv
aW5nIGEgbG90IG9mIGNhY2hlCj4gbWFpbnRlbmFuY2Ugb3Igc3lzdGVtIHJlZ2lzdGVyIG1vZGlm
aWNhdGlvbiBvciBzb21lIG90aGVyIG9wZXJhdGlvbiB0aGF0Cj4gaGFwcGVucyB0byBiZSBzbG93
ZXIgb24gQ2FybWVsIGNvbXBhcmVkIHRvIENvcnRleC1BNzIuCgpJdCB3b3VsZCBhbHNvIGJlIHdv
cnRoY2hlY2tpbmcgdGhhIHRoZSBDUFVzIGFyZSBydW5uaW5nIGF0IHRoZSBzcGVlZCB5b3UKZXhw
ZWN0LCBpbiBlLmcuIGNhc2UgdGhlIGxhY2sgb2YgYSBEVkZTIGRyaXZlciBtZWFucyB0aGV5J3Jl
IHJ1bm5pbmcKc2xvdywgYW5kIHRoaXMganVzdCBoYXBwZW5zIHRvIGJlIG1vcmUgbm90aWNlYWJs
ZSBpbiBhIFZNLgoKWW91IGNhbiBlc3RpbWF0ZSB0aGF0IGJ5IHVzaW5nIGBwZXJmIHN0YXRgIG9u
IHRoZSBob3N0IG9uIGEgYnVzeSBsb29wLAphbmQgbG9va2luZyB3aGF0IHRoZSBjcHUtY3ljbGVz
IGNvdW50IGltcGxpZXMuCgpUaGFua3MsCk1hcmsuCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
