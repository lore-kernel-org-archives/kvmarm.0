Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E02FC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:04:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB42B611CE
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB42B611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030EA4B703;
	Mon, 10 May 2021 09:04:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OrrtZ6OByBRn; Mon, 10 May 2021 09:04:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B354B490;
	Mon, 10 May 2021 09:04:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5774B4BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 06:38:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NwbG4xFGEZ9e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 06:38:14 -0400 (EDT)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D19AA4B490
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 06:38:13 -0400 (EDT)
IronPort-SDR: Fqie5WVYzVluEl9KsmBZo9k1Pu589Ic8QXjTR2Q+5MdwEn5YE6rS/jf6sYrZXmxUjROvqi8LOZ
 G9WLULsYEn4w==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178751746"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; d="scan'208";a="178751746"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 May 2021 03:38:12 -0700
IronPort-SDR: JU9em1rwG53c9I2GxwySruTaXdECp0gSZmcOso56Md1N0uhUomogH00vC9OTP7tlBwt4Y3xl/N
 uFOmBnvwbipg==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; d="scan'208";a="470754705"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136])
 ([10.254.212.136])
 by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 May 2021 03:38:05 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: Marc Zyngier <maz@kernel.org>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
 <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
 <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
 <feee2889-6e91-46f3-123f-826a9c4ef43c@intel.com>
 <87wns6oqn1.wl-maz@kernel.org>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <dc75cd9b-cbab-41f1-bf92-71047f628389@intel.com>
Date: Mon, 10 May 2021 18:37:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <87wns6oqn1.wl-maz@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Mon, 10 May 2021 09:04:26 -0400
Cc: kvm@vger.kernel.org, mst@redhat.com, Jason Wang <jasowang@redhat.com>,
 cohuck@redhat.com, stable@vger.kernel.org, alex.williamson@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

CgpPbiA1LzEwLzIwMjEgNjowMCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIE1vbiwgMTAg
TWF5IDIwMjEgMDk6MzI6NTQgKzAxMDAsCj4gIlpodSwgTGluZ3NoYW4iIDxsaW5nc2hhbi56aHVA
aW50ZWwuY29tPiB3cm90ZToKPj4KPj4KPj4gT24gNS8xMC8yMDIxIDM6MDkgUE0sIFpodSwgTGlu
Z3NoYW4gd3JvdGU6Cj4+Pgo+Pj4gT24gNS8xMC8yMDIxIDEyOjM0IFBNLCBKYXNvbiBXYW5nIHdy
b3RlOgo+Pj4+IOWcqCAyMDIxLzUvMTAg5LiK5Y2IMTE6MDAsIFpodSwgTGluZ3NoYW4g5YaZ6YGT
Ogo+Pj4+Pgo+Pj4+PiBPbiA1LzEwLzIwMjEgMTA6NDMgQU0sIEphc29uIFdhbmcgd3JvdGU6Cj4+
Pj4+PiDlnKggMjAyMS81Lzgg5LiL5Y2IMzoxMSwgWmh1IExpbmdzaGFuIOWGmemBkzoKPj4+Pj4+
PiBUaGlzIHJldmVydHMgY29tbWl0IGE5NzlhNmFhMDA5ZjNjOTk2ODk0MzJlMGNkYjU0MDJhNDQ2
M2ZiODguCj4+Pj4+Pj4KPj4+Pj4+PiBUaGUgcmV2ZXJ0ZWQgY29tbWl0IG1heSBjYXVzZSBWTSBm
cmVlemUgb24gYXJtNjQgcGxhdGZvcm0uCj4+Pj4+Pj4gQmVjYXVzZSBvbiBhcm02NCBwbGF0Zm9y
bSwgc3RvcCBhIGNvbnN1bWVyIHdpbGwgc3VzcGVuZCB0aGUgVk0sCj4+Pj4+Pj4gdGhlIFZNIHdp
bGwgZnJlZXplIHdpdGhvdXQgYSBzdGFydCBjb25zdW1lcgo+Pj4+Pj4+Cj4+Pj4+Pj4gU2lnbmVk
LW9mZi1ieTogWmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPgo+Pj4+Pj4KPj4+
Pj4+IEFja2VkLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPgo+Pj4+Pj4KPj4+
Pj4+IFBsZWFzZSByZXN1Ym1pdCB3aXRoIHRoZSBmb3JtYWwgcHJvY2VzcyBvZiBzdGFibGUKPj4+
Pj4+IChzdGFibGUta2VybmVsLXJ1bGVzLnJzdCkuCj4+Pj4+IHN1cmUsIEkgd2lsbCByZS1zdWJt
aXQgaXQgdG8gc3RhYmxlIGtlcm5lbCBvbmNlIGl0IGlzIG1lcmdlZCBpbnRvCj4+Pj4+IExpbnVz
IHRyZWUuCj4+Pj4+Cj4+Pj4+IFRoYW5rcwo+Pj4+Cj4+Pj4gSSB0aGluayBpdCdzIGJldHRlciB0
byByZXN1Ym1pdCAob3B0aW9uIDEpLCBzZWUgaG93Cj4+Pj4gc3RhYmxlLWtlcm5lbC1ydWxlcy5y
c3Qgc2FpZDoKPj4+Pgo+Pj4+ICIiCj4+Pj4KPj4+PiA6cmVmOmBvcHRpb25fMWAgaXMgKipzdHJv
bmdseSoqIHByZWZlcnJlZCwgaXMgdGhlIGVhc2llc3QgYW5kIG1vc3QKPj4+PiBjb21tb24uCj4+
Pj4gOnJlZjpgb3B0aW9uXzJgIGFuZCA6cmVmOmBvcHRpb25fM2AgYXJlIG1vcmUgdXNlZnVsIGlm
IHRoZSBwYXRjaAo+Pj4+IGlzbid0IGRlZW1lZAo+Pj4+IHdvcnRoeSBhdCB0aGUgdGltZSBpdCBp
cyBhcHBsaWVkIHRvIGEgcHVibGljIGdpdCB0cmVlIChmb3IKPj4+PiBpbnN0YW5jZSwgYmVjYXVz
ZQo+Pj4+IGl0IGRlc2VydmVzIG1vcmUgcmVncmVzc2lvbiB0ZXN0aW5nIGZpcnN0KS4KPj4+Pgo+
Pj4+ICIiIgo+Pj4+Cj4+Pj4gVGhhbmtzCj4+PiBPSywgd29ya3MgZm9yIG1lLCBJIHdpbGwgYWRk
IGNjIHN0YWJsZSwgYW5kIHJlc3VibWl0IGl0IHNvb24KPj4+Cj4+PiBUaGFua3MhCj4+IEkganVz
dCBzZWVNYXJjIGhhcyBhbHJlYWR5IGFkZGVkICJDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyIs
IGFuZAo+PiBoZSB3b3VsZCB0YWtlIHRoZSBwYXRjaCBpbiBoaXMgdHJlZSwgc28gSSB0aGluayBu
byBuZWVkIHRvIHJlc2VuZC4KPiBUaGF0J3MgZmluZSwgSSBjYW4gZml4IHRoaW5ncyB1cCBteXNl
bGYgYW5kIHF1ZXVlIHRoZSBmaXggZm9yIC1yYzIuClRoYW5rcyBNYXJjIQo+Cj4gVGhhbmtzLAo+
Cj4gCU0uCj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
