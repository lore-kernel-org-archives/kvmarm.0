Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6ECC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 11:50:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9C34B166;
	Tue, 11 Jan 2022 06:50:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KNEAFbILm7t3; Tue, 11 Jan 2022 06:50:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A31CE4B1AF;
	Tue, 11 Jan 2022 06:50:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4FC14B231
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 06:32:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id irQvz0QDq3Bh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 06:32:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 579424B21E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 06:32:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641900762;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ntz4OdwBNqZu8v1ik+qX1K0Vqvd5kyFiJX82I/JSWBM=;
 b=ExeJO+MH2HDcaP5egKhOAmQMP4Qe45hQmP0MpMkZ56xPoBCxmBAjHSBvW1eKUn5+xZ5Pjy
 h/UaaFHYoqttZCk82zKrSGbIdpsjmgQLS0lYdkXIwQNe+qGBexKPqM/jRK4u2IT7Idgz1K
 xDE9JdfhZQ9MH0Us63ZXdgzixCT4y+A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-r-l-dLlFPmiUPKaqwQCW7g-1; Tue, 11 Jan 2022 06:32:40 -0500
X-MC-Unique: r-l-dLlFPmiUPKaqwQCW7g-1
Received: by mail-wr1-f70.google.com with SMTP id
 v1-20020adfc5c1000000b001a37fd2fa2dso4836945wrg.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 03:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=Ntz4OdwBNqZu8v1ik+qX1K0Vqvd5kyFiJX82I/JSWBM=;
 b=EybbKaSUY6y4wvTZ+dwVwPwV9OJJJxpCN1eR2Ox/qKcSXjjVqQg5keqqVqrHiowkCu
 K4Cv16Vp6qvAWIq91MLOF+iEvD8076Rof9xQYnfG+neLiUk17LVaTj3/MX2iMDFR+BsL
 llHYXpJBOqQ6GDSRBCsdaHwC99WCmJ9JARg38e+kMFUYK6sC4jcrKf0vdmMecB872f/l
 nR7238KnQ0MjgPeK4NX9mDb51mLWUiNGyvt2N+FmSpFLzUF+Qh2c3pZcI2yu5LYQCJPf
 /0NQhrAKlIl0UNG9mupGhoXU+FKgZ+5R3CZ92r/QYqFJaiqbyO8FcssjDb5Th0zbf0rf
 Z6Ow==
X-Gm-Message-State: AOAM531Ou/e9lKaQwN/slWI5wDx3sLUWZQuKsS84qqE+/zIXQs9aBb3u
 /YvX8Fss5I0DfN72uwc1Vib9AIRM50zT81HUOnZ6p+m0WROKdwHKkHwUIRNlUIz2FDtexIzIG0L
 cCODVcGkkUipfW3UH3zop5nAv
X-Received: by 2002:a05:600c:1f16:: with SMTP id
 bd22mr638640wmb.55.1641900759547; 
 Tue, 11 Jan 2022 03:32:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVL3iNrW3WKpYn6GzQuj8SMBM75HxOEOHTlJ+vpSpokIuvZWIzUcmFzLx+N+TQE1uqDKbg/Q==
X-Received: by 2002:a05:600c:1f16:: with SMTP id
 bd22mr638624wmb.55.1641900759341; 
 Tue, 11 Jan 2022 03:32:39 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:1e09:d600:637e:7f1b:a4a0:fc92?
 ([2a0c:5a80:1e09:d600:637e:7f1b:a4a0:fc92])
 by smtp.gmail.com with ESMTPSA id u3sm11320283wrs.0.2022.01.11.03.32.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Jan 2022 03:32:39 -0800 (PST)
Message-ID: <399d8805ca09f7d3c905b8c653abf60dd7141574.camel@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 11 Jan 2022 12:32:38 +0100
In-Reply-To: <YdR4N9QVYOzjowAb@FVFF77S0Q05N>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <YdR4N9QVYOzjowAb@FVFF77S0Q05N>
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 11 Jan 2022 06:50:07 -0500
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, Anup Patel <Anup.Patel@wdc.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
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

SGkgTWFyaywKCk9uIFR1ZSwgMjAyMi0wMS0wNCBhdCAxNjozOSArMDAwMCwgTWFyayBSdXRsYW5k
IHdyb3RlOgo+IE9uIEZyaSwgRGVjIDE3LCAyMDIxIGF0IDA0OjU0OjIyUE0gKzAxMDAsIFBhb2xv
IEJvbnppbmkgd3JvdGU6Cj4gPiBPbiAxMi8xNy8yMSAxNTozOCwgTWFyayBSdXRsYW5kIHdyb3Rl
Ogo+ID4gPiBGb3IgZXhhbXBsZSBrdm1fZ3Vlc3RfZW50ZXJfaXJxb2ZmKCkgY2FsbHMgZ3Vlc3Rf
ZW50ZXJfaXJxX29mZigpIHdoaWNoIGNhbGxzCj4gPiA+IHZ0aW1lX2FjY291bnRfZ3Vlc3RfZW50
ZXIoKSwgYnV0IGt2bV9ndWVzdF9leGl0X2lycW9mZigpIGRvZXNuJ3QgY2FsbAo+ID4gPiBndWVz
dF9leGl0X2lycV9vZmYoKSBhbmQgdGhlIGNhbGwgdG8gdnRpbWVfYWNjb3VudF9ndWVzdF9leGl0
KCkgaXMgb3Blbi1jb2RlZAo+ID4gPiBlbHNld2hlcmUuIEFsc28sIGd1ZXN0X2VudGVyX2lycV9v
ZmYoKSBjb25kaXRpb25hbGx5IGNhbGxzCj4gPiA+IHJjdV92aXJ0X25vdGVfY29udGV4dF9zd2l0
Y2goKSwgYnV0IEkgY2FuJ3QgaW1tZWRpYXRlbHkgc3BvdCBhbnl0aGluZyBvbiB0aGUKPiA+ID4g
ZXhpdCBzaWRlIHRoYXQgY29ycmVzcG9uZGVkIHdpdGggdGhhdCwgd2hpY2ggbG9va3Mgc3VzcGlj
aW91cy4KPiA+IAo+ID4gcmN1X25vdGVfY29udGV4dF9zd2l0Y2goKSBpcyBhIHBvaW50LWluLXRp
bWUgbm90aWZpY2F0aW9uOyBpdCdzIG5vdCBzdHJpY3RseQo+ID4gbmVjZXNzYXJ5LCBidXQgaXQg
bWF5IGltcHJvdmUgcGVyZm9ybWFuY2UgYSBiaXQgYnkgYXZvaWRpbmcgdW5uZWNlc3NhcnkgSVBJ
cwo+ID4gZnJvbSB0aGUgUkNVIHN1YnN5c3RlbS4KPiA+IAo+ID4gVGhlcmUncyBubyBiZW5lZml0
IGZyb20gZG9pbmcgaXQgd2hlbiB5b3UncmUgYmFjayBmcm9tIHRoZSBndWVzdCwgYmVjYXVzZSBh
dAo+ID4gdGhhdCBwb2ludCB0aGUgQ1BVIGlzIGp1c3QgcnVubmluZyBub3JtYWwga2VybmVsIGNv
ZGUuCj4gCj4gSSBzZWUuCj4gCj4gTXkgbWFpbiBpc3N1ZSBoZXJlIHdhcyBqdXN0IHRoYXQgaXQn
cyByZWFsbHkgZGlmZmljdWx0IHRvIHNlZSBob3cgdGhlCj4gZW50cnkvZXhpdCBsb2dpYyBpcyBi
YWxhbmNlZCwgYW5kIEkgcmVja29uIHdlIGNhbiBzb2x2ZSB0aGF0IGJ5IHNwbGl0dGluZwo+IGd1
ZXN0X3tlbnRlcixleGl0fV9pcnFvZmYoKSBpbnRvIGhlbHBlciBmdW5jdGlvbnMgdG8gaGFuZGxl
IHRoZSB2dGltZQo+IGFjY291bnRpbmcgc2VwYXJhdGVseSBmcm9tIHRoZSBjb250ZXh0IHRyYWNr
aW5nLCBzbyB0aGF0IGFyY2ggY29kZSBjYW4gZG8KPiBzb21ldGhpbmcgbGlrZToKPiAKPiAgIGd1
ZXN0X3RpbWluZ19lbnRlcl9pcnFvZmYoKTsKPiAgIAo+ICAgZ3Vlc3RfZXFzX2VudGVyX2lycW9m
ZigpOwo+ICAgPCBhY3R1YWxseSBydW4gdkNQVSBoZXJlID4KPiAgIGd1ZXN0X2Vxc19leGl0X2ly
cW9mZigpOwo+ICAgCj4gICA8IGhhbmRsZSBwZW5kaW5nIElSUXMgaGVyZSA+Cj4gICAKPiAgIGd1
ZXN0X3RpbWluZ19leGl0X2lycW9mZigpOwo+IAo+IC4uLiB3aGljaCBJIGhvcGUgc2hvdWxkIHdv
cmsgZm9yIFJJU0MtViB0b28uCj4gCj4gSSd2ZSBoYWQgYSBnbywgYW5kIEkndmUgcHVzaGVkIG91
dCBhIFdJUCB0bzoKPiAKPiAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L21hcmsvbGludXguZ2l0L2xvZy8/aD1hcm02NC9rdm0vcmN1CgpIYWQgYSBsb29r
IGF0IHRoZSBwYXRjaGVzIGFuZCB0aGV5IHNlZWVtIE9LIHRvIG1lLgoKVGhhbmtzIQoKLS0gCk5p
Y29sw6FzIFPDoWVuegoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
