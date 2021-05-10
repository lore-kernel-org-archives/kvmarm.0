Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F97C43460
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 08:35:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5A1261456
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 08:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5A1261456
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 338DE4B6F3;
	Mon, 10 May 2021 04:34:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KhlePbGfrAGD; Mon, 10 May 2021 04:34:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB5F4B57F;
	Mon, 10 May 2021 04:34:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B3F44B456
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 04:33:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PuGdErYeo54n for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 04:33:00 -0400 (EDT)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5B1D4B2CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 04:33:00 -0400 (EDT)
IronPort-SDR: fwJxLN6NE9Dswo7t/AGsOe50ffWlM8qqPfQzcOYUlnef+eYQbHYfiTYD+H1VbpI0SxxQ3BLV0a
 m5g1EIN7Dm/Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="260409532"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; d="scan'208";a="260409532"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 May 2021 01:32:59 -0700
IronPort-SDR: EI6UBs0GHV3icPsMda52IPH37BYgVnWhaaGj5zqVCose/og3/4GEBs4LFn3kLp+v2Feg7yeNcq
 l7DNyidfXprg==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; d="scan'208";a="470722622"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136])
 ([10.254.212.136])
 by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 May 2021 01:32:56 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, maz@kernel.org,
 alex.williamson@redhat.com
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
 <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
 <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
Message-ID: <feee2889-6e91-46f3-123f-826a9c4ef43c@intel.com>
Date: Mon, 10 May 2021 16:32:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
Content-Language: en-US
X-Mailman-Approved-At: Mon, 10 May 2021 04:34:57 -0400
Cc: stable@vger.kernel.org, cohuck@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiA1LzEwLzIwMjEgMzowOSBQTSwgWmh1LCBMaW5nc2hhbiB3cm90ZToKPgo+Cj4gT24gNS8x
MC8yMDIxIDEyOjM0IFBNLCBKYXNvbiBXYW5nIHdyb3RlOgo+Pgo+PiDlnKggMjAyMS81LzEwIOS4
iuWNiDExOjAwLCBaaHUsIExpbmdzaGFuIOWGmemBkzoKPj4+Cj4+Pgo+Pj4gT24gNS8xMC8yMDIx
IDEwOjQzIEFNLCBKYXNvbiBXYW5nIHdyb3RlOgo+Pj4+Cj4+Pj4g5ZyoIDIwMjEvNS84IOS4i+WN
iDM6MTEsIFpodSBMaW5nc2hhbiDlhpnpgZM6Cj4+Pj4+IFRoaXMgcmV2ZXJ0cyBjb21taXQgYTk3
OWE2YWEwMDlmM2M5OTY4OTQzMmUwY2RiNTQwMmE0NDYzZmI4OC4KPj4+Pj4KPj4+Pj4gVGhlIHJl
dmVydGVkIGNvbW1pdCBtYXkgY2F1c2UgVk0gZnJlZXplIG9uIGFybTY0IHBsYXRmb3JtLgo+Pj4+
PiBCZWNhdXNlIG9uIGFybTY0IHBsYXRmb3JtLCBzdG9wIGEgY29uc3VtZXIgd2lsbCBzdXNwZW5k
IHRoZSBWTSwKPj4+Pj4gdGhlIFZNIHdpbGwgZnJlZXplIHdpdGhvdXQgYSBzdGFydCBjb25zdW1l
cgo+Pj4+Pgo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBaaHUgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBp
bnRlbC5jb20+Cj4+Pj4KPj4+Pgo+Pj4+IEFja2VkLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0By
ZWRoYXQuY29tPgo+Pj4+Cj4+Pj4gUGxlYXNlIHJlc3VibWl0IHdpdGggdGhlIGZvcm1hbCBwcm9j
ZXNzIG9mIHN0YWJsZSAKPj4+PiAoc3RhYmxlLWtlcm5lbC1ydWxlcy5yc3QpLgo+Pj4gc3VyZSwg
SSB3aWxsIHJlLXN1Ym1pdCBpdCB0byBzdGFibGUga2VybmVsIG9uY2UgaXQgaXMgbWVyZ2VkIGlu
dG8gCj4+PiBMaW51cyB0cmVlLgo+Pj4KPj4+IFRoYW5rcwo+Pgo+Pgo+PiBJIHRoaW5rIGl0J3Mg
YmV0dGVyIHRvIHJlc3VibWl0IChvcHRpb24gMSksIHNlZSBob3cgCj4+IHN0YWJsZS1rZXJuZWwt
cnVsZXMucnN0IHNhaWQ6Cj4+Cj4+ICIiCj4+Cj4+IDpyZWY6YG9wdGlvbl8xYCBpcyAqKnN0cm9u
Z2x5KiogcHJlZmVycmVkLCBpcyB0aGUgZWFzaWVzdCBhbmQgbW9zdCAKPj4gY29tbW9uLgo+PiA6
cmVmOmBvcHRpb25fMmAgYW5kIDpyZWY6YG9wdGlvbl8zYCBhcmUgbW9yZSB1c2VmdWwgaWYgdGhl
IHBhdGNoIAo+PiBpc24ndCBkZWVtZWQKPj4gd29ydGh5IGF0IHRoZSB0aW1lIGl0IGlzIGFwcGxp
ZWQgdG8gYSBwdWJsaWMgZ2l0IHRyZWUgKGZvciBpbnN0YW5jZSwgCj4+IGJlY2F1c2UKPj4gaXQg
ZGVzZXJ2ZXMgbW9yZSByZWdyZXNzaW9uIHRlc3RpbmcgZmlyc3QpLgo+Pgo+PiAiIiIKPj4KPj4g
VGhhbmtzCj4gT0ssIHdvcmtzIGZvciBtZSwgSSB3aWxsIGFkZCBjYyBzdGFibGUsIGFuZCByZXN1
Ym1pdCBpdCBzb29uCj4KPiBUaGFua3MhCkkganVzdCBzZWVNYXJjIGhhcyBhbHJlYWR5IGFkZGVk
ICJDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyIsIGFuZCBoZSAKd291bGQgdGFrZSB0aGUgcGF0
Y2ggaW4gaGlzIHRyZWUsCnNvIEkgdGhpbmsgbm8gbmVlZCB0byByZXNlbmQuCgpUaGFua3MsClpo
dSBMaW5nc2hhbgo+Pgo+Pgo+Pj4+Cj4+Pj4gVGhhbmtzCj4+Pj4KPj4+Pgo+Pj4+PiAtLS0KPj4+
Pj4gwqAgdmlydC9saWIvaXJxYnlwYXNzLmMgfCAxNiArKysrKystLS0tLS0tLS0tCj4+Pj4+IMKg
IDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+Pj4+Pgo+
Pj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9saWIvaXJxYnlwYXNzLmMgYi92aXJ0L2xpYi9pcnFieXBh
c3MuYwo+Pj4+PiBpbmRleCBjOWJiMzk1N2Y1OGEuLjI4ZmRhNDJlNDcxYiAxMDA2NDQKPj4+Pj4g
LS0tIGEvdmlydC9saWIvaXJxYnlwYXNzLmMKPj4+Pj4gKysrIGIvdmlydC9saWIvaXJxYnlwYXNz
LmMKPj4+Pj4gQEAgLTQwLDIxICs0MCwxNyBAQCBzdGF0aWMgaW50IF9fY29ubmVjdChzdHJ1Y3Qg
Cj4+Pj4+IGlycV9ieXBhc3NfcHJvZHVjZXIgKnByb2QsCj4+Pj4+IMKgwqDCoMKgwqAgaWYgKHBy
b2QtPmFkZF9jb25zdW1lcikKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHByb2QtPmFk
ZF9jb25zdW1lcihwcm9kLCBjb25zKTsKPj4+Pj4gwqAgLcKgwqDCoCBpZiAocmV0KQo+Pj4+PiAt
wqDCoMKgwqDCoMKgwqAgZ290byBlcnJfYWRkX2NvbnN1bWVyOwo+Pj4+PiAtCj4+Pj4+IC3CoMKg
wqAgcmV0ID0gY29ucy0+YWRkX3Byb2R1Y2VyKGNvbnMsIHByb2QpOwo+Pj4+PiAtwqDCoMKgIGlm
IChyZXQpCj4+Pj4+IC3CoMKgwqDCoMKgwqDCoCBnb3RvIGVycl9hZGRfcHJvZHVjZXI7Cj4+Pj4+
ICvCoMKgwqAgaWYgKCFyZXQpIHsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IGNvbnMtPmFk
ZF9wcm9kdWNlcihjb25zLCBwcm9kKTsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQgJiYg
cHJvZC0+ZGVsX2NvbnN1bWVyKQo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcm9kLT5k
ZWxfY29uc3VtZXIocHJvZCwgY29ucyk7Cj4+Pj4+ICvCoMKgwqAgfQo+Pj4+PiDCoCDCoMKgwqDC
oMKgIGlmIChjb25zLT5zdGFydCkKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnMtPnN0YXJ0
KGNvbnMpOwo+Pj4+PiDCoMKgwqDCoMKgIGlmIChwcm9kLT5zdGFydCkKPj4+Pj4gwqDCoMKgwqDC
oMKgwqDCoMKgIHByb2QtPnN0YXJ0KHByb2QpOwo+Pj4+PiAtZXJyX2FkZF9wcm9kdWNlcjoKPj4+
Pj4gLcKgwqDCoCBpZiAocHJvZC0+ZGVsX2NvbnN1bWVyKQo+Pj4+PiAtwqDCoMKgwqDCoMKgwqAg
cHJvZC0+ZGVsX2NvbnN1bWVyKHByb2QsIGNvbnMpOwo+Pj4+PiAtZXJyX2FkZF9jb25zdW1lcjoK
Pj4+Pj4gKwo+Pj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+Pj4+IMKgIH0KPj4+Pgo+Pj4K
Pj4KPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
