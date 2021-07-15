Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20D3C07E96
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 10:00:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7231D610CB
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 10:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7231D610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D062940CC5;
	Thu, 15 Jul 2021 06:00:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JoD4R9WQfmDQ; Thu, 15 Jul 2021 06:00:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD81849FB0;
	Thu, 15 Jul 2021 06:00:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B49A540D0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 06:00:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wngVhJ3+Z2H9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 06:00:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3718640CC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 06:00:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB15431B;
 Thu, 15 Jul 2021 03:00:48 -0700 (PDT)
Received: from [10.57.36.240] (unknown [10.57.36.240])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FAED3F694;
 Thu, 15 Jul 2021 03:00:48 -0700 (PDT)
Subject: Re: Any way to disable KVM VHE extension?
To: Qu Wenruo <wqu@suse.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
 <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
 <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <6331dfe5-a028-4a71-6cc1-479003a58f47@arm.com>
Date: Thu, 15 Jul 2021 11:00:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
Content-Language: en-GB
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

T24gMjAyMS0wNy0xNSAxMDo0NCwgUXUgV2VucnVvIHdyb3RlOgo+IAo+IAo+IE9uIDIwMjEvNy8x
NSDkuIvljYg1OjI4LCBSb2JpbiBNdXJwaHkgd3JvdGU6Cj4+IE9uIDIwMjEtMDctMTUgMDk6NTUs
IFF1IFdlbnJ1byB3cm90ZToKPj4+IEhpLAo+Pj4KPj4+IFJlY2VudGx5IEknbSBwbGF5aW5nIGFy
b3VuZCB0aGUgTnZpZGlhIFhhdmllciBBR1ggYm9hcmQsIHdoaWNoIGhhcyAKPj4+IFZIRSBleHRl
bnNpb24gc3VwcG9ydC4KPj4+Cj4+PiBJbiB0aGVvcnksIGNvbnNpZGVyaW5nIHRoZSBDUFUgYW5k
IG1lbW9yeSwgaXQgc2hvdWxkIGJlIHByZXR0eSAKPj4+IHBvd2VyZnVsIGNvbXBhcmVkIHRvIGJv
YXJkcyBsaWtlIFJQSSBDTTQuCj4+Pgo+Pj4gQnV0IHRvIG15IHN1cnByaXNlLCBLVk0gcnVucyBw
cmV0dHkgcG9vciBvbiBYYXZpZXIuCj4+Pgo+Pj4gSnVzdCBib290aW5nIHRoZSBlZGsyIGZpcm13
YXJlIGNvdWxkIHRha2Ugb3ZlciAxMHMsIGFuZCAyMHMgdG8gZnVsbHkgCj4+PiBib290IHRoZSBr
ZXJuZWwuCj4+PiBFdmVuIG15IFZNIG9uIFJQSSBDTTQgaGFzIHdheSBmYXN0ZXIgYm9vdCB0aW1l
LCBldmVuIGp1c3QgcnVubmluZyBvbiAKPj4+IFBDSUUyLjAgeDEgbGFuZSBOVk1FLCBhbmQganVz
dCA0IDIuMUdoeiBBNzIgY29yZS4KPj4+Cj4+PiBUaGlzIGlzIGRlZmluaXRlbHkgb3V0IG9mIG15
IGV4cGVjdGF0aW9uLCBJIGRvdWJsZSBjaGVja2VkIHRvIGJlIHN1cmUgCj4+PiB0aGF0IGl0J3Mg
cnVubmluZyBpbiBLVk0gbW9kZS4KPj4+Cj4+PiBCdXQgZnVydGhlciBkaWdnaW5nIHNob3dzIHRo
YXQsIHNpbmNlIFhhdmllciBBR1ggQ1BVIHN1cHBvcnRzIFZIRSwgCj4+PiBrdm0gaXMgcnVubmlu
ZyBpbiBWSEUgbW9kZSBvdGhlciB0aGFuIEhZUCBtb2RlIG9uIENNNC4KPj4+Cj4+PiBJcyB0aGVy
ZSBhbnl3YXkgdG8gbWFudWFsbHkgZGlzYWJsZSBWSEUgbW9kZSB0byB0ZXN0IHRoZSBtb3JlIGNv
bW1vbiAKPj4+IEhZUCBtb2RlIG9uIFhhdmllcj8KPj4KPj4gQWNjb3JkaW5nIHRvIGtlcm5lbC1w
YXJhbWV0ZXJzLnR4dCwgImt2bS1hcm0ubW9kZT1udmhlIiAob3IgaXRzIAo+PiBsb3ctbGV2ZWwg
ZXF1aXZhbGVudCAiaWRfYWE2NG1tZnIxLnZoPTAiKSBvbiB0aGUgY29tbWFuZCBsaW5lIHNob3Vs
ZCAKPj4gZG8gdGhhdC4KPiAKPiBUaGFua3MgZm9yIHRoaXMgb25lLCBJIHN0dXBpZGx5IG9ubHkg
c2VhcmNoZWQgbW9kaW5mbyBvZiBrdm0sIGFuZCBkaWRuJ3QgCj4gZXZlbiBib3RoZXIgdG8gc2Vh
cmNoIGFyY2gvYXJtNjQva3ZtLi4uCj4gCj4+Cj4+IEhvd2V2ZXIgSSdkIGltYWdpbmUgdGhlIGRp
c2NyZXBhbmN5IGlzIGxpa2VseSB0byBiZSBzb21ldGhpbmcgbW9yZSAKPj4gZnVuZGFtZW50YWwg
dG8gdGhlIHdpbGRseSBkaWZmZXJlbnQgbWljcm9hcmNoaXRlY3R1cmVzLiBUaGVyZSdzIAo+PiBj
ZXJ0YWlubHkgbm8gaGFybSBpbiBnaXZpbmcgbm9uLVZIRSBhIGdvIGZvciBjb21wYXJpc29uLCBi
dXQgSSAKPj4gd291bGRuJ3QgYmUgc3VycHJpc2VkIGlmIGl0IHR1cm5zIG91dCBldmVuIHNsb3dl
ci4uLgo+IAo+IFlvdSdyZSB0b3RhbGx5IHJpZ2h0LCB3aXRoIG52aGUgbW9kZSwgaXQncyBzdGls
bCB0aGUgc2FtZSBzbG93IHNwZWVkLgo+IAo+IEJUVywgd2hhdCBkaWQgeW91IG1lYW4gYnkgdGhl
ICJ3aWxkbHkgZGlmZmVyZW50IG1pY3JvYXJjaCI/Cj4gSXMgQVJNdjguMiBhcmNoIHRoYXQgZGlm
ZmVyZW50IGZyb20gQVJNdjggb2YgUlBJND8KCkkgZG9uJ3QgbWVhbiBBcm12OC54IGFyY2hpdGVj
dHVyYWwgZmVhdHVyZXMsIEkgbWVhbiB0aGUgYWN0dWFsIAppbXBsZW1lbnRhdGlvbiBvZiBOVklE
SUEncyBDYXJtZWwgY29yZSBpcyB2ZXJ5LCB2ZXJ5IGRpZmZlcmVudCBmcm9tIApDb3J0ZXgtQTcy
IG9yIGluZGVlZCBvdXIgbmV3ZXIgdjguMiBDb3J0ZXgtQSBkZXNpZ25zLgoKPiBBbmQgYW55IGV4
dHJhIG1ldGhvZHMgSSBjb3VsZCB0cnkgdG8gZXhwbG9yZSB0aGUgcmVhc29uIG9mIHRoZSBzbG93
bmVzcz8KCkkgZ3Vlc3MgdGhlIGZpcnN0IGNoZWNrIHdvdWxkIGJlIHdoZXRoZXIgeW91J3JlIHRy
YXBwaW5nIGFuZCBleGl0aW5nIHRoZSAKVk0gc2lnbmlmaWNhbnRseSBtb3JlLiBJIGJlbGlldmUg
dGhlcmUgYXJlIHN0YXRzIHNvbWV3aGVyZSwgYnV0IEkgZG9uJ3QgCmtub3cgZXhhY3RseSB3aGVy
ZSwgc29ycnkgLSBJIGtub3cgdmVyeSBsaXR0bGUgYWJvdXQgYWN0dWFsbHkgKnVzaW5nKiBLVk0g
OikKCklmIGl0J3Mgbm90IHRoYXQsIHRoZW4gaXQgbWlnaHQganVzdCBiZSB0aGF0IEVESzIgaXMg
ZG9pbmcgYSBsb3Qgb2YgCmNhY2hlIG1haW50ZW5hbmNlIG9yIHN5c3RlbSByZWdpc3RlciBtb2Rp
ZmljYXRpb24gb3Igc29tZSBvdGhlciAKb3BlcmF0aW9uIHRoYXQgaGFwcGVucyB0byBiZSBzbG93
ZXIgb24gQ2FybWVsIGNvbXBhcmVkIHRvIENvcnRleC1BNzIuCgpSb2Jpbi4KCj4gQXQgbGVhc3Qg
UlBJIENNNCBpcyBiZXlvbmQgbXkgZXhwZWN0YXRpb24gYW5kIGlzIHdvcmtpbmcgcHJldHR5IGZp
bmUuCj4gCj4gVGhhbmtzLAo+IFF1Cj4gCj4+Cj4+IFJvYmluLgo+Pgo+Pj4gQlRXLCB0aGlzIGlz
IHRoZSBkbWVzZyByZWxhdGVkIHRvIEtWTSBvbiBYYXZpZXIsIHJ1bm5pbmcgdjUuMTMgCj4+PiB1
cHN0cmVhbSBrZXJuZWwsIHdpdGggNjRLIHBhZ2Ugc2l6ZToKPj4+IFvCoMKgwqAgMC44NTIzNTdd
IGt2bSBbMV06IElQQSBTaXplIExpbWl0OiA0MCBiaXRzCj4+PiBbwqDCoMKgIDAuODU3Mzc4XSBr
dm0gWzFdOiB2Z2ljIGludGVycnVwdCBJUlE5Cj4+PiBbwqDCoMKgIDAuODYyMTIyXSBrdm06IHBt
dSBldmVudCBjcmVhdGlvbiBmYWlsZWQgLTIKPj4+IFvCoMKgwqAgMC44NjY3MzRdIGt2bSBbMV06
IFZIRSBtb2RlIGluaXRpYWxpemVkIHN1Y2Nlc3NmdWxseQo+Pj4KPj4+IFdoaWxlIG9uIENNNCwg
dGhlIGhvc3QgcnVucyB2NS4xMi4xMCB1cHN0cmVhbSBrZXJuZWwgKHdpdGggZG93bnN0cmVhbSAK
Pj4+IGR0YiksIHdpdGggNEsgcGFnZSBzaXplOgo+Pj4gW8KgwqDCoCAxLjI3NjgxOF0ga3ZtIFsx
XTogSVBBIFNpemUgTGltaXQ6IDQ0IGJpdHMKPj4+IFvCoMKgwqAgMS4yNzg0MjVdIGt2bSBbMV06
IHZnaWMgaW50ZXJydXB0IElSUTkKPj4+IFvCoMKgwqAgMS4yNzg2MjBdIGt2bSBbMV06IEh5cCBt
b2RlIGluaXRpYWxpemVkIHN1Y2Nlc3NmdWxseQo+Pj4KPj4+IENvdWxkIGl0IGJlIHRoZSBQQUdF
IHNpemUgY2F1c2luZyBwcm9ibGVtPwo+Pj4KPj4+IFRoYW5rcywKPj4+IFF1Cj4+Pgo+Pj4KPj4+
IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4+PiBsaW51
eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdAo+Pj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZy
YWRlYWQub3JnCj4+PiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZv
L2xpbnV4LWFybS1rZXJuZWwKPj4KPiAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
