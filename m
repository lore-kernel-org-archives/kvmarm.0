Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC21C4167B
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 23:26:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 728CA4B856;
	Mon, 12 Dec 2022 18:26:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3U-JZGNphPwk; Mon, 12 Dec 2022 18:26:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB1F4B89E;
	Mon, 12 Dec 2022 18:26:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFB84B887
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:26:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MFhNGRgsWQ0P for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 18:26:40 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E0424B856
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:26:40 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id jn7so13703662plb.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 15:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=zJOQecEGgSp0glbzJ1RpRnPbkp2HAzeJE/NybulD13E=;
 b=LgVzXCUoiKNG9USGHdtxDWk3jXHPhUfF7aC6Jb6oAf8XA1bTwz+AQ/vH//iOu+Txbq
 HtNSM7bobeYY6HNyDm3070/s1Oas0aeVxdQOxg9nHQgvvOSD+HbQky0G3NWU2aHHH9iG
 JVh1AUDnlaepYuer6Ncinshp4+sTBfERSvbRGIUdHuN0fvrTLKzxKu4eop/o7jhMUBSa
 9I1Z1oUAs6TpwbdTo0ilfAV5dpWM/KOAPcjBCaf+Wh+PzYd+4+Je5We3hpfEFSHW2X9B
 XNOJfuewe5Qh+b7VEFMhtgGppnAqVlzsDeqFiGrPyEqs9m8tEG3SEwVL1QUihijPEdBo
 3YcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=zJOQecEGgSp0glbzJ1RpRnPbkp2HAzeJE/NybulD13E=;
 b=bzflTROa4EmcuqpQGIORIpKLD31HZht2NiKHAhdZ4ZAfgJ7buyefLsLSxjQ5RyY9Eq
 eaGAW+rHldLHxJQR8L6WfHPZBdSA4kTC2AZRoonLx2AhrI82x1n6CvVQl3nK/kU6V3kT
 SzUZ9HBpZeK43J3nk0DnnirluFkg4LwZHO2yBNZJHefyr3kCZuUv2vCfVbhVRk2qxbYg
 d9R6KUmNwzoA9VHAimah/sBgAnCeYvlpy3VAAbybhTpY2P5pLV9KNW3PNDwB8I5Md3YR
 oBul8fCSfzEg3NPga8CZqD4W3y255Q0W4/ewDxzdpdOsotSzXxSaPtgtTdggsp8kWoTv
 4/XQ==
X-Gm-Message-State: ANoB5pnop/GsDAp6VcOJ2gGa8plVhXL/SP1JR159ADjTPyKrZeaiVjDk
 nBfEQNHN49bwRi/NVH4iGzkCMw==
X-Google-Smtp-Source: AA0mqf5Ct9lyTd0t0PIpKHrR2fvGzlGpqd0kxk6VIFCVK4Ckp27HzLLjvycFuCodXJHfa/pjm6FVZg==
X-Received: by 2002:a17:902:da8d:b0:189:3a04:4466 with SMTP id
 j13-20020a170902da8d00b001893a044466mr16713plx.2.1670887599032; 
 Mon, 12 Dec 2022 15:26:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 z9-20020a170903018900b00189af02aba4sm6992708plg.3.2022.12.12.15.26.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 15:26:38 -0800 (PST)
Date: Mon, 12 Dec 2022 23:26:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
Message-ID: <Y5e4qxjHWoMt8YGs@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <Y5OHVzBSHPmAq2FO@google.com>
 <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, David Matlack <dmatlack@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

T24gTW9uLCBEZWMgMTIsIDIwMjIsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24gMTIvOS8yMiAy
MDowNywgT2xpdmVyIFVwdG9uIHdyb3RlOgo+ID4gPiAgIC0gTmFtaW5nLiBUaGlzIHNlcmllcyBk
b2VzIG5vdCBjaGFuZ2UgdGhlIG5hbWVzIG9mIGFueSBleGlzdGluZyBjb2RlLgo+ID4gPiAgICAg
U28gYWxsIHRoZSBLVk0veDg2IFNoYWRvdyBNTVUtc3R5bGUgdGVybWlub2xvZ3kgbGlrZQo+ID4g
PiAgICAgInNoYWRvd19wYWdlIi8ic3AiLyJzcHRlIiBwZXJzaXN0cy4gU2hvdWxkIHdlIGtlZXAg
dGhhdCBzdHlsZSBpbgo+ID4gPiAgICAgY29tbW9uIGNvZGUgb3IgbW92ZSB0b3dhcmQgc29tZXRo
aW5nIGxlc3Mgc2hhZG93LXBhZ2luZy1zcGVjaWZpYz8KPiA+ID4gICAgIGUuZy4gInBhZ2VfdGFi
bGUiLyJwdCIvInB0ZSIuCj4gPiAKPiA+IEkgd291bGQgc3Ryb25nbHkgYmUgaW4gZmF2b3Igb2Yg
ZGlzY2FyZGluZyB0aGUgc2hhZG93IHBhZ2luZyByZXNpZHVlIGlmCj4gPiB4ODYgZm9sa3MgYXJl
IHdpbGxpbmcgdG8gcGFydCB3YXlzIHdpdGggaXQg8J+YhAo+IAo+IFllcywgYWJzb2x1dGVseS4g
IFNvbWV0aGluZyBsaWtlIHRvX3NoYWRvd19wYWdlLT50b19tbXVfZGF0YSwgc3AtPm1kLAo+IHNw
dC0+aHB0LCBzcHRlLT5zcHRlLCBzcHRlcC0+aHB0ZXAuCgoiaG9zdCIgd2lsbCBiZSBjb25mdXNp
bmcgaWYgd2hlbiB0aGUgcHJpbWFyeSBNTVUgaXMgaW52b2x2ZWQgdGhvdWdoLCBlLmcuIEkgYWx3
YXlzCnRoaW5rIG9mIHRoZSBwcmltYXJ5IE1NVSdzIHBhZ2UgdGFibGVzIGFzIHRoZSAiaG9zdCBw
YWdlIHRhYmxlcyIuCgpXaGF0IGlmIHdlIGtlZXAgdGhlICJTIiBmb3IgU1BUKEUpIGFuZCByZXB1
cnBvc2UgaXQgdG8gbWVhbiBTZWNvbmRhcnkgUFRFPwpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
