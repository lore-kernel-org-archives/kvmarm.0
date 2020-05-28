Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1296C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 07:53:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A0B420899
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 07:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mj10Dg9p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A0B420899
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 329FC4B205;
	Thu, 28 May 2020 03:53:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2HGguYhgE1aZ; Thu, 28 May 2020 03:53:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DE64B21C;
	Thu, 28 May 2020 03:53:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DC44B18A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 02:32:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lDL0zLxRcI7x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 02:32:26 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EDD64B182
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 02:32:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590647546;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EsuvlfT5LaD0+QJMlQUnPkzKGgI/J37TooIeB6KE0lA=;
 b=Mj10Dg9pQgJSBs4NA27d6TjRB5m7FjFOcOFGW8E1p2UJI9s3et2jJh6XYEDWVcRNrR1h1M
 4f6Me5vxygNOiovXiytVwezIm4md33NOsQIVdRANOi483ub3TeefsrNQrzqr2nSYqx3vrq
 B1sN6bYDQj/GWqdOBzGLGDcGLhqC1zI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-hi3646I5O5GPZp5FhiiXgw-1; Thu, 28 May 2020 02:32:21 -0400
X-MC-Unique: hi3646I5O5GPZp5FhiiXgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 508CB80183C;
 Thu, 28 May 2020 06:32:20 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-130.bne.redhat.com
 [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0639D1A914;
 Thu, 28 May 2020 06:32:12 +0000 (UTC)
Subject: Re: [PATCH RFCv2 7/9] kvm/arm64: Support async page fault
To: Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-8-gshan@redhat.com>
 <20200526123424.GF1363@C02TD0UTHF1T.local>
 <e1230110-b51f-b8b8-60d9-372660c5c387@redhat.com>
 <28c74819f42306e66370ddaf88f16918@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <924ee966-7412-f9ff-c2b0-598e4abbb05c@redhat.com>
Date: Thu, 28 May 2020 16:32:09 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <28c74819f42306e66370ddaf88f16918@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mailman-Approved-At: Thu, 28 May 2020 03:53:17 -0400
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

SGkgTWFyYywKCk9uIDUvMjcvMjAgNTozNyBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjAtMDUtMjcgMDU6MDUsIEdhdmluIFNoYW4gd3JvdGU6CgpbLi4uXQogIAo+Pj4+ICtzdHJ1Y3Qg
a3ZtX3ZjcHVfcHZfYXBmX2RhdGEgewo+Pj4+ICvCoMKgwqAgX191MzLCoMKgwqAgcmVhc29uOwo+
Pj4+ICvCoMKgwqAgX191OMKgwqDCoCBwYWRbNjBdOwo+Pj4+ICvCoMKgwqAgX191MzLCoMKgwqAg
ZW5hYmxlZDsKPj4+PiArfTsKPj4+Cj4+PiBXaGF0J3MgYWxsIHRoZSBwYWRkaW5nIGZvcj8KPj4+
Cj4+Cj4+IFRoZSBwYWRkaW5nIGlzIGVuc3VyZSB0aGUgQHJlYXNvbiBhbmQgQGVuYWJsZWQgaW4g
ZGlmZmVyZW50IGNhY2hlCj4+IGxpbmUuIEByZWFzb24gaXMgc2hhcmVkIGJ5IGhvc3QvZ3Vlc3Qs
IHdoaWxlIEBlbmFibGVkIGlzIGFsbW9zdGx5Cj4+IG93bmVkIGJ5IGd1ZXN0Lgo+IAo+IFNvIHlv
dSBhcmUgYXNzdW1pbmcgdGhhdCBhIGNhY2hlIGxpbmUgaXMgYXQgbW9zdCA2NCBieXRlcy4KPiBJ
dCBpcyBhY3R1YWx5IGltcGxlbWVudGF0aW9uIGRlZmluZWQsIGFuZCB5b3UgY2FuIHByb2JlIGZv
ciBpdAo+IGJ5IGxvb2tpbmcgYXQgdGhlIENUUl9FTDAgcmVnaXN0ZXIuIFRoZXJlIGFyZSBpbXBs
ZW1lbnRhdGlvbnMKPiByYW5naW5nIGZyb20gMzIgdG8gMjU2IGJ5dGVzIGluIHRoZSB3aWxkLCBh
bmQgbGV0J3Mgbm90IG1lbnRpb24KPiBicm9rZW4gYmlnLWxpdHRsZSBpbXBsZW1lbnRhdGlvbnMg
aGVyZS4KPiAKPiBbLi4uXQo+IAoKT2ssIFRoYW5rcyBmb3IgeW91ciBjb21tZW50cyBhbmQgaGlu
dHMuCgo+Pj4+ICtib29sIGt2bV9hcmNoX2Nhbl9pbmplY3RfYXN5bmNfcGFnZV9ub3RfcHJlc2Vu
dChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+Pj4gK3sKPj4+PiArwqDCoMKgIHU2NCB2YmFyLCBw
YzsKPj4+PiArwqDCoMKgIHUzMiB2YWw7Cj4+Pj4gK8KgwqDCoCBpbnQgcmV0Owo+Pj4+ICsKPj4+
PiArwqDCoMKgIGlmICghKHZjcHUtPmFyY2guYXBmLmNvbnRyb2xfYmxvY2sgJiBLVk1fQVNZTkNf
UEZfRU5BQkxFRCkpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKPj4+PiArCj4+
Pj4gK8KgwqDCoCBpZiAodmNwdS0+YXJjaC5hcGYuc2VuZF91c2VyX29ubHkgJiYgdmNwdV9tb2Rl
X3ByaXYodmNwdSkpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKPj4+PiArCj4+
Pj4gK8KgwqDCoCAvKiBQZW5kaW5nIHBhZ2UgZmF1bHQsIHdoaWNoIGlucyd0IGFja25vd2xlZGdl
ZCBieSBndWVzdCAqLwo+Pj4+ICvCoMKgwqAgcmV0ID0ga3ZtX2FzeW5jX3BmX3JlYWRfY2FjaGUo
dmNwdSwgJnZhbCk7Cj4+Pj4gK8KgwqDCoCBpZiAocmV0IHx8IHZhbCkKPj4+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIGZhbHNlOwo+Pj4+ICsKPj4+PiArwqDCoMKgIC8qCj4+Pj4gK8KgwqDCoMKg
ICogRXZlbnRzIGNhbid0IGJlIGluamVjdGVkIHRocm91Z2ggZGF0YSBhYm9ydCBiZWNhdXNlIGl0
J3MKPj4+PiArwqDCoMKgwqAgKiBnb2luZyB0byBjbG9iYmVyIEVMUl9FTDEsIHdoaWNoIG1pZ2h0
IG5vdCBjb25zdWVkIChvciBzYXZlZCkKPj4+PiArwqDCoMKgwqAgKiBieSBndWVzdCB5ZXQuCj4+
Pj4gK8KgwqDCoMKgICovCj4+Pj4gK8KgwqDCoCB2YmFyID0gdmNwdV9yZWFkX3N5c19yZWcodmNw
dSwgVkJBUl9FTDEpOwo+Pj4+ICvCoMKgwqAgcGMgPSAqdmNwdV9wYyh2Y3B1KTsKPj4+PiArwqDC
oMKgIGlmIChwYyA+PSB2YmFyICYmIHBjIDwgKHZiYXIgKyB2Y3B1LT5hcmNoLmFwZi5ub19mYXVs
dF9pbnN0X3JhbmdlKSkKPj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGZhbHNlOwo+Pj4KPj4+
IEFoLCBzbyB0aGF0J3Mgd2hlbiB0aGlzIGBub19mYXVsdF9pbnN0X3JhbmdlYCBpcyBmb3IuCj4+
Pgo+Pj4gQXMtaXMgdGhpcyBpcyBub3Qgc3VmZmljaWVudCwgYW5kIHdlJ2xsIG5lZWQgdCBiZSBl
eHRyZW1lbHkgY2FyZWZ1bAo+Pj4gaGVyZS4KPj4+Cj4+PiBUaGUgdmVjdG9ycyB0aGVtc2VsdmVz
IHR5cGljYWxseSBvbmx5IGhhdmUgYSBzbWFsbCBhbW91bnQgb2Ygc3R1YiBjb2RlLAo+Pj4gYW5k
IHRoZSBidWxrIG9mIHRoZSBub24tcmVlbnRyYW50IGV4Y2VwdGlvbiBlbnRyeSB3b3JrIGhhcHBl
bnMKPj4+IGVsc2V3aGVyZSwgaW4gYSBtaXh0dXJlIG9mIGFzc2VtYmx5IGFuZCBDIGNvZGUgdGhh
dCBpc24ndCBldmVuIHZpcnR1YWxseQo+Pj4gY29udGlndW91cyB3aXRoIGVpdGhlciB0aGUgdmVj
dG9ycyBvciBpdHNlbGYuCj4+Pgo+Pj4gSXQncyBwb3NzaWJsZSBpbiB0aGVvcnkgdGhhdCBjb2Rl
IGluIG1vZHVsZXMgKG9yIHBlcmhhcHMgaW4gZUJQRiBKSVQnZAo+Pj4gY29kZSkgdGhhdCBpc24n
dCBzYWZlIHRvIHRha2UgYSBmYXVsdCBmcm9tLCBzbyBldmVuIGhhdmluZyBhIGNvbnRpZ3VvdXMK
Pj4+IHJhbmdlIGNvbnRyb2xsZWQgYnkgdGhlIGtlcm5lbCBpc24ndCBpZGVhbC4KPj4+Cj4+PiBI
b3cgZG9lcyB0aGlzIHdvcmsgb24geDg2Pwo+Pj4KPj4KPj4gWWVhaCwgaGVyZSB3ZSBqdXN0IHBy
b3ZpZGUgYSBtZWNoYW5pc20gdG8gZm9yYmlkIGluamVjdGluZyBkYXRhIGFib3J0LiBUaGUKPj4g
cmFuZ2UgaXMgZmVkIGJ5IGd1ZXN0IHRocm91Z2ggSFZDIGNhbGwuIFNvIEkgdGhpbmsgaXQncyBn
dWVzdCByZWxhdGVkIGlzc3VlLgo+PiBZb3UgaGFkIG1vcmUgY29tbWVudHMgYWJvdXQgdGhpcyBp
biBQQVRDSFs5XS4gSSB3aWxsIGV4cGxhaW4gYSBiaXQgbW9yZSB0aGVyZS4KPj4KPj4geDg2IGJh
c2ljYWxseSByZWxpZXMgb24gRUZMQUdTW0lGXSBmbGFnLiBUaGUgYXN5bmMgcGFnZSBmYXVsdCBj
YW4gYmUgaW5qZWN0ZWQKPj4gaWYgaXQncyBvbi4gT3RoZXJ3aXNlLCBpdCdzIGZvcmJpZGRlbi4g
SXQncyB3b3JrYWJsZSBiZWNhdXNlIGV4Y2VwdGlvbiBpcwo+PiBzcGVjaWFsIGludGVycnVwdCB0
byB4ODYgaWYgSSdtIGNvcnJlY3QuCj4+Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAo
dm1jc19yZWFkbChHVUVTVF9SRkxBR1MpICYgWDg2X0VGTEFHU19JRikgJiYKPj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAhKHZtY3NfcmVhZDMyKEdVRVNUX0lOVEVSUlVQVElC
SUxJVFlfSU5GTykgJgo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIChHVUVTVF9JTlRSX1NUQVRFX1NUSSB8IEdVRVNUX0lOVFJfU1RBVEVfTU9WX1NTKSk7
Cj4gCj4gSSByZWFsbHkgd2lzaCB0aGlzIHdhcyByZWx5aW5nIG9uIGFuIGFyY2hpdGVjdGVkIGV4
Y2VwdGlvbiBkZWxpdmVyeQo+IG1lY2hhbmlzbSB0aGF0IGNhbiBiZSBibG9ja2VkIGJ5IHRoZSBn
dWVzdCBpdHNlbGYgKFBTVEFURS57SSxGLEF9KS4KPiBUcnlpbmcgdG8gZ3Vlc3MgYmFzZWQgb24g
dGhlIFBDIHdvbid0IGZseS4gQnV0IHRoZXNlIHNpZ25hbHMgYXJlCj4gcHJldHR5IGhhcmQgdG8g
bXVsdGlwbGV4IHdpdGggYW55dGhpbmcgZWxzZS4gTGlrZSBhbnkgZm9ybSBvZgo+IG5vbi1hcmNo
aXRlY3RlZCBleGNlcHRpb24gaW5qZWN0aW9uLCBJIGRvbid0IHNlZSBhIGdvb2QgcGF0aCBmb3J3
YXJkCj4gdW5sZXNzIHdlIHN0YXJ0IGNvbnNpZGVyaW5nIHNvbWV0aGluZyBsaWtlIFNERUkuCj4g
Cj4gIMKgwqDCoMKgwqDCoMKgIE0uCgpBcyBQYW9sbyBtZW50aW9uZWQgaW4gYW5vdGhlciByZXBs
eS4gVGhlcmUgYXJlIHR3byB0eXBlcyBvZiBub3RpZmljYXRpb25zCnNlbnQgZnJvbSBob3N0IHRv
IGd1ZXN0OiBwYWdlX25vdF9wcmVzZW50IGFuZCBwYWdlX3JlYWR5LiBUaGUgcGFnZV9ub3RfcHJl
c2VudApub3RpZmljYXRpb24gc2hvdWxkIGJlIGRlbGl2ZXJlZCBzeW5jaHJvbm91c2x5IHdoaWxl
IHBhZ2VfcmVhZHkgY2FuIGJlCmRlbGl2ZXJlZCBhc3luY2hyb25vdXNseS4gSGUgYWxzbyBzdWdn
ZXN0ZWQgdG8gcmVzZXJ2ZSBhIEVTUiAob3IgREZTQykgc3ViY2xhc3MKZm9yIHBhZ2Vfbm90X3By
ZXNlbnQuIEZvciBwYWdlX3JlYWR5LCBpdCBjYW4gYmUgZGVsaXZlcmVkIGJ5IGludGVycnVwdCwg
bGlrZSBQUEkuCng4NiBpcyBjaGFuZ2luZyB0aGUgY29kZSB0byBkZWxpdmVyIHBhZ2VfcmVhZHkg
YnkgaW50ZXJydXB0LCB3aGljaCB3YXMgZG9uZSBieQpleGNlcHRpb24gcHJldmlvdXNseS4KCndo
ZW4gd2UgdXNlIGludGVycnVwdCwgaW5zdGVhZCBvZiBleGNlcHRpb24gZm9yIHBhZ2VfcmVhZHku
IFdlIHdvbid0IG5lZWQgdGhlCmdhbWUgb2YgZ3Vlc3NpbmcgUEMuCgpJIGFzc3VtZSB5b3UgcHJl
ZmVyIHRvIHVzZSBTREVJIGZvciBwYWdlX25vdF9wcmVzZW50LCBjb3JyZWN0PyBJbiB0aGF0IGNh
c2UsCndoYXQncyB0aGUgY3VycmVudCBzdGF0dXMgb2YgU0RFST8gSSBtZWFuIGl0IGhhcyBiZWVu
IGZ1bGx5IG9yIHBhcnRpYWxseQpzdXBwb3J0ZWQsIG9yIHdlIG5lZWQgZGV2ZWxvcCBpdCBmcm9t
IHRoZSBzY3JhdGNoIDopCgpUaGFua3MsCkdhdmluCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
