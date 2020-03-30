Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AB5C2D0EB
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:24:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE51920733
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhxim3sy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE51920733
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9D64B26D;
	Mon, 30 Mar 2020 06:24:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ik58tL79bKyi; Mon, 30 Mar 2020 06:24:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 295464B266;
	Mon, 30 Mar 2020 06:24:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 943FE4B25C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:24:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CFI3t9a17q5y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 06:24:49 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C844B266
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:24:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585563889;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hV3tcQVZBDcc35pPKZYbOzggPvGr6YLo9yi3ZRnZDd4=;
 b=fhxim3syvTUNrR+kmd+PKbjgpGt7nJIQXtjk9QnjnBeAn72fF5bc8ogSsO0hiyYcWWsWqn
 bNr7UMsw9jSXjz0uRW0Yk7NYECBrvn7NkJVQfmheJbykjPJjfNQMv7MLphRZKHiWgxprei
 mlDD5zWI8mJBBsftcuytZiCM2H9cIvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-PQUSFHo_ObOqDO3zjTfwqA-1; Mon, 30 Mar 2020 06:24:47 -0400
X-MC-Unique: PQUSFHo_ObOqDO3zjTfwqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE8ED100551A;
 Mon, 30 Mar 2020 10:24:45 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AFDD96B82;
 Mon, 30 Mar 2020 10:24:39 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To: Andrew Jones <drjones@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
 <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
 <7d6dc4e7-82b4-3c54-574f-2149d4a85c48@redhat.com>
 <20200330101955.2rlksuzkkvopk52t@kamzik.brq.redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <6a939f4b-f1b4-ff59-b074-aebb1b4e046a@redhat.com>
Date: Mon, 30 Mar 2020 12:24:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200330101955.2rlksuzkkvopk52t@kamzik.brq.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgRHJldywKCk9uIDMvMzAvMjAgMTI6MTkgUE0sIEFuZHJldyBKb25lcyB3cm90ZToKPiBPbiBN
b24sIE1hciAzMCwgMjAyMCBhdCAxMTo1NjowMEFNICswMjAwLCBBdWdlciBFcmljIHdyb3RlOgo+
PiBIaSwKPj4KPj4gT24gMy8zMC8yMCAxMToxMSBBTSwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+Pj4g
T24gTW9uLCBNYXIgMzAsIDIwMjAgYXQgMTA6NDY6NTdBTSArMDIwMCwgQXVnZXIgRXJpYyB3cm90
ZToKPj4+PiBIaSBaZW5naHVpLAo+Pj4+Cj4+Pj4gT24gMy8zMC8yMCAxMDozMCBBTSwgWmVuZ2h1
aSBZdSB3cm90ZToKPj4+Pj4gSGkgRXJpYywKPj4+Pj4KPj4+Pj4gT24gMjAyMC8zLzIwIDE3OjI0
LCBFcmljIEF1Z2VyIHdyb3RlOgo+Pj4+Pj4gK3N0YXRpYyB2b2lkIGl0c19jbWRfcXVldWVfaW5p
dCh2b2lkKQo+Pj4+Pj4gK3sKPj4+Pj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyBvcmRlciA9IGdl
dF9vcmRlcihTWl82NEsgPj4gUEFHRV9TSElGVCk7Cj4+Pj4+PiArwqDCoMKgIHU2NCBjYmFzZXI7
Cj4+Pj4+PiArCj4+Pj4+PiArwqDCoMKgIGl0c19kYXRhLmNtZF9iYXNlID0gKHZvaWQgKil2aXJ0
X3RvX3BoeXMoYWxsb2NfcGFnZXMob3JkZXIpKTsKPj4+Pj4KPj4+Pj4gU2hvdWxkbid0IHRoZSBj
bWRfYmFzZSAoYW5kIHRoZSBjbWRfd3JpdGUpIGJlIHNldCBhcyBhIEdWQT8KPj4+PiB5ZXMgaXQg
c2hvdWxkCj4+Pgo+Pj4gSWYgaXQncyBzdXBwb3NlZCB0byBiZSBhIHZpcnR1YWwgYWRkcmVzcywg
d2hlbiB3aHkgZG8gdGhlIHZpcnRfdG9fcGh5cz8KPj4gV2hhdCBpcyBwcm9ncmFtbWVkIGluIENC
QVNFUiByZWdpc3RlciBpcyBhIHBoeXNpY2FsIGFkZHJlc3MuIFNvIHRoZQo+PiB2aXJ0X3RvX3Bo
eXMoKSBpcyByZWxldmFudC4gVGhlIGluY29uc2lzdGVuY3kgaXMgaW4gaXRzX2FsbG9jYXRlX2Vu
dHJ5KCkKPj4gaW50cm9kdWNlZCBsYXRlciBvbiB3aGVyZSBJIHJldHVybiB0aGUgcGh5c2ljYWwg
YWRkcmVzcyBpbnN0ZWFkIG9mIHRoZQo+PiB2aXJ0dWFsIGFkZHJlc3MuIEkgd2lsbCBmaXggdGhh
dC4KPj4KPj4KPj4+Cj4+Pj4+Cj4+Pj4+IE90aGVyd2lzZSBJIHRoaW5rIHdlIHdpbGwgZW5kLXVw
IHdpdGggbWVtb3J5IGNvcnJ1cHRpb24gd2hlbiB3cml0aW5nCj4+Pj4+IHRoZSBjb21tYW5kIHF1
ZXVlLsKgIEJ1dCBpdCBzZWVtcyB0aGF0IGV2ZXJ5dGhpbmcganVzdCB3b3JrcyBmaW5lIC4uLgo+
Pj4+PiBTbyBJJ20gcmVhbGx5IGNvbmZ1c2VkIGhlcmUgOi0vCj4+Pj4gSSB3YXMgdG9sZCBieSBQ
YW9sbyB0aGF0IHRoZSBWQS9QQSBtZW1vcnkgbWFwIGlzIGZsYXQgaW4ga3ZtdW5pdCB0ZXN0Lgo+
Pj4KPj4+IFdoYXQgZG9lcyBmbGF0IG1lYW4/Cj4+Cj4+IFllcyBJIG1lYW50IGFuIGlkZW50aXR5
IG1hcC4KPj4KPj4gIGt2bS11bml0LXRlc3RzLCBhdCBsZWFzdCBhcm0vYXJtNjQsIGRvZXMgcHJl
cGFyZQo+Pj4gYW4gaWRlbnRpdHkgbWFwIG9mIGFsbCBwaHlzaWNhbCBtZW1vcnksIHdoaWNoIGV4
cGxhaW5zIHdoeSB0aGUgYWJvdmUKPj4+IGlzIHdvcmtpbmcuCj4+Cj4+IHNob3VsZCBiZSB0aGUg
c2FtZSBvbiB4ODYKPiAKPiBNYXliZSwgYnV0IEkgZGlkbid0IHdyaXRlIG9yIHJldmlldyBob3cg
eDg2IGRvZXMgdGhlaXIgZGVmYXVsdCBtYXAsIHNvIEkKPiBkb24ndCBrbm93Lgo+IAo+Pgo+PiAg
SXQncyBkb2luZyB2aXJ0X3RvX3BoeXMoc29tZS12aXJ0LWFkZHIpLCB3aGljaCBnZXRzIGEKPj4+
IHBoeXMgYWRkciwgYnV0IHdoZW4gdGhlIElUUyB1c2VzIGl0IGFzIGEgdmlydCBhZGRyIGl0IHdv
cmtzIGJlY2F1c2UKPj4+IHdlICphbHNvKiBoYXZlIGEgdmlydCBhZGRyID09IHBoeXMgYWRkciBt
YXBwaW5nIGluIHRoZSBkZWZhdWx0IHBhZ2UKPj4+IHRhYmxlLCB3aGljaCBpcyBuYW1lZCAiaWRt
YXAiIGZvciBnb29kIHJlYXNvbi4KPj4+Cj4+PiBJIHRoaW5rIGl0IHdvdWxkIGJlIGJldHRlciB0
byB0ZXN0IHdpdGggdGhlIG5vbi1pZGVudGl0eSBtYXBwZWQgYWRkcmVzc2VzCj4+PiB0aG91Z2gu
Cj4+Cj4+IGlzIHRoZXJlIGFueSB3YXkgdG8gZXhlcmNpc2UgYSBub24gaWRtYXA/Cj4gCj4gWW91
IGNvdWxkIGNyZWF0ZSB5b3VyIG93biBtYXAgYW5kIHRoZW4gc3dpdGNoIHRvIGl0LiBTZWUgbGli
L2FybS9hc20vbW11LWFwaS5oCj4gCj4gQnV0LCB5b3UgZG9uJ3QgaGF2ZSB0byBzd2l0Y2ggdGhl
IHdob2xlIG1hcCB0byB1c2Ugbm9uLWlkZW50aXR5IG1hcHBlZAo+IGFkZHJlc3Nlcy4gSnVzdCBj
cmVhdGUgbmV3IHZpcnQgbWFwcGluZ3MgdG8gdGhlIHBoeXMgYWRkcmVzc2VzIHlvdSdyZQo+IGlu
dGVyZXN0ZWQgaW4sIGFuZCB0aGVuIHVzZSB0aG9zZSBuZXcgdmlydCBhZGRyZXNzZXMgaW5zdGVh
ZC4gSWYgeW91J3JlCj4gd29ycmllZCB0aGF0IHNvbWV3aGVyZSBhbiBpZGVudGl0eSBtYXBwZWQg
dmlydCBhZGRyZXNzIGlzIGdldHRpbmcgdXNlZAo+IGJlY2F1c2Ugb2YgYSBwaHlzL3ZpcnQgYWRk
cmVzcyBtaXggdXAsIHRoZW4geW91IGNvdWxkIHByb2JhYmx5IHNwcmlua2xlCj4gc29tZSBhc3Nl
cnQodmlydF90b19waHlzKGFkZHIpICE9IGFkZHIpJ3MgYXJvdW5kIHRvIGVuc3VyZSBpdC4KCk9L
LiBXZWxsIEkgZG9uJ3Qga25vdyBpZiBpdCBpcyB3b3J0aCB0aGUgY2FuZGxlLiBJIHdpbGwgcmV2
aWV3IHRoZSBjb2RlCmFnYWluIGFuZCBmaXggdGhlIHJlbWFpbmluZyBpbmNvbnNpc3RlbmNpZXMg
SSBjYW4gc2VlLgoKVGhhbmtzCgpFcmljCj4gCj4gVGhhbmtzLAo+IGRyZXcKPiAKPj4KPj4gVGhh
bmtzCj4+Cj4+IEVyaWMKPj4+Cj4+PiBUaGFua3MsCj4+PiBkcmV3Cj4+Pgo+Pj4+Cj4+Pj4+Cj4+
Pj4+PiArCj4+Pj4+PiArwqDCoMKgIGNiYXNlciA9ICgodTY0KWl0c19kYXRhLmNtZF9iYXNlIHwg
KFNaXzY0SyAvIFNaXzRLIC0gMSnCoMKgwqAgfAo+Pj4+Pj4gR0lUU19DQkFTRVJfVkFMSUQpOwo+
Pj4+Pj4gKwo+Pj4+Pj4gK8KgwqDCoCB3cml0ZXEoY2Jhc2VyLCBpdHNfZGF0YS5iYXNlICsgR0lU
U19DQkFTRVIpOwo+Pj4+Pj4gKwo+Pj4+Pj4gK8KgwqDCoCBpdHNfZGF0YS5jbWRfd3JpdGUgPSBp
dHNfZGF0YS5jbWRfYmFzZTsKPj4+Pj4+ICvCoMKgwqAgd3JpdGVxKDAsIGl0c19kYXRhLmJhc2Ug
KyBHSVRTX0NXUklURVIpOwo+Pj4+Pj4gK30KPj4+Pj4KPj4+Pj4gT3RoZXJ3aXNlIHRoaXMgbG9v
a3MgZ29vZCwKPj4+Pj4gUmV2aWV3ZWQtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWku
Y29tPgo+Pj4+IFRoYW5rcyEKPj4+Pgo+Pj4+IEVyaWMKPj4+Pj4KPj4+Pj4KPj4+Pj4gVGhhbmtz
Cj4+Pj4+Cj4+Pj4KPj4+Pgo+Pgo+PgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
