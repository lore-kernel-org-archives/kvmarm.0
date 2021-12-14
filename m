Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96094C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 15:37:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43C224B229;
	Tue, 14 Dec 2021 10:37:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KxXkNaRznDr4; Tue, 14 Dec 2021 10:37:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 624244B212;
	Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3A74B0F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:58:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9jUG-jdCvlsz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 02:58:20 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 670724B0DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:58:20 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639468700;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tkEptgESprKMD9zOqtebbAr6XmQkSHwUeHWVtJ98Yr0=;
 b=VyUQa/XL47nkT8vhNDsFNvzFwXzyAuY7Ep/mS7W0zbEDjqKhLJNpsJpcvy+HJW3D9nAl08
 4qVP1DWDkbJRY96Pp9Mo+RAsXyUtRNy6JJoB8Wz/PMDdFKmPKFLprZmKKnK/6P8NaNuUOj
 NGRXAWVnckxFKP7fQWzxfffHUHUo75Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-S8ledeDzMDidfntX7VEUeg-1; Tue, 14 Dec 2021 02:58:19 -0500
X-MC-Unique: S8ledeDzMDidfntX7VEUeg-1
Received: by mail-wm1-f71.google.com with SMTP id
 a85-20020a1c7f58000000b0033ddc0eacc8so12808314wmd.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 23:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=tkEptgESprKMD9zOqtebbAr6XmQkSHwUeHWVtJ98Yr0=;
 b=mS7zAFTnWVcp40DpHQz4oSMMXEb9gOw8ClTIpvE1uyThvOi5vbxuKDHzuhPUdgqddV
 TcNk+S1xFtH3ppsScVNo/UC6at53eONLrAR3Udo+NDRLvJR9pYcdBd49Tb6rDjOyDBm0
 YAOrivGfrqceONVyrCxliOVcmxxmT7kuyPuXvlzGYgLLvje4sDBa7knRG/k2UOnoib6U
 fKjiQh/OZMkkIjinamJQONknnlCnjfXbC0DyNXhZ9NJknEH1QyoG6d79ASkD/q+eOTde
 NcpE129rBB02ehxv3kwVLQ7hfCvTIOBfnZc2qXdDKDBelraVT/RJ3jbf+i/Ii3ORZaSk
 GVuA==
X-Gm-Message-State: AOAM5325xrOPG9fdBxa+dgLpkwQk/t6fHi9633Ce6eN3EN9nAdFTRVxW
 fmq6nox5wK1MH5OpTDcZniHVQGKz+pD37qXDxaWUBXkLOwoHzO2ZDo+L+jqyR4P1rIlQY3Yp939
 8qgSWKw6mo9WShgFApUlufnvw
X-Received: by 2002:a05:600c:1d91:: with SMTP id
 p17mr5149508wms.193.1639468698054; 
 Mon, 13 Dec 2021 23:58:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaKP+JUP0Y8n8LpMnKS6OvfZRLuJpD+JpcyElimgWqZR6s5CAbLNM3hhVR3q714t4yrp9XHA==
X-Received: by 2002:a05:600c:1d91:: with SMTP id
 p17mr5149468wms.193.1639468697807; 
 Mon, 13 Dec 2021 23:58:17 -0800 (PST)
Received: from [10.43.2.64] (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id k1sm1355118wms.26.2021.12.13.23.58.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 13 Dec 2021 23:58:17 -0800 (PST)
Message-ID: <f7b2dcdc-505c-e713-14f0-8c85e6014e8b@redhat.com>
Date: Tue, 14 Dec 2021 08:58:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
To: Marc Zyngier <maz@kernel.org>, Peter Maydell <peter.maydell@linaro.org>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org>
From: =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <87lf0ojvq2.wl-maz@kernel.org>
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

T24gMTIvMTMvMjEgMTc6NDksIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiBNb24sIDEzIERlYyAy
MDIxIDE2OjA2OjE0ICswMDAwLAo+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4+Cj4+IEtWTSBvbiBiaWcubGl0dGxlIHNldHVwcyBpcyBhIGtlcm5lbC1s
ZXZlbCBxdWVzdGlvbiByZWFsbHk7IEkndmUKPj4gY2MnZCB0aGUga3ZtYXJtIGxpc3QuCj4gCj4g
VGhhbmtzIFBldGVyIGZvciB0aHJvd2luZyB1cyB1bmRlciB0aGUgYmlnLWxpdHRsZSBidXMhIDst
KQo+IAo+Pgo+PiBPbiBNb24sIDEzIERlYyAyMDIxIGF0IDE1OjAyLCBRdSBXZW5ydW8gPHF1d2Vu
cnVvLmJ0cmZzQGdteC5jb20+IHdyb3RlOgo+Pj4KPj4+Cj4+Pgo+Pj4gT24gMjAyMS8xMi8xMyAy
MToxNywgTWljaGFsIFByw612b3puw61rIHdyb3RlOgo+Pj4+IE9uIDEyLzExLzIxIDAyOjU4LCBR
dSBXZW5ydW8gd3JvdGU6Cj4+Pj4+IEhpLAo+Pj4+Pgo+Pj4+PiBSZWNlbnRseSBJIGdvdCBteSBs
aWJ2aXJ0IHNldHVwIG9uIGJvdGggUkszMzk5IChSb2NrUHJvNjQpIGFuZCBSUEkgQ000LAo+Pj4+
PiB3aXRoIHVwc3RyZWFtIGtlcm5lbHMuCj4+Pj4+Cj4+Pj4+IEZvciBSUEkgQ000IGl0cyBtb3N0
bHkgc21vb3RoIHNhaWwsIGJ1dCBvbiBSSzMzOTkgZHVlIHRvIGl0cyBsaXR0bGUuQklHCj4+Pj4+
IHNldHVwIChjb3JlIDAtMyBhcmUgNHggQTU1IGNvcmVzLCBhbmQgY29yZSA0LTUgYXJlIDJ4IEE3
MiBjb3JlcyksIGl0Cj4+Pj4+IGJyaW5ncyBxdWl0ZSBzb21lIHRyb3VibGVzIGZvciBWTXMuCj4+
Pj4+Cj4+Pj4+IEluIHNob3J0LCB3aXRob3V0IHByb3BlciBjcHVzZXQgdG8gYmluZCB0aGUgVk0g
dG8gZWl0aGVyIGFsbCBBNzIgY29yZXMKPj4+Pj4gb3IgYWxsIEE1NSBjb3JlcywgdGhlIFZNIHdp
bGwgbW9zdGx5IGZhaWwgdG8gYm9vdC4KPiAKPiBzL0E1NS9BNTMvLiBUaGVyZSB3ZXJlIHRoYW5r
ZnVsbHkgbm8gQTcyK0E1NSBldmVyIHByb2R1Y2VkIChqdXN0IHRoZQo+IHRob3VnaCBvZiBpdCBt
YWtlcyBtZSBzaWNrKS4KPiAKPj4+Pj4KPj4+Pj4gQ3VycmVudGx5IHRoZSB3b3JraW5nIHhtbCBp
czoKPj4+Pj4KPj4+Pj4gICAgPHZjcHUgcGxhY2VtZW50PSdzdGF0aWMnIGNwdXNldD0nNC01Jz4y
PC92Y3B1Pgo+Pj4+PiAgICA8Y3B1IG1vZGU9J2hvc3QtcGFzc3Rocm91Z2gnIGNoZWNrPSdub25l
Jy8+Cj4+Pj4+Cj4+Pj4+IEJ1dCBldmVuIHdpdGggdmNwdXBpbiwgcGlubmluZyBlYWNoIHZjcHUg
dG8gZWFjaCBwaHlzaWNhbCBjb3JlLCBWTSB3aWxsCj4+Pj4+IG1vc3RseSBmYWlsIHRvIHN0YXJ0
IHVwIGR1ZSB0byB2Y3B1IGluaXRpYWxpemF0aW9uIGZhaWxlZCB3aXRoIC1FSU5WQUwuCj4gCj4g
RGlzY2xhaW1lcjogSSBrbm93IG5vdGhpbmcgYWJvdXQgbGlidmlydCAoYW5kIG5vLCBJIGRvbid0
IHdhbnQgdG8KPiBrbm93ISA7LSkuCj4gCj4gSG93ZXZlciwgZm9yIHRoaW5ncyB0byBiZSByZWxp
YWJsZSwgeW91IG5lZWQgdG8gdGFza3NldCB0aGUgd2hvbGUgUUVNVQo+IHByb2Nlc3MgdG8gdGhl
IENQVSB0eXBlIHlvdSBpbnRlbmQgdG8gdXNlLiBUaGF0J3MgYmVjYXVzZSwgQUZBSUNULAo+IFFF
TVUgd2lsbCBzbmFwc2hvdCB0aGUgc3lzdGVtIHJlZ2lzdGVycyBvdXRzaWRlIG9mIHRoZSB2Y3B1
IHRocmVhZHMsCj4gYW5kIGF0dGVtcHQgdG8gdXNlIHRoZSByZXN1bHQgdG8gY29uZmlndXJlIHRo
ZSBhY3R1YWwgdmNwdSB0aHJlYWRzLiBJZgo+IHRoZXkgaGFwcGVuIHRvIHJ1biBvbiBkaWZmZXJl
bnQgQ1BVIHR5cGVzLCB0aGUgc3lzcmVncyB3aWxsIGRpZmZlciBpbgo+IGluY29tcGF0aWJsZSB3
YXlzIGFuZCBhbiBlcnJvciB3aWxsIGJlIHJldHVybmVkLiBUaGlzIG1heSBvciBtYXkgbm90Cj4g
YmUgYSBidWcsIEkgZG9uJ3Qga25vdyAoSSBzZWUgaXQgYXMgYSBmZWF0dXJlKS4KPiAKCk9oLCBJ
IGhhZCBubyBpZGVhIHRoYXQgUUVNVSBkb2VzIHRoaXMuIEFueXdheSwgUUVNVSBzcGF3bnMgYSB0
aHJlYWQgZm9yCmVhY2ggdkNQVSB3aGljaCBpcyBwZXJmZWN0LCBiZWNhdXNlIHRoZW4gbGlidmly
dCBjYW4gdXNlIENHcm91cHMgdG8KcmVzdHJpY3QgZWFjaCB2Q1BVIGluZGl2aWR1YWxseSBvbnRv
IGEgc3Vic2V0IG9mIHBoeXNpY2FsIENQVShzKS4gQW5kIGluCmZhY3QsIGxpYnZpcnQgaGFzIHRo
aXMgZmVhdHVyZSBmb3IgbWFueSB5ZWFycy4gSSBhbHdheXMgdmlld2VkIGl0IGFzIGEKcGVyZm9y
bWFuY2UgdHVuaW5nLCBidXQgVElMLgoKTWljaGFsCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
