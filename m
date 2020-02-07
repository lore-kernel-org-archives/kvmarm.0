Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3310AC2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:18:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A758521775
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="brDrT5F5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A758521775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4234A5C6;
	Fri,  7 Feb 2020 11:18:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zU7WXWLG-1pK; Fri,  7 Feb 2020 11:18:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFC174A418;
	Fri,  7 Feb 2020 11:18:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 822994A418
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:18:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nAnTHJWG6G1p for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:18:51 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5F84A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:18:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581092331;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vHAt/AukijeggKNEebr+yrLfBVqYD7HKA3edhEKXPqY=;
 b=brDrT5F5oINfkVXwe7SQepw3CzqzuTa+MB3ekkN3v60f/EkujHHzJ0KnR0yqNiL2IZeZyf
 lrQKfJ/idBnOEZdUArB+esTPGB1zTw9CmmOKcDR+2/dhYaofdq9VDdUPAJdP3mw1xEO/5/
 PaZIdyZFOUnXgh5gS5rgYVpgzl4zLCo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-bRiEqCvpOGSW2OgMLiSfmQ-1; Fri, 07 Feb 2020 11:18:48 -0500
Received: by mail-qk1-f198.google.com with SMTP id 12so1732256qkf.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 08:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=jclxcwAozM1U7HhbQOM73LDCd0RoMBSWDQazU9Vp+Ns=;
 b=dwctvBG8v4mMnYmt7iX2KUYP5ZglmDFAZFRLDtpygw4tVlLaIbBMyde7gqFTL9RhuB
 VYf3bY2UEwp8nFE027y8MbMzfZSBoUsPshQLHf3s9a87IbTBts+aY+dGLrG8k3Odvkfj
 r0K12C7AWhaVoHHNSDvpsWbQD42V1yrRjBRu4nyntCVibaYj0cJZOJVxCzK0pQpcmssf
 pm3GhKV5+kI+nHrqoLvfkB3kAh2TIDi/wSwrAItd4dWWoN0f4cv8ZyYGz2poWZGDnE4u
 ab0q65dUPx+IKoS04rLKmiPW+ID+9vfbRgKa9+0HmyhxSCJdBQlx+RqCRokqygR9JOsr
 7LdQ==
X-Gm-Message-State: APjAAAUTOozzuCyY30aUJyQ46rTqMGxk8NUYhVDVUNHi9846sMj+sHY2
 mojhr2roBzUQwGJHqian+7UfuG3f0lIAoThXO82uV7yb1ioQ7jkXkGTFGsTj48vohFkDCBMN8vu
 Gky7VZ5gRQrvWua+3beibvK5+
X-Received: by 2002:a05:6214:a41:: with SMTP id
 ee1mr7489344qvb.149.1581092328378; 
 Fri, 07 Feb 2020 08:18:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxy7CZezKLhxlm/hSkDn+LBRyJvdycCSzmggJ171E3ZeERFf2xuwxzRz4plj88GUzI7cZZyjQ==
X-Received: by 2002:a05:6214:a41:: with SMTP id
 ee1mr7489286qvb.149.1581092327872; 
 Fri, 07 Feb 2020 08:18:47 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id n32sm1616811qtk.66.2020.02.07.08.18.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 08:18:47 -0800 (PST)
Date: Fri, 7 Feb 2020 11:18:45 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: BUG: using __this_cpu_read() in preemptible [00000000] code
Message-ID: <20200207161845.GB707371@xz-x1>
References: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
 <828d3b538b7258f692f782b6798277cf@kernel.org>
 <3e90c020-e7f3-61f1-3731-a489df0b1d9c@huawei.com>
 <f2fd3b371fda9167a02a7312cda5d217@kernel.org>
MIME-Version: 1.0
In-Reply-To: <f2fd3b371fda9167a02a7312cda5d217@kernel.org>
X-MC-Unique: bRiEqCvpOGSW2OgMLiSfmQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

T24gRnJpLCBGZWIgMDcsIDIwMjAgYXQgMTA6MjU6MjNBTSArMDAwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IE9uIDIwMjAtMDItMDcgMTA6MTksIFplbmdodWkgWXUgd3JvdGU6Cj4gPiBIaSBNYXJj
LAo+ID4gCj4gPiBPbiAyMDIwLzIvNyAxNzoxOSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+ID4gPiBI
aSBaZW5naHVpLAo+ID4gPiAKPiA+ID4gT24gMjAyMC0wMi0wNyAwOTowMCwgWmVuZ2h1aSBZdSB3
cm90ZToKPiA+ID4gPiBIaSwKPiA+ID4gPiAKPiA+ID4gPiBSdW5uaW5nIGEgbGF0ZXN0IHByZWVt
cHRpYmxlIGtlcm5lbCBhbmQgc29tZSBndWVzdHMgb24gaXQsCj4gPiA+ID4gSSBnb3QgdGhlIGZv
bGxvd2luZyBtZXNzYWdlLAo+ID4gPiA+IAo+ID4gPiA+IC0tLTg8LS0tCj4gPiA+ID4gCj4gPiA+
ID4gW8KgIDYzMC4wMzE4NzBdIEJVRzogdXNpbmcgX190aGlzX2NwdV9yZWFkKCkgaW4gcHJlZW1w
dGlibGUgWzAwMDAwMDAwXQo+ID4gPiA+IGNvZGU6IHFlbXUtc3lzdGVtLWFhci8zNzI3MAo+ID4g
PiA+IFvCoCA2MzAuMDMxODcyXSBjYWxsZXIgaXMga3ZtX2dldF9ydW5uaW5nX3ZjcHUrMHgxYy8w
eDM4Cj4gPiA+ID4gW8KgIDYzMC4wMzE4NzRdIENQVTogMzIgUElEOiAzNzI3MCBDb21tOiBxZW11
LXN5c3RlbS1hYXIgS2R1bXA6IGxvYWRlZAo+ID4gPiA+IE5vdCB0YWludGVkIDUuNS4wKwo+ID4g
PiA+IFvCoCA2MzAuMDMxODc2XSBIYXJkd2FyZSBuYW1lOiBIdWF3ZWkgVGFpU2hhbiAyMjgwIC9C
QzExU1BDRCwKPiA+ID4gPiBCSU9TIDEuNTgKPiA+ID4gPiAxMC8yOS8yMDE4Cj4gPiA+ID4gW8Kg
IDYzMC4wMzE4NzZdIENhbGwgdHJhY2U6Cj4gPiA+ID4gW8KgIDYzMC4wMzE4NzhdwqAgZHVtcF9i
YWNrdHJhY2UrMHgwLzB4MjAwCj4gPiA+ID4gW8KgIDYzMC4wMzE4ODBdwqAgc2hvd19zdGFjaysw
eDI0LzB4MzAKPiA+ID4gPiBbwqAgNjMwLjAzMTg4Ml3CoCBkdW1wX3N0YWNrKzB4YjAvMHhmNAo+
ID4gPiA+IFvCoCA2MzAuMDMxODg0XcKgIF9fdGhpc19jcHVfcHJlZW1wdF9jaGVjaysweGM4LzB4
ZDAKPiA+ID4gPiBbwqAgNjMwLjAzMTg4Nl3CoCBrdm1fZ2V0X3J1bm5pbmdfdmNwdSsweDFjLzB4
MzgKPiA+ID4gPiBbwqAgNjMwLjAzMTg4OF3CoCB2Z2ljX21taW9fY2hhbmdlX2FjdGl2ZS5pc3Jh
LjQrMHgyYy8weGUwCj4gPiA+ID4gW8KgIDYzMC4wMzE4OTBdwqAgX192Z2ljX21taW9fd3JpdGVf
Y2FjdGl2ZSsweDgwLzB4YzgKPiA+ID4gPiBbwqAgNjMwLjAzMTg5Ml3CoCB2Z2ljX21taW9fdWFj
Y2Vzc193cml0ZV9jYWN0aXZlKzB4M2MvMHg1MAo+ID4gPiA+IFvCoCA2MzAuMDMxODk0XcKgIHZn
aWNfdWFjY2VzcysweGNjLzB4MTM4Cj4gPiA+ID4gW8KgIDYzMC4wMzE4OTZdwqAgdmdpY192M19y
ZWRpc3RfdWFjY2VzcysweDdjLzB4YTgKPiA+ID4gPiBbwqAgNjMwLjAzMTg5OF3CoCB2Z2ljX3Yz
X2F0dHJfcmVnc19hY2Nlc3MrMHgxYTgvMHgyMzAKPiA+ID4gPiBbwqAgNjMwLjAzMTkwMV3CoCB2
Z2ljX3YzX3NldF9hdHRyKzB4MWI0LzB4MjkwCj4gPiA+ID4gW8KgIDYzMC4wMzE5MDNdwqAga3Zt
X2RldmljZV9pb2N0bF9hdHRyKzB4YmMvMHgxMTAKPiA+ID4gPiBbwqAgNjMwLjAzMTkwNV3CoCBr
dm1fZGV2aWNlX2lvY3RsKzB4YzQvMHgxMDgKPiA+ID4gPiBbwqAgNjMwLjAzMTkwN13CoCBrc3lz
X2lvY3RsKzB4YjQvMHhkMAo+ID4gPiA+IFvCoCA2MzAuMDMxOTA5XcKgIF9fYXJtNjRfc3lzX2lv
Y3RsKzB4MjgvMHgzOAo+ID4gPiA+IFvCoCA2MzAuMDMxOTExXcKgIGVsMF9zdmNfY29tbW9uLmNv
bnN0cHJvcC4xKzB4N2MvMHgxYTAKPiA+ID4gPiBbwqAgNjMwLjAzMTkxM13CoCBkb19lbDBfc3Zj
KzB4MzQvMHhhMAo+ID4gPiA+IFvCoCA2MzAuMDMxOTE1XcKgIGVsMF9zeW5jX2hhbmRsZXIrMHgx
MjQvMHgyNzQKPiA+ID4gPiBbwqAgNjMwLjAzMTkxNl3CoCBlbDBfc3luYysweDE0MC8weDE4MAo+
ID4gPiA+IAo+ID4gPiA+IC0tLTg8LS0tCj4gPiA+ID4gCj4gPiA+ID4gSSdtIG5vdyBhdCBjb21t
aXQgOTA1NjhlY2Y1NjE1NDBmYTMzMDUxMWUyMWZjZDgyM2IwYzM4MjljNi4KPiA+ID4gPiAKPiA+
ID4gPiBBbmQgaXQgbG9va3MgbGlrZSB2Z2ljX2dldF9tbWlvX3JlcXVlc3Rlcl92Y3B1KCkgd2Fz
IGJyb2tlbiBieQo+ID4gPiA+IDc0OTVlMjJiYjE2NSAoIktWTTogTW92ZSBydW5uaW5nIFZDUFUg
ZnJvbSBBUk0gdG8gY29tbW9uIGNvZGUiKS4KPiA+ID4gPiAKPiA+ID4gPiBDb3VsZCBhbnlvbmUg
cGxlYXNlIGhhdmUgYSBsb29rPwo+ID4gPiAKPiA+ID4gSGVyZSB5b3UgZ286Cj4gPiA+IAo+ID4g
PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMKPiA+ID4gYi92aXJ0
L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8uYwo+ID4gPiBpbmRleCBkNjU2ZWJkNWY5ZDQuLmUxNzM1
ZjE5YzkyNCAxMDA2NDQKPiA+ID4gLS0tIGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMK
PiA+ID4gKysrIGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMKPiA+ID4gQEAgLTE5MCw2
ICsxOTAsMTUgQEAgdW5zaWduZWQgbG9uZyB2Z2ljX21taW9fcmVhZF9wZW5kaW5nKHN0cnVjdAo+
ID4gPiBrdm1fdmNwdSAqdmNwdSwKPiA+ID4gIMKgICogdmFsdWUgbGF0ZXIgd2lsbCBnaXZlIHVz
IHRoZSBzYW1lIHZhbHVlIGFzIHdlIHVwZGF0ZSB0aGUKPiA+ID4gcGVyLUNQVSB2YXJpYWJsZQo+
ID4gPiAgwqAgKiBpbiB0aGUgcHJlZW1wdCBub3RpZmllciBoYW5kbGVycy4KPiA+ID4gIMKgICov
Cj4gPiA+ICtzdGF0aWMgc3RydWN0IGt2bV92Y3B1ICp2Z2ljX2dldF9tbWlvX3JlcXVlc3Rlcl92
Y3B1KHZvaWQpCj4gPiA+ICt7Cj4gPiA+ICvCoMKgwqAgc3RydWN0IGt2bV92Y3B1ICp2Y3B1Owo+
ID4gPiArCj4gPiA+ICvCoMKgwqAgcHJlZW1wdF9kaXNhYmxlKCk7Cj4gPiA+ICvCoMKgwqAgdmNw
dSA9IGt2bV9nZXRfcnVubmluZ192Y3B1KCk7Cj4gPiA+ICvCoMKgwqAgcHJlZW1wdF9lbmFibGUo
KTsKPiA+ID4gK8KgwqDCoCByZXR1cm4gdmNwdTsKPiA+ID4gK30KPiA+ID4gCj4gPiA+ICDCoC8q
IE11c3QgYmUgY2FsbGVkIHdpdGggaXJxLT5pcnFfbG9jayBoZWxkICovCj4gPiA+ICDCoHN0YXRp
YyB2b2lkIHZnaWNfaHdfaXJxX3NwZW5kaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0
Cj4gPiA+IHZnaWNfaXJxICppcnEsCj4gPiA+IEBAIC0yMTIsNyArMjIxLDcgQEAgdm9pZCB2Z2lj
X21taW9fd3JpdGVfc3BlbmRpbmcoc3RydWN0IGt2bV92Y3B1Cj4gPiA+ICp2Y3B1LAo+ID4gPiAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdwYV90IGFkZHIsIHVuc2lnbmVk
IGludCBsZW4sCj4gPiA+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5z
aWduZWQgbG9uZyB2YWwpCj4gPiA+ICDCoHsKPiA+ID4gLcKgwqDCoCBib29sIGlzX3VhY2Nlc3Mg
PSAha3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsKPiA+ID4gK8KgwqDCoCBib29sIGlzX3VhY2Nlc3Mg
PSAhdmdpY19nZXRfbW1pb19yZXF1ZXN0ZXJfdmNwdSgpOwo+ID4gPiAgwqDCoMKgwqAgdTMyIGlu
dGlkID0gVkdJQ19BRERSX1RPX0lOVElEKGFkZHIsIDEpOwo+ID4gPiAgwqDCoMKgwqAgaW50IGk7
Cj4gPiA+ICDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIGZsYWdzOwo+ID4gPiBAQCAtMjY1LDcgKzI3
NCw3IEBAIHZvaWQgdmdpY19tbWlvX3dyaXRlX2NwZW5kaW5nKHN0cnVjdCBrdm1fdmNwdQo+ID4g
PiAqdmNwdSwKPiA+ID4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBncGFf
dCBhZGRyLCB1bnNpZ25lZCBpbnQgbGVuLAo+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgdmFsKQo+ID4gPiAgwqB7Cj4gPiA+IC3CoMKgwqAg
Ym9vbCBpc191YWNjZXNzID0gIWt2bV9nZXRfcnVubmluZ192Y3B1KCk7Cj4gPiA+ICvCoMKgwqAg
Ym9vbCBpc191YWNjZXNzID0gIXZnaWNfZ2V0X21taW9fcmVxdWVzdGVyX3ZjcHUoKTsKPiA+ID4g
IMKgwqDCoMKgIHUzMiBpbnRpZCA9IFZHSUNfQUREUl9UT19JTlRJRChhZGRyLCAxKTsKPiA+ID4g
IMKgwqDCoMKgIGludCBpOwo+ID4gPiAgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBmbGFnczsKPiA+
ID4gQEAgLTMyNiw3ICszMzUsNyBAQCBzdGF0aWMgdm9pZCB2Z2ljX21taW9fY2hhbmdlX2FjdGl2
ZShzdHJ1Y3QKPiA+ID4ga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCB2Z2ljX2lycSAqaXJxLAo+ID4g
PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBib29sIGFjdGl2ZSkK
PiA+ID4gIMKgewo+ID4gPiAgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBmbGFnczsKPiA+ID4gLcKg
wqDCoCBzdHJ1Y3Qga3ZtX3ZjcHUgKnJlcXVlc3Rlcl92Y3B1ID0ga3ZtX2dldF9ydW5uaW5nX3Zj
cHUoKTsKPiA+ID4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3ZjcHUgKnJlcXVlc3Rlcl92Y3B1ID0gdmdp
Y19nZXRfbW1pb19yZXF1ZXN0ZXJfdmNwdSgpOwo+ID4gPiAKPiA+ID4gIMKgwqDCoMKgIHJhd19z
cGluX2xvY2tfaXJxc2F2ZSgmaXJxLT5pcnFfbG9jaywgZmxhZ3MpOwo+ID4gPiAKPiA+ID4gCj4g
PiA+IFRoYXQncyBiYXNpY2FsbHkgYSByZXZlcnQgb2YgdGhlIG9mZmVuZGluZyBjb2RlLiBUaGUg
Y29tbWVudCByaWdodAo+ID4gPiBhYm92ZQo+ID4gPiB2Z2ljX2dldF9tbWlvX3JlcXVlc3Rlcl92
Y3B1KCkgZXhwbGFpbnMgKndoeSogdGhpcyBpcyB2YWxpZCwgYW5kIHdoeQo+ID4gPiBwcmVlbXB0
X2Rpc2FibGUoKSBpcyBuZWVkZWQuCgpTb3JyeSBmb3Igbm90IG5vdGljaW5nIHRoaXMgYmVmb3Jl
LgoKPiA+IAo+ID4gSSBzZWUsIHRoYW5rcyEKPiA+IAo+ID4gPiAKPiA+ID4gQ2FuIHlvdSBwbGVh
c2UgZ2l2ZSBpdCBhIHNob3Q/Cj4gPiAKPiA+IFllcywgaXQgd29ya3MgZm9yIG1lOgo+ID4gCj4g
PiBUZXN0ZWQtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+IAo+IEFjdHVh
bGx5LCBtYXliZSBhIGJldHRlci9zaW1wbGVyIGZpeCB3b3VsZCBiZSB0aGlzOgo+IAo+IGRpZmYg
LS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYwo+IGluZGV4
IDY3YWUyZDVjMzdiMi4uM2NmNzcxOWQzMTc3IDEwMDY0NAo+IC0tLSBhL3ZpcnQva3ZtL2t2bV9t
YWluLmMKPiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4gQEAgLTQ0MTQsNyArNDQxNCwxMyBA
QCBzdGF0aWMgdm9pZCBrdm1fc2NoZWRfb3V0KHN0cnVjdCBwcmVlbXB0X25vdGlmaWVyCj4gKnBu
LAo+ICAgKi8KPiAgc3RydWN0IGt2bV92Y3B1ICprdm1fZ2V0X3J1bm5pbmdfdmNwdSh2b2lkKQo+
ICB7Cj4gLSAgICAgICAgcmV0dXJuIF9fdGhpc19jcHVfcmVhZChrdm1fcnVubmluZ192Y3B1KTsK
PiArCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKPiArCj4gKwlwcmVlbXB0X2Rpc2FibGUoKTsKPiAr
CXZjcHUgPSBfX3RoaXNfY3B1X3JlYWQoa3ZtX3J1bm5pbmdfdmNwdSk7Cj4gKwlwcmVlbXB0X2Vu
YWJsZSgpOwo+ICsKPiArCXJldHVybiB2Y3B1Owo+ICB9Cj4gCj4gIC8qKgo+IAo+IHdoaWNoIG1h
dGNoZXMgdGhlIGNvbW1lbnQgdGhhdCBjb21lcyB3aXRoIHRoZSBmdW5jdGlvbi4KPiAKPiBQYW9s
bywgd2hpY2ggb25lIGRvIHlvdSBwcmVmZXI/IEl0IHNlZW1zIHRvIG1lIHRoYXQgdGhlIGludGVu
dCBvZiBtb3ZpbmcKPiB0aGlzIHRvIGNvcmUgY29kZSB3YXMgdG8gcHJvdmlkZSBhIGhpZ2ggbGV2
ZWwgQVBJIHRoYXQgd29ya3MgYXQgYWxsIHRpbWVzLgoKTm90IHN1cmUgYWJvdXQgUGFvbG8sIGJ1
dCB0aGlzIGxvb2tzIGJldHRlciBhdCBsZWFzdCB0byBtZS4gIFNoYWxsIHdlCmFsc28gbW92ZSB0
aGUgY29tbWVudCBmcm9tIHZnaWMtbW1pby5jIHRvIGhlcmU/ICBBbmQgd2UgY2FuIHJlbW92ZSB0
aGUKMXN0IHBhcmFncmFwaDoKCi8qCiAqIFdlIGNhbiBkaXNhYmxlIHByZWVtcHRpb24gbG9jYWxs
eSBhcm91bmQgYWNjZXNzaW5nIHRoZSBwZXItQ1BVIHZhcmlhYmxlLAogKiBhbmQgdXNlIHRoZSBy
ZXNvbHZlZCB2Y3B1IHBvaW50ZXIgYWZ0ZXIgZW5hYmxpbmcgcHJlZW1wdGlvbiBhZ2FpbiwgYmVj
YXVzZQogKiBldmVuIGlmIHRoZSBjdXJyZW50IHRocmVhZCBpcyBtaWdyYXRlZCB0byBhbm90aGVy
IENQVSwgcmVhZGluZyB0aGUgcGVyLUNQVQogKiB2YWx1ZSBsYXRlciB3aWxsIGdpdmUgdXMgdGhl
IHNhbWUgdmFsdWUgYXMgd2UgdXBkYXRlIHRoZSBwZXItQ1BVIHZhcmlhYmxlCiAqIGluIHRoZSBw
cmVlbXB0IG5vdGlmaWVyIGhhbmRsZXJzLgogKi8KClRoYW5rcyEKCi0tIApQZXRlciBYdQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
