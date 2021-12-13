Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57509C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 16:06:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C9C64B10B;
	Mon, 13 Dec 2021 11:06:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5lIyGRGgaH2y; Mon, 13 Dec 2021 11:06:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB6D4B105;
	Mon, 13 Dec 2021 11:06:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A374B105
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 11:06:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vrZHws3Qt4md for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 11:06:26 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3538A4B102
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 11:06:26 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id
 j140-20020a1c2392000000b003399ae48f58so14371977wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 08:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=v+DyQHPEiFhyER7h0hPB0no5B8xZTcLCN9irrfJc7Pw=;
 b=RBHget5STrVdgQtTnwf18whbtTUtscj5OrlvqvnY8w28fTOEstMG+1baR8sD/Aw+t+
 OwVSsUfJn+3th80JeHq37NpVd0clpN/8ANk9hkLBJlgECSZ2XawVGwRYq5rg8efYbhSd
 iJgB939Yfvo55zZUE5VxfatmG7tDtPY8izxEbMKyuC5af7RFIFDJgAlWLr6S+EKROm/c
 IJSMgQKopPEtZQn4cOZ6wFzfZZBzK4tvZpbkR1Zp+YIEoRkgNylUhByeLWdwCVpJbWNu
 9RDQMygtrWM2RNtl1amfeyQIF4AyXX9KiUNKNelYdUnztHmgsnO0UoDziaoMI4vScxek
 U+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=v+DyQHPEiFhyER7h0hPB0no5B8xZTcLCN9irrfJc7Pw=;
 b=7y7e4jStHCrAQLZ4HU2eVPxGFZy1GpI0UEfJKWdcKGPS/mQHTSGWKNXnlH/tn9/ekg
 AK6aZ8q+olYy9uWzdaQFjajhwqJyQ+LnAVdPO2ns29C6N6Lhz06oKak2AjfKKMxLDIAy
 cZUe2tnI6qlPrkdE8CZN0k9xCxZ9tJbp5lb6HaeQ1ObN7V8Qh3sN1TXFOK0jKB6IPX/N
 loFnkzP7j6Fi5878oqv+3bAKZxxF3hsUOjxBRn7VQMzpfP+9uAJdwcUXQOMXf02ZxNVW
 bBE4DO77usSZ4rXNEsktf4H896eJn2AooHazR+tRxJ7DJ3pff6hoEUAYATpe27N1Vu7S
 BQGA==
X-Gm-Message-State: AOAM5334WibH2oPdL0sT1rSYk7Rz1JtVuIJBa7q1rXEl2AbzqmHs7boY
 n8a+OIStCH/kC0G2EOtZc1964Cv7hxseX86TX7Zjzw==
X-Google-Smtp-Source: ABdhPJwa7EE761jbmcQ9Tasl3M5SlfV3h3lYA7AL9p9RcR0IieMlGEO0nUL5uDW3w2B0i5YUCv8caTev5BECR8jYK0s=
X-Received: by 2002:a1c:7f43:: with SMTP id a64mr38993337wmd.133.1639411585144; 
 Mon, 13 Dec 2021 08:06:25 -0800 (PST)
MIME-Version: 1.0
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
In-Reply-To: <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 13 Dec 2021 16:06:14 +0000
Message-ID: <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: libvirt-users@redhat.com,
 =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
 qemu-arm@nongnu.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
 qemu-discuss@nongnu.org
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

S1ZNIG9uIGJpZy5saXR0bGUgc2V0dXBzIGlzIGEga2VybmVsLWxldmVsIHF1ZXN0aW9uIHJlYWxs
eTsgSSd2ZQpjYydkIHRoZSBrdm1hcm0gbGlzdC4KCk9uIE1vbiwgMTMgRGVjIDIwMjEgYXQgMTU6
MDIsIFF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT4gd3JvdGU6Cj4KPgo+Cj4gT24g
MjAyMS8xMi8xMyAyMToxNywgTWljaGFsIFByw612b3puw61rIHdyb3RlOgo+ID4gT24gMTIvMTEv
MjEgMDI6NTgsIFF1IFdlbnJ1byB3cm90ZToKPiA+PiBIaSwKPiA+Pgo+ID4+IFJlY2VudGx5IEkg
Z290IG15IGxpYnZpcnQgc2V0dXAgb24gYm90aCBSSzMzOTkgKFJvY2tQcm82NCkgYW5kIFJQSSBD
TTQsCj4gPj4gd2l0aCB1cHN0cmVhbSBrZXJuZWxzLgo+ID4+Cj4gPj4gRm9yIFJQSSBDTTQgaXRz
IG1vc3RseSBzbW9vdGggc2FpbCwgYnV0IG9uIFJLMzM5OSBkdWUgdG8gaXRzIGxpdHRsZS5CSUcK
PiA+PiBzZXR1cCAoY29yZSAwLTMgYXJlIDR4IEE1NSBjb3JlcywgYW5kIGNvcmUgNC01IGFyZSAy
eCBBNzIgY29yZXMpLCBpdAo+ID4+IGJyaW5ncyBxdWl0ZSBzb21lIHRyb3VibGVzIGZvciBWTXMu
Cj4gPj4KPiA+PiBJbiBzaG9ydCwgd2l0aG91dCBwcm9wZXIgY3B1c2V0IHRvIGJpbmQgdGhlIFZN
IHRvIGVpdGhlciBhbGwgQTcyIGNvcmVzCj4gPj4gb3IgYWxsIEE1NSBjb3JlcywgdGhlIFZNIHdp
bGwgbW9zdGx5IGZhaWwgdG8gYm9vdC4KPiA+Pgo+ID4+IEN1cnJlbnRseSB0aGUgd29ya2luZyB4
bWwgaXM6Cj4gPj4KPiA+PiAgICA8dmNwdSBwbGFjZW1lbnQ9J3N0YXRpYycgY3B1c2V0PSc0LTUn
PjI8L3ZjcHU+Cj4gPj4gICAgPGNwdSBtb2RlPSdob3N0LXBhc3N0aHJvdWdoJyBjaGVjaz0nbm9u
ZScvPgo+ID4+Cj4gPj4gQnV0IGV2ZW4gd2l0aCB2Y3B1cGluLCBwaW5uaW5nIGVhY2ggdmNwdSB0
byBlYWNoIHBoeXNpY2FsIGNvcmUsIFZNIHdpbGwKPiA+PiBtb3N0bHkgZmFpbCB0byBzdGFydCB1
cCBkdWUgdG8gdmNwdSBpbml0aWFsaXphdGlvbiBmYWlsZWQgd2l0aCAtRUlOVkFMLgo+ID4+Cj4g
Pj4KPiA+PiBUaGlzIGJyaW5ncyBhIHByb2JsZW0sIGluIHRoZW9yeSBSSzMzOTkgU29DIHNob3Vs
ZCBvdXQtcGVyZm9ybSBCQ00yNzExCj4gPj4gaW4gbXVsdGktY29yZSBwZXJmb3JtYW5jZSwgYnV0
IGlmIGEgVk0gY2FuIG9ubHkgYmUgYmluZCB0byBlaXRoZXIgQTcyIG9yCj4gPj4gQTU1IGNvcmVz
LCB0aGVuIHRoZSBwZXJmb3JtYW5jZSBpcyBubyBsb25nZXIgY29tcGV0aXRpdmUgYWdhaW5zdAo+
ID4+IEJDTTI3MTEsIHdhc3RpbmcgdGhlIFBDSUUgMi4wIHg0IGNhcGFjaXR5Lgo+ID4+Cj4gPj4g
SSBndWVzcyB3aXRoIHByb2plY3RzIGxpa2UgQXNhaGkgTGludXggbWFraW5nIHByb2dyZXNzLCB0
aGVyZSB3aWxsIGJlCj4gPj4gbW9yZSBhbmQgbW9yZSBzdWNoIHByb2JsZW1zLgo+ID4+Cj4gPj4g
QW55IGNsdWUgb24gaG93IHRvIHByb3Blcmx5IHBhc3MgYWxsIHBoeXNpY2FsIENQVSBjb3JlcyB0
byBWTSBmb3IKPiA+PiBsaXR0bGUuQklHIHNldHVwPwo+ID4+Cj4gPgo+ID4gSSBoYXZlIG5ldmVy
IG1ldCBiaWcuTElUVExFIGJ1dCBteSB1bmRlcnN0YW5kaW5nIHdhcyB0aGF0IHRob3NlIGJpZwo+
ID4gY29yZXMgYXJlIGNvbXBhdGlibGUgd2l0aCBsaXR0bGUgb25lcyBhbmQgdGhlIG9ubHkgZGlm
ZmVyZW5jZSBpcyB0aGF0Cj4gPiB0aGUgYmlnIG9uZXMgYXJlIHNodXQgb2ZmIGlmIHRoZXJlJ3Mg
bm8gZGVtYW5kICh0byBzYXZlIGVuZXJneSkgbGVhdmluZwo+ID4gb25seSB0aGUgbGl0dGxlIG9u
ZXMgcnVubmluZy4KPgo+IFRoZSBiaWcgb25lcyBhcmUgbm90IGRpc2FibGVkIEFGQUlLLgo+Cj4g
QW5kIGV2ZW4gY2hhbmdpbmcgdGhlIENQVSBtb2RlbCB0byBBNTMgKHRoZSBsaXR0bGUgb25lcyks
IGl0IHN0aWxsIGZhaWxzCj4gdG8gYm9vdCwgdGh1cyBpdCBsb29rcyBsaWtlIEE3MiBpcyBub3Qg
cmVhbGx5IGFibGUgdG8gZW11bGF0ZSBBNTMgY29yZXM/Cj4KPiA+Cj4gPiBBbnl3YXksIHRoaXMg
aXMgbGlrZWx5IHRvbyBoaWdoIGxldmVsIGZvcnVtIGFuZCBJJ2QgYXNrIFFFTVUgZGV2ZWxvcGVy
czoKPiA+Cj4gPiBodHRwczovL3d3dy5xZW11Lm9yZy9zdXBwb3J0Lwo+Cj4gVGhhdCdzIGluZGVl
ZCB0aGUgY2FzZSwgYWRkaW5nIHFlbXUgdG8gdGhlIENDIGxpc3QuCj4KPiBBbmQgSSBmb3VuZCBh
biBleGlzdGluZyBidWcgcmVwb3J0Ogo+IGh0dHBzOi8vYnVncy5saW5hcm8ub3JnL3Nob3dfYnVn
LmNnaT9pZD0xNDQzCgooVGhpcyBidWcgdHJhY2tpbmcgc3lzdGVtIHdhcyBlc3NlbnRpYWxseSBh
YmFuZG9uZWQgeWVhcnMgYWdvOyB0aGUKc3RhdHVzIG9mIGxlZnRvdmVyIGJ1Z3Mgd2l0aGluIGl0
IGlzbid0IGluZGljYXRpdmUgb2YgYW55dGhpbmcuKQoKPiBCdXQgSSBzdGlsbCBkaWRuJ3QgZ2V0
IHRoZSBwb2ludCB3aHkgdGhlIDE6MSBDUFUtdG8tdmNwdSBtYXBwaW5nIHN0aWxsCj4gZG9lc24n
dCB3b3JrLgoKLS0gUE1NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
