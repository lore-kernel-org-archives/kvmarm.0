Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B3FC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 14:24:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 967F661213
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 14:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 967F661213
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 222BF4B199;
	Fri, 19 Nov 2021 09:24:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7RjwzsSvN467; Fri, 19 Nov 2021 09:24:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 168DA4B19F;
	Fri, 19 Nov 2021 09:24:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA764B188
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:26:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HXjwPQ0JykM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 08:26:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7EA4B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:26:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637328368;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tDrQgx53U8HesTcis3pQIJTyz9AOSXX3EzbKVHyF6d0=;
 b=SziIYqv0KLzgwD5aCJ5KMxcwuGadyQwRAb057m2oKIn2puulXHe+rUbXAcW5XjRGnDGbOa
 EATYthtM7Uopk22q5m0tXrVIuUH9jIQ0o8rz+IdBP3d/oKGD3ujVQ5BNC3yJ7olxaF+wSR
 dsYgUwG932njJgq0UJszLkQrmsvlKng=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-bDnOH6JWNxSnwp9ygaVGRA-1; Fri, 19 Nov 2021 08:26:06 -0500
X-MC-Unique: bDnOH6JWNxSnwp9ygaVGRA-1
Received: by mail-wr1-f70.google.com with SMTP id
 q17-20020adff791000000b00183e734ba48so1781199wrp.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:26:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=tDrQgx53U8HesTcis3pQIJTyz9AOSXX3EzbKVHyF6d0=;
 b=j7Ek+89Ma+1p0V3VHBYwA/WN4hcAfcVsf0JFW+VXT/5VoKNeA1MoQ3YRUKxYiU2KmE
 7G66KonGcBZzU151ZSJMTT8sSSRxJS39hOHOe/+TDYYMMrISpFdKEfXTcGgV8w+pDxDh
 boRMrB4JLZUwbGYaszXK4ke03QOFOdo5tknEHN5HUb7AOURYgnmWugcc+TWH7jBFgDlx
 HcAEppHPFi0E50ynOeOb4BdwOV8xnuiTmwFjWNNCzsLW+z0lVEdp43xfHffm3O3jx67v
 oOC3JhhNqucq/gFmwYKfkkzxrU1qMpT0a5j6xi34P+Wl6Gg1s4dwaUHKrMeFT34aVjsp
 k0sA==
X-Gm-Message-State: AOAM532z2rWDOun37uQshoox2ZCsOf2cwe/9opntb9fmvMmKhUpn6xqK
 +SeWQvTL/Ui/l3xYCcHnwKYOqGjW4JFf7bR1/djftQIuAz4QSQhVv+rB9Xvc6BRMTT+tKbTWlj2
 9XcraCPNpitE7+N8AICCJYKmY
X-Received: by 2002:a05:600c:4303:: with SMTP id
 p3mr6982027wme.128.1637328365503; 
 Fri, 19 Nov 2021 05:26:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweP7wgXb5BaGXphhgtU6lkM9ldywaVRytkeY4pifGSaoOTuJNb3qZ1CNxeHzPL9hlFgq7JTQ==
X-Received: by 2002:a05:600c:4303:: with SMTP id
 p3mr6981971wme.128.1637328365233; 
 Fri, 19 Nov 2021 05:26:05 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae?
 ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
 by smtp.gmail.com with ESMTPSA id s8sm3034920wro.19.2021.11.19.05.26.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 05:26:04 -0800 (PST)
Message-ID: <f83be3c5b582d1d25a4d3337e1d2971b48e9a83d.camel@redhat.com>
Subject: Re: [RFC PATCH 1/2] arm64/tracing: add cntvct based trace clock
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Date: Fri, 19 Nov 2021 14:26:03 +0100
In-Reply-To: <87h7c873u0.wl-maz@kernel.org>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-2-nsaenzju@redhat.com>
 <20211119112624.GA51423@fuller.cnet> <87h7c873u0.wl-maz@kernel.org>
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 19 Nov 2021 09:24:09 -0500
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, mingo@redhat.com, nilal@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gRnJpLCAyMDIxLTExLTE5IGF0IDEyOjAwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4g
T24gRnJpLCAxOSBOb3YgMjAyMSAxMToyNjoyNCArMDAwMCwKPiBNYXJjZWxvIFRvc2F0dGkgPG10
b3NhdHRpQHJlZGhhdC5jb20+IHdyb3RlOgo+ID4gCj4gPiBPbiBGcmksIE5vdiAxOSwgMjAyMSBh
dCAxMToyMToxN0FNICswMTAwLCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+ID4gPiBB
ZGQgYSBuZXcgYXJtNjQtc3BlY2lmaWMgdHJhY2UgY2xvY2sgdXNpbmcgdGhlIGNudHZjdCByZWdp
c3Rlciwgc2ltaWxhcgo+ID4gPiB0byB4NjQtdHNjLiBUaGlzIGdpdmVzIHVzOgo+ID4gPiAgLSBB
IGNsb2NrIHRoYXQgaXMgcmVsYXRpdmVseSBmYXN0ICgxR0h6IG9uIGFybXY4LjYsIDEtNTBNSHog
b3RoZXJ3aXNlKSwKPiA+ID4gICAgbW9ub3RvbmljLCBhbmQgcmVzaWxpZW50IHRvIGxvdyBwb3dl
ciBtb2Rlcy4KPiA+ID4gIC0gSXQgY2FuIGJlIHVzZWQgdG8gY29ycmVsYXRlIGV2ZW50cyBhY3Jv
c3MgY3B1cyBhcyB3ZWxsIGFzIGFjcm9zcwo+ID4gPiAgICBoeXBlcnZpc29yIGFuZCBndWVzdHMu
Cj4gPiA+IAo+ID4gPiBCeSB1c2luZyBhcmNoX3RpbWVyX3JlYWRfY291bnRlcigpIHdlIG1ha2Ug
c3VyZSB0aGF0IGFybXY4LjYgY3B1cyB1c2UKPiA+ID4gdGhlIGxlc3MgZXhwZW5zaXZlIENOVFZD
VFNTX0VMMCwgd2hpY2ggY2Fubm90IGJlIGFjY2Vzc2VkIHNwZWN1bGF0aXZlbHkuCj4gPiAKPiA+
IENhbiB0aGlzIHJlZ2lzdGVyIGJlIHJlYWQgYnkgdXNlcnNwYWNlID8gKG90aGVyd2lzZSBpdCB3
b24ndCBiZSBwb3NzaWJsZQo+ID4gdG8gY29ycmVsYXRlIHVzZXJzcGFjZSBldmVudHMpLgo+IAo+
IFllcy4gVGhhdCdzIHBhcnQgb2YgdGhlIHVzZXJzcGFjZSBBQkkuIEFsdGhvdWdoIHRoaXMgcGFy
dGljdWxhcgo+IGFjY2Vzc29yIGlzIG9ubHkgYXZhaWxhYmxlIGZyb20gQVJNdjguNiBhbmQgaXMg
YWR2ZXJ0aXNlZCB2aWEgYSBod2NhcAo+IHRvIHVzZXJzcGFjZS4KPiAKPiBGb3IgY3VycmVudGx5
IGV4aXN0aW5nIGltcGxlbWVudGF0aW9ucywgdXNlcnNwYWNlIHdpbGwgdXNlIHRoZQo+IENOVFZD
VF9FTDAgYWNjZXNzb3IsIHdoaWNoIHJlcXVpcmVzIGV4dHJhIHN5bmNocm9uaXNhdGlvbiBhcyBp
dCBjYW4gYmUKPiBzcGVjdWxhdGVkLgoKVG8gY29tcGxldGUgTWFyYydzIHJlcGx5LCBoZXJlJ3Mg
YW4gZXhhbXBsZSBvZiBob3cgQ05UVkNUX0VMMCBpcyBiZWluZyB1c2VkIGluCnJ0LXRlc3RzJyBv
c2xhdDoKCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS91dGlscy9ydC10ZXN0cy9ydC10
ZXN0cy5naXQvdHJlZS9zcmMvb3NsYXQvb3NsYXQuYyNuODcKCi0tIApOaWNvbMOhcyBTw6FlbnoK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
