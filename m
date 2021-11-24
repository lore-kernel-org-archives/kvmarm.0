Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8177C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 09:51:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 305B74B19D;
	Wed, 24 Nov 2021 04:51:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ztfda+jRVMYj; Wed, 24 Nov 2021 04:51:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3CDE4B118;
	Wed, 24 Nov 2021 04:51:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8C84B164
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 04:45:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dlMNSJPoTnKy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 04:45:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 915EE406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 04:45:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637747148;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/ocPRPURvuCP4fzE5T0eVQSQIxy0gRmJcpuXxwEQtHM=;
 b=UqQJ2Z6JnRTP7Gw0KZ6sMAFwJKwHJhOf0Dxfk2JwPXEKawIU9Im1PuqqG/oCgDaCUqAPvt
 AoeRuICMZ5ovjYpy+0CMP09ohaCJsDdUmnXwqdemqw99rbX+MfP154poeFVqoeOQP7bLs+
 ayWoaolUuSl0GF/xC3axPA0BKd0S3ds=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-frpx6wo-MEG-iJBtAkp8vg-1; Wed, 24 Nov 2021 04:45:46 -0500
X-MC-Unique: frpx6wo-MEG-iJBtAkp8vg-1
Received: by mail-wm1-f70.google.com with SMTP id
 z138-20020a1c7e90000000b003319c5f9164so2700551wmc.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 01:45:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=/ocPRPURvuCP4fzE5T0eVQSQIxy0gRmJcpuXxwEQtHM=;
 b=x3F/09+EFQeKFMLUUkcb7DdWc+PG0yX7XKYIAJ/4sDvM8k2U+hFMtgQDeDDkz3DEL/
 b424q6HuwqWAm58fA9kLWxg8rYMEUFaVXf4sKab2yLXum2cJQuMzt7mvzfjVcD3jx6z5
 swMO5EN02dZ0AIEeuZIYXwmHxbLPliuwp7ttwI63mLQuMdYnSCO1+22edFpUjLkVEK3J
 jiIoJ6dT8SlHtGCdyREZHjbpTSseIdEhoRbuFN3hTof318g27Y1kbLVpasI7kW3MFOa+
 4m3XRrRzPlKWQG0jptG7KGlP+nmZLTiZK3FYF2XXky6nUu8yWuEfHIo5BN8Q2LqQ6DUv
 zoYA==
X-Gm-Message-State: AOAM531sODEwT95K5xqyAXHsvMrhnKpPBXSX7awpBx+xmU1ZL5L6X11O
 9m7zNqcr4/lGgKeEx9W1LhgjyMC1KlrpgFt2s/Wxr7luZkL4fAFcXXeghAJJCnbZrtB+Aa8Q/gs
 K7WKPDD+ud2e8SEZLbwzctLxN
X-Received: by 2002:a5d:58f9:: with SMTP id f25mr17470508wrd.206.1637747145635; 
 Wed, 24 Nov 2021 01:45:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP0zHgPBVMJ6rnPoEJ8gNRRURG0BefwNCQkWdV/Pp5YgDYW6ukSyMMP2OQX0rFvd7bFyHeUw==
X-Received: by 2002:a5d:58f9:: with SMTP id f25mr17470474wrd.206.1637747145442; 
 Wed, 24 Nov 2021 01:45:45 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae?
 ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
 by smtp.gmail.com with ESMTPSA id a10sm4350726wmq.27.2021.11.24.01.45.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 01:45:45 -0800 (PST)
Message-ID: <482c55bc52b17c4ddf113a75acaca73a0c0a7b9b.camel@redhat.com>
Subject: Re: [RFC PATCH 1/2] arm64/tracing: add cntvct based trace clock
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 24 Nov 2021 10:45:44 +0100
In-Reply-To: <20211122095735.2340f38f@gandalf.local.home>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-2-nsaenzju@redhat.com>
 <20211122095735.2340f38f@gandalf.local.home>
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Wed, 24 Nov 2021 04:51:26 -0500
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, will@kernel.org,
 maz@kernel.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
 mingo@redhat.com, catalin.marinas@arm.com, nilal@redhat.com,
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

T24gTW9uLCAyMDIxLTExLTIyIGF0IDA5OjU3IC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToK
PiBPbiBGcmksIDE5IE5vdiAyMDIxIDExOjIxOjE3ICswMTAwCj4gTmljb2xhcyBTYWVueiBKdWxp
ZW5uZSA8bnNhZW56anVAcmVkaGF0LmNvbT4gd3JvdGU6Cj4gCj4gPiArLyogU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAgKi8KPiA+ICsjaWZuZGVmIF9BU01fQVJNNjRfVFJBQ0VfQ0xP
Q0tfSAo+ID4gKyNkZWZpbmUgX0FTTV9BUk02NF9UUkFDRV9DTE9DS19ICj4gPiArCj4gPiArI2lu
Y2x1ZGUgPGxpbnV4L3R5cGVzLmg+Cj4gPiArCj4gPiArZXh0ZXJuIHU2NCBub3RyYWNlIHRyYWNl
X2Nsb2NrX2FybTY0X2NudHZjdCh2b2lkKTsKPiA+ICsKPiA+ICsjIGRlZmluZSBBUkNIX1RSQUNF
X0NMT0NLUyBcCj4gPiArCXsgdHJhY2VfY2xvY2tfYXJtNjRfY250dmN0LCAiY250dmN0IiwgLmlu
X25zID0gMCB9LAo+ID4gKwo+ID4gKyNlbmRpZiAgLyogX0FTTV9BUk02NF9UUkFDRV9DTE9DS19I
ICovCj4gCj4gU28gdGhpcyB3aWxsIGFwcGVhciBhcyBhIHVzYWJsZSBjbG9jayBpbiB0cmFjZS1j
bWQuCj4gCj4gQW5kIHNpbmNlIHRoaXMgd2lsbCBiZSB1c2VkIHRvIHN5bmNocm9uaXplIGJldHdl
ZW4gaG9zdCBhbmQgZ3Vlc3QgbGlrZSB0aGUKPiB4ODZfdHNjIGlzIHVzZWQsIHRoYXQgbWVhbnMg
dGhhdCB0cmFjZS1jbWQgbmVlZHMgdG8ga25vdyB0aGF0IHRoaXMgaXMgdGhlCj4gYW4gYXJjaCAi
Q1BVIiBjbG9jay4gSSB3b25kZXIgaWYgd2Ugc2hvdWxkIHJlbmFtZSB4ODZfY2xvY2sgKG9yIGF0
IGxlYXN0Cj4gbWFrZSBpdCBhbiBhbGlhcykgdG8gImt2bV9jbG9jayIuIFRoZW4gd2UgY2FuIGhh
dmUgdHJhY2UtY21kIHVzZQo+ICJrdm1fY2xvY2siIGFzIHRoZSBjbG9jayBmb3Igc3luY2hyb25p
emF0aW9uIGJldHdlZW4gaG9zdCBhbmQgZ3Vlc3RzIGZvcgo+IGFsbCBhcmNoaXRlY3R1cmVzPwo+
Cj4gVGhpbmtpbmcgYWJvdXQgdGhpcywgaW5zdGVhZCBvZiByZW5hbWluZyBpdCwgSSdsbCBhZGQg
Y29kZSB0byBjcmVhdGUgYW4KPiBhbGlhcyB0byB0aGVzZSBjbG9ja3MuIFRoZW4gZXZlcnkgYXJj
aCBjYW4gcGljayB3aGF0IGNsb2NrIGlzIHVzZWQgdGhhdCBpcwo+IHRoZSBzYW1lIGJldHdlZW4g
aG9zdHMgYW5kIGd1ZXN0cyBzdWNoIHRoYXQgdXNlciBzcGFjZSB0b29saW5nIGRvZXNuJ3QgaGF2
ZQo+IHRvIGtlZXAgYSBkYXRhYmFzZSBvZiB3aGF0IGNsb2NrcyBhcmUgdXNlZCBmb3Igc3luY2hy
b25pemF0aW9uIGJldHdlZW4KPiBob3N0cyBhbmQgZ3Vlc3RzIGZvciBlYWNoIGFyY2guCj4gCj4g
SSdsbCBnbyBhZGQgc29tZSBjb2RlIDstKQoKSSByZWFsbHkgbGlrZSB0aGUgaWRlYSwgcGxlYXNl
IGtlZXAgbWUgaW4gdGhlIGxvb3AgaWYgeW91IHNlbmQgc29tZXRoaW5nCnVwc3RyZWFtLgoKLS0g
Ck5pY29sw6FzIFPDoWVuegoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
