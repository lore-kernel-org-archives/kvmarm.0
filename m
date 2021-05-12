Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8809C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 08:52:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4191A613C4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 08:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4191A613C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 915FB4B4B4;
	Wed, 12 May 2021 04:52:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jytx3rqgIa2M; Wed, 12 May 2021 04:52:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D89A4B4B1;
	Wed, 12 May 2021 04:52:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 133434B4B1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 04:52:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z1w+G9vNynYt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 04:52:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0494B4A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 04:52:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620809536;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0wtuPVOomswhN3nKbizxfMzPJgWJmm0zGlVQ5c3NWyA=;
 b=N/yTTDZowlCD71r3u/DlRHsRSAYU6uK1AL4PUFRivlbSwXSnxePRVLcBY+WLmjlc9imMvz
 py1WG5WCoHNWQIVVztQ3NAImVVIS84mFOLMTARti8OiVQveTwl3uxCV/IoCAT8TMz9LC0Y
 HNHwkBYSvnq4kvwRozTJA23ArOQ/p8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-68KwoGpgOO-EJxJemm-tJg-1; Wed, 12 May 2021 04:52:14 -0400
X-MC-Unique: 68KwoGpgOO-EJxJemm-tJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ABEC107ACCA;
 Wed, 12 May 2021 08:52:13 +0000 (UTC)
Received: from [10.36.112.87] (ovpn-112-87.ams2.redhat.com [10.36.112.87])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7ECAE159;
 Wed, 12 May 2021 08:52:10 +0000 (UTC)
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
To: Marc Zyngier <maz@kernel.org>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com> <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <YJRADhU4CcTE7bdm@google.com>
 <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
 <YJuDYZbqe8V47YCJ@google.com>
 <4e83daa3-3166-eeed-840c-39be71b1124d@redhat.com>
 <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <628dca08-4108-8be1-9bea-8c388f28401e@redhat.com>
Date: Wed, 12 May 2021 10:52:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

SGksCgpPbiA1LzEyLzIxIDEwOjMzIEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMS0w
NS0xMiAwOToxOSwgQXVnZXIgRXJpYyB3cm90ZToKPj4gSGkgUmljYXJkbywKPj4KPj4gT24gNS8x
Mi8yMSA5OjI3IEFNLCBSaWNhcmRvIEtvbGxlciB3cm90ZToKPj4+IE9uIEZyaSwgTWF5IDA3LCAy
MDIxIGF0IDA0OjA4OjA3UE0gKzAyMDAsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+Pj4gSGkgUmljYXJk
bywKPj4+Pgo+Pj4+IE9uIDUvNi8yMSA5OjE0IFBNLCBSaWNhcmRvIEtvbGxlciB3cm90ZToKPj4+
Pj4gT24gVGh1LCBNYXkgMDYsIDIwMjEgYXQgMDI6MzA6MTdQTSArMDIwMCwgQXVnZXIgRXJpYyB3
cm90ZToKPj4+Pj4+IEhpIFJpY2FyZG8sCj4+Pj4+Pgo+Pj4+Pgo+Pj4+PiBIaSBFcmljLAo+Pj4+
Pgo+Pj4+PiBUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB0aGUgdGVzdC4KPj4+Pj4KPj4+Pj4+IE9u
IDUvMy8yMSA5OjEyIFBNLCBSaWNhcmRvIEtvbGxlciB3cm90ZToKPj4+Pj4+PiBPbiBNb24sIE1h
eSAwMywgMjAyMSBhdCAxMTozMjozOUFNICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+
Pj4+IE9uIFNhdCwgMDEgTWF5IDIwMjEgMDA6MjQ6MDYgKzAxMDAsCj4+Pj4+Pj4+IFJpY2FyZG8g
S29sbGVyIDxyaWNhcmtvbEBnb29nbGUuY29tPiB3cm90ZToKPj4+Pj4+Pj4+Cj4+Pj4+Pj4+PiBB
ZGQgdGhlIGluZnJhc3RydWN0dXJlIG5lZWRlZCB0byBlbmFibGUgZXhjZXB0aW9uIGhhbmRsaW5n
IGluCj4+Pj4+Pj4+PiBhYXJjaDY0Cj4+Pj4+Pj4+PiBzZWxmdGVzdHMuIFRoZSBleGNlcHRpb24g
aGFuZGxpbmcgZGVmYXVsdHMgdG8gYW4KPj4+Pj4+Pj4+IHVuaGFuZGxlZC1leGNlcHRpb24KPj4+
Pj4+Pj4+IGhhbmRsZXIgd2hpY2ggYWJvcnRzIHRoZSB0ZXN0LCBqdXN0IGxpa2UgeDg2LiBUaGVz
ZSBoYW5kbGVycwo+Pj4+Pj4+Pj4gY2FuIGJlCj4+Pj4+Pj4+PiBvdmVycmlkZGVuIGJ5IGNhbGxp
bmcgdm1faW5zdGFsbF92ZWN0b3JfaGFuZGxlcih2ZWN0b3IpIG9yCj4+Pj4+Pj4+PiB2bV9pbnN0
YWxsX2V4Y2VwdGlvbl9oYW5kbGVyKHZlY3RvciwgZWMpLiBUaGUgdW5oYW5kbGVkIGV4Y2VwdGlv
bgo+Pj4+Pj4+Pj4gcmVwb3J0aW5nIGZyb20gdGhlIGd1ZXN0IGlzIGRvbmUgdXNpbmcgdGhlIHVj
YWxsIHR5cGUKPj4+Pj4+Pj4+IGludHJvZHVjZWQgaW4gYQo+Pj4+Pj4+Pj4gcHJldmlvdXMgY29t
bWl0LCBVQ0FMTF9VTkhBTkRMRUQuCj4+Pj4+Pj4+Pgo+Pj4+Pj4+Pj4gVGhlIGV4Y2VwdGlvbiBo
YW5kbGluZyBjb2RlIGlzIGhlYXZpbHkgaW5zcGlyZWQgb24ga3ZtLXVuaXQtdGVzdHMuCj4+Pj4+
Pgo+Pj4+Pj4gcnVubmluZyB0aGUgdGVzdCBvbiA1LjEyIEkgZ2V0Cj4+Pj4+Pgo+Pj4KPj4+IEhp
IEVyaWMsCj4+Pgo+Pj4gSSdtIGFibGUgdG8gcmVwcm9kdWNlIHRoZSBmYWlsdXJlIHlvdSBhcmUg
c2VlaW5nIG9uIDUuNiwgc3BlY2lmaWNhbGx5Cj4+PiB3aXRoIGtlcm5lbHMgb2xkZXIgdGhhbiB0
aGlzIGNvbW1pdDoKPj4+Cj4+PiDCoCA0OTQyZGM2NjM4YjAgS1ZNOiBhcm02NDogV3JpdGUgYXJj
aC5tZGNyX2VsMiBjaGFuZ2VzIHNpbmNlIGxhc3QKPj4+IHZjcHVfbG9hZCBvbiBWSEUKPj4+Cj4+
PiBidXQgbm90IHlldCBvbiB2NS4xMi4gQ291bGQgeW91IHNoYXJlIHRoZSBjb21taXQgb2YgdGhl
IGtlcm5lbCB5b3UgYXJlCj4+PiB0ZXN0aW5nLCBwbGVhc2U/Cj4+Cj4+IG15IGhvc3QgaXMgYSA1
LjEyIGtlcm5lbCAoODQwNGM5ZmJjODRiKQo+IAo+IFRpbWUgdG8gY29tcGFyZSBub3RlcyB0aGVu
LiBXaGF0IEhXIGFyZSB5b3UgdXNpbmc/IFJ1bm5pbmcgVkhFIG9yIG5vdD8KVkhFIHllcy4gQ2F2
aXVtIFNhYnJlIHN5c3RlbS4KClRoYW5rcwoKRXJpYwo+IAo+IFRoYW5rcywKPiAKPiDCoMKgwqDC
oMKgwqDCoCBNLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
