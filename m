Return-Path: <SRS0=z9tc=KD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F56C433ED
	for <kvmarm@archiver.kernel.org>; Sat,  8 May 2021 09:18:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 595EB61466
	for <kvmarm@archiver.kernel.org>; Sat,  8 May 2021 09:18:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 595EB61466
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC76D4B809;
	Sat,  8 May 2021 05:18:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WoO+0bu5txbg; Sat,  8 May 2021 05:18:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E1B4B803;
	Sat,  8 May 2021 05:18:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 541D14B815
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 May 2021 02:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cAsffUfw-hXL for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 May 2021 02:57:20 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCB7D4B80A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 May 2021 02:57:19 -0400 (EDT)
IronPort-SDR: EEy2j4RmkkUE29js7BU3C7lp1eOYAkOeUUk8FDra/25zZHGMd1sgJUA9bXbzgrIdqe2TpNuPKU
 3J2ma2XQa/Kg==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="198534777"
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; d="scan'208";a="198534777"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 07 May 2021 23:57:18 -0700
IronPort-SDR: zS4QOPadBzcAxJpEIR004ULpAonv9OaBt4d9Hfs0piQ51u0zXRSpAbLsa0LmW5WvY0rMNl+A/g
 R8ub7TQ6FLPQ==
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; d="scan'208";a="470153866"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.3])
 ([10.254.209.3])
 by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 07 May 2021 23:57:02 -0700
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To: Jason Wang <jasowang@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Shaokun Zhang <zhangshaokun@hisilicon.com>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
 <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
 <878s4qq00u.wl-maz@kernel.org> <874kfepht4.wl-maz@kernel.org>
 <373c70d3-eda3-8e84-d138-2f90d4e55217@redhat.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <4695fd66-7832-5070-627a-74dd254f7456@intel.com>
Date: Sat, 8 May 2021 14:56:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <373c70d3-eda3-8e84-d138-2f90d4e55217@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Sat, 08 May 2021 05:18:12 -0400
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-pci@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Bjorn Helgaas <bhelgaas@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

CgpPbiA1LzgvMjAyMSA5OjUxIEFNLCBKYXNvbiBXYW5nIHdyb3RlOgo+Cj4g5ZyoIDIwMjEvNS84
IOS4iuWNiDE6MzYsIE1hcmMgWnluZ2llciDlhpnpgZM6Cj4+IE9uIEZyaSwgMDcgTWF5IDIwMjEg
MTI6MDI6NTcgKzAxMDAsCj4+IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyb3RlOgo+
Pj4gT24gRnJpLCAwNyBNYXkgMjAyMSAxMDo1ODoyMyArMDEwMCwKPj4+IFNoYW9rdW4gWmhhbmcg
PHpoYW5nc2hhb2t1bkBoaXNpbGljb24uY29tPiB3cm90ZToKPj4+PiBIaSBNYXJjLAo+Pj4+Cj4+
Pj4gVGhhbmtzIGZvciB5b3VyIHF1aWNrIHJlcGx5Lgo+Pj4+Cj4+Pj4gT24gMjAyMS81LzcgMTc6
MDMsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+Pj4gT24gRnJpLCAwNyBNYXkgMjAyMSAwNjo1Nzow
NCArMDEwMCwKPj4+Pj4gU2hhb2t1biBaaGFuZyA8emhhbmdzaGFva3VuQGhpc2lsaWNvbi5jb20+
IHdyb3RlOgo+Pj4+Pj4gW1RoaXMgbGV0dGVyIGNvbWVzIGZyb20gTmlhbnlhbyBUYW5nXQo+Pj4+
Pj4KPj4+Pj4+IEhpLAo+Pj4+Pj4KPj4+Pj4+IFVzaW5nIEdJQ3Y0LzQuMSBhbmQgbXNpIGNhcGFi
aWxpdHksIGd1ZXN0IHZmIGRyaXZlciByZXF1aXJlcyAzCj4+Pj4+PiB2ZWN0b3JzIGFuZCBlbmFi
bGUgbXNpLCB3aWxsIGxlYWQgdG8gZ3Vlc3Qgc3R1Y2suCj4+Pj4+IFN0dWNrIGhvdz8KPj4+PiBH
dWVzdCBzZXJpYWwgZG9lcyBub3QgcmVzcG9uc2UgYW55bW9yZSBhbmQgZ3Vlc3QgbmV0d29yayBz
aHV0ZG93bi4KPj4+Pgo+Pj4+Pj4gUWVtdSBnZXRzIG51bWJlciBvZiBpbnRlcnJ1cHRzIGZyb20g
TXVsdGlwbGUgTWVzc2FnZSBDYXBhYmxlIGZpZWxkCj4+Pj4+PiBzZXQgYnkgZ3Vlc3QuIFRoaXMg
ZmllbGQgaXMgYWxpZ25lZCB0byBhIHBvd2VyIG9mIDIoaWYgYSBmdW5jdGlvbgo+Pj4+Pj4gcmVx
dWlyZXMgMyB2ZWN0b3JzLCBpdCBpbml0aWFsaXplcyBpdCB0byAyKS4KPj4+Pj4gU28gSSBndWVz
cyB0aGlzIGlzIGEgTXVsdGlNU0kgZGV2aWNlIHdpdGggNCB2ZWN0b3JzLCByaWdodD8KPj4+Pj4K
Pj4+PiBZZXMsIGl0IGNhbiBzdXBwb3J0IG1heGltdW0gb2YgMzIgbXNpIGludGVycnVwdHMsIGFu
ZCB2ZiBkcml2ZXIgCj4+Pj4gb25seSB1c2UgMyBtc2kuCj4+Pj4KPj4+Pj4+IEhvd2V2ZXIsIGd1
ZXN0IGRyaXZlciBqdXN0IHNlbmRzIDMgbWFwaS1jbWQgdG8gdml0cyBhbmQgMyBpdGUKPj4+Pj4+
IGVudHJpZXMgaXMgcmVjb3JkZWQgaW4gaG9zdC7CoCBWZmlvIGluaXRpYWxpemVzIG1zaSBpbnRl
cnJ1cHRzIHVzaW5nCj4+Pj4+PiB0aGUgbnVtYmVyIG9mIGludGVycnVwdHMgNCBwcm92aWRlIGJ5
IHFlbXUuwqAgV2hlbiBpdCBjb21lcyB0byB0aGUKPj4+Pj4+IDR0aCBtc2kgd2l0aG91dCBpdGUg
aW4gdml0cywgaW4gaXJxX2J5cGFzc19yZWdpc3Rlcl9wcm9kdWNlciwKPj4+Pj4+IHByb2R1Y2Vy
IGFuZCBjb25zdW1lciB3aWxsIF9fY29ubmVjdCBmYWlsLCBkdWUgdG8gZmluZF9pdGUgZmFpbCwg
YW5kCj4+Pj4+PiBkbyBub3QgcmVzdW1lIGd1ZXN0Lgo+Pj4+PiBMZXQgbWUgcmVwaHJhc2UgdGhp
cyB0byBjaGVjayB0aGF0IEkgdW5kZXJzdGFuZCBpdDoKPj4+Pj4gLSBUaGUgZGV2aWNlIGhhcyA0
IHZlY3RvcnMKPj4+Pj4gLSBUaGUgZ3Vlc3Qgb25seSBjcmVhdGUgbWFwcGluZ3MgZm9yIDMgb2Yg
dGhlbQo+Pj4+PiAtIFZGSU8gY2FsbHMga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoKSBmb3Ig
ZWFjaCB2ZWN0b3IKPj4+Pj4gLSBLVk0gZG9lc24ndCBoYXZlIGEgbWFwcGluZyBmb3IgdGhlIDR0
aCB2ZWN0b3IgYW5kIHJldHVybnMgYW4gZXJyb3IKPj4+Pj4gLSBWRklPIGRpc2FibGUgdGhpcyA0
dGggdmVjdG9yCj4+Pj4+Cj4+Pj4+IElzIHRoYXQgY29ycmVjdD8gSWYgeWVzLCBJIGRvbid0IHVu
ZGVyc3RhbmQgd2h5IHRoYXQgaW1wYWN0cyB0aGUgCj4+Pj4+IGd1ZXN0Cj4+Pj4+IGF0IGFsbC4g
RnJvbSB3aGF0IEkgY2FuIHNlZSwgdmZpb19tc2lfc2V0X3ZlY3Rvcl9zaWduYWwoKSBqdXN0IHBy
aW50cwo+Pj4+PiBhIG1lc3NhZ2Ugb24gdGhlIGNvbnNvbGUgYW5kIGNhcnJpZXMgb24uCj4+Pj4+
Cj4+Pj4gZnVuY3Rpb24gY2FsbHM6Cj4+Pj4gLS0+IHZmaW9fbXNpX3NldF92ZWN0b3Jfc2lnbmFs
Cj4+Pj4gwqDCoMKgIC0tPiBpcnFfYnlwYXNzX3JlZ2lzdGVyX3Byb2R1Y2VyCj4+Pj4gwqDCoMKg
wqDCoMKgIC0tPl9fY29ubmVjdAo+Pj4+Cj4+Pj4gaW4gX19jb25uZWN0LCBhZGRfcHJvZHVjZXIg
ZmluYWxseSBjYWxscyBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZwo+Pj4+IGFuZCBmYWlscyB0
byBnZXQgdGhlIDR0aCBtYXBwaW5nLiBXaGVuIGFkZF9wcm9kdWNlciBmYWlsLCBpdCBkb2VzCj4+
Pj4gbm90IGNhbGwgY29ucy0+c3RhcnQsIGNhbGxzIGt2bV9hcmNoX2lycV9ieXBhc3Nfc3RhcnQg
YW5kIHRoZW4KPj4+PiBrdm1fYXJtX3Jlc3VtZV9ndWVzdC4KPj4+IFsrRXJpYywgd2hvIHdyb3Rl
IHRoZSBpcnFfYnlwYXNzIGluZnJhc3RydWN0dXJlLl0KPj4+Cj4+PiBBaCwgc28gdGhlIGd1ZXN0
IGlzIGFjdHVhbGx5IHBhdXNlZCwgbm90IGluIGEgbGl2ZWxvY2sgc2l0dWF0aW9uCj4+PiAod2hp
Y2ggaXMgaG93IEkgaW50ZXJwcmV0ZWQgInN0dWNrIikuCj4+Pgo+Pj4gSSB0aGluayB3ZSBzaG91
bGQgaGFuZGxlIHRoaXMgY2FzZSBncmFjZWZ1bGx5LCBhcyB0aGVyZSBzaG91bGQgYmUgbm8KPj4+
IGV4cGVjdGF0aW9uIHRoYXQgdGhlIGd1ZXN0IHdpbGwgYmUgdXNpbmcgdGhpcyBpbnRlcnJ1cHQu
IEdpdmVuIHRoYXQKPj4+IFZGSU8gc2VlbXMgdG8gYmUgcHJldHR5IHVuZmF6ZWQgd2hlbiBhIHBy
b2R1Y2VyIGZhaWxzLCBJJ20gdGVtcGVkIHRvCj4+PiBkbyB0aGUgc2FtZSB0aGluZyBhbmQgcmVz
dGFydCB0aGUgZ3Vlc3QuCj4+Pgo+Pj4gQWxzbywgX19kaXNjb25uZWN0IGRvZXNuJ3QgY2FyZSBh
Ym91dCBlcnJvcnMsIHNvIHdoeSBzaG91bGQgX19jb25uZWN0Cj4+PiBoYXZlIHRoaXMgb2RkIGJl
aGF2aW91cj8KPj4+Cj4+PiBDYW4geW91IHBsZWFzZSB0cnkgdGhpcz8gSXQgaXMgY29tcGxldGVs
eSB1bnRlc3RlZCAoYW5kIEkgdGhpbmsgdGhlCj4+PiBkZWxfY29uc3VtZXIgY2FsbCBpcyBvZGQs
IHdoaWNoIGlzIHdoeSBJJ3ZlIGFsc28gZHJvcHBlZCBpdCkuCj4+Pgo+Pj4gRXJpYywgd2hhdCBk
byB5b3UgdGhpbms/Cj4+IEFkZGluZyBaaHUsIEphc29uLCBNU1QgdG8gdGhlIHBhcnR5LiBJdCBh
bGwgc2VlbXMgdG8gYmUgY2F1c2VkIGJ5IHRoaXMKPj4gY29tbWl0Ogo+Pgo+PiBjb21taXQgYTk3
OWE2YWEwMDlmM2M5OTY4OTQzMmUwY2RiNTQwMmE0NDYzZmI4OAo+PiBBdXRob3I6IFpodSBMaW5n
c2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4KPj4gRGF0ZTrCoMKgIEZyaSBKdWwgMzEgMTQ6
NTU6MzMgMjAyMCArMDgwMAo+Pgo+PiDCoMKgwqDCoCBpcnFieXBhc3M6IGRvIG5vdCBzdGFydCBj
b25zL3Byb2Qgd2hlbiBmYWlsZWQgY29ubmVjdAo+PiDCoMKgwqDCoCDCoMKgwqDCoCBJZiBmYWls
ZWQgdG8gY29ubmVjdCwgdGhlcmUgaXMgbm8gbmVlZCB0byBzdGFydCBjb25zdW1lciBub3IKPj4g
wqDCoMKgwqAgcHJvZHVjZXIuCj4+IMKgwqDCoMKgIMKgwqDCoMKgIFNpZ25lZC1vZmYtYnk6IFpo
dSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4KPj4gwqDCoMKgwqAgU3VnZ2VzdGVk
LWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPgo+PiDCoMKgwqDCoCBMaW5rOiAK
Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIwMDczMTA2NTUzMy40MTQ0LTctbGluZ3No
YW4uemh1QGludGVsLmNvbQo+PiDCoMKgwqDCoCBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFMuIFRz
aXJraW4gPG1zdEByZWRoYXQuY29tPgo+Pgo+Pgo+PiBaaHUsIEknZCByZWFsbHkgbGlrZSB0byB1
bmRlcnN0YW5kIHdoeSB5b3UgdGhpbmsgaXQgaXMgT0sgbm90IHRvCj4+IHJlc3RhcnQgY29uc3Vt
ZXIgYW5kIHByb2R1Y2VycyB3aGVuIGEgY29ubmVjdGlvbiBoYXMgZmFpbGVkIHRvIGJlCj4+IGVz
dGFibGlzaGVkIGJldHdlZW4gdGhlIHR3bz8KPgo+Cj4gTXkgYmFkLCBJIGRpZG4ndCBjaGVjayBB
Uk0gY29kZSBidXQgaXQncyBub3QgZWFzeSB0byBpbmZlciB0aGF0IHRoZSAKPiBjb25zLT5zdGFy
dC9zdG9wIGlzIG5vdCBhIHBlciBjb25zdW1lciBzcGVjaWZpYyBvcGVyYXRpb24gYnV0IGEgZ2xv
YmFsIAo+IG9uZSBsaWtlIFZNIGhhbHRpbmcvcmVzdW1pbmcuCkhpIE1hcmMsCgpJIHdpbGwgc2Vu
ZCBvdXQgYSBwYXRjaCB0byByZXZlcnQgdGhpcyBjb21taXQgYXMgSmFzb24gc3VnZ2VzdGVkLgoK
VGhhbmtzCj4KPgo+Pgo+PiBJbiB0aGUgY2FzZSBvZiBLVk0vYXJtNjQsIHRoaXMgcmVzdWx0cyBp
biB0aGUgZ3Vlc3QgYmVpbmcgZm9yZXZlcgo+PiBzdXNwZW5kZWQgYW5kIG5ldmVyIHJlc3VtZWQu
IFRoYXQncyBvYnZpb3VzbHkgbm90IGFuIGFjY2VwdGFibGUKPj4gcmVncmVzc2lvbiwgYXMgdGhl
cmUgaXMgYSBudW1iZXIgb2YgYmVuaWduIHJlYXNvbnMgZm9yIGEgY29ubmVjdCB0bwo+PiBmYWls
Lgo+Cj4KPiBMZXQncyByZXZlcnQgdGhpcyBjb21taXQuCj4KPiBUaGFua3MKPgo+Cj4+Cj4+IFRo
YW5rcywKPj4KPj4gwqDCoMKgwqBNLgo+Pgo+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
