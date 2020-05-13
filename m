Return-Path: <SRS0=/ewP=63=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B908BC2D0FF
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 13:29:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F316C20657
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 13:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcTjyLBn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F316C20657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 895934B329;
	Wed, 13 May 2020 09:29:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ddOUZ54mJXyI; Wed, 13 May 2020 09:29:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170944B320;
	Wed, 13 May 2020 09:29:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A854B31E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 09:29:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wYgiLoswOGdr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2020 09:29:03 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5C94B30B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 09:29:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1589376543;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KoV5Wqms5AH46esJ6zYoKxLFFe0Vww3N0l8ERghmRN4=;
 b=RcTjyLBnCN8cwUOlTOor2lVXEpwVNshjO4b2+gSQU0hh4fIU54DPQ1j88OI7MeuGTVs0hf
 eyroIJPyYMQ7yHH3pDkSByAhbkKCtgYP8T4DIZOjv31b+F8M3AHaZeSTWPXe0kdvNK3dyL
 4Nv0/W1w59IqMEwopIqREGf/kwRL2vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-HnptDom5NM2MsQHnVL9a5Q-1; Wed, 13 May 2020 09:28:58 -0400
X-MC-Unique: HnptDom5NM2MsQHnVL9a5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DEED80183C;
 Wed, 13 May 2020 13:28:56 +0000 (UTC)
Received: from [10.36.112.22] (ovpn-112-22.ams2.redhat.com [10.36.112.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94BE910013BD;
 Wed, 13 May 2020 13:28:45 +0000 (UTC)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Zhangfei Gao <zhangfei.gao@linaro.org>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
 <06fe02f7-2556-8986-2f1e-dcdf59773b8c@redhat.com>
 <c7786a2a314e4c4ab37ef157ddfa23af@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <3858dd8c-ee55-b0d7-96cc-3c047ba8f652@redhat.com>
Date: Wed, 13 May 2020 15:28:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c7786a2a314e4c4ab37ef157ddfa23af@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "bbhushan2@marvell.com" <bbhushan2@marvell.com>
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

SGkgU2hhbWVlciwKCk9uIDUvNy8yMCA4OjU5IEFNLCBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2Rp
IHdyb3RlOgo+IEhpIEVyaWMsCj4gCj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tCj4+IEZy
b206IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkKPj4gU2VudDogMzAgQXByaWwgMjAyMCAxMDoz
OAo+PiBUbzogJ0F1Z2VyIEVyaWMnIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+OyBaaGFuZ2ZlaSBH
YW8KPj4gPHpoYW5nZmVpLmdhb0BsaW5hcm8ub3JnPjsgZXJpYy5hdWdlci5wcm9AZ21haWwuY29t
Owo+PiBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsKPj4ga3ZtQHZnZXIua2VybmVsLm9yZzsga3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdTsgd2lsbEBrZXJuZWwub3JnOwo+PiBqb3JvQDhieXRlcy5vcmc7IG1hekBrZXJuZWwu
b3JnOyByb2Jpbi5tdXJwaHlAYXJtLmNvbQo+PiBDYzogamVhbi1waGlsaXBwZUBsaW5hcm8ub3Jn
OyBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsKPj4gamFjb2IuanVuLnBhbkBsaW51eC5pbnRl
bC5jb207IHlpLmwubGl1QGludGVsLmNvbTsgcGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3JnOwo+PiB0
bkBzZW1paGFsZi5jb207IGJiaHVzaGFuMkBtYXJ2ZWxsLmNvbQo+PiBTdWJqZWN0OiBSRTogW1BB
VENIIHYxMSAwMC8xM10gU01NVXYzIE5lc3RlZCBTdGFnZSBTZXR1cCAoSU9NTVUgcGFydCkKPj4K
Pj4gSGkgRXJpYywKPj4KPj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tCj4+PiBGcm9tOiBB
dWdlciBFcmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQuY29tXQo+Pj4gU2VudDogMTYgQXBy
aWwgMjAyMCAwODo0NQo+Pj4gVG86IFpoYW5nZmVpIEdhbyA8emhhbmdmZWkuZ2FvQGxpbmFyby5v
cmc+OyBlcmljLmF1Z2VyLnByb0BnbWFpbC5jb207Cj4+PiBpb21tdUBsaXN0cy5saW51eC1mb3Vu
ZGF0aW9uLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsKPj4+IGt2bUB2Z2VyLmtl
cm5lbC5vcmc7IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7IHdpbGxAa2VybmVsLm9yZzsK
Pj4+IGpvcm9AOGJ5dGVzLm9yZzsgbWF6QGtlcm5lbC5vcmc7IHJvYmluLm11cnBoeUBhcm0uY29t
Cj4+PiBDYzogamVhbi1waGlsaXBwZUBsaW5hcm8ub3JnOyBTaGFtZWVyYWxpIEtvbG90aHVtIFRo
b2RpCj4+PiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPjsgYWxleC53aWxs
aWFtc29uQHJlZGhhdC5jb207Cj4+PiBqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbTsgeWku
bC5saXVAaW50ZWwuY29tOyBwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc7Cj4+PiB0bkBzZW1paGFs
Zi5jb207IGJiaHVzaGFuMkBtYXJ2ZWxsLmNvbQo+Pj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTEg
MDAvMTNdIFNNTVV2MyBOZXN0ZWQgU3RhZ2UgU2V0dXAgKElPTU1VIHBhcnQpCj4+Pgo+Pj4gSGkg
WmhhbmdmZWksCj4+Pgo+Pj4gT24gNC8xNi8yMCA2OjI1IEFNLCBaaGFuZ2ZlaSBHYW8gd3JvdGU6
Cj4+Pj4KPj4+Pgo+Pj4+IE9uIDIwMjAvNC8xNCDkuIvljYgxMTowNSwgRXJpYyBBdWdlciB3cm90
ZToKPj4+Pj4gVGhpcyB2ZXJzaW9uIGZpeGVzIGFuIGlzc3VlIG9ic2VydmVkIGJ5IFNoYW1lZXIg
b24gYW4gU01NVSAzLjIsCj4+Pj4+IHdoZW4gbW92aW5nIGZyb20gZHVhbCBzdGFnZSBjb25maWcg
dG8gc3RhZ2UgMSBvbmx5IGNvbmZpZy4KPj4+Pj4gVGhlIDIgaGlnaCA2NGIgb2YgdGhlIFNURSBu
b3cgZ2V0IHJlc2V0LiBPdGhlcndpc2UsIGxlYXZpbmcgdGhlCj4+Pj4+IFMyVFRCIHNldCBtYXkg
Y2F1c2UgYSBDX0JBRF9TVEUgZXJyb3IuCj4+Pj4+Cj4+Pj4+IFRoaXMgc2VyaWVzIGNhbiBiZSBm
b3VuZCBhdDoKPj4+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9saW51eC90cmVlL3Y1LjYt
MnN0YWdlLXYxMV8xMC4xCj4+Pj4+IChpbmNsdWRpbmcgdGhlIFZGSU8gcGFydCkKPj4+Pj4gVGhl
IFFFTVUgZmVsbG93IHNlcmllcyBzdGlsbCBjYW4gYmUgZm91bmQgYXQ6Cj4+Pj4+IGh0dHBzOi8v
Z2l0aHViLmNvbS9lYXVnZXIvcWVtdS90cmVlL3Y0LjIuMC0yc3RhZ2UtcmZjdjYKPj4+Pj4KPj4+
Pj4gVXNlcnMgaGF2ZSBleHByZXNzZWQgaW50ZXJlc3QgaW4gdGhhdCB3b3JrIGFuZCB0ZXN0ZWQg
djkvdjEwOgo+Pj4+PiAtIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvY292ZXIvMTEwMzk5
OTUvIzIzMDEyMzgxCj4+Pj4+IC0gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9jb3Zlci8x
MTAzOTk5NS8jMjMxOTcyMzUKPj4+Pj4KPj4+Pj4gQmFja2dyb3VuZDoKPj4+Pj4KPj4+Pj4gVGhp
cyBzZXJpZXMgYnJpbmdzIHRoZSBJT01NVSBwYXJ0IG9mIEhXIG5lc3RlZCBwYWdpbmcgc3VwcG9y
dAo+Pj4+PiBpbiB0aGUgU01NVXYzLiBUaGUgVkZJTyBwYXJ0IGlzIHN1Ym1pdHRlZCBzZXBhcmF0
ZWx5Lgo+Pj4+Pgo+Pj4+PiBUaGUgSU9NTVUgQVBJIGlzIGV4dGVuZGVkIHRvIHN1cHBvcnQgMiBu
ZXcgQVBJIGZ1bmN0aW9uYWxpdGllczoKPj4+Pj4gMSkgcGFzcyB0aGUgZ3Vlc3Qgc3RhZ2UgMSBj
b25maWd1cmF0aW9uCj4+Pj4+IDIpIHBhc3Mgc3RhZ2UgMSBNU0kgYmluZGluZ3MKPj4+Pj4KPj4+
Pj4gVGhlbiB0aG9zZSBjYXBhYmlsaXRpZXMgZ2V0cyBpbXBsZW1lbnRlZCBpbiB0aGUgU01NVXYz
IGRyaXZlci4KPj4+Pj4KPj4+Pj4gVGhlIHZpcnR1YWxpemVyIHBhc3NlcyBpbmZvcm1hdGlvbiB0
aHJvdWdoIHRoZSBWRklPIHVzZXIgQVBJCj4+Pj4+IHdoaWNoIGNhc2NhZGVzIHRoZW0gdG8gdGhl
IGlvbW11IHN1YnN5c3RlbS4gVGhpcyBhbGxvd3MgdGhlIGd1ZXN0Cj4+Pj4+IHRvIG93biBzdGFn
ZSAxIHRhYmxlcyBhbmQgY29udGV4dCBkZXNjcmlwdG9ycyAoc28tY2FsbGVkIFBBU0lECj4+Pj4+
IHRhYmxlKSB3aGlsZSB0aGUgaG9zdCBvd25zIHN0YWdlIDIgdGFibGVzIGFuZCBtYWluIGNvbmZp
Z3VyYXRpb24KPj4+Pj4gc3RydWN0dXJlcyAoU1RFKS4KPj4+Pj4KPj4+Pj4KPj4+Pgo+Pj4+IFRo
YW5rcyBFcmljCj4+Pj4KPj4+PiBUZXN0ZWQgdjExIG9uIEhpc2lsaWNvbiBrdW5wZW5nOTIwIGJv
YXJkIHZpYSBoYXJkd2FyZSB6aXAgYWNjZWxlcmF0b3IuCj4+Pj4gMS4gbm8tc3ZhIHdvcmtzLCB3
aGVyZSBndWVzdCBhcHAgZGlyZWN0bHkgdXNlIHBoeXNpY2FsIGFkZHJlc3MgdmlhIGlvY3RsLgo+
Pj4gVGhhbmsgeW91IGZvciB0aGUgdGVzdGluZy4gR2xhZCBpdCB3b3JrcyBmb3IgeW91Lgo+Pj4+
IDIuIHZTVkEgc3RpbGwgbm90IHdvcmssIHNhbWUgYXMgdjEwLAo+Pj4gWWVzIHRoYXQncyBub3Jt
YWwgdGhpcyBzZXJpZXMgaXMgbm90IG1lYW50IHRvIHN1cHBvcnQgdlNWTSBhdCB0aGlzIHN0YWdl
Lgo+Pj4KPj4+IEkgaW50ZW5kIHRvIGFkZCB0aGUgbWlzc2luZyBwaWVjZXMgZHVyaW5nIHRoZSBu
ZXh0IHdlZWtzLgo+Pgo+PiBUaGFua3MgZm9yIHRoYXQuIEkgaGF2ZSBtYWRlIGFuIGF0dGVtcHQg
dG8gYWRkIHRoZSB2U1ZBIGJhc2VkIG9uCj4+IHlvdXIgdjEwICsgSlBCcyBzdmEgcGF0Y2hlcy4g
VGhlIGhvc3Qga2VybmVsIGFuZCBRZW11IGNoYW5nZXMgY2FuCj4+IGJlIGZvdW5kIGhlcmVbMV1b
Ml0uCj4+Cj4+IFRoaXMgYmFzaWNhbGx5IGFkZHMgbXVsdGlwbGUgcGFzaWQgc3VwcG9ydCBvbiB0
b3Agb2YgeW91ciBjaGFuZ2VzLgo+PiBJIGhhdmUgZG9uZSBzb21lIGJhc2ljIHNhbml0eSB0ZXN0
aW5nIGFuZCB3ZSBoYXZlIHNvbWUgaW5pdGlhbCBzdWNjZXNzCj4+IHdpdGggdGhlIHppcCB2ZiBk
ZXYgb24gb3VyIEQwNiBwbGF0Zm9ybS4gUGxlYXNlIG5vdGUgdGhhdCB0aGUgU1RBTEwgZXZlbnQg
aXMKPj4gbm90IHlldCBzdXBwb3J0ZWQgdGhvdWdoLCBidXQgd29ya3MgZmluZSBpZiB3ZSBtbG9j
aygpIGd1ZXN0IHVzciBtZW0uCj4gCj4gSSBoYXZlIGFkZGVkIFNUQUxMIHN1cHBvcnQgZm9yIG91
ciB2U1ZBIHByb3RvdHlwZSBhbmQgaXQgc2VlbXMgdG8gYmUKPiB3b3JraW5nKG9uIG91ciBoYXJk
d2FyZSkuIEkgaGF2ZSB1cGRhdGVkIHRoZSBrZXJuZWwgYW5kIHFlbXUgYnJhbmNoZXMgd2l0aAo+
IHRoZSBzYW1lWzFdWzJdLiBJIHNob3VsZCB3YXJuIHlvdSB0aG91Z2ggdGhhdCB0aGVzZSBhcmUg
cHJvdG90eXBlIGNvZGUgYW5kIEkgYW0gcHJldHR5Cj4gbXVjaCByZS11c2luZyB0aGUgVkZJT19J
T01NVV9TRVRfUEFTSURfVEFCTEUgaW50ZXJmYWNlIGZvciBhbG1vc3QgZXZlcnl0aGluZy4KPiBC
dXQgdGhvdWdodCBvZiBzaGFyaW5nLCBpbiBjYXNlIGlmIGl0IGlzIHVzZWZ1bCBzb21laG93IS4K
ClRoYW5rIHlvdSBhZ2FpbiBmb3Igc2hhcmluZyB0aGUgUE9DLiBJIGxvb2tlZCBhdCB0aGUga2Vy
bmVsIGFuZCBRRU1VCmJyYW5jaGVzLgoKSGVyZSBhcmUgc29tZSBwcmVsaW1pbmFyeSBjb21tZW50
czoKLSAiYXJtLXNtbXUtdjM6IFJlc2V0IFMyVFRCIHdoaWxlIHN3aXRjaGluZyBiYWNrIGZyb20g
bmVzdGVkIHN0YWdlIjogIGFzCnlvdSBtZW50aW9ubmVkIFMyVFRCIHJlc2V0IG5vdyBpcyBmZWF0
dXJlZCBpbiB2MTEKLSAiYXJtLXNtbXUtdjM6IEFkZCBzdXBwb3J0IGZvciBtdWx0aXBsZSBwYXNp
ZCBpbiBuZXN0ZWQgbW9kZSI6IEkgY291bGQKZWFzaWx5IGludGVncmF0ZSB0aGlzIGludG8gbXkg
c2VyaWVzLiBVcGRhdGUgdGhlIGlvbW11IGFwaSBmaXJzdCBhbmQKcGFzcyBtdWx0aXBsZSBDRCBp
bmZvIGluIGEgc2VwYXJhdGUgcGF0Y2gKLSAiYXJtLXNtbXUtdjM6IEFkZCBzdXBwb3J0IHRvIElu
dmFsaWRhdGUgQ0QiOiBDRCBpbnZhbGlkYXRpb24gc2hvdWxkIGJlCmNhc2NhZGVkIHRvIGhvc3Qg
dGhyb3VnaCB0aGUgUEFTSUQgY2FjaGUgaW52YWxpZGF0aW9uIHVhcGkgKG5vIHBiIHlvdQp3YXJu
ZWQgdXMgZm9yIHRoZSBQT0MgeW91IHNpbXBseSB1c2VkIFZGSU9fSU9NTVVfU0VUX1BBU0lEX1RB
QkxFKS4gSQp0aGluayBJIHNob3VsZCBhZGQgdGhpcyBzdXBwb3J0IGluIG15IG9yaWdpbmFsIHNl
cmllcyBhbHRob3VnaCBpdCBkb2VzCm5vdCBzZWVtIHRvIHRyaWdnZXIgYW55IGlzc3VlIHVwIHRv
IG5vdy4KLSAiYXJtLXNtbXUtdjM6IFJlbW92ZSBkdXBsaWNhdGlvbiBvZiBmYXVsdCBwcm9wYWdh
dGlvbiIuIEkgdW5kZXJzdGFuZAp0aGUgdHJhbnNjb2RlIGlzIGRvbmUgc29tZXdoZXJlIGVsc2Ug
d2l0aCBTVkEgYnV0IHdlIHN0aWxsIG5lZWQgdG8gZG8gaXQKaWYgYSBzaW5nbGUgQ0QgaXMgdXNl
ZCwgcmlnaHQ/IEkgd2lsbCByZXZpZXcgdGhlIFNWQSBjb2RlIHRvIGJldHRlcgp1bmRlcnN0YW5k
LgotIGZvciB0aGUgU1RBTEwgcmVzcG9uc2UgaW5qZWN0aW9uIEkgd291bGQgdGVuZCB0byB1c2Ug
YSBuZXcgVkZJTyByZWdpb24KZm9yIHJlc3BvbnNlcy4gQXQgdGhlIG1vbWVudCB0aGVyZSBpcyBh
IHNpbmdsZSBWRklPIHJlZ2lvbiBmb3IgcmVwb3J0aW5nCnRoZSBmYXVsdC4KCk9uIFFFTVUgc2lk
ZToKLSBJIGFtIGN1cnJlbnRseSB3b3JraW5nIG9uIDMuMiByYW5nZSBpbnZhbGlkYXRpb24gc3Vw
cG9ydCB3aGljaCBpcwpuZWVkZWQgZm9yIERQREsvVkZJTwotIFdoaWxlIGF0IGl0IEkgd2lsbCBs
b29rIGF0IGhvdyB0byBpbmNyZW1lbnRhbGx5IGludHJvZHVjZSBzb21lIG9mIHRoZQpmZWF0dXJl
cyB5b3UgbmVlZCBpbiB0aGlzIHNlcmllcy4KClRoYW5rcwoKRXJpYwoKCgo+IAo+IFRoYW5rcywK
PiBTaGFtZWVyCj4gCj4gWzFdaHR0cHM6Ly9naXRodWIuY29tL2hpc2lsaWNvbi9rZXJuZWwtZGV2
L2NvbW1pdHMvdnN2YS1wcm90b3R5cGUtaG9zdC12MQo+IAo+IFsyXWh0dHBzOi8vZ2l0aHViLmNv
bS9oaXNpbGljb24vcWVtdS90cmVlL3Y0LjIuMC0yc3RhZ2UtcmZjdjYtdnN2YS1wcm90b3R5cGUt
djEKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
