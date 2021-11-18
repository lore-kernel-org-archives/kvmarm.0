Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4BDC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 19:47:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC4D1619BB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 19:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC4D1619BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 586304B231;
	Thu, 18 Nov 2021 14:47:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EDFFtWmFf2zX; Thu, 18 Nov 2021 14:47:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 152BA4B1F3;
	Thu, 18 Nov 2021 14:47:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB1444B1BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 14:47:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vaNpKaIDmEdL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 14:47:02 -0500 (EST)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7981A4B177
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 14:47:02 -0500 (EST)
Received: by mail-pl1-f179.google.com with SMTP id m24so6165302pls.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 11:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=etzXRtUGTr8lCEC3N+zBz9sC9KLaK/1vTaoNub+XSrA=;
 b=TJltHTqmUDTIgL1P24a20gD79MoRsYyT+oWNI7Zk1KCB0kxMW9nay123E+ZoFctpYI
 aiNnMLJVER0OaOWjGQFAAodEb7XssAPkbTv3HZ/7Xvc56U/KwoqRQGvrj5PKP0bcKR4k
 2vvhP28esD9If7TAFeNjBviDlcYadmbYqHQK4EKbmvqKoyyDe2mAxq3N83OoFp8cHZvs
 tW/44+HbAaU7BnQeov5HYKclsNsjLoArhh5d8PMaS08emGsC4hW0iBqIihQVo007XCgE
 f+/05PLBrEHbV7h1EwSp8E42irdKiOdyzv/mpEc9ne+Zn3+nJLJHbZQwUjsMNM99uGwK
 D+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=etzXRtUGTr8lCEC3N+zBz9sC9KLaK/1vTaoNub+XSrA=;
 b=aW/dPcQM3UcP0gz2U76t7PYuEVIxiJHkTA514wTHOdfoUvzFqMe1mC/w1Wf53McTJB
 T07VDQOx613YwNHKyE6HrbVuFUBJe+eOtl4AAdKByUJxo9zQEf0BCJRKtm97KB0awbr7
 DJCg85SndVakwf5DBJo3w6ZYXIToYjpsPB5kAM9nIcZwG98qQrlWCh5MRassbBZ39Bv2
 Z2soEIE+fkApayk/kRcSFIFhlJ/4Yr2mzGusqN0H1Ezkj2mE//9FzkSQ4DeEBvvPkMJp
 nyuKmPCRF2PhNbN5SGdfvvURwx5YSw7NhJWTPzPZHfosffl5ZDzniSM3EijrX7JoZSU2
 QGXg==
X-Gm-Message-State: AOAM5328PDhoy8bGjQ37MuE2Do6FOFKIIlHaswTXI70aiQEEbHztOukA
 EUFAtM6sCCINow01eH824TFiLw==
X-Google-Smtp-Source: ABdhPJw2jmwgTmZEgqtXJQ8BT+0frIfcOwv6QQsFYGUkgZtQBdhdiIC61pVtTpnGW9Ux3cY+6emP4Q==
X-Received: by 2002:a17:90b:4d09:: with SMTP id
 mw9mr13604040pjb.238.1637264821320; 
 Thu, 18 Nov 2021 11:47:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id t40sm435895pfg.107.2021.11.18.11.46.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 11:46:59 -0800 (PST)
Date: Thu, 18 Nov 2021 19:46:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
Message-ID: <YZatsB3oadj6dgb8@google.com>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
 <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
 <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
 <YZaeL5YztL3p1nLM@google.com> <YZagjzYUsixbFre9@google.com>
 <35AEC3FD-B46A-451D-B7D5-4B1BDD5407BD@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <35AEC3FD-B46A-451D-B7D5-4B1BDD5407BD@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

T24gVGh1LCBOb3YgMTgsIDIwMjEsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiAKPiAKPiBPbiAx
OCBOb3ZlbWJlciAyMDIxIDE4OjUwOjU1IEdNVCwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+IHdyb3RlOgo+ID5PbiBUaHUsIE5vdiAxOCwgMjAyMSwgU2VhbiBDaHJpc3Rv
cGhlcnNvbiB3cm90ZToKPiA+PiBPbiBUaHUsIE5vdiAxOCwgMjAyMSwgRGF2aWQgV29vZGhvdXNl
IHdyb3RlOgo+ID4+ID4gVGhhdCBsZWF2ZXMgdGhlIG9uZSBpbiBURFAgTU1VIGhhbmRsZV9jaGFu
Z2VkX3NwdGVfZGlydHlfbG9nKCkgd2hpY2gKPiA+PiA+IEFGQUlDVCBjYW4gdHJpZ2dlciB0aGUg
c2FtZSBjcmFzaCBzZWVuIGJ5IGJ1dHQzcmZseWg0Y2sg4oCUIGNhbid0IHRoYXQKPiA+PiA+IGhh
cHBlbiBmcm9tIGEgdGhyZWFkIHdoZXJlIGt2bV9nZXRfcnVubmluZ192Y3B1KCkgaXMgTlVMTCB0
b28/IEZvciB0aGF0Cj4gPj4gPiBvbmUgSSdtIG5vdCBzdXJlLgo+ID4+IAo+ID4+IEkgdGhpbmsg
Y291bGQgYmUgdHJpZ2dlciBpbiB0aGUgVERQIE1NVSB2aWEga3ZtX21tdV9ub3RpZmllcl9yZWxl
YXNlKCkKPiA+PiAtPiBrdm1fbW11X3phcF9hbGwoKSwgZS5nLiBpZiB0aGUgdXNlcnNwYWNlIFZN
TSBleGl0cyB3aGlsZSBkaXJ0eSBsb2dnaW5nIGlzCj4gPj4gZW5hYmxlZC4gIFRoYXQgc2hvdWxk
IGJlIGVhc3kgdG8gKGRpcylwcm92ZSB2aWEgYSBzZWxmdGVzdC4KPiA+Cj4gPlNjcmF0Y2ggdGhh
dCwgdGhlIGRpcnR5IGxvZyB1cGRhdGUgaXMgZ3VhcmRlZCBieSB0aGUgbmV3X3NwdGUgYmVpbmcg
cHJlc2VudCwgc28KPiA+emFwcGluZyBvZiBhbnkga2luZCB3b24ndCB0cmlnZ2VyIGl0Lgo+ID4K
PiA+Q3VycmVudGx5LCBJIGJlbGlldmUgdGhlIG9ubHkgcGF0aCB0aGF0IHdvdWxkIGNyZWF0ZSBh
IHByZXNlbnQgU1BURSB3aXRob3V0IGFuCj4gPmFjdGl2ZSB2Q1BVIGlzIG1tdV9ub3RpZmVyLmNo
YW5nZV9wdGUsIGJ1dCB0aGF0IHNxdWVha3MgYnkgYmVjYXVzZSBpdHMgcmVxdWlyZWQKPiA+dG8g
YmUgd3JhcHBlZCB3aXRoIGludmFsaWRhdGVfcmFuZ2Vfe3N0YXJ0LGVuZH0oTU1VX05PVElGWV9D
TEVBUiksIGFuZCBLVk0gemFwcwo+ID5pbiB0aGF0IHNpdHVhdGlvbi4KPiAKPiBJcyBpdCBzdWZm
aWNpZW50IHRvIGhhdmUgKmFuKiBhY3RpdmUgdkNQVT8gIFdoYXQgaWYgYSBWTU0gaGFzIHRocmVh
ZHMgZm9yCj4gYWN0aXZlIHZDUFVzIGJ1dCBpcyBkb2luZyBtbWFwL211bm1hcCBvbiBhICpkaWZm
ZXJlbnQqIHRocmVhZD8gRG9lcyB0aGF0IG5vdAo+IHN1ZmZlciB0aGUgc2FtZSBjcmFzaD8KCkl0
IGlzIHN1ZmZpY2llbnQgZm9yIHRoZSBjdXJyZW50IHBoeXNpY2FsIENQVSB0byBoYXZlIGFuIGFj
dGl2ZSB2Q1BVLCB3aGljaCBpcwpnZW5lcmFsbHkgZ3VhcmFudGVlZCBpbiB0aGUgTU1VIGNvZGUg
YmVjYXVzZSwgd2l0aCBhIGZldyBleGNlcHRpb25zLCBwb3B1bGF0aW5nClNQVEVzIGlzIGRvbmUg
aW4gdkNQVSBjb250ZXh0LgoKbW1hcCgpIHdpbGwgbmV2ZXIgZGlyZWN0bHkgdHJpZ2dlciBTUFRF
IGNyZWF0aW9uLCBLVk0gZmlyc3QgcmVxdWlyZXMgYSB2Q1BVIHRvCmZhdWx0IG9uIHRoZSBuZXcg
YWRkcmVzcy4gIG11bm1hcCgpIGlzIGEgcHVyZSB6YXAgZmxvdywgaS5lLiB3b24ndCBjcmVhdGUg
YQpwcmVzZW50IFNQVEUgYW5kIHRyaWdnZXIgdGhlIHdyaXRlYmFjayBvZiB0aGUgZGlydHkgYml0
LgoKVGhhdCdzIGFsc28gd2h5IEkgZGlzbGlrZSB1c2luZyBrdm1fZ2V0X3J1bm5pbmdfdmNwdSgp
OyB3aGVuIGl0J3MgbmVlZGVkLCB0aGVyZSdzCmEgdmFsaWQgdkNQVSBmcm9tIHRoZSBjYWxsZXIs
IGJ1dCBpdCBkZWxpYmVyYXRlbHkgZ2V0cyBkcm9wcGVkIGFuZCBpbmRpcmVjdGx5CnBpY2tlZCBi
YWNrIHVwLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
