Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC230C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 18:31:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFF749B12;
	Tue, 25 Jan 2022 13:31:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8e2MpvYEhz4o; Tue, 25 Jan 2022 13:31:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5D949E49;
	Tue, 25 Jan 2022 13:31:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E97E49DF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:31:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xX5dCegvyWzU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 13:31:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E24049B12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:31:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643135507;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZiMvtf0ISdZjP/XjkwKlDCax9+P+Wq5+7WeQC/1x/e0=;
 b=Hxhf0Ft01ESWssz8LkmeoQkaTKl2E7scc4ibncSRt67/eoJoUMePkUbGG05Ky64a2t9Via
 YwUkrx7tA+Ql6UIjUI39SnW+4zSUmj9l7//0wDriFW76WGsmKnpY/A2DYanzts5A4FqSR6
 PskXtnJbysDPq3weehr8/ts7BL15xns=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-TD5edhBgM6-5PPhO3tWcRA-1; Tue, 25 Jan 2022 13:31:42 -0500
X-MC-Unique: TD5edhBgM6-5PPhO3tWcRA-1
Received: by mail-wm1-f70.google.com with SMTP id
 f7-20020a1cc907000000b0034b63f314ccso1889489wmb.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:31:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ZiMvtf0ISdZjP/XjkwKlDCax9+P+Wq5+7WeQC/1x/e0=;
 b=EtWchyyWEW4ROu6VyInj/NwYmnbP46ZMwSA/IjcnV5S2qZw71yNd9ZES1MvXOnl5y8
 80oObCMTBQzdumOb+Y1X8brD1NGaiqH2ZBugEIHuwqS2jNiv+wOxH+4PKU+PQA4ifqo3
 LpoviR2TC6tvr9tAMhdAgf9KnMACVCHoZttyqNqAir6PHkTJHSIoPqVlg8+Rs60pRAA9
 NKChPp9k/MCDZtaQG2RbxdKNh9yebpxeUBJ7MU0OPbZahv2xffVixtFawblbg65seZRv
 n2v69RPVb3uZ/yoGAN330hvuOG1JNEzVgMDM6WKcAKYY0ArX8Cpa3ZGXBLFxpk7mPauw
 m6Bw==
X-Gm-Message-State: AOAM5307Ew6W4TR2m9eT70BPKTwoQhbDgMycpsPkfYc4HqRn8tdXU5t4
 BujvNqcuaqaANdZAMAcCaWI92/+vowzTzqNamQeHHAYBTRLlTDx3cr0cSlUzCsz3/VwHl7Eq21L
 qRF6gEtz8Ub3GpmKvk1K+dBAH
X-Received: by 2002:a05:600c:3b9c:: with SMTP id
 n28mr4026533wms.128.1643135501346; 
 Tue, 25 Jan 2022 10:31:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyN0IgX820Ekp2FGnNepZZuBtQxuN7cmwVJ8BQ4uskdVHzzxIheTLTx4aGzRFqWOkVsmlYLoA==
X-Received: by 2002:a05:600c:3b9c:: with SMTP id
 n28mr4026515wms.128.1643135501089; 
 Tue, 25 Jan 2022 10:31:41 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d4sm1656669wri.39.2022.01.25.10.31.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 25 Jan 2022 10:31:40 -0800 (PST)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Gavin Shan <gshan@redhat.com>, Shannon Zhao <shannon.zhaosl@gmail.com>,
 kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
 <40d818a2-0c91-e06e-6ce8-ac8123b8d1d4@gmail.com>
 <798ecbb0-f369-f3e7-ad50-78acfd902d1d@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <3d791443-d3d3-29fb-98a4-bebadb84597e@redhat.com>
Date: Tue, 25 Jan 2022 19:31:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <798ecbb0-f369-f3e7-ad50-78acfd902d1d@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, Jonathan.Cameron@huawei.com, will@kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

SGkgR2F2aW4sCgpPbiAxLzEzLzIyIDg6MDIgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gSGkgU2hh
bm5vbiwKPiAKPiBPbiAxLzExLzIyIDU6NDMgUE0sIFNoYW5ub24gWmhhbyB3cm90ZToKPj4gT24g
MjAyMS84LzE1IDg6MTMsIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiArc3RhdGljIHVuc2lnbmVkIGxv
bmcga3ZtX3NkZWlfaHlwZXJjYWxsX2NvbnRleHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4g
K3sKPj4+ICvCoMKgwqAgc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+Pj4gK8KgwqDCoCBz
dHJ1Y3Qga3ZtX3NkZWlfa3ZtICprc2RlaSA9IGt2bS0+YXJjaC5zZGVpOwo+Pj4gK8KgwqDCoCBz
dHJ1Y3Qga3ZtX3NkZWlfdmNwdSAqdnNkZWkgPSB2Y3B1LT5hcmNoLnNkZWk7Cj4+PiArwqDCoMKg
IHN0cnVjdCBrdm1fc2RlaV92Y3B1X3JlZ3MgKnJlZ3M7Cj4+PiArwqDCoMKgIHVuc2lnbmVkIGxv
bmcgaW5kZXggPSBzbWNjY19nZXRfYXJnMSh2Y3B1KTsKPj4+ICvCoMKgwqAgdW5zaWduZWQgbG9u
ZyByZXQgPSBTREVJX1NVQ0NFU1M7Cj4+PiArCj4+PiArwqDCoMKgIC8qIFNhbml0eSBjaGVjayAq
Lwo+Pj4gK8KgwqDCoCBpZiAoIShrc2RlaSAmJiB2c2RlaSkpIHsKPj4+ICvCoMKgwqDCoMKgwqDC
oCByZXQgPSBTREVJX05PVF9TVVBQT1JURUQ7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7
Cj4+PiArwqDCoMKgIH0KPj4gTWF5YmUgd2UgY291bGQgbW92ZSB0aGVzZSBjb21tb24gc2FuaXR5
IGNoZWNrIGNvZGVzIHRvCj4+IGt2bV9zZGVpX2h5cGVyY2FsbCB0byBzYXZlIHNvbWUgbGluZXMu
Cj4+Cj4gCj4gTm90IGFsbCBoeXBlcmNhbGxzIG5lZWQgdGhpcyBjaGVjay4gRm9yIGV4YW1wbGUs
Cj4gQ09NUExFVEUvQ09NUExFVEVfUkVTVU1FL0NPTlRFWFQgZG9uJ3QKPiBoYXZlIFNERUkgZXZl
bnQgbnVtYmVyIGFzIHRoZSBhcmd1bWVudC4gSWYgd2UgcmVhbGx5IHdhbnQgbW92ZSB0aGlzCj4g
Y2hlY2sgaW50byBmdW5jdGlvbgo+IGt2bV9zZGVpX2h5cGVyY2FsbCgpLCB3ZSB3b3VsZCBoYXZl
IGNvZGUgbGlrZSBiZWxvdy4gVG9vIG11Y2ggZHVwbGljYXRlZAo+IHNuaXBwZXRzIHdpbGwKPiBi
ZSBzZWVuLiBJIGRvbid0IHRoaW5rIGl0J3MgYmV0dGVyIHRoYW4gd2hhdCB3ZSBoYXZlIGlmIEkg
ZnVsbHkKPiB1bmRlcnN0YW5kIHlvdXIgY29tbWVudHMuCj4gCj4gwqDCoMKgwqDCoCBzd2l0Y2gg
KC4uLikgewo+IMKgwqDCoMKgwqAgY2FzZSBSRUdJU1RFUjoKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAoIShrc2RlaSAmJiB2c2RlaSkpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldCA9IFNERUlfTk9UX1NVUFBPUlRFRDsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGJyZWFrOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KYXQgbGVhc3QgeW91IGNhbiB1c2UgYW4g
aW5saW5lIGZ1bmN0aW9uIHRha2luZyB0aGUgdmNwdSBhcyBwYXJhbT8KClRoYW5rcwoKRXJpYwo+
IAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IGt2bV9zZGVpX2h5cGVyY2FsbF9yZWdpc3Rl
cih2Y3B1KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiDCoMKgwqDCoMKgIGNhc2Ug
VU5SRUdJU1RFUjoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIShrc2RlaSAmJiB2c2RlaSkp
IHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IFNERUlfTk9UX1NVUFBPUlRF
RDsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgIH0KPiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBrdm1fc2RlaV9oeXBlcmNh
bGxfdW5yZWdpc3Rlcih2Y3B1KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiDCoMKg
wqDCoCBjYXNlIENPTlRFWFQ6Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0ga3ZtX3NkZWlf
aHlwZXJjYWxsX2NvbnRleHQodmNwdSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4g
wqDCoMKgwqDCoMKgIDoKPiDCoMKgwqAgfQo+IAo+IFRoYW5rcywKPiBHYXZpbgo+IAo+IF9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4ga3ZtYXJtIG1haWxp
bmcgbGlzdAo+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKPiBodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
