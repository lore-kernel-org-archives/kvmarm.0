Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE77C433FE
	for <kvmarm@archiver.kernel.org>; Sun, 19 Dec 2021 12:12:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD2A4B2C8;
	Sun, 19 Dec 2021 07:12:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cXia2hsHP4v6; Sun, 19 Dec 2021 07:12:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6821A4B2E7;
	Sun, 19 Dec 2021 07:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E25514B31A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 09:15:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7HYouwW+qMb0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 09:15:33 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF9C04B31D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 09:15:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639750532;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8ohkHIXbcCmEoZRJLeZUjZIF9jP1Brmddy61OPwOb80=;
 b=Ug2xhOJn4AQZV3QGeubq7X5HmDWTb7nWntIeW+IHIU4R3DCxdAXmYO4YYQspWgocMtJygw
 kt/htu49O6vK8VC2XKACD0/np+HA12FEQ5Ew86LJXjCvkVPU7rNnAnDLEzINg0v2NmENjO
 gFXXMQ9Bqo5gCVypmzMusLqh/fgjPO0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-gW8-27PfP8SGOjF1v4qm3g-1; Fri, 17 Dec 2021 09:15:31 -0500
X-MC-Unique: gW8-27PfP8SGOjF1v4qm3g-1
Received: by mail-wm1-f69.google.com with SMTP id
 n41-20020a05600c502900b003335ab97f41so1109117wmr.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 06:15:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=8ohkHIXbcCmEoZRJLeZUjZIF9jP1Brmddy61OPwOb80=;
 b=Ou2c6frHPTHiFcc06Z90RuYExVxBCqvEvjEbMQBF/ICjLYaHZdcVxhZhWA4X3JkEPd
 STjh+Y8tbciaEZgF/oEVf7RlHANzu6KanXqmU99Jrj8+ZuIfENHmvG8JeY79714tRy3v
 kmkv2TQd1DOZaHCTPVDdYoI+fqBSS7kM5rSLfdF9m9lCMK6blMbwvb0tsSuQNBGUrgPk
 UhqiF9hAprp0hS8fSQf6o9n2qoZjncbxBFB3leGp1Q7wod+SZUXAm73eFBhfm+ac7DKN
 rWXUT+cG4Lj5YkR9SQGCgYrMO05PrapYNzUPS5ElJ7oTI16/C1ZMPn1xfl7HmNsDQ0Zr
 TFvg==
X-Gm-Message-State: AOAM533iZVXu89Uc8gGERWj/+cQ93pS/JBIxCFvYGJeNJU2tZxTe4Rdk
 pNlUVq/O7jwBq4oo/ay089utbrdPO8YsjkuJN6E2Hebd5Jwf0TkSA/NK31/QQAVR9HEduNp4OJy
 vtIAxEh6MjxfPjcYLAXTkoHhL
X-Received: by 2002:a5d:6d41:: with SMTP id k1mr2755370wri.134.1639750530463; 
 Fri, 17 Dec 2021 06:15:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+5OK+wHJ+oNtmr4sqDbaf0TDCwcL3mgQ2Qu1ZhPUKAGIgzAQyZaO0vxFPOl7tahX2YBbx5w==
X-Received: by 2002:a5d:6d41:: with SMTP id k1mr2755351wri.134.1639750530277; 
 Fri, 17 Dec 2021 06:15:30 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:3511:9200:f938:102b:34c2:d5db?
 ([2a0c:5a80:3511:9200:f938:102b:34c2:d5db])
 by smtp.gmail.com with ESMTPSA id m20sm11441371wmq.11.2021.12.17.06.15.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Dec 2021 06:15:30 -0800 (PST)
Message-ID: <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Date: Fri, 17 Dec 2021 15:15:29 +0100
In-Reply-To: <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Sun, 19 Dec 2021 07:12:12 -0500
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
 rcu <rcu@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

T24gRnJpLCAyMDIxLTEyLTE3IGF0IDEzOjIxICswMDAwLCBNYXJrIFJ1dGxhbmQgd3JvdGU6Cj4g
T24gRnJpLCBEZWMgMTcsIDIwMjEgYXQgMTI6NTE6NTdQTSArMDEwMCwgTmljb2xhcyBTYWVueiBK
dWxpZW5uZSB3cm90ZToKPiA+IEhpIEFsbCwKPiAKPiBIaSwKPiAKPiA+IGFybTY0J3MgZ3Vlc3Qg
ZW50cnkgY29kZSBkb2VzIHRoZSBmb2xsb3dpbmc6Cj4gPiAKPiA+IGludCBrdm1fYXJjaF92Y3B1
X2lvY3RsX3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4gPiB7Cj4gPiAJWy4uLl0KPiA+IAo+
ID4gCWd1ZXN0X2VudGVyX2lycW9mZigpOwo+ID4gCj4gPiAJcmV0ID0ga3ZtX2NhbGxfaHlwX3Jl
dChfX2t2bV92Y3B1X3J1biwgdmNwdSk7Cj4gPiAKPiA+IAlbLi4uXQo+ID4gCj4gPiAJbG9jYWxf
aXJxX2VuYWJsZSgpOwo+ID4gCj4gPiAJLyoKPiA+IAkgKiBXZSBkbyBsb2NhbF9pcnFfZW5hYmxl
KCkgYmVmb3JlIGNhbGxpbmcgZ3Vlc3RfZXhpdCgpIHNvCj4gPiAJICogdGhhdCBpZiBhIHRpbWVy
IGludGVycnVwdCBoaXRzIHdoaWxlIHJ1bm5pbmcgdGhlIGd1ZXN0IHdlCj4gPiAJICogYWNjb3Vu
dCB0aGF0IHRpY2sgYXMgYmVpbmcgc3BlbnQgaW4gdGhlIGd1ZXN0LiAgV2UgZW5hYmxlCj4gPiAJ
ICogcHJlZW1wdGlvbiBhZnRlciBjYWxsaW5nIGd1ZXN0X2V4aXQoKSBzbyB0aGF0IGlmIHdlIGdl
dAo+ID4gCSAqIHByZWVtcHRlZCB3ZSBtYWtlIHN1cmUgdGlja3MgYWZ0ZXIgdGhhdCBpcyBub3Qg
Y291bnRlZCBhcwo+ID4gCSAqIGd1ZXN0IHRpbWUuCj4gPiAJICovCj4gPiAJZ3Vlc3RfZXhpdCgp
Owo+ID4gCVsuLi5dCj4gPiB9Cj4gPiAKPiA+IAo+ID4gT24gYSBub2h6LWZ1bGwgQ1BVLCBndWVz
dF97ZW50ZXIsZXhpdH0oKSBkZWxpbWl0IGFuIFJDVSBleHRlbmRlZCBxdWllc2NlbnQKPiA+IHN0
YXRlIChFUVMpLiBBbnkgaW50ZXJydXB0IGhhcHBlbmluZyBiZXR3ZWVuIGxvY2FsX2lycV9lbmFi
bGUoKSBhbmQKPiA+IGd1ZXN0X2V4aXQoKSBzaG91bGQgZGlzYWJsZSB0aGF0IEVRUy4gTm93LCBB
RkFJQ1QgYWxsIGVsMCBpbnRlcnJ1cHQgaGFuZGxlcnMKPiA+IGRvIHRoZSByaWdodCB0aGluZyBp
ZiB0cmdnZXJlZCBpbiB0aGlzIGNvbnRleHQsIGJ1dCBlbDEncyB3b24ndC4gSXMgaXQKPiA+IHBv
c3NpYmxlIHRvIGhpdCBhbiBlbDEgaGFuZGxlciAoZm9yIGV4YW1wbGUgX19lbDFfaXJxKCkpIHRo
ZXJlPwo+IAo+IEkgdGhpbmsgeW91J3JlIHJpZ2h0IHRoYXQgdGhlIEVMMSBoYW5kbGVycyBjYW4g
dHJpZ2dlciBoZXJlIGFuZCB3b24ndCBleGl0IHRoZQo+IEVRUy4KPiAKPiBJJ20gbm90IGltbWVk
aWF0ZWx5IHN1cmUgd2hhdCB3ZSAqc2hvdWxkKiBkbyBoZXJlLiBXaGF0IGRvZXMgeDg2IGRvIGZv
ciBhbiBJUlEKPiB0YWtlbiBmcm9tIGEgZ3Vlc3QgbW9kZT8gSSBjb3VsZG4ndCBzcG90IGFueSBo
YW5kbGluZyBvZiB0aGF0IGNhc2UsIGJ1dCBJJ20gbm90Cj4gZmFtaWxpYXIgZW5vdWdoIHdpdGgg
dGhlIHg4NiBleGNlcHRpb24gbW9kZWwgdG8ga25vdyBpZiBJJ20gbG9va2luZyBpbiB0aGUKPiBy
aWdodCBwbGFjZS4KCldlbGwgeDg2IGhhcyBpdHMgb3duIHByaXZhdGUgS1ZNIGd1ZXN0IGNvbnRl
eHQgZXhpdCBmdW5jdGlvbgona3ZtX2d1ZXN0X2V4aXRfaXJxb2ZmKCknLCB3aGljaCBhbGxvd3Mg
aXQgdG8gZG8gdGhlIHJpZ2h0IHRoaW5nIChzaW1wbGlmeWluZwp0aGluZ3MpOgoKCWxvY2FsX2ly
cV9kaXNhYmxlKCk7Cglrdm1fZ3Vlc3RfZW50ZXJfaXJxb2ZmKCkgLy8gSW5mb3JtIENULCBlbnRl
ciBFUVMKCV9fdm14X2t2bV9ydW4oKQoJa3ZtX2d1ZXN0X2V4aXRfaXJxb2ZmKCkgLy8gSW5mb3Jt
IENULCBleGl0IEVRUywgdGFzayBzdGlsbCBtYXJrZWQgd2l0aCBQRl9WQ1BVCgoJLyoKCSAqIENv
bnN1bWUgYW55IHBlbmRpbmcgaW50ZXJydXB0cywgaW5jbHVkaW5nIHRoZSBwb3NzaWJsZSBzb3Vy
Y2Ugb2YKCSAqIFZNLUV4aXQgb24gU1ZNIGFuZCBhbnkgdGlja3MgdGhhdCBvY2N1ciBiZXR3ZWVu
IFZNLUV4aXQgYW5kIG5vdy4KCSAqIEFuIGluc3RydWN0aW9uIGlzIHJlcXVpcmVkIGFmdGVyIGxv
Y2FsX2lycV9lbmFibGUoKSB0byBmdWxseSB1bmJsb2NrCgkgKiBpbnRlcnJ1cHRzIG9uIHByb2Nl
c3NvcnMgdGhhdCBpbXBsZW1lbnQgYW4gaW50ZXJydXB0IHNoYWRvdywgdGhlCgkgKiBzdGF0LmV4
aXRzIGluY3JlbWVudCB3aWxsIGRvIG5pY2VseS4KCSAqLwoJbG9jYWxfaXJxX2VuYWJsZSgpOwoJ
Kyt2Y3B1LT5zdGF0LmV4aXRzOwoJbG9jYWxfaXJxX2Rpc2FibGUoKTsKCgkvKgoJICogV2FpdCB1
bnRpbCBhZnRlciBzZXJ2aWNpbmcgSVJRcyB0byBhY2NvdW50IGd1ZXN0IHRpbWUgc28gdGhhdCBh
bnkKCSAqIHRpY2tzIHRoYXQgb2NjdXJyZWQgd2hpbGUgcnVubmluZyB0aGUgZ3Vlc3QgYXJlIHBy
b3Blcmx5IGFjY291bnRlZAoJICogdG8gdGhlIGd1ZXN0LiAgV2FpdGluZyB1bnRpbCBJUlFzIGFy
ZSBlbmFibGVkIGRlZ3JhZGVzIHRoZSBhY2N1cmFjeQoJICogb2YgYWNjb3VudGluZyB2aWEgY29u
dGV4dCB0cmFja2luZywgYnV0IHRoZSBsb3NzIG9mIGFjY3VyYWN5IGlzCgkgKiBhY2NlcHRhYmxl
IGZvciBhbGwga25vd24gdXNlIGNhc2VzLgoJICovCgl2dGltZV9hY2NvdW50X2d1ZXN0X2V4aXQo
KTsgLy8gY3VycmVudC0+ZmxhZ3MgJj0gflBGX1ZDUFUKClNvIEkgZ3Vlc3Mgd2Ugc2hvdWxkIGNv
bnZlcnQgdG8geDg2J3Mgc2NoZW1lLCBhbmQgbWF5YmUgY3JlYXRlIGFub3RoZXIgZ2VuZXJpYwpn
dWVzdF97ZW50ZXIsZXhpdH0oKSBmbGF2b3IgZm9yIHZpcnR1YWxpemF0aW9uIHNjaGVtZXMgdGhh
dCBydW4gd2l0aCBpbnRlcnJ1cHRzCmRpc2FibGVkLgoKPiBOb3RlIHRoYXQgdGhlIEVMMCBoYW5k
bGVycyAqY2Fubm90KiB0cmlnZ2VyIGZvciBhbiBleGNlcHRpb24gdGFrZW4gZnJvbSBhCj4gZ3Vl
c3QuIFdlIHVzZSBzZXBhcmF0ZSB2ZWN0b3JzIHdoaWxlIHJ1bm5pbmcgYSBndWVzdCAoZm9yIGJv
dGggVkhFIGFuZCBuVkhFCj4gbW9kZXMpLCBhbmQgZnJvbSB0aGUgbWFpbiBrZXJuZWwncyBQb1Yg
d2UgcmV0dXJuIGZyb20ga3ZtX2NhbGxfaHlwX3JldCgpLiBXZQo+IGNhbiBvbnkgdGFrZSBJUlEg
ZnJvbSBFTDEgKmFmdGVyKiB0aGF0IHJldHVybnMuCj4gCj4gV2UgKm1pZ2h0KiBuZWVkIHRvIGF1
ZGl0IHRoZSBLVk0gdmVjdG9yIGhhbmRsZXJzIHRvIG1ha2Ugc3VyZSB0aGV5J3JlIG5vdAo+IGRl
cGVuZGVudCBvbiBSQ1UgcHJvdGVjdGlvbiAoSSBhc3N1bWUgdGhleSdyZSBub3QsIGJ1dCBpdCdz
IHBvc3NpYmxlIHNvbWV0aGluZwo+IGhhcyBsZWFrZWQgaW50byB0aGUgVkhFIGNvZGUpLgoKSUlV
QyBpbiB0aGUgd2luZG93IGJldHdlZW4gbG9jYWxfaXJxX2VuYWJsZSgpIGFuZCBndWVzdF9leGl0
KCkgYW55IGRyaXZlcgppbnRlcnJ1cHQgbWlnaHQgdHJpZ2dlciwgaXNuJ3QgaXQ/CgpSZWdhcmRz
LAoKLS0gCk5pY29sw6FzIFPDoWVuegoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
