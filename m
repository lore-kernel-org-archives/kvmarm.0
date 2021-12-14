Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB23C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 15:37:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CD14B22C;
	Tue, 14 Dec 2021 10:37:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q6CT1uCGrIWO; Tue, 14 Dec 2021 10:37:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4329A4B210;
	Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF5A4B215
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:53:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tkF8jK4sgzgC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 02:53:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B08914B20D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:53:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639468415;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DQnA16VkAqKaFSkz78q65wOFX1IYz3uTY5bc4vdx9+c=;
 b=NOgsR70EI7Ursty0j3p1OnfXJzubU0/ISmADu8AChopjWfCD3abVpMxi3wh4SriGi2EJKb
 TF4DTgUFQrNmfhHRf+Q595R6ri/Taq5GRB6vpFRvzWVbijXWW6EJMsYPtbFGVU932lLBH0
 dW9ylOm6q1Jg0/Z/FRrxDEXT4uwECyQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-bQ_APme_MKmX1Lv9OV_umw-1; Tue, 14 Dec 2021 02:53:31 -0500
X-MC-Unique: bQ_APme_MKmX1Lv9OV_umw-1
Received: by mail-wr1-f71.google.com with SMTP id
 u4-20020a5d4684000000b0017c8c1de97dso4382456wrq.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 23:53:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=DQnA16VkAqKaFSkz78q65wOFX1IYz3uTY5bc4vdx9+c=;
 b=czq6uwgtp3XmH7zr48zVWjOgX2ZpwWWAy1zMOkS+2kd8uSnr1p6hJcL39iD6QpMOvH
 /lvX0ir5YkfyaAadh+VPdwbbMeCznAZ+qodyzri+HRFl1TMo7E6SgQCe8kyZltpdd0A4
 w8FmwJy8OhfcgxBSMGgYiSC73NFbt2CgDmBMzBJrmBxSp1v1YyCZvEqi9SZq+eYDFPqS
 Jmu/5KXL2s5yztEiE8cmDSeff02/n3QkAGwGeThfxj92/gAAPgm8GEiwN/wK+gLTCrHn
 L5utNXSDynAuzVFUfT7cf5GCMwUe4U+b3yYMP7DZXJ9dYrhqYXG8jqECr6ffsZ1rfbZe
 ylhQ==
X-Gm-Message-State: AOAM532RF+YJr3s/7E/GLM/6MmfWJrOGPP+D33+Tjr5UNusGyCv1tMjt
 2fs15XuUgQ1F8yYO4rphxqcnfe433r6Apur0WVHQhEmX6yPyEiqr4Z5FPmfkL9N3iagGaUHTAIS
 Gr4dVONU02MF4ZuNPEH2zLkjV
X-Received: by 2002:a5d:6c63:: with SMTP id r3mr4274874wrz.213.1639468410028; 
 Mon, 13 Dec 2021 23:53:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysjU9QLo7Pn7rTaoZKy+4ZNFiS9Wi/Wf95GIbHE/wY2ApWxGaznsQszac5F/S69YO7xe6Bag==
X-Received: by 2002:a5d:6c63:: with SMTP id r3mr4274855wrz.213.1639468409828; 
 Mon, 13 Dec 2021 23:53:29 -0800 (PST)
Received: from [10.43.2.64] (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id z15sm12634056wrr.65.2021.12.13.23.53.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 13 Dec 2021 23:53:29 -0800 (PST)
Message-ID: <29409a18-5156-6b3a-6a44-eecd83a20a78@redhat.com>
Date: Tue, 14 Dec 2021 08:53:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Marc Zyngier <maz@kernel.org>,
 Peter Maydell <peter.maydell@linaro.org>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org> <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
From: =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mprivozn@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Tue, 14 Dec 2021 10:37:24 -0500
Cc: libvirt-users@redhat.com, qemu-arm@nongnu.org,
 kvmarm <kvmarm@lists.cs.columbia.edu>, qemu-discuss@nongnu.org
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

T24gMTIvMTQvMjEgMDE6NDEsIFF1IFdlbnJ1byB3cm90ZToKPiAKPiAKPiBPbiAyMDIxLzEyLzE0
IDAwOjQ5LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIE1vbiwgMTMgRGVjIDIwMjEgMTY6MDY6
MTQgKzAwMDAsCj4+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3Jv
dGU6Cj4+Pgo+Pj4gS1ZNIG9uIGJpZy5saXR0bGUgc2V0dXBzIGlzIGEga2VybmVsLWxldmVsIHF1
ZXN0aW9uIHJlYWxseTsgSSd2ZQo+Pj4gY2MnZCB0aGUga3ZtYXJtIGxpc3QuCj4+Cj4+IFRoYW5r
cyBQZXRlciBmb3IgdGhyb3dpbmcgdXMgdW5kZXIgdGhlIGJpZy1saXR0bGUgYnVzISA7LSkKPj4K
Pj4+Cj4+PiBPbiBNb24sIDEzIERlYyAyMDIxIGF0IDE1OjAyLCBRdSBXZW5ydW8gPHF1d2VucnVv
LmJ0cmZzQGdteC5jb20+IHdyb3RlOgo+Pj4+Cj4+Pj4KPj4+Pgo+Pj4+IE9uIDIwMjEvMTIvMTMg
MjE6MTcsIE1pY2hhbCBQcsOtdm96bsOtayB3cm90ZToKPj4+Pj4gT24gMTIvMTEvMjEgMDI6NTgs
IFF1IFdlbnJ1byB3cm90ZToKPj4+Pj4+IEhpLAo+Pj4+Pj4KPj4+Pj4+IFJlY2VudGx5IEkgZ290
IG15IGxpYnZpcnQgc2V0dXAgb24gYm90aCBSSzMzOTkgKFJvY2tQcm82NCkgYW5kIFJQSQo+Pj4+
Pj4gQ000LAo+Pj4+Pj4gd2l0aCB1cHN0cmVhbSBrZXJuZWxzLgo+Pj4+Pj4KPj4+Pj4+IEZvciBS
UEkgQ000IGl0cyBtb3N0bHkgc21vb3RoIHNhaWwsIGJ1dCBvbiBSSzMzOTkgZHVlIHRvIGl0cwo+
Pj4+Pj4gbGl0dGxlLkJJRwo+Pj4+Pj4gc2V0dXAgKGNvcmUgMC0zIGFyZSA0eCBBNTUgY29yZXMs
IGFuZCBjb3JlIDQtNSBhcmUgMnggQTcyIGNvcmVzKSwgaXQKPj4+Pj4+IGJyaW5ncyBxdWl0ZSBz
b21lIHRyb3VibGVzIGZvciBWTXMuCj4+Pj4+Pgo+Pj4+Pj4gSW4gc2hvcnQsIHdpdGhvdXQgcHJv
cGVyIGNwdXNldCB0byBiaW5kIHRoZSBWTSB0byBlaXRoZXIgYWxsIEE3Mgo+Pj4+Pj4gY29yZXMK
Pj4+Pj4+IG9yIGFsbCBBNTUgY29yZXMsIHRoZSBWTSB3aWxsIG1vc3RseSBmYWlsIHRvIGJvb3Qu
Cj4+Cj4+IHMvQTU1L0E1My8uIFRoZXJlIHdlcmUgdGhhbmtmdWxseSBubyBBNzIrQTU1IGV2ZXIg
cHJvZHVjZWQgKGp1c3QgdGhlCj4+IHRob3VnaCBvZiBpdCBtYWtlcyBtZSBzaWNrKS4KPj4KPj4+
Pj4+Cj4+Pj4+PiBDdXJyZW50bHkgdGhlIHdvcmtpbmcgeG1sIGlzOgo+Pj4+Pj4KPj4+Pj4+IMKg
wqDCoCA8dmNwdSBwbGFjZW1lbnQ9J3N0YXRpYycgY3B1c2V0PSc0LTUnPjI8L3ZjcHU+Cj4+Pj4+
PiDCoMKgwqAgPGNwdSBtb2RlPSdob3N0LXBhc3N0aHJvdWdoJyBjaGVjaz0nbm9uZScvPgo+Pj4+
Pj4KPj4+Pj4+IEJ1dCBldmVuIHdpdGggdmNwdXBpbiwgcGlubmluZyBlYWNoIHZjcHUgdG8gZWFj
aCBwaHlzaWNhbCBjb3JlLCBWTQo+Pj4+Pj4gd2lsbAo+Pj4+Pj4gbW9zdGx5IGZhaWwgdG8gc3Rh
cnQgdXAgZHVlIHRvIHZjcHUgaW5pdGlhbGl6YXRpb24gZmFpbGVkIHdpdGgKPj4+Pj4+IC1FSU5W
QUwuCj4+Cj4+IERpc2NsYWltZXI6IEkga25vdyBub3RoaW5nIGFib3V0IGxpYnZpcnQgKGFuZCBu
bywgSSBkb24ndCB3YW50IHRvCj4+IGtub3chIDstKS4KPj4KPj4gSG93ZXZlciwgZm9yIHRoaW5n
cyB0byBiZSByZWxpYWJsZSwgeW91IG5lZWQgdG8gdGFza3NldCB0aGUgd2hvbGUgUUVNVQo+PiBw
cm9jZXNzIHRvIHRoZSBDUFUgdHlwZSB5b3UgaW50ZW5kIHRvIHVzZS4KPiAKPiBZZXAsIHRoYXQn
cyB3aGF0IEknbSBkb2luZy4KPiAKPj4gVGhhdCdzIGJlY2F1c2UsIEFGQUlDVCwKPj4gUUVNVSB3
aWxsIHNuYXBzaG90IHRoZSBzeXN0ZW0gcmVnaXN0ZXJzIG91dHNpZGUgb2YgdGhlIHZjcHUgdGhy
ZWFkcywKPj4gYW5kIGF0dGVtcHQgdG8gdXNlIHRoZSByZXN1bHQgdG8gY29uZmlndXJlIHRoZSBh
Y3R1YWwgdmNwdSB0aHJlYWRzLiBJZgo+PiB0aGV5IGhhcHBlbiB0byBydW4gb24gZGlmZmVyZW50
IENQVSB0eXBlcywgdGhlIHN5c3JlZ3Mgd2lsbCBkaWZmZXIgaW4KPj4gaW5jb21wYXRpYmxlIHdh
eXMgYW5kIGFuIGVycm9yIHdpbGwgYmUgcmV0dXJuZWQuIFRoaXMgbWF5IG9yIG1heSBub3QKPj4g
YmUgYSBidWcsIEkgZG9uJ3Qga25vdyAoSSBzZWUgaXQgYXMgYSBmZWF0dXJlKS4KPiAKPiBUaGVu
IHRoaXMgYnJpbmdzIGFub3RoZXIgcXVlc3Rpb24uCj4gCj4gSWYgd2UgY2FuIHBpbiBlYWNoIHZD
UFUgdG8gZWFjaCBwaHlzaWNhbCBjb3JlIChib3RoIGxpdHRsZSBhbmQgYmlnKSwKPiB0aGVuIGFz
IGxvbmcgYXMgdGhlIHJlZ2lzdGVycyBhcmUgcGVyLXZDUFUgYmFzZWQsIGl0IHNob3VsZCBiZSBh
YmxlIHRvCj4gcGFzcyBib3RoIGJpZyBhbmQgbGl0dGxlIGNvcmVzIHRvIHRoZSBWTS4KPiAKPiBZ
ZWFoLCBJIHRvdGFsbHkgdW5kZXJzdGFuZCB0aGlzIHNjcmV3IHVwIHRoZSBzY2hlZHVsaW5nLCBi
dXQgdGhhdCdzIGF0Cj4gbGVhc3Qgd2hhdCAoc29tZSBpbnNhbmUpIHVzZXJzIHdhbnQgKGp1c3Qg
bGlrZSBtZSkuCj4gCj4+Cj4+IElmIHlvdSBhcmUgYW5ub3llZCB3aXRoIHRoaXMgYmVoYXZpb3Vy
LCB5b3UgY2FuIGFsd2F5cyB1c2UgYSBkaWZmZXJlbnQKPj4gVk1NIHRoYXQgd29uJ3QgY2FyZSBh
Ym91dCBzdWNoIGRpZmZlcmVuY2UgKGNyb3N2bSBvciBrdm10b29sLCB0byBuYW1lCj4+IGEgZmV3
KS4KPiAKPiBTb3VuZHMgcHJldHR5IGludGVyZXN0aW5nLCBhIG5ldyB3b3JsZCBidXQgd2l0aG91
dCBsaWJ2aXJ0Li4uCj4gCj4+IEhvd2V2ZXIsIHRoZSBndWVzdCB3aWxsIGJlIGFibGUgdG8gb2Jz
ZXJ2ZSB0aGUgbWlncmF0aW9uIGZyb20KPj4gb25lIGNwdSB0eXBlIHRvIGFub3RoZXIuIFRoaXMg
bWF5IG9yIG1heSBub3QgYWZmZWN0IHlvdXIgZ3Vlc3Qncwo+PiBiZWhhdmlvdXIuCj4gCj4gTm90
IHN1cmUgaWYgaXQncyBwb3NzaWJsZSB0byBwaW4gZWFjaCB2Q1BVIHRocmVhZCB0byBlYWNoIGNv
cmUsIGJ1dCBsZXQKPiBtZSB0cnkuCj4gCgpTdXJlIGl0IGlzLCBmb3IgaW5zdGFuY2U6Cgo8Y3B1
dHVuZT4KICAgIDx2Y3B1cGluIHZjcHU9IjAiIGNwdXNldD0iMS00LF4yIi8+CiAgICA8dmNwdXBp
biB2Y3B1PSIxIiBjcHVzZXQ9IjAsMSIvPgogICAgPHZjcHVwaW4gdmNwdT0iMiIgY3B1c2V0PSIy
LDMiLz4KICAgIDx2Y3B1cGluIHZjcHU9IjMiIGNwdXNldD0iMCw0Ii8+CiAgICA8ZW11bGF0b3Jw
aW4gY3B1c2V0PSIxLTMiLz4KICAgIDxpb3RocmVhZHBpbiBpb3RocmVhZD0iMSIgY3B1c2V0PSI1
LDYiLz4KICAgIDxpb3RocmVhZHBpbiBpb3RocmVhZD0iMiIgY3B1c2V0PSI3LDgiLz4KPC9jcHV0
dW5lPgoKcGlucyB2Q1BVIzAgb250byBob3N0IENQVXMgMS00LCBleGNsdWRpbmcgMjsgdkNQVSMx
IG9udG8gaG9zdCBDUFVzIDAtMQphbmQgc28gb24uIFlvdSBjYW4gYWxzbyBwaW4gZW11bGF0b3Ig
KFFFTVUpIGFuZCBpdHMgaW90aHJlYWRzLiBJdCdzCmRvY3VtZW50ZWQgaGVyZToKCmh0dHBzOi8v
bGlidmlydC5vcmcvZm9ybWF0ZG9tYWluLmh0bWwjY3B1LXR1bmluZwoKTWljaGFsCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
