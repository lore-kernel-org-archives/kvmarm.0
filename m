Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A80C6379F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 08:40:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5D4324686
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 08:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4IycsIF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5D4324686
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135624B7E5;
	Tue, 17 Nov 2020 03:39:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T88nFH2kWOSK; Tue, 17 Nov 2020 03:39:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 947F14B7EC;
	Tue, 17 Nov 2020 03:39:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2134B7CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 03:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AHV80yheTcSF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 03:39:55 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 808FF4B698
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 03:39:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605602395;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=n1R2Oej2qk/ViRPwh0/U2GX+OhMC9Ake3lJNa//gEoY=;
 b=F4IycsIFgMf6hWr9KY6VEC/KRRNFwZj6RDLh/9U6Wp4VUuPIxxJ1+LxQdR8i2eo+33D/+v
 UCj0JeT7/kSl576AbCq6FejUzhXflJ5/JhRt5v2WQrU7iwNpxd4JPrE8uqXvVi7a2G4Jac
 M9zbKgB32zquNCqfxIi0PGcHPWS/tvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-5KeOuAeIMG6pvM2MHmcMaw-1; Tue, 17 Nov 2020 03:39:49 -0500
X-MC-Unique: 5KeOuAeIMG6pvM2MHmcMaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 706FC8030C7;
 Tue, 17 Nov 2020 08:39:47 +0000 (UTC)
Received: from [10.36.113.230] (ovpn-113-230.ams2.redhat.com [10.36.113.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A67925D9CC;
 Tue, 17 Nov 2020 08:39:39 +0000 (UTC)
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
 <3858dd8c-ee55-b0d7-96cc-3c047ba8f652@redhat.com>
 <9e323c4668e94ea89beec3689376b893@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a96395ff-09c2-8839-7a72-7b4031b5a5f4@redhat.com>
Date: Tue, 17 Nov 2020 09:39:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9e323c4668e94ea89beec3689376b893@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

SGkgU2hhbWVlciwKCk9uIDUvMTMvMjAgNTo1NyBQTSwgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9k
aSB3cm90ZToKPiBIaSBFcmljLAo+IAo+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQo+PiBG
cm9tOiBBdWdlciBFcmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQuY29tXQo+PiBTZW50OiAx
MyBNYXkgMjAyMCAxNDoyOQo+PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVl
cmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPjsKPj4gWmhhbmdmZWkgR2FvIDx6aGFuZ2Zl
aS5nYW9AbGluYXJvLm9yZz47IGVyaWMuYXVnZXIucHJvQGdtYWlsLmNvbTsKPj4gaW9tbXVAbGlz
dHMubGludXgtZm91bmRhdGlvbi5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7Cj4+
IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7IHdpbGxA
a2VybmVsLm9yZzsKPj4gam9yb0A4Ynl0ZXMub3JnOyBtYXpAa2VybmVsLm9yZzsgcm9iaW4ubXVy
cGh5QGFybS5jb20KPj4gQ2M6IGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZzsgYWxleC53aWxsaWFt
c29uQHJlZGhhdC5jb207Cj4+IGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tOyB5aS5sLmxp
dUBpbnRlbC5jb207IHBldGVyLm1heWRlbGxAbGluYXJvLm9yZzsKPj4gdG5Ac2VtaWhhbGYuY29t
OyBiYmh1c2hhbjJAbWFydmVsbC5jb20KPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTEgMDAvMTNd
IFNNTVV2MyBOZXN0ZWQgU3RhZ2UgU2V0dXAgKElPTU1VIHBhcnQpCj4+Cj4gWy4uLl0KPiAKPj4+
Pj4gWWVzIHRoYXQncyBub3JtYWwgdGhpcyBzZXJpZXMgaXMgbm90IG1lYW50IHRvIHN1cHBvcnQg
dlNWTSBhdCB0aGlzIHN0YWdlLgo+Pj4+Pgo+Pj4+PiBJIGludGVuZCB0byBhZGQgdGhlIG1pc3Np
bmcgcGllY2VzIGR1cmluZyB0aGUgbmV4dCB3ZWVrcy4KPj4+Pgo+Pj4+IFRoYW5rcyBmb3IgdGhh
dC4gSSBoYXZlIG1hZGUgYW4gYXR0ZW1wdCB0byBhZGQgdGhlIHZTVkEgYmFzZWQgb24KPj4+PiB5
b3VyIHYxMCArIEpQQnMgc3ZhIHBhdGNoZXMuIFRoZSBob3N0IGtlcm5lbCBhbmQgUWVtdSBjaGFu
Z2VzIGNhbgo+Pj4+IGJlIGZvdW5kIGhlcmVbMV1bMl0uCj4+Pj4KPj4+PiBUaGlzIGJhc2ljYWxs
eSBhZGRzIG11bHRpcGxlIHBhc2lkIHN1cHBvcnQgb24gdG9wIG9mIHlvdXIgY2hhbmdlcy4KPj4+
PiBJIGhhdmUgZG9uZSBzb21lIGJhc2ljIHNhbml0eSB0ZXN0aW5nIGFuZCB3ZSBoYXZlIHNvbWUg
aW5pdGlhbCBzdWNjZXNzCj4+Pj4gd2l0aCB0aGUgemlwIHZmIGRldiBvbiBvdXIgRDA2IHBsYXRm
b3JtLiBQbGVhc2Ugbm90ZSB0aGF0IHRoZSBTVEFMTCBldmVudCBpcwo+Pj4+IG5vdCB5ZXQgc3Vw
cG9ydGVkIHRob3VnaCwgYnV0IHdvcmtzIGZpbmUgaWYgd2UgbWxvY2soKSBndWVzdCB1c3IgbWVt
Lgo+Pj4KPj4+IEkgaGF2ZSBhZGRlZCBTVEFMTCBzdXBwb3J0IGZvciBvdXIgdlNWQSBwcm90b3R5
cGUgYW5kIGl0IHNlZW1zIHRvIGJlCj4+PiB3b3JraW5nKG9uIG91ciBoYXJkd2FyZSkuIEkgaGF2
ZSB1cGRhdGVkIHRoZSBrZXJuZWwgYW5kIHFlbXUgYnJhbmNoZXMKPj4gd2l0aAo+Pj4gdGhlIHNh
bWVbMV1bMl0uIEkgc2hvdWxkIHdhcm4geW91IHRob3VnaCB0aGF0IHRoZXNlIGFyZSBwcm90b3R5
cGUgY29kZSBhbmQgSQo+PiBhbSBwcmV0dHkKPj4+IG11Y2ggcmUtdXNpbmcgdGhlIFZGSU9fSU9N
TVVfU0VUX1BBU0lEX1RBQkxFIGludGVyZmFjZSBmb3IgYWxtb3N0Cj4+IGV2ZXJ5dGhpbmcuCj4+
PiBCdXQgdGhvdWdodCBvZiBzaGFyaW5nLCBpbiBjYXNlIGlmIGl0IGlzIHVzZWZ1bCBzb21laG93
IS4KPj4KPj4gVGhhbmsgeW91IGFnYWluIGZvciBzaGFyaW5nIHRoZSBQT0MuIEkgbG9va2VkIGF0
IHRoZSBrZXJuZWwgYW5kIFFFTVUKPj4gYnJhbmNoZXMuCj4+Cj4+IEhlcmUgYXJlIHNvbWUgcHJl
bGltaW5hcnkgY29tbWVudHM6Cj4+IC0gImFybS1zbW11LXYzOiBSZXNldCBTMlRUQiB3aGlsZSBz
d2l0Y2hpbmcgYmFjayBmcm9tIG5lc3RlZCBzdGFnZSI6ICBhcwo+PiB5b3UgbWVudGlvbm5lZCBT
MlRUQiByZXNldCBub3cgaXMgZmVhdHVyZWQgaW4gdjExCj4gCj4gWWVzLgo+IAo+PiAtICJhcm0t
c21tdS12MzogQWRkIHN1cHBvcnQgZm9yIG11bHRpcGxlIHBhc2lkIGluIG5lc3RlZCBtb2RlIjog
SSBjb3VsZAo+PiBlYXNpbHkgaW50ZWdyYXRlIHRoaXMgaW50byBteSBzZXJpZXMuIFVwZGF0ZSB0
aGUgaW9tbXUgYXBpIGZpcnN0IGFuZAo+PiBwYXNzIG11bHRpcGxlIENEIGluZm8gaW4gYSBzZXBh
cmF0ZSBwYXRjaAo+IAo+IE9rLgppbiB2MTIsIEkgYWRkZWQKW1BBVENIIHYxMiAxNC8xNV0gaW9t
bXUvc21tdXYzOiBBY2NlcHQgY29uZmlncyB3aXRoIG1vcmUgdGhhbiBvbmUKY29udGV4dCBkZXNj
cmlwdG9yCgpJIGRvbid0IHRoaW5rIHlvdSBuZWVkIHRvIGFkZCBzMWNkbWF4IGFkZGl0aW9uIGFz
IHdlIGFscmVhZHkgaGF2ZQpwYXNpZF9iaXRzIHdoaWNoIHNob3VsZCBkbyB0aGUgam9iLgoKPj4g
LSAiYXJtLXNtbXUtdjM6IEFkZCBzdXBwb3J0IHRvIEludmFsaWRhdGUgQ0QiOiBDRCBpbnZhbGlk
YXRpb24gc2hvdWxkIGJlCj4+IGNhc2NhZGVkIHRvIGhvc3QgdGhyb3VnaCB0aGUgUEFTSUQgY2Fj
aGUgaW52YWxpZGF0aW9uIHVhcGkgKG5vIHBiIHlvdQo+PiB3YXJuZWQgdXMgZm9yIHRoZSBQT0Mg
eW91IHNpbXBseSB1c2VkIFZGSU9fSU9NTVVfU0VUX1BBU0lEX1RBQkxFKS4gSQo+PiB0aGluayBJ
IHNob3VsZCBhZGQgdGhpcyBzdXBwb3J0IGluIG15IG9yaWdpbmFsIHNlcmllcyBhbHRob3VnaCBp
dCBkb2VzCj4+IG5vdCBzZWVtIHRvIHRyaWdnZXIgYW55IGlzc3VlIHVwIHRvIG5vdy4KPiAKPiBB
Z3JlZS4gQ2FjaGUgaW52YWxpZGF0aW9uIHVhcGkgaXMgYSBiZXR0ZXIgaW50ZXJmYWNlIGZvciB0
aGlzLiBBbHNvIEkgZG9u4oCZdCB0aGluawo+IHRoaXMgbWF0dGVycyBmb3Igbm9uLXZzdmEgY2Fz
ZXMgYXMgR3Vlc3Qga2VybmVsIHRhYmxlL0NEKHBhc2lkIDApIHdpbGwgbmV2ZXIKPiBnZXQgaW52
YWxpZGF0ZWQuIAppbiB2MTIgSSBhZGRlZCBbUEFUQ0ggdjEyIDE1LzE1XSBpb21tdS9zbW11djM6
IEFkZCBQQVNJRCBjYWNoZQppbnZhbGlkYXRpb24gcGVyIFBBU0lELiBJIGhhdmUgbm90IHRlc3Rl
ZCBpdCB0aG91Z2guCj4gCj4+IC0gImFybS1zbW11LXYzOiBSZW1vdmUgZHVwbGljYXRpb24gb2Yg
ZmF1bHQgcHJvcGFnYXRpb24iLiBJIHVuZGVyc3RhbmQKPj4gdGhlIHRyYW5zY29kZSBpcyBkb25l
IHNvbWV3aGVyZSBlbHNlIHdpdGggU1ZBIGJ1dCB3ZSBzdGlsbCBuZWVkIHRvIGRvIGl0Cj4+IGlm
IGEgc2luZ2xlIENEIGlzIHVzZWQsIHJpZ2h0PyBJIHdpbGwgcmV2aWV3IHRoZSBTVkEgY29kZSB0
byBiZXR0ZXIKPj4gdW5kZXJzdGFuZC4KClNpbmNlIEkgaGF2ZSByZWJhc2Ugb24gNS4xMC1yYzQg
eW91IHdpbGwgc3RpbGwgaGF2ZSB0aGlzIGR1cGxpY2F0aW9uIHRvCmhhbmRsZS4KPiAKPiBIbW0u
Lm5vdCBzdXJlLiBOZWVkIHRvIHRha2UgYW5vdGhlciBsb29rIHRvIHNlZSB3aGV0aGVyIHdlIG5l
ZWQgYSBzcGVjaWFsCj4gaGFuZGxpbmcgZm9yIHNpbmdsZSBDRCBvciBub3QuCj4gCj4+IC0gZm9y
IHRoZSBTVEFMTCByZXNwb25zZSBpbmplY3Rpb24gSSB3b3VsZCB0ZW5kIHRvIHVzZSBhIG5ldyBW
RklPIHJlZ2lvbgo+PiBmb3IgcmVzcG9uc2VzLiBBdCB0aGUgbW9tZW50IHRoZXJlIGlzIGEgc2lu
Z2xlIFZGSU8gcmVnaW9uIGZvciByZXBvcnRpbmcKPj4gdGhlIGZhdWx0LgoKaW4gdjEyIEkgYWRk
ZWQgYSBuZXcgVkZJTyByZWdpb24gdG8gaW5qZWN0IHlvdXIgZmF1bHQuIFRoaXMgd2FzIHRlc3Rl
ZAp3aXRoIGR1bW15IGV2ZW50IGluamVjdGlvbiwgdGhpcyBzaG91bGQgd29yayBwcm9wZXJseS4K
CklmIHdlIGNsZWFybHkgaWRlbnRpZnkgYWxsIHRoZSBwdWJsaWMgZGVwZW5kZW5jaWVzIG5lZWRl
ZCBmb3IgdlNWQS9BUk0gSQpjYW4gaGVscCB5b3UgcmVzcGlubmluZyBvbiB0b3Agb2YgdGhlbQoK
VGhhbmtzCgpFcmljCj4gCj4gU3VyZS4gVGhhdCB3aWxsIGJlIG11Y2ggY2xlYW5lciBhbmQgcHJv
YmFibHkgaW1wcm92ZSB0aGUgY29udGV4dCBzd2l0Y2gKPiBsYXRlbmN5LiBBbm90aGVyIHRoaW5n
IEkgbm90ZWQgd2l0aCBTVEFMTCBpcyB0aGF0IHBhc2lkX3ZhbGlkIGZsYWcgbmVlZHMgdG8gYmUK
PiB0YWtlbiBjYXJlIGluIHRoZSBTVkEga2VybmVsIHBhdGguIAo+IAo+ICJpb21tdTogUmVtb3Zl
IHBhc2lkIHZhbGlkaXR5IGNoZWNrIGZvciBTVEFMTCBtb2RlbCBwYWdlIHJlc3BvbnNlIG1zZyIK
PiBOb3Qgc3VyZSB0aGlzIG9uZSBpcyBhIHByb3BlciB3YXkgdG8gaGFuZGxlIHRoaXMuCj4gIAo+
PiBPbiBRRU1VIHNpZGU6Cj4+IC0gSSBhbSBjdXJyZW50bHkgd29ya2luZyBvbiAzLjIgcmFuZ2Ug
aW52YWxpZGF0aW9uIHN1cHBvcnQgd2hpY2ggaXMKPj4gbmVlZGVkIGZvciBEUERLL1ZGSU8KPj4g
LSBXaGlsZSBhdCBpdCBJIHdpbGwgbG9vayBhdCBob3cgdG8gaW5jcmVtZW50YWxseSBpbnRyb2R1
Y2Ugc29tZSBvZiB0aGUKPj4gZmVhdHVyZXMgeW91IG5lZWQgaW4gdGhpcyBzZXJpZXMuCj4gCj4g
T2suIAo+IAo+IFRoYW5rcyBmb3IgdGFraW5nIGEgbG9vayBhdCB0aGUgUE9DLgo+IAo+IENoZWVy
cywKPiBTaGFtZWVyCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
