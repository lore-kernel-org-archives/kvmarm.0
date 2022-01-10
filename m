Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47E5C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 15:39:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6184B16E;
	Mon, 10 Jan 2022 10:39:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QP5zWhKZ+swI; Mon, 10 Jan 2022 10:39:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7294B15E;
	Mon, 10 Jan 2022 10:39:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC2F44B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:39:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mgn4EQo-ZMtL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 10:39:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6EA49FE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:39:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641829141;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Vn/4MITr303eLI/9sy4vZE7T+80p2T43/HHj8bjumUI=;
 b=EqGkm6LolTRYNRUUKoBJba5S/+i6bDTVHKDUjkqPtJwboI8zoZmcDHOlTgo5GQaeh+l4rM
 DyOo3/t9DFr4FewRBfigZUBQGPhNmJyPJ5XrBkVsDKxsSzSmnMgGlh/MMu+9Told5Annlv
 zvPiqVs2KRLTSRTVOJr/fRzVvS0YC6s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-CEx7yLGMNqOXvqY5yMS55g-1; Mon, 10 Jan 2022 10:39:00 -0500
X-MC-Unique: CEx7yLGMNqOXvqY5yMS55g-1
Received: by mail-wm1-f69.google.com with SMTP id
 d4-20020a05600c34c400b00345d5d47d54so94558wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 07:39:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=Vn/4MITr303eLI/9sy4vZE7T+80p2T43/HHj8bjumUI=;
 b=eFn1yX8N4V9+52xVNruC7IWSN8jmT830UNILlGCAeR/VjHO9SdL94AfKJjbYbnAb3g
 bV37lpVsIJy6zV+4rZ9Zfn58/pjB5HEgrOJpff2oNI5Yfp4DecDgU8sN6NnL9iWADIag
 LvIA7qhNk4odnI/lszxNau3JagnpE3/V7VuhGUO+ej4YHnTWQTb16lH01J7o9Kznb5kx
 TwEidaBSahk7c9297ISmrSzOPHmkCrlf48qj8VX6qXGoI1K7HinqIsK56GJ5Kb/czplM
 bUhH2zQbqs+qtx2YvORse4qglXh08qIsdacaFDmHdlvbCyNi9t+RFSCf34ZN56yO79ER
 YaKQ==
X-Gm-Message-State: AOAM533pOSXbix/s/2R9gZbiHE8A9FauY1j2utpyXxux+MyRRdzEkPA+
 k+jtJedxbCn7sphuTBPzPFP4/zCLippegT/jGQVdwhULN7FMGE3XOGqIa948FYS6zkMkTDLhoy6
 FmwLjl7jtDfrGsqWIG1X42Nhz
X-Received: by 2002:a5d:4609:: with SMTP id t9mr153678wrq.551.1641829138990;
 Mon, 10 Jan 2022 07:38:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZifhrLZp+3rpsOY24CeNlWG+k7+BKtRIYq4bZWPG5Q97FLrRELUVOFGLaCLaT/fCtp/nCcw==
X-Received: by 2002:a5d:4609:: with SMTP id t9mr153665wrq.551.1641829138790;
 Mon, 10 Jan 2022 07:38:58 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n12sm7169407wmq.30.2022.01.10.07.38.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 10 Jan 2022 07:38:57 -0800 (PST)
Subject: Re: [PATCH v4 4/6] hw/arm/virt: Use the PA range to compute the
 memory map
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-5-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <d7f793ab-bf78-32fb-e793-54a034ffd5d8@redhat.com>
Date: Mon, 10 Jan 2022 16:38:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-5-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgTWFyYywKCk9uIDEvNy8yMiA1OjMzIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gVGhlIGhp
Z2htZW0gYXR0cmlidXRlIGlzIG5vdGhpbmcgYnV0IGFub3RoZXIgd2F5IHRvIGV4cHJlc3MgdGhl
Cj4gUEEgcmFuZ2Ugb2YgYSBWTS4gVG8gc3VwcG9ydCBIVyB0aGF0IGhhcyBhIHNtYWxsZXIgUEEg
cmFuZ2UgdGhlbgo+IHdoYXQgUUVNVSBhc3N1bWVzLCBwYXNzIHRoaXMgUEEgcmFuZ2UgdG8gdGhl
IHZpcnRfc2V0X21lbW1hcCgpCj4gZnVuY3Rpb24sIGFsbG93aW5nIGl0IHRvIGNvcnJlY3RseSBl
eGNsdWRlIGhpZ2htZW0gZGV2aWNlcwo+IGlmIHRoZXkgYXJlIG91dHNpZGUgb2YgdGhlIFBBIHJh
bmdlLgo+Cj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPiAt
LS0KPiAgaHcvYXJtL3ZpcnQuYyB8IDUzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKSwg
NyBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9ody9hcm0vdmlydC5jIGIvaHcvYXJtL3Zp
cnQuYwo+IGluZGV4IDU3YzU1ZThhMzcuLmRiNGIwNjM2ZTEgMTAwNjQ0Cj4gLS0tIGEvaHcvYXJt
L3ZpcnQuYwo+ICsrKyBiL2h3L2FybS92aXJ0LmMKPiBAQCAtMTY2MCw3ICsxNjYwLDcgQEAgc3Rh
dGljIHVpbnQ2NF90IHZpcnRfY3B1X21wX2FmZmluaXR5KFZpcnRNYWNoaW5lU3RhdGUgKnZtcywg
aW50IGlkeCkKPiAgICAgIHJldHVybiBhcm1fY3B1X21wX2FmZmluaXR5KGlkeCwgY2x1c3RlcnN6
KTsKPiAgfQo+ICAKPiAtc3RhdGljIHZvaWQgdmlydF9zZXRfbWVtbWFwKFZpcnRNYWNoaW5lU3Rh
dGUgKnZtcykKPiArc3RhdGljIHZvaWQgdmlydF9zZXRfbWVtbWFwKFZpcnRNYWNoaW5lU3RhdGUg
KnZtcywgaW50IHBhX2JpdHMpCj4gIHsKPiAgICAgIE1hY2hpbmVTdGF0ZSAqbXMgPSBNQUNISU5F
KHZtcyk7Cj4gICAgICBod2FkZHIgYmFzZSwgZGV2aWNlX21lbW9yeV9iYXNlLCBkZXZpY2VfbWVt
b3J5X3NpemUsIG1lbXRvcDsKPiBAQCAtMTY3OCw2ICsxNjc4LDEzIEBAIHN0YXRpYyB2b2lkIHZp
cnRfc2V0X21lbW1hcChWaXJ0TWFjaGluZVN0YXRlICp2bXMpCj4gICAgICAgICAgZXhpdChFWElU
X0ZBSUxVUkUpOwo+ICAgICAgfQo+ICAKPiArICAgIC8qCj4gKyAgICAgKiAhaGlnaG1lbSBpcyBl
eGFjdGx5IHRoZSBzYW1lIGFzIGxpbWl0aW5nIHRoZSBQQSBzcGFjZSB0byAzMmJpdCwKPiArICAg
ICAqIGlycmVzcGVjdGl2ZSBvZiB0aGUgdW5kZXJseWluZyBjYXBhYmlsaXRpZXMgb2YgdGhlIEhX
Lgo+ICsgICAgICovCj4gKyAgICBpZiAoIXZtcy0+aGlnaG1lbSkKPiArCSAgICBwYV9iaXRzID0g
MzI7CnlvdSBuZWVkIHt9IGFjY29yZGluZyB0byB0aGUgUUVNVSBjb2Rpbmcgc3R5bGUuIFdlbGNv
bWUgdG8gYSBuZXcgc2hpbnkKd29ybGQgOi0pCj4gKwo+ICAgICAgLyoKPiAgICAgICAqIFdlIGNv
bXB1dGUgdGhlIGJhc2Ugb2YgdGhlIGhpZ2ggSU8gcmVnaW9uIGRlcGVuZGluZyBvbiB0aGUKPiAg
ICAgICAqIGFtb3VudCBvZiBpbml0aWFsIGFuZCBkZXZpY2UgbWVtb3J5LiBUaGUgZGV2aWNlIG1l
bW9yeSBzdGFydC9zaXplCj4gQEAgLTE2OTEsOCArMTY5OCw5IEBAIHN0YXRpYyB2b2lkIHZpcnRf
c2V0X21lbW1hcChWaXJ0TWFjaGluZVN0YXRlICp2bXMpCj4gIAo+ICAgICAgLyogQmFzZSBhZGRy
ZXNzIG9mIHRoZSBoaWdoIElPIHJlZ2lvbiAqLwo+ICAgICAgbWVtdG9wID0gYmFzZSA9IGRldmlj
ZV9tZW1vcnlfYmFzZSArIFJPVU5EX1VQKGRldmljZV9tZW1vcnlfc2l6ZSwgR2lCKTsKPiAtICAg
IGlmICghdm1zLT5oaWdobWVtICYmIG1lbXRvcCA+IDQgKiBHaUIpIHsKPiAtICAgICAgICBlcnJv
cl9yZXBvcnQoImhpZ2htZW09b2ZmLCBidXQgbWVtb3J5IGNyb3NzZXMgdGhlIDRHaUIgbGltaXRc
biIpOwo+ICsgICAgaWYgKG1lbXRvcCA+IEJJVF9VTEwocGFfYml0cykpIHsKPiArCSAgICBlcnJv
cl9yZXBvcnQoIkFkZHJlc3NpbmcgbGltaXRlZCB0byAlZCBiaXRzLCBidXQgbWVtb3J5IGV4Y2Vl
ZHMgaXQgYnkgJWxsdSBieXRlc1xuIiwKPiArCQkJIHBhX2JpdHMsIG1lbXRvcCAtIEJJVF9VTEwo
cGFfYml0cykpOwo+ICAgICAgICAgIGV4aXQoRVhJVF9GQUlMVVJFKTsKPiAgICAgIH0KPiAgICAg
IGlmIChiYXNlIDwgZGV2aWNlX21lbW9yeV9iYXNlKSB7Cj4gQEAgLTE3MTEsNyArMTcxOSwxMyBA
QCBzdGF0aWMgdm9pZCB2aXJ0X3NldF9tZW1tYXAoVmlydE1hY2hpbmVTdGF0ZSAqdm1zKQo+ICAg
ICAgICAgIHZtcy0+bWVtbWFwW2ldLnNpemUgPSBzaXplOwo+ICAgICAgICAgIGJhc2UgKz0gc2l6
ZTsKPiAgICAgIH0KPiAtICAgIHZtcy0+aGlnaGVzdF9ncGEgPSAodm1zLT5oaWdobWVtID8gYmFz
ZSA6IG1lbXRvcCkgLSAxOwo+ICsKPiArICAgIC8qCj4gKyAgICAgKiBJZiBiYXNlIGZpdHMgd2l0
aGluIHBhX2JpdHMsIGFsbCBnb29kLiBJZiBpdCBkb2Vzbid0LCBsaW1pdCBpdAo+ICsgICAgICog
dG8gdGhlIGVuZCBvZiBSQU0sIHdoaWNoIGlzIGd1YXJhbnRlZWQgdG8gZml0IHdpdGhpbiBwYV9i
aXRzLgo+ICsgICAgICovCj4gKyAgICB2bXMtPmhpZ2hlc3RfZ3BhID0gKGJhc2UgPD0gQklUX1VM
TChwYV9iaXRzKSA/IGJhc2UgOiBtZW10b3ApIC0gMTsKPiArCj4gICAgICBpZiAoZGV2aWNlX21l
bW9yeV9zaXplID4gMCkgewo+ICAgICAgICAgIG1zLT5kZXZpY2VfbWVtb3J5ID0gZ19tYWxsb2Mw
KHNpemVvZigqbXMtPmRldmljZV9tZW1vcnkpKTsKPiAgICAgICAgICBtcy0+ZGV2aWNlX21lbW9y
eS0+YmFzZSA9IGRldmljZV9tZW1vcnlfYmFzZTsKPiBAQCAtMTkwMiwxMiArMTkxNiwzOCBAQCBz
dGF0aWMgdm9pZCBtYWNodmlydF9pbml0KE1hY2hpbmVTdGF0ZSAqbWFjaGluZSkKPiAgICAgIHVu
c2lnbmVkIGludCBzbXBfY3B1cyA9IG1hY2hpbmUtPnNtcC5jcHVzOwo+ICAgICAgdW5zaWduZWQg
aW50IG1heF9jcHVzID0gbWFjaGluZS0+c21wLm1heF9jcHVzOwpNb3ZlIHRoZSBjcHVfdHlwZSBj
aGVjayBiZWZvcmU/CgrCoMKgwqAgaWYgKCFjcHVfdHlwZV92YWxpZChtYWNoaW5lLT5jcHVfdHlw
ZSkpIHsKwqDCoMKgwqDCoMKgwqAgZXJyb3JfcmVwb3J0KCJtYWNoLXZpcnQ6IENQVSB0eXBlICVz
IG5vdCBzdXBwb3J0ZWQiLAptYWNoaW5lLT5jcHVfdHlwZSk7CsKgwqDCoMKgwqDCoMKgIGV4aXQo
MSk7CsKgwqDCoCB9Cj4gIAo+ICsgICAgcG9zc2libGVfY3B1cyA9IG1jLT5wb3NzaWJsZV9jcHVf
YXJjaF9pZHMobWFjaGluZSk7Cj4gKwo+ICAgICAgLyoKPiAgICAgICAqIEluIGFjY2VsZXJhdGVk
IG1vZGUsIHRoZSBtZW1vcnkgbWFwIGlzIGNvbXB1dGVkIGVhcmxpZXIgaW4ga3ZtX3R5cGUoKQo+
ICAgICAgICogdG8gY3JlYXRlIGEgVk0gd2l0aCB0aGUgcmlnaHQgbnVtYmVyIG9mIElQQSBiaXRz
Lgo+ICAgICAgICovCj4gICAgICBpZiAoIXZtcy0+bWVtbWFwKSB7Cj4gLSAgICAgICAgdmlydF9z
ZXRfbWVtbWFwKHZtcyk7Cj4gKyAgICAgICAgT2JqZWN0ICpjcHVvYmo7Cj4gKyAgICAgICAgQVJN
Q1BVICphcm1jcHU7Cj4gKyAgICAgICAgaW50IHBhX2JpdHM7Cj4gKwo+ICsgICAgICAgIC8qCj4g
KyAgICAgICAgICogSW5zdGFuY2lhdGUgYSB0ZW1wb3JhcnkgQ1BVIG9iamVjdCB0byBmaW5kIG91
dCBhYm91dCB3aGF0Cj4gKyAgICAgICAgICogd2UgYXJlIGFib3V0IHRvIGRlYWwgd2l0aC4gT25j
ZSB0aGlzIGlzIGRvbmUsIGdldCByaWQgb2YKPiArICAgICAgICAgKiB0aGUgb2JqZWN0Lgo+ICsg
ICAgICAgICAqLwo+ICsgICAgICAgIGNwdW9iaiA9IG9iamVjdF9uZXcocG9zc2libGVfY3B1cy0+
Y3B1c1swXS50eXBlKTsKPiArICAgICAgICBhcm1jcHUgPSBBUk1fQ1BVKGNwdW9iaik7Cj4gKwo+
ICsgICAgICAgIGlmIChvYmplY3RfcHJvcGVydHlfZ2V0X2Jvb2woY3B1b2JqLCAiYWFyY2g2NCIs
IE5VTEwpKSB7Cj4gKyAgICAgICAgICAgIHBhX2JpdHMgPSBhcm1fcGFtYXgoYXJtY3B1KTsKPiAr
ICAgICAgICB9IGVsc2UgaWYgKGFybV9mZWF0dXJlKCZhcm1jcHUtPmVudiwgQVJNX0ZFQVRVUkVf
TFBBRSkpIHsKPiArICAgICAgICAgICAgLyogdjcgd2l0aCBMUEFFICovCj4gKyAgICAgICAgICAg
IHBhX2JpdHMgPSA0MDsKPiArICAgICAgICB9IGVsc2Ugewo+ICsgICAgICAgICAgICAvKiBBbnl0
aGluZyBlbHNlICovCj4gKyAgICAgICAgICAgIHBhX2JpdHMgPSAzMjsKPiArICAgICAgICB9Cj4g
Kwo+ICsgICAgICAgIG9iamVjdF91bnJlZihjcHVvYmopOwo+ICsKPiArICAgICAgICB2aXJ0X3Nl
dF9tZW1tYXAodm1zLCBwYV9iaXRzKTsKPiAgICAgIH0KPiAgCj4gICAgICAvKiBXZSBjYW4gcHJv
YmUgb25seSBoZXJlIGJlY2F1c2UgZHVyaW5nIHByb3BlcnR5IHNldAo+IEBAIC0xOTg5LDcgKzIw
MjksNiBAQCBzdGF0aWMgdm9pZCBtYWNodmlydF9pbml0KE1hY2hpbmVTdGF0ZSAqbWFjaGluZSkK
PiAgCj4gICAgICBjcmVhdGVfZmR0KHZtcyk7Cj4gIAo+IC0gICAgcG9zc2libGVfY3B1cyA9IG1j
LT5wb3NzaWJsZV9jcHVfYXJjaF9pZHMobWFjaGluZSk7Cj4gICAgICBhc3NlcnQocG9zc2libGVf
Y3B1cy0+bGVuID09IG1heF9jcHVzKTsKPiAgICAgIGZvciAobiA9IDA7IG4gPCBwb3NzaWJsZV9j
cHVzLT5sZW47IG4rKykgewo+ICAgICAgICAgIE9iamVjdCAqY3B1b2JqOwo+IEBAIC0yNjQ2LDcg
KzI2ODUsNyBAQCBzdGF0aWMgaW50IHZpcnRfa3ZtX3R5cGUoTWFjaGluZVN0YXRlICptcywgY29u
c3QgY2hhciAqdHlwZV9zdHIpCj4gICAgICBtYXhfdm1fcGFfc2l6ZSA9IGt2bV9hcm1fZ2V0X21h
eF92bV9pcGFfc2l6ZShtcywgJmZpeGVkX2lwYSk7Cj4gIAo+ICAgICAgLyogd2UgZnJlZXplIHRo
ZSBtZW1vcnkgbWFwIHRvIGNvbXB1dGUgdGhlIGhpZ2hlc3QgZ3BhICovCj4gLSAgICB2aXJ0X3Nl
dF9tZW1tYXAodm1zKTsKPiArICAgIHZpcnRfc2V0X21lbW1hcCh2bXMsIG1heF92bV9wYV9zaXpl
KTsKPiAgCj4gICAgICByZXF1ZXN0ZWRfcGFfc2l6ZSA9IDY0IC0gY2x6NjQodm1zLT5oaWdoZXN0
X2dwYSk7Cj4gIApUaGFua3MKCkVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
