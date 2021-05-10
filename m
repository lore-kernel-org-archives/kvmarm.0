Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F73C433B4
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B8776143C
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B8776143C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A577D4B254;
	Mon, 10 May 2021 03:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lKnBA63arnwY; Mon, 10 May 2021 03:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDF84B3BF;
	Mon, 10 May 2021 03:51:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F604B4EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 00:34:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fm9HjiTMQCQv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 00:34:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 288684B3CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 00:34:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620621280;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5uXhSn/w6CZf/GcmcktyqqIlCH6uf+CBfk9ICAipjiM=;
 b=OboNuuOZRZHL8sNJC95aOMWlFV6tpbKlugYyeU5zJ0GtxsTSPZXmsYVGW8IAyDPblCfTsL
 TqkqwTmzxkwMEKP5glUzr4gAlWKF45W2U4XN3Fq9imy2//G7LPkVlgRDlnCUxRVS573b/R
 rbmlclDWauIl1EOK2HLf81weeWRS5fY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-Yc4M7mgcNYuNtdcv3A8eww-1; Mon, 10 May 2021 00:34:38 -0400
X-MC-Unique: Yc4M7mgcNYuNtdcv3A8eww-1
Received: by mail-pf1-f198.google.com with SMTP id
 g144-20020a6252960000b029023d959faca6so10026076pfb.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 May 2021 21:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=5uXhSn/w6CZf/GcmcktyqqIlCH6uf+CBfk9ICAipjiM=;
 b=M3Ej+WPKOFA5gQCN+5EO3vbwrBRzJGisryWPXqhbPyYdbauF2FdLk2WRKB3WiPThhp
 eWOg6K7MqvBgJ4ke4wP6s9DDWrNEa7zwK5W9+i2/RnPk+gXKFYg+akBTNMX1KvqNgxSu
 IYv85FF0UDtPvsCjX2JrpyTmUrJGzQi2Pw5XXFDrLCM8eNDsWE4iwxomKXuanidNiE1w
 DpPC8IhoFOqAkxUOhWCYBg6YEZZUf2Asp76ZALKJgNp9D0+ixVJM6G95+qC1dtTi7Z93
 AsJI7BwTYwZfOrNGEgld8RPUw1AWhDEFA2zYCvFpgh3WFkzt/mdQNUWLVWv5Ss8w95l2
 EEuQ==
X-Gm-Message-State: AOAM5336NQYsU2gDRWoYs79CRiym64Uirb5+VMm4xyDO5JGlTODhhqcx
 sQ5aVR6vU7AvWEIaxyfDN6XjxJvJxG5+B6AVtL65pDOpGllY92h17ioXAASFOBDecaaZZyhD+Tv
 ZXjeGMzE87A0wHsZUOpAT1jWU
X-Received: by 2002:a63:4512:: with SMTP id s18mr23457197pga.275.1620621277260; 
 Sun, 09 May 2021 21:34:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygmSy3Fdas8cpmiqmQfqfLtuCoMdKjuVFbGs0UxKU35ro+F/44i5Shmvs9MQ/0/XJwJ1PxMg==
X-Received: by 2002:a63:4512:: with SMTP id s18mr23457181pga.275.1620621277002; 
 Sun, 09 May 2021 21:34:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id h36sm10483782pgh.63.2021.05.09.21.34.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 09 May 2021 21:34:35 -0700 (PDT)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com, maz@kernel.org, 
 alex.williamson@redhat.com
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
Date: Mon, 10 May 2021 12:34:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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

CuWcqCAyMDIxLzUvMTAg5LiK5Y2IMTE6MDAsIFpodSwgTGluZ3NoYW4g5YaZ6YGTOgo+Cj4KPiBP
biA1LzEwLzIwMjEgMTA6NDMgQU0sIEphc29uIFdhbmcgd3JvdGU6Cj4+Cj4+IOWcqCAyMDIxLzUv
OCDkuIvljYgzOjExLCBaaHUgTGluZ3NoYW4g5YaZ6YGTOgo+Pj4gVGhpcyByZXZlcnRzIGNvbW1p
dCBhOTc5YTZhYTAwOWYzYzk5Njg5NDMyZTBjZGI1NDAyYTQ0NjNmYjg4Lgo+Pj4KPj4+IFRoZSBy
ZXZlcnRlZCBjb21taXQgbWF5IGNhdXNlIFZNIGZyZWV6ZSBvbiBhcm02NCBwbGF0Zm9ybS4KPj4+
IEJlY2F1c2Ugb24gYXJtNjQgcGxhdGZvcm0sIHN0b3AgYSBjb25zdW1lciB3aWxsIHN1c3BlbmQg
dGhlIFZNLAo+Pj4gdGhlIFZNIHdpbGwgZnJlZXplIHdpdGhvdXQgYSBzdGFydCBjb25zdW1lcgo+
Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNv
bT4KPj4KPj4KPj4gQWNrZWQtYnk6IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+Cj4+
Cj4+IFBsZWFzZSByZXN1Ym1pdCB3aXRoIHRoZSBmb3JtYWwgcHJvY2VzcyBvZiBzdGFibGUgCj4+
IChzdGFibGUta2VybmVsLXJ1bGVzLnJzdCkuCj4gc3VyZSwgSSB3aWxsIHJlLXN1Ym1pdCBpdCB0
byBzdGFibGUga2VybmVsIG9uY2UgaXQgaXMgbWVyZ2VkIGludG8gCj4gTGludXMgdHJlZS4KPgo+
IFRoYW5rcwoKCkkgdGhpbmsgaXQncyBiZXR0ZXIgdG8gcmVzdWJtaXQgKG9wdGlvbiAxKSwgc2Vl
IGhvdyAKc3RhYmxlLWtlcm5lbC1ydWxlcy5yc3Qgc2FpZDoKCiIiCgo6cmVmOmBvcHRpb25fMWAg
aXMgKipzdHJvbmdseSoqIHByZWZlcnJlZCwgaXMgdGhlIGVhc2llc3QgYW5kIG1vc3QgY29tbW9u
Lgo6cmVmOmBvcHRpb25fMmAgYW5kIDpyZWY6YG9wdGlvbl8zYCBhcmUgbW9yZSB1c2VmdWwgaWYg
dGhlIHBhdGNoIGlzbid0IApkZWVtZWQKd29ydGh5IGF0IHRoZSB0aW1lIGl0IGlzIGFwcGxpZWQg
dG8gYSBwdWJsaWMgZ2l0IHRyZWUgKGZvciBpbnN0YW5jZSwgYmVjYXVzZQppdCBkZXNlcnZlcyBt
b3JlIHJlZ3Jlc3Npb24gdGVzdGluZyBmaXJzdCkuCgoiIiIKClRoYW5rcwoKCj4+Cj4+IFRoYW5r
cwo+Pgo+Pgo+Pj4gLS0tCj4+PiDCoCB2aXJ0L2xpYi9pcnFieXBhc3MuYyB8IDE2ICsrKysrKy0t
LS0tLS0tLS0KPj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEwIGRlbGV0
aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS92aXJ0L2xpYi9pcnFieXBhc3MuYyBiL3ZpcnQv
bGliL2lycWJ5cGFzcy5jCj4+PiBpbmRleCBjOWJiMzk1N2Y1OGEuLjI4ZmRhNDJlNDcxYiAxMDA2
NDQKPj4+IC0tLSBhL3ZpcnQvbGliL2lycWJ5cGFzcy5jCj4+PiArKysgYi92aXJ0L2xpYi9pcnFi
eXBhc3MuYwo+Pj4gQEAgLTQwLDIxICs0MCwxNyBAQCBzdGF0aWMgaW50IF9fY29ubmVjdChzdHJ1
Y3QgaXJxX2J5cGFzc19wcm9kdWNlciAKPj4+ICpwcm9kLAo+Pj4gwqDCoMKgwqDCoCBpZiAocHJv
ZC0+YWRkX2NvbnN1bWVyKQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHByb2QtPmFkZF9j
b25zdW1lcihwcm9kLCBjb25zKTsKPj4+IMKgIC3CoMKgwqAgaWYgKHJldCkKPj4+IC3CoMKgwqDC
oMKgwqDCoCBnb3RvIGVycl9hZGRfY29uc3VtZXI7Cj4+PiAtCj4+PiAtwqDCoMKgIHJldCA9IGNv
bnMtPmFkZF9wcm9kdWNlcihjb25zLCBwcm9kKTsKPj4+IC3CoMKgwqAgaWYgKHJldCkKPj4+IC3C
oMKgwqDCoMKgwqDCoCBnb3RvIGVycl9hZGRfcHJvZHVjZXI7Cj4+PiArwqDCoMKgIGlmICghcmV0
KSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gY29ucy0+YWRkX3Byb2R1Y2VyKGNvbnMsIHBy
b2QpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQgJiYgcHJvZC0+ZGVsX2NvbnN1bWVyKQo+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJvZC0+ZGVsX2NvbnN1bWVyKHByb2QsIGNvbnMp
Owo+Pj4gK8KgwqDCoCB9Cj4+PiDCoCDCoMKgwqDCoMKgIGlmIChjb25zLT5zdGFydCkKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCBjb25zLT5zdGFydChjb25zKTsKPj4+IMKgwqDCoMKgwqAgaWYgKHBy
b2QtPnN0YXJ0KQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHByb2QtPnN0YXJ0KHByb2QpOwo+Pj4g
LWVycl9hZGRfcHJvZHVjZXI6Cj4+PiAtwqDCoMKgIGlmIChwcm9kLT5kZWxfY29uc3VtZXIpCj4+
PiAtwqDCoMKgwqDCoMKgwqAgcHJvZC0+ZGVsX2NvbnN1bWVyKHByb2QsIGNvbnMpOwo+Pj4gLWVy
cl9hZGRfY29uc3VtZXI6Cj4+PiArCj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+PiDCoCB9
Cj4+Cj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
