Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE02C43460
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96F6161432
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96F6161432
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 350B44B3AB;
	Mon, 10 May 2021 03:51:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tazGQ32VK-KM; Mon, 10 May 2021 03:51:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46EBD4B3C6;
	Mon, 10 May 2021 03:51:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7CC54B433
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 03:09:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C5xhzcq0OWMx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 03:09:57 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB7BC402DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 03:09:57 -0400 (EDT)
IronPort-SDR: 7/DsEcxiL45MUwn33k1ZSie7odGozPlIACcrMMPyzaLm1be61f+NLCBGwKpg3pNqXSnopyJ8bK
 8L2kMrXJDu3A==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="220068770"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; d="scan'208";a="220068770"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 May 2021 00:09:56 -0700
IronPort-SDR: o0cXtX7zzu3uW9T2hJ+jaCGwDlWLBh+AsAvwRMc7EH2cGJ2bNXhLg1+iE3YSh74xWeRrtgnppO
 4P3A9+apSpHw==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; d="scan'208";a="470697844"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136])
 ([10.254.212.136])
 by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 May 2021 00:09:50 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, maz@kernel.org,
 alex.williamson@redhat.com
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
 <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
Date: Mon, 10 May 2021 15:09:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Mon, 10 May 2021 03:51:13 -0400
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

CgpPbiA1LzEwLzIwMjEgMTI6MzQgUE0sIEphc29uIFdhbmcgd3JvdGU6Cj4KPiDlnKggMjAyMS81
LzEwIOS4iuWNiDExOjAwLCBaaHUsIExpbmdzaGFuIOWGmemBkzoKPj4KPj4KPj4gT24gNS8xMC8y
MDIxIDEwOjQzIEFNLCBKYXNvbiBXYW5nIHdyb3RlOgo+Pj4KPj4+IOWcqCAyMDIxLzUvOCDkuIvl
jYgzOjExLCBaaHUgTGluZ3NoYW4g5YaZ6YGTOgo+Pj4+IFRoaXMgcmV2ZXJ0cyBjb21taXQgYTk3
OWE2YWEwMDlmM2M5OTY4OTQzMmUwY2RiNTQwMmE0NDYzZmI4OC4KPj4+Pgo+Pj4+IFRoZSByZXZl
cnRlZCBjb21taXQgbWF5IGNhdXNlIFZNIGZyZWV6ZSBvbiBhcm02NCBwbGF0Zm9ybS4KPj4+PiBC
ZWNhdXNlIG9uIGFybTY0IHBsYXRmb3JtLCBzdG9wIGEgY29uc3VtZXIgd2lsbCBzdXNwZW5kIHRo
ZSBWTSwKPj4+PiB0aGUgVk0gd2lsbCBmcmVlemUgd2l0aG91dCBhIHN0YXJ0IGNvbnN1bWVyCj4+
Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBaaHUgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5j
b20+Cj4+Pgo+Pj4KPj4+IEFja2VkLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29t
Pgo+Pj4KPj4+IFBsZWFzZSByZXN1Ym1pdCB3aXRoIHRoZSBmb3JtYWwgcHJvY2VzcyBvZiBzdGFi
bGUgCj4+PiAoc3RhYmxlLWtlcm5lbC1ydWxlcy5yc3QpLgo+PiBzdXJlLCBJIHdpbGwgcmUtc3Vi
bWl0IGl0IHRvIHN0YWJsZSBrZXJuZWwgb25jZSBpdCBpcyBtZXJnZWQgaW50byAKPj4gTGludXMg
dHJlZS4KPj4KPj4gVGhhbmtzCj4KPgo+IEkgdGhpbmsgaXQncyBiZXR0ZXIgdG8gcmVzdWJtaXQg
KG9wdGlvbiAxKSwgc2VlIGhvdyAKPiBzdGFibGUta2VybmVsLXJ1bGVzLnJzdCBzYWlkOgo+Cj4g
IiIKPgo+IDpyZWY6YG9wdGlvbl8xYCBpcyAqKnN0cm9uZ2x5KiogcHJlZmVycmVkLCBpcyB0aGUg
ZWFzaWVzdCBhbmQgbW9zdCAKPiBjb21tb24uCj4gOnJlZjpgb3B0aW9uXzJgIGFuZCA6cmVmOmBv
cHRpb25fM2AgYXJlIG1vcmUgdXNlZnVsIGlmIHRoZSBwYXRjaCBpc24ndCAKPiBkZWVtZWQKPiB3
b3J0aHkgYXQgdGhlIHRpbWUgaXQgaXMgYXBwbGllZCB0byBhIHB1YmxpYyBnaXQgdHJlZSAoZm9y
IGluc3RhbmNlLCAKPiBiZWNhdXNlCj4gaXQgZGVzZXJ2ZXMgbW9yZSByZWdyZXNzaW9uIHRlc3Rp
bmcgZmlyc3QpLgo+Cj4gIiIiCj4KPiBUaGFua3MKT0ssIHdvcmtzIGZvciBtZSwgSSB3aWxsIGFk
ZCBjYyBzdGFibGUsIGFuZCByZXN1Ym1pdCBpdCBzb29uCgpUaGFua3MhCj4KPgo+Pj4KPj4+IFRo
YW5rcwo+Pj4KPj4+Cj4+Pj4gLS0tCj4+Pj4gwqAgdmlydC9saWIvaXJxYnlwYXNzLmMgfCAxNiAr
KysrKystLS0tLS0tLS0tCj4+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwg
MTAgZGVsZXRpb25zKC0pCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9saWIvaXJxYnlwYXNz
LmMgYi92aXJ0L2xpYi9pcnFieXBhc3MuYwo+Pj4+IGluZGV4IGM5YmIzOTU3ZjU4YS4uMjhmZGE0
MmU0NzFiIDEwMDY0NAo+Pj4+IC0tLSBhL3ZpcnQvbGliL2lycWJ5cGFzcy5jCj4+Pj4gKysrIGIv
dmlydC9saWIvaXJxYnlwYXNzLmMKPj4+PiBAQCAtNDAsMjEgKzQwLDE3IEBAIHN0YXRpYyBpbnQg
X19jb25uZWN0KHN0cnVjdCBpcnFfYnlwYXNzX3Byb2R1Y2VyIAo+Pj4+ICpwcm9kLAo+Pj4+IMKg
wqDCoMKgwqAgaWYgKHByb2QtPmFkZF9jb25zdW1lcikKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0ID0gcHJvZC0+YWRkX2NvbnN1bWVyKHByb2QsIGNvbnMpOwo+Pj4+IMKgIC3CoMKgwqAgaWYg
KHJldCkKPj4+PiAtwqDCoMKgwqDCoMKgwqAgZ290byBlcnJfYWRkX2NvbnN1bWVyOwo+Pj4+IC0K
Pj4+PiAtwqDCoMKgIHJldCA9IGNvbnMtPmFkZF9wcm9kdWNlcihjb25zLCBwcm9kKTsKPj4+PiAt
wqDCoMKgIGlmIChyZXQpCj4+Pj4gLcKgwqDCoMKgwqDCoMKgIGdvdG8gZXJyX2FkZF9wcm9kdWNl
cjsKPj4+PiArwqDCoMKgIGlmICghcmV0KSB7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IGNv
bnMtPmFkZF9wcm9kdWNlcihjb25zLCBwcm9kKTsKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKHJl
dCAmJiBwcm9kLT5kZWxfY29uc3VtZXIpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJv
ZC0+ZGVsX2NvbnN1bWVyKHByb2QsIGNvbnMpOwo+Pj4+ICvCoMKgwqAgfQo+Pj4+IMKgIMKgwqDC
oMKgwqAgaWYgKGNvbnMtPnN0YXJ0KQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBjb25zLT5zdGFy
dChjb25zKTsKPj4+PiDCoMKgwqDCoMKgIGlmIChwcm9kLT5zdGFydCkKPj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqAgcHJvZC0+c3RhcnQocHJvZCk7Cj4+Pj4gLWVycl9hZGRfcHJvZHVjZXI6Cj4+Pj4g
LcKgwqDCoCBpZiAocHJvZC0+ZGVsX2NvbnN1bWVyKQo+Pj4+IC3CoMKgwqDCoMKgwqDCoCBwcm9k
LT5kZWxfY29uc3VtZXIocHJvZCwgY29ucyk7Cj4+Pj4gLWVycl9hZGRfY29uc3VtZXI6Cj4+Pj4g
Kwo+Pj4+IMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPj4+PiDCoCB9Cj4+Pgo+Pgo+CgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
