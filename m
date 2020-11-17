Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E84C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 10:51:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ED1C241A7
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 10:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJb1EcqJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ED1C241A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 759F44B6F1;
	Tue, 17 Nov 2020 05:51:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d-9mX599dQlm; Tue, 17 Nov 2020 05:51:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5049F4B732;
	Tue, 17 Nov 2020 05:51:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5473C4B71E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 05:51:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 33DrlUbBZ5k4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 05:51:13 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36F1D4B6F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 05:51:13 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DF07A22447;
 Tue, 17 Nov 2020 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605610272;
 bh=M9flKwRDRr9z64KmcbSgnOXXghPG2KQsLqY0zyac1Pc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=hJb1EcqJN7y1+EllTk1nrvx7ql2HD2xrFheKYg8a5Qe1xK4dx+bbBZuRQE43nJsgP
 cLIg109k/Xs+axWgm62EusuYdb1mhlnsy5YoJwfluMJ9qupSxhcu4yXO2J0KinRL6h
 6YzGxnDuj0ANEfmFcJ7Quv/pVpImxgKmhNcqZMsc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1keyZp-00BIq8-MW; Tue, 17 Nov 2020 10:51:09 +0000
MIME-Version: 1.0
Date: Tue, 17 Nov 2020 10:51:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
In-Reply-To: <5ba4a98e-276b-2462-0580-fe0e007e9b38@redhat.com>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
 <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
 <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
 <cc45285fe491aff5c28a24f94c124508@kernel.org>
 <7e58200c-814e-3598-155a-9a7e6cc24374@huawei.com>
 <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
 <5ba4a98e-276b-2462-0580-fe0e007e9b38@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6f4312dbedd6c1d8fa88dc0fc5adcb5d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, yuzenghui@huawei.com,
 suzuki.poulose@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, wanghaibin.wang@huawei.com,
 zhukeqian1@huawei.com, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

T24gMjAyMC0xMS0xNyAwOTo1OSwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDExLzE3LzIwIDk6NDkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgWmVuZ2h1aSwKPj4g
Cj4+IE9uIDIwMjAtMTEtMTYgMTQ6NTcsIFplbmdodWkgWXUgd3JvdGU6Cj4+PiBIaSBNYXJjLAo+
Pj4gCj4+PiBPbiAyMDIwLzExLzE2IDIyOjEwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+IE15
IHRha2UgaXMgdGhhdCBvbmx5IGlmIHRoZSAiW1JlXURpc3RyaWJ1dG9yIGJhc2UgYWRkcmVzcyIg
aXMgCj4+Pj4+IHNwZWNpZmllZAo+Pj4+PiBpbiB0aGUgc3lzdGVtIG1lbW9yeSBtYXAsIHdpbGwg
dGhlIHVzZXItcHJvdmlkZWQgCj4+Pj4+IGt2bV9kZXZpY2VfYXR0ci5vZmZzZXQKPj4+Pj4gbWFr
ZSBzZW5zZS4gQW5kIHdlIGNhbiB0aGVuIGhhbmRsZSB0aGUgYWNjZXNzIHRvIHRoZSByZWdpc3Rl
ciB3aGljaCAKPj4+Pj4gaXMKPj4+Pj4gZGVmaW5lZCBieSAiYmFzZSBhZGRyZXNzICsgb2Zmc2V0
Ii4KPj4+PiAKPj4+PiBJJ2QgdGVuZCB0byBhZ3JlZSwgYnV0IGl0IGlzIGp1c3QgdGhhdCB0aGlz
IGlzIGEgbGFyZ2UgY2hhbmdlIGF0IAo+Pj4+IC1yYzQuCj4+Pj4gSSdkIHJhdGhlciBoYXZlIGEg
cXVpY2sgZml4IGZvciA1LjEwLCBhbmQgYSBtb3JlIGludmFzaXZlIGNoYW5nZSBmb3IKPj4+PiA1
LjExLAo+Pj4+IHNwYW5uaW5nIGFsbCB0aGUgcG9zc2libGUgdmdpYyBkZXZpY2VzLgo+Pj4gCj4+
PiBTbyB5b3UgcHJlZmVyIGZpeGluZyBpdCBieSAicmV0dXJuIGEgdmFsdWUgdGhhdCBkb2Vzbid0
IGhhdmUgdGhlIExhc3QKPj4+IGJpdCBzZXQiIGZvciB2NS4xMD8gSSdtIG9rIHdpdGggaXQgYW5k
IGNhbiBzZW5kIHYyIGZvciBpdC4KPj4gCj4+IENvb2wuIFRoYW5rcyBmb3IgdGhhdC4KPj4gCj4+
PiBCdHcsIGxvb2tpbmcgYWdhaW4gYXQgdGhlIHdheSB3ZSBoYW5kbGUgdGhlIHVzZXItcmVhZGlu
ZyBvZiAKPj4+IEdJQ1JfVFlQRVIKPj4+IAo+Pj4gwqDCoMKgwqB2Z2ljX21taW9fcmVhZF92M3Jf
dHlwZXIodmNwdSwgYWRkciwgbGVuKQo+Pj4gCj4+PiBpdCBzZWVtcyB0aGF0IEBhZGRyIGlzIGFj
dHVhbGx5IHRoZSAqb2Zmc2V0KiBvZiBHSUNSX1RZUEVSICgweDAwMDgpIAo+Pj4gYW5kCj4+PiBA
YWRkciBpcyB1bmxpa2VseSB0byBiZSBlcXVhbCB0byBsYXN0X3JkaXN0X3R5cGVyLCB3aGljaCBp
cyB0aGUgKkdQQSogCj4+PiBvZgo+Pj4gdGhlIGxhc3QgUkQuIExvb2tzIGxpa2UgdGhlIHVzZXIt
cmVhZGluZyBvZiBHSUNSX1RZUEVSLkxhc3QgaXMgYWx3YXlzCj4+PiBicm9rZW4/Cj4+IAo+PiBJ
IHRoaW5rIHlvdSBhcmUgcmlnaHQuIFNvbWVob3csIHdlIGRvbid0IHNlZW0gdG8gdHJhY2sgdGhl
IGluZGV4IG9mCj4+IHRoZSBSRCBpbiB0aGUgcmVnaW9uLCBzbyB3ZSBjYW4gbmV2ZXIgY29tcHV0
ZSB0aGUgYWRkcmVzcyBvZiB0aGUgUkQKPj4gZXZlbiBpZiB0aGUgYmFzZSBhZGRyZXNzIGlzIHNl
dC4KPj4gCj4+IExldCdzIGRyb3AgdGhlIHJlcG9ydGluZyBvZiBMYXN0IGZvciB1c2Vyc3BhY2Ug
Zm9yIG5vdywgYXMgaXQgbmV2ZXIKPj4gd29ya2VkLiBJZiB5b3UgcG9zdCBhIHBhdGNoIGFkZHJl
c3NpbmcgdGhhdCBxdWlja2x5LCBJJ2xsIGdldCBpdCB0bwo+PiBQYW9sbyBieSB0aGUgZW5kIG9m
IHRoZSB3ZWVrICh0aGVyZSdzIGFub3RoZXIgZml4IHRoYXQgbmVlZHMgbWVyZ2luZykuCj4+IAo+
PiBFcmljOiBkbyB3ZSBoYXZlIGFueSB0ZXN0IGNvdmVyaW5nIHRoZSB1c2Vyc3BhY2UgQVBJPwo+
IAo+IFNvIGFzIHRoaXMgaXNzdWUgc2VlbXMgcmVsYXRlZCB0byB0aGUgY2hhbmdlcyBtYWRlIHdo
ZW4gaW1wbGVtZW50aW5nIAo+IHRoZQo+IG11bHRpcGxlIFJESVNUIHJlZ2lvbnMsIEkgdm9sdW50
ZWVyIHRvIHdyaXRlIHRob3NlIEtWTSBzZWxmdGVzdHMgOi0pCgpZb3UncmUgb24hIDpECgpNb3Jl
IHNlcmlvdXNseSwgdGhlcmUgaXMgc2NvcGUgZm9yIGZ1enppbmcgdGhlIGRldmljZSBzYXZlL3Jl
c3RvcmUgQVBJLAphcyB3ZSBmaW5kIGJ1Z3MgZXZlcnkgdGltZSBzb21lb25lIGNoYW5nZSB0aGUg
Imtub3duIGdvb2QiIG9yZGVyaW5nIHRoYXQKaXMgaW1wbGVtZW50ZWQgaW4gUUVNVS4KCk1heWJl
IGl0IG1lYW5zIGdldHRpbmcgcmlkIG9mIHNvbWUgdW5uZWNlc3NhcnkgZmxleGliaWxpdHksIGFz
IHByb3Bvc2VkCmJ5IFplbmdodWksIGlmIHdlIGFyZSBjb25maWRlbnQgdGhhdCBubyB1c2Vyc3Bh
Y2UgbWFrZXMgdXNlIG9mIGl0LgpBbmQgaW4gdGhlIGZ1dHVyZSwgbWFraW5nIHN1cmUgdGhhdCBu
ZXcgQVBJcyBhcmUgcmlnaWQgZW5vdWdoIHRvIGF2b2lkIApzdWNoCmJ1Z3MuCgpUaGFua3MsCgog
ICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
